import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:udrive/src/features/home/controllers/delivery_controller.dart';
import 'package:udrive/src/features/home/views/current_location_screen.dart';
import 'package:udrive/src/features/home/views/delivery/delivery_options_screen.dart';
import 'package:udrive/src/features/home/views/delivery/delivery_summary_screen.dart';
import 'package:udrive/src/features/map/controllers/ride_controller.dart';
import 'package:udrive/src/features/map/views/map.dart';
import 'package:udrive/src/features/map/views/widget/ride_progress.dart';
import 'package:udrive/src/global/ui/widgets/others/containers.dart';
import 'package:udrive/src/src_barrel.dart';

import '../../../../global/ui/ui_barrel.dart';

class CarouselAd extends StatelessWidget {
  const CarouselAd({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(CurrentLocationScreen());
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          SizedBox(
            width: Ui.width(context) * 0.8,
            height: 144,
          ),
          CurvedContainer(
            color: AppColors.secondaryColor,
            radius: 30,
            width: Ui.width(context) * 0.8,
            child: SizedBox(
              height: 144,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Ui.align(
                  align: Alignment.centerRight,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 32.0),
                        child: AppText.thin("Ready to go", fontSize: 16),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 32.0),
                        child: AppText.bold("somewhere?", fontSize: 16),
                      ),
                      Ui.boxHeight(8),
                      Ui.align(
                          align: Alignment.centerRight,
                          child: CircleAvatar(
                            backgroundColor: AppColors.white,
                            radius: 20,
                            child: Icon(
                              IconlyLight.arrow_right_2,
                              color: AppColors.primaryColor,
                              size: 24,
                            ),
                          ))
                      // SvgPicture.asset(Assets.arrowLeft)
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: -12,
            top: 0,
            bottom: 0,
            child: Image.asset(
              Assets.carousel,
              width: Ui.width(context) * 0.4,
            ),
          )
        ],
      ),
    );
  }
}

class CarouselAd2 extends StatelessWidget {
  CarouselAd2({super.key});
  final controller = Get.find<DeliveryController>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(controller.isIn([
          DeliveryStates.dlvFinished,
          DeliveryStates.dlvCanceled,
          DeliveryStates.searchingForDriver
        ])
            ? DeliveryOptionsScreen()
            : DeliverySummaryScreen());
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          SizedBox(
            width: Ui.width(context) * 0.8,
            height: 144,
          ),
          CurvedContainer(
            color: AppColors.accentColor,
            radius: 30,
            width: Ui.width(context) * 0.8,
            child: SizedBox(
              height: 144,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Ui.align(
                  align: Alignment.centerRight,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 32.0),
                        child: AppText.thin("Udrive", fontSize: 16),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 32.0),
                        child: AppText.bold("Delivery Service", fontSize: 16),
                      ),
                      // AppText.thin("Udrive", fontSize: 16),
                      // AppText.bold("Delivery Service", fontSize: 16),
                      Ui.boxHeight(8),
                      Ui.align(
                          align: Alignment.centerRight,
                          child: CircleAvatar(
                            backgroundColor: AppColors.white,
                            radius: 20,
                            child: Icon(
                              IconlyLight.arrow_right_2,
                              color: AppColors.primaryColor,
                              size: 24,
                            ),
                          ))
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 16,
            top: 16,
            bottom: 16,
            child: Image.asset(
              Assets.carousel2,
            ),
          )
        ],
      ),
    );
  }
}

class CarouselSlider extends StatelessWidget {
  CarouselSlider({super.key});
  final rideController = Get.find<RideController>();
  final dlvController = Get.find<DeliveryController>();

  @override
  Widget build(BuildContext context) {
    // return Obx(() {
    //   return !rideController.isIn([
    //     RideStates.rideFinished,
    //     RideStates.rideCanceled,
    //     RideStates.searchingForDriver
    //   ])
    //       ? CurvedContainer(
    //           padding: EdgeInsets.all(16),
    //           radius: 30,
    //           width: Ui.width(context) - 48,
    //           onPressed: () {
    //             Get.to(MapWidget());
    //           },
    //           color: AppColors.secondaryColor,
    //           child: RideProgressWidget())
    //       : CarouselAd();
    // });
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: [
          Obx(() {
            return !rideController.isIn([
              RideStates.rideFinished,
              RideStates.rideCanceled,
              RideStates.searchingForDriver
            ])
                ? CurvedContainer(
                    padding: EdgeInsets.all(16),
                    radius: 30,
                    width: Ui.width(context) - 48,
                    onPressed: () {
                      Get.to(MapWidget());
                    },
                    color: AppColors.secondaryColor,
                    child: RideProgressWidget())
                : CarouselAd();
          }),
          Ui.boxWidth(24),
          Obx(() {
            return !dlvController.isIn([
              DeliveryStates.dlvFinished,
              DeliveryStates.dlvCanceled,
              DeliveryStates.searchingForDriver
            ])
                ? CurvedContainer(
                    width: Ui.width(context) - 48,
                    padding: EdgeInsets.all(16),
                    radius: 30,
                    onPressed: () {
                      Get.to(DeliverySummaryScreen());
                    },
                    color: AppColors.secondaryColor,
                    child: RideProgressWidget(
                      deliveryMode: dlvController.currentDeliveryMode.value,
                    ))
                : CarouselAd2();
          }),
        ],
      ),
    );
  }
}
