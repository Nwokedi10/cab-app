import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:udrive/src/app/theme/colors.dart';
import 'package:udrive/src/features/home/controllers/home_controller.dart';
import 'package:udrive/src/features/home/views/ride_info_screen.dart';
import 'package:udrive/src/features/home/views/widgets/empty_screen.dart';
import 'package:udrive/src/features/home/views/widgets/single_trip_tile.dart';
import 'package:udrive/src/global/ui/widgets/others/containers.dart';

import '../../../global/ui/ui_barrel.dart';

class RegularTripsScreen extends StatefulWidget {
  const RegularTripsScreen({super.key});

  @override
  State<RegularTripsScreen> createState() => _RegularTripsScreenState();
}

class _RegularTripsScreenState extends State<RegularTripsScreen> {
  final controller = Get.find<HomeController>();
  bool isLoading = true;

  @override
  void initState() {
    // isLoading = controller.userTrips.isEmpty;
    getRides();
    super.initState();
  }

  Future getRides() async {
    setState(() {
      isLoading = controller.userRegularTrips.isEmpty;
    });
    await controller.getRegularTripHistory();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SinglePageScaffold(
      title: "Regular Trips",
      safeArea: true,
      child: Ui.padding(
        child: isLoading
            ? ListView.builder(
                itemCount: 8,
                itemBuilder: (_, i) {
                  return ShimmerWidget();
                })
            : Obx(() {
                return controller.userRegularTrips.isEmpty
                    ? EmptyScreen()
                    : ListView.separated(
                        physics: const BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics()),
                        padding: const EdgeInsets.only(
                            top: 64, left: 24, right: 24, bottom: 24),
                        itemBuilder: (_, i) {
                          final c = controller.userRegularTrips[i];
                          return SingleTripTile(
                            hasIcon: true,
                            srcLocation: c.src,
                            dstLocation: c.dst,
                            onTap: () {
                              Get.to(RideInfoScreen(c));
                            },
                          );
                        },
                        separatorBuilder: (_, i) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 24.0),
                            child: Divider(
                              color: AppColors.secondaryColor,
                            ),
                          );
                        },
                        itemCount: controller.userRegularTrips.length);
              }),
      ),
    );
  }
}
