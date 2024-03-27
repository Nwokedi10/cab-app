import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:udrive/src/features/home/controllers/delivery_controller.dart';
import 'package:udrive/src/features/home/controllers/home_controller.dart';
import 'package:udrive/src/features/map/controllers/ride_controller.dart';
import 'package:udrive/src/global/controller/custom_ride_controller.dart';
import 'package:udrive/src/global/ui/ui_barrel.dart';
import 'package:udrive/src/src_barrel.dart';

class RideProgressWidget extends StatefulWidget {
  final DeliveryMode deliveryMode;
  const RideProgressWidget({this.deliveryMode = DeliveryMode.none, super.key});

  @override
  State<RideProgressWidget> createState() => _RideProgressWidgetState();
}

class _RideProgressWidgetState extends State<RideProgressWidget> {
  // int mins = 0;
  // int totalMins = 80;
  String sride = "Ride";
  final controller = Get.find<RideController>();
  final homeController = Get.find<HomeController>();
  final dlvController = Get.find<DeliveryController>();

  @override
  void initState() {
    sride = widget.deliveryMode.name;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() {
              return AppText.medium((widget.deliveryMode == DeliveryMode.none
                      ? controller.hasEnded
                      : dlvController.hasEnded)
                  ? "$sride Finished"
                  : "$sride Started");
            }),
            const Spacer(),
            Obx(() {
              return AppText.thin("${currentCont().timeElapsed.value}",
                  fontSize: 48);
            }),
            AppText.thin("mins", color: AppColors.accentColor, fontSize: 15),
          ],
        ),
        Ui.boxHeight(8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() {
              return AnimatedContainer(
                duration: Duration(seconds: 1),
                width: currentWidth(currentCont().timeElapsed.value,
                    currentCont().totalTime.value),
              );
            }),
            // Ui.boxWidth(mins > totalMins
            //     ? 0
            //     : (1 - ((totalMins - mins) / totalMins)) *
            //         (Ui.width(context) - 196)),
            Image.asset(
              homeController.currentVehicleType.value.imageRide,
              width: 100,
            ),
          ],
        ),
        Ui.boxHeight(8),
        SizedBox(
          height: 32,
          child: Row(
            children: [
              CircleDot(),
              Expanded(
                child: Stack(
                  children: [
                    Divider(
                      color: AppColors.secondaryColor,
                    ),
                    Obx(() {
                      return AnimatedContainer(
                        duration: Duration(seconds: 1),
                        width: currentWidth(currentCont().timeElapsed.value,
                            currentCont().totalTime.value,
                            space: 96),
                        child: Divider(
                          color: AppColors.accentColor,
                        ),
                      );
                    }),
                    // SizedBox(
                    //   width: mins > totalMins
                    //       ? 0
                    //       : (1 - ((totalMins - mins) / totalMins)) *
                    //           (Ui.width(context) - 96),
                    //   child: Divider(
                    //     color: AppColors.accentColor,
                    //   ),
                    // )
                  ],
                ),
              ),
              CircleDot()
            ],
          ),
        )
      ],
    );
  }

  double currentWidth(int a, int b, {double space = 196}) {
    return a > b ? 0 : (1 - ((b - a) / b)) * (Ui.width(context) - space);
  }

  CustomRideController currentCont() {
    if (widget.deliveryMode == DeliveryMode.none) {
      return controller;
    } else {
      return dlvController;
    }
  }
}
