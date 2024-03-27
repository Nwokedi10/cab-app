import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:udrive/src/features/map/controllers/ride_controller.dart';
import 'package:udrive/src/global/ui/ui_barrel.dart';
import 'package:udrive/src/src_barrel.dart';

class DriversCar extends StatelessWidget {
  DriversCar({super.key});
  final controller = Get.find<RideController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              const Color(0xFF0B060C).withOpacity(0.8),
              AppColors.accentColor.withOpacity(0.5),
            ],
            radius: 1,
          )),
      child: Obx(() {
        return Transform.rotate(
            angle: UtilFunctions.deg(
                controller.currentTrip.value.driver?.locationData?.heading ??
                    0),
            child: SizedBox(
              height: 48,
              width: 28,
              child: Image.asset(
                Assets.mapCar,
                fit: BoxFit.contain,
                height: 48,
                width: 28,
              ),
            ));
      }),
    );
  }
}

class LocationWidget extends StatelessWidget {
  final bool isUser;
  LocationWidget({this.isUser = true, super.key});
  final controller = Get.find<RideController>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Ui.width(context) / 2,
      height: 45,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleDot(
            size: 44,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.medium(isUser ? "Your Location" : "Destination"),
              Ui.boxHeight(4),
              if (!isUser)
                Obx(() {
                  return AppText.thin(
                      "${controller.currentTrip.value.duration!.inMinutes} mins away");
                })
            ],
          )
        ],
      ),
    );
  }
}
