import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:udrive/src/features/home/controllers/delivery_controller.dart';
import 'package:udrive/src/features/home/controllers/home_controller.dart';
import 'package:udrive/src/features/home/controllers/others.dart';
import 'package:udrive/src/features/home/views/delivery/delivery_summary_screen.dart';
import 'package:udrive/src/features/home/views/order_ride_screen.dart';
import 'package:udrive/src/features/home/views/search_place_screen.dart';
import 'package:udrive/src/features/map/controllers/ride_controller.dart';
import 'package:udrive/src/global/model/loc.dart';
import 'package:udrive/src/global/ui/widgets/fields/custom_textfield.dart';
import 'package:udrive/src/global/ui/widgets/others/containers.dart';

import '../../../../global/ui/ui_barrel.dart';
import '../../../../src_barrel.dart';

class SearchFields extends StatefulWidget {
  final Loc src, dst;
  final DeliveryMode deliveryMode;
  final List<Loc>? stopLocs;
  const SearchFields(this.src, this.dst,
      {this.deliveryMode = DeliveryMode.none,
      this.stopLocs = const [],
      super.key});

  @override
  State<SearchFields> createState() => _SearchFieldsState();
}

class _SearchFieldsState extends State<SearchFields> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      srcToDst(),
      Ui.boxWidth(8),
      Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: CustomTextField(
                    "Enter a location",
                    "",
                    widget.src.name!,
                    isLabel: false,
                    varl: FPL.text,
                    readOnly: true,
                    suffix: IconlyLight.search,
                    onTap: () {
                      Get.to(SearchScreen(
                        widget.src.name!,
                        title: "Enter Location",
                        afterTap: (value) {
                          widget.src.llng = value;
                          Get.back();
                        },
                      ));
                    },
                  ),
                ),
                if (widget.stopLocs != null) Ui.boxWidth(44),
              ],
            ),
            if (count > 0)
              ...List.generate(count, (i) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: CustomTextField(
                        "Stop location",
                        "",
                        widget.stopLocs![i].name!,
                        isLabel: false,
                        varl: FPL.text,
                        readOnly: true,
                        suffix: IconlyLight.search,
                        onTap: () {
                          Get.to(SearchScreen(
                            widget.stopLocs![i].name!,
                            title: "Stop Location",
                            afterTap: (value) {
                              widget.stopLocs![i].llng = value;
                              Get.back();
                            },
                          ));
                        },
                      ),
                    ),
                    Ui.boxWidth(12),
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: CurvedContainer(
                        onPressed: () {
                          if (count == 0) return;
                          widget.stopLocs!.removeAt(i);
                          setState(() {
                            count--;
                          });
                        },
                        padding: EdgeInsets.all(4),
                        color: AppColors.secondaryColor,
                        child: const Icon(
                          Icons.remove,
                          color: AppColors.white,
                        ),
                      ),
                    )
                  ],
                );
              }),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: CustomTextField(
                    "Enter a destination",
                    "",
                    widget.dst.name!,
                    isLabel: false,
                    readOnly: true,
                    varl: FPL.text,
                    suffix: IconlyLight.search,
                    onTap: () {
                      Get.to(SearchScreen(
                        widget.dst.name!,
                        title: "Enter Destination",
                        afterTap: (value) async {
                          widget.dst.llng = value;
                          if (widget.deliveryMode != DeliveryMode.none) {
                            await Get.find<DeliveryController>()
                                .getDeliveryDetails();
                          } else {
                            await Get.find<RideController>().getTripDetails();
                          }

                          Get.to(widget.deliveryMode != DeliveryMode.none
                              ? DeliverySummaryScreen()
                              : OrderRideScreen());
                        },
                      ));
                    },
                  ),
                ),
                if (widget.stopLocs != null) Ui.boxWidth(12),
                if (widget.stopLocs != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: CurvedContainer(
                      onPressed: () {
                        if (count == 10) return;
                        widget.stopLocs!.add(Loc(
                          name: TextEditingController(),
                        ));
                        setState(() {
                          count++;
                        });
                      },
                      padding: EdgeInsets.all(4),
                      color: AppColors.accentColor,
                      child: Icon(
                        Icons.add,
                        color: AppColors.white,
                      ),
                    ),
                  )
              ],
            ),
          ],
        ),
      )
    ]);
  }

  Widget srcToDst() {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Ui.boxHeight(12),
      const Icon(
        IconlyLight.location,
        size: 24,
        color: AppColors.accentColor,
      ),
      ...stopCnt()
    ]);
  }

  List<Widget> stopCnt() {
    return List.generate(count + 1, (index) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Ui.boxHeight(4),
          SizedBox(
            width: 12,
            child: Ui.align(
              align: Alignment.center,
              child: SvgPicture.asset(
                Assets.arrowDown,
                height: index == 0 ? 60 : 68,
              ),
            ),
          ),
          Ui.boxHeight(4),
          ConcCircle(),
        ],
      );
    });
  }
}
