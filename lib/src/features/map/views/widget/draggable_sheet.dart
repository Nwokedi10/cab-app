import 'package:flutter/material.dart' hide FilledButton;
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:udrive/src/features/home/controllers/home_controller.dart';
import 'package:udrive/src/features/home/views/reason_cancel.dart';
import 'package:udrive/src/features/home/views/search_place_screen.dart';
import 'package:udrive/src/features/home/views/widgets/loading_screen.dart';
import 'package:udrive/src/features/home/views/widgets/single_trip_tile.dart';
import 'package:udrive/src/features/map/controllers/ride_controller.dart';
import 'package:udrive/src/features/map/views/map.dart';
import 'package:udrive/src/features/map/views/widget/ride_progress.dart';
import 'package:udrive/src/global/model/trip.dart';
import 'package:udrive/src/global/ui/ui_barrel.dart';
import 'package:udrive/src/global/ui/widgets/others/containers.dart';
import 'package:udrive/src/src_barrel.dart';
import 'package:url_launcher/url_launcher.dart';

import 'driver_tile.dart';

class DraggableMapBottomSheet extends StatefulWidget {
  const DraggableMapBottomSheet({super.key});

  @override
  State<DraggableMapBottomSheet> createState() =>
      _DraggableMapBottomSheetState();
}

class _DraggableMapBottomSheetState extends State<DraggableMapBottomSheet> {
  final controller = Get.find<RideController>();
  final homeController = Get.find<HomeController>();
  // List<Widget> screens = [];

  @override
  void initState() {
    // screens = [
    //   initialScreen(), //0.5
    //   collapsedScreen(), //0.12
    //   containerRideProgress(), //0.24
    //   fullScreen() //1
    // ];
    controller.changeScreen(controller.currentRideStatus.value.screen);

    controller.dragController.addListener(() {
      final curSize = controller.dragController.size;
      if (!mounted) return;
      if (curSize > 0.6 && controller.isGreaterThan(RideStates.rideStarted)) {
        controller.changeScreen(3);
      } else if (curSize > 0.3 &&
          controller.isIn([RideStates.foundDriver, RideStates.driverArrived])) {
        controller.changeScreen(0);
      } else if (curSize > 0.2 &&
          controller.isGreaterThan(RideStates.rideStarted)) {
        controller.changeScreen(2);
      } else {
        controller.changeScreen(1);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return DraggableScrollableSheet(
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              clipBehavior: Clip.none,
              child: Obx(() {
                return controller.curScreen.value == 3
                    ? ColoredBox(
                        color: AppColors.primaryColor,
                        child: SizedBox(
                            height: Ui.height(context), child: fullScreen()),
                      )
                    : DragContainer(
                        child: SizedBox(
                            height: Ui.height(context),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Obx(() {
                                    switch (controller.curScreen.value) {
                                      case 0:
                                        return initialScreen();
                                      case 1:
                                        return collapsedScreen(); //0.12
                                      case 2:
                                        return containerRideProgress(); //0.24
                                      case 3:
                                        return fullScreen(); //1
                                      default:
                                        return initialScreen();
                                    }
                                  }),
                                ])),
                      );
              }),
            );
          },
          controller: controller.dragController,
          minChildSize: 0.12,
          initialChildSize: controller.currentRideStatus.value.size,
          maxChildSize:
              controller.isGreaterThan(RideStates.rideStarted) ? 1 : 0.5,
          snap: true,
          snapSizes: controller.isGreaterThan(RideStates.rideStarted)
              ? const [0.24]
              : null,
        );
      },
    );
  }

  Widget initialScreen() {
    return Stack(
      alignment: AlignmentDirectional.topStart,
      children: [
        SizedBox(
          height: (Ui.height(context) / 2),
          width: Ui.width(context),
        ),
        DriverTile(driver: controller.currentTrip.value.driver!),
        Positioned(
          right: 12,
          child: CircleAvatar(
            radius: 50,
            backgroundColor: AppColors.accentColor,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppText.thin(
                    controller.currentTrip.value.duration!.inMinutes.toString(),
                    fontSize: 36),
                Ui.boxWidth(4),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppText.thin("mins", fontSize: 14),
                    AppText.thin("away",
                        fontSize: 14, color: AppColors.white40),
                  ],
                )
              ],
            ),
          ),
        ),
        Positioned(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                homeController.currentVehicleType.value.image,
                width: Ui.width(context) - 48,
              ),
              AppText.thin(controller.currentTrip.value.driver!.car.name,
                  color: AppColors.white40),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppText.thin("Plate No: ", color: AppColors.white40),
                  AppText.bold(
                      controller.currentTrip.value.driver!.car.plateNo),
                ],
              ),
              Ui.boxHeight(24),
              LineTripTile(trip: controller.currentTrip.value, hasIcon: true),
              Ui.boxHeight(24),
              SizedBox(
                height: 48,
                width: Ui.width(context) - 48,
                child: Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                        onPressed: () async {
                          await launchUrl(Uri(
                              scheme: 'tel',
                              path:
                                  controller.currentTrip.value.driver!.phone));
                        },
                        text: "Call Driver",
                      ),
                    ),
                    Ui.boxWidth(8),
                    Expanded(
                      child: FilledButton.outline(
                        () {
                          Get.to(ReasonCancelScreen());
                        },
                        "Cancel Ride",
                        color: AppColors.primaryColor,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget containerRideProgress() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 56.0),
      child: SizedBox(
        height: Ui.height(context) * 0.24,
        child: Center(child: RideProgressWidget()),
      ),
    );
  }

  Widget fullScreen() {
    return Padding(
      padding: const EdgeInsets.all(48.0),
      child: Column(
        children: [
          Ui.align(
              align: Alignment.centerRight,
              child: SvgIconButton(Assets.close, () {
                controller.reduce();
              })),
          Ui.boxHeight(48),
          RideProgressWidget(),
          Ui.boxHeight(64),
          // Ui.align(child: AppText.medium("Ride Options")),
          // Ui.boxHeight(24),
          // ListTile(
          //   leading: AppText.thin("Cancel Ride"),
          //   onTap: controller.cancelRide,
          //   trailing: Icon(
          //     IconlyLight.arrow_right_2,
          //     color: AppColors.accentColor,
          //   ),
          // ),
          // ListTile(
          //   leading: AppText.thin("Change Destination"),
          //   onTap: () {
          //     Get.to(SearchScreen(
          //       homeController.srcDst[1].name!,
          //       title: "Change Destination",
          //       afterTap: (value) {
          //         Get.to(LoadingScreen(
          //             "Updating Destination", () {}, MapWidget()));
          //       },
          //     ));
          //   },
          //   trailing: Icon(
          //     IconlyLight.arrow_right_2,
          //     color: AppColors.accentColor,
          //   ),
          // ),
          // Ui.boxHeight(48),
          // Ui.align(child: AppText.medium("Payment Methods"))
        ],
      ),
    );
  }

  Widget collapsedScreen() {
    return Ui.align(
        align: Alignment.center,
        child: SvgIconButton(
          Assets.expand,
          () {},
          size: 56,
        ));
  }
}

class DragContainer extends StatelessWidget {
  final Widget? child;
  const DragContainer({this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          top: -16,
          left: 28,
          right: 28,
          child: Container(
            height: 56,
            decoration: BoxDecoration(
                color: Color(0xFF050124), borderRadius: Ui.topRadius(39)),
          ),
        ),
        Container(
          width: Ui.width(context),
          decoration: BoxDecoration(
              color: AppColors.primaryColor, borderRadius: Ui.topRadius(39)),
          padding: EdgeInsets.only(right: 24, left: 24, top: 12, bottom: 48),
          child: child,
        ),
      ],
    );
  }
}
