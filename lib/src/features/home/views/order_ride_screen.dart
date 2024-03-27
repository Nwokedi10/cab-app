import 'package:flutter/material.dart' hide FilledButton;
import 'package:get/get.dart';
import 'package:udrive/src/features/home/views/widgets/loading_screen.dart';
import 'package:udrive/src/features/map/controllers/ride_controller.dart';
import 'package:udrive/src/features/map/views/map.dart';
import 'package:udrive/src/global/model/trip.dart';
import 'package:udrive/src/global/model/user.dart';
import 'package:udrive/src/global/services/mypref.dart';
import 'package:udrive/src/global/ui/ui_barrel.dart';

import '../../../src_barrel.dart';
import 'widgets/def_order_ride_page.dart';
import 'widgets/single_trip_tile.dart';

class OrderRideScreen extends StatefulWidget {
  OrderRideScreen({super.key});

  @override
  State<OrderRideScreen> createState() => _OrderRideScreenState();
}

class _OrderRideScreenState extends State<OrderRideScreen> {
  final controller = Get.find<RideController>();

  @override
  Widget build(BuildContext context) {
    return DefOrderPage(
      appBar: backAppBar(title: "Order Ride"),
      trip: SingleTripTile(
        srcLocation: controller.homeController.srcDst[0].name!.value.text,
        dstLocation: controller.homeController.srcDst[1].name!.value.text,
      ),
      image: Image.asset(
        Assets.order,
        width: Ui.width(context),
        fit: BoxFit.fitWidth,
      ),
      desc: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppText.medium("Estimated Fare"),
          Ui.boxHeight(12),
          Obx(() {
            return controller.currentTrip.value.cost == 0
                ? CircularProgress(24)
                : AppText(
                    UtilFunctions.moneyRange(
                        controller.currentTrip.value.moneyRange[0],
                        controller.currentTrip.value.moneyRange[1]),
                    fontSize: 27,
                    fontFamily: 'Roboto',
                  );
          }),
          Ui.boxHeight(12),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppText.thin("Payment Method", color: AppColors.accentColor),
              Ui.boxWidth(4),
              AppText.thin(MyPrefs.readData(MyPrefs.mpUdrivePaym) ?? "Cash"),
            ],
          )
        ],
      ),
      button: Obx(() {
        return FilledButton(
          onPressed: () {
            Get.to(LoadingScreen(
                "Connecting you to a driver...",
                () async {
                  final c = await controller.searchForDriver();
                  return c;
                },
                MapWidget(),
                onBack: () async {
                  await controller.terminateRide();
                  Get.back();
                }));
          },
          disabled: controller.currentTrip.value.cost == 0,
          text: "Book Ride",
        );
      }),
    );
  }
}
