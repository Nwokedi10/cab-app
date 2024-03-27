import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconly/iconly.dart';
import 'package:udrive/src/features/home/controllers/home_controller.dart';
import 'package:udrive/src/global/model/query_place.dart';
import 'package:udrive/src/global/services/http_service.dart';
import 'package:udrive/src/global/ui/widgets/fields/custom_textfield.dart';

import '../../../global/ui/ui_barrel.dart';
import '../../../src_barrel.dart';

class SearchScreen extends StatefulWidget {
  final String? title;
  final TextEditingController controller;
  final Function(dynamic)? afterTap;
  const SearchScreen(this.controller,
      {this.title = "Search...", this.afterTap, super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<QueryPlace> suggestions = [];
  bool isSearching = false;
  final d = Debouncer(delay: Duration(milliseconds: 2500));

  @override
  void initState() {
    // TODO: implement initState
    widget.controller.addListener(() async {
      //search for places autocomplete
      if (mounted) {
        final query = widget.controller.value.text;
        if (query.length > 3) {
          setState(() {
            isSearching = true;
          });
          d(
            () async {
              suggestions = await HttpService.searchAllPlaces(query);

              setState(() {
                isSearching = false;
              });
            },
          );
        } else {
          setState(() {
            isSearching = false;
            suggestions = [];
          });
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    d.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backAppBar(title: widget.title),
      body: Ui.padding(
        child: Column(
          children: [
            CustomTextField(
              "Enter a location",
              "",
              widget.controller,
              isLabel: false,
              varl: FPL.text,
              autofocus: true,
              suffix: IconlyLight.search,
            ),
            if (suggestions.isNotEmpty && !isSearching)
              Expanded(
                child: ListView.builder(
                  itemBuilder: (_, i) {
                    print(suggestions[0].address!);
                    return ListTile(
                      title: AppText.thin(suggestions[i].desc!),
                      subtitle: AppText.thin(suggestions[i].address!,
                          fontSize: 14, color: AppColors.white40),
                      onTap: () async {
                        widget.controller.text = suggestions[i].desc!;
                        final d = await HttpService.getPlaceLocation(
                            suggestions[i].placeId!);
                        if (d == null) return;
                        if (widget.afterTap != null) {
                          await widget.afterTap!(d);
                        } else {
                          Get.back();
                        }
                      },
                    );
                  },
                  itemCount: suggestions.length,
                ),
              ),
            if (isSearching) CircularProgress(56),
          ],
        ),
      ),
    );
  }
}
