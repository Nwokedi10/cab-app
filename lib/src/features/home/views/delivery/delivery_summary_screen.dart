import 'package:flutter/material.dart' hide FilledButton;
import 'package:get/get.dart';
import 'package:udrive/src/features/home/controllers/delivery_controller.dart';
import 'package:udrive/src/features/home/views/delivery/delivery_recipient_screen.dart';
import 'package:udrive/src/features/home/views/home_page.dart';
import 'package:udrive/src/features/home/views/widgets/def_order_ride_page.dart';
import 'package:udrive/src/features/home/views/widgets/loading_screen.dart';
import 'package:udrive/src/features/home/views/widgets/single_trip_tile.dart';
import 'package:udrive/src/features/map/controllers/ride_controller.dart';
import 'package:udrive/src/features/map/views/cancel_ride_screen.dart';
import 'package:udrive/src/features/map/views/map.dart';
import 'package:udrive/src/features/map/views/widget/driver_tile.dart';
import 'package:udrive/src/global/model/trip.dart';
import 'package:udrive/src/global/model/user.dart';
import 'package:udrive/src/global/services/mypref.dart';
import 'package:udrive/src/global/ui/ui_barrel.dart';
import 'package:udrive/src/global/ui/widgets/others/containers.dart';

import '../../../../src_barrel.dart';

class DeliverySummaryScreen extends StatelessWidget {
  DeliverySummaryScreen({super.key});
  final controller = Get.find<DeliveryController>();

  @override
  Widget build(BuildContext context) {
    print(controller.currentDlvStatus.value);
    return DefOrderPage(
        appBar: backAppBar(title: "Delivery Summary"),
        trip: SingleTripTile(
          srcLocation: controller.homeController.srcDst[0].name!.value.text,
          dstLocation: controller.homeController.srcDst[1].name!.value.text,
        ),
        // image: Hero(
        //   tag: "bigIcon",
        //   child: Image.asset(
        //     Assets.order,
        //     width: Ui.width(context) + 16,
        //   ),
        // ),
        desc: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText.medium("Estimated Fare"),
            Ui.boxHeight(12),
            Obx(() {
              return controller.currentDelivery.value.cost == 0
                  ? CircularProgress(24)
                  : AppText(
                      UtilFunctions.moneyRange(
                          controller.currentDelivery.value.moneyRange[0],
                          controller.currentDelivery.value.moneyRange[1]),
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
            ),
            Ui.boxHeight(12),
            if (controller.currentDlvStatus.value ==
                DeliveryStates.searchingForDriver)
              Ui.align(child: AppText.medium("Note:")),
            if (controller.currentDlvStatus.value ==
                DeliveryStates.searchingForDriver)
              Ui.boxHeight(12),
            if (controller.currentDlvStatus.value ==
                DeliveryStates.searchingForDriver)
              SizedText(
                  child: AppText.thin(
                      "The estimated fare may vary from the actual cost. This would be confirmed by our delivery driver upon weighing and determining the size of the item to be sent.",
                      fontSize: 13)),
            if (controller.currentDlvStatus.value ==
                DeliveryStates.searchingForDriver)
              Ui.boxHeight(24),
            controller.currentDelivery.value.driver == null
                ? SizedBox()
                : CurvedContainer(
                    radius: 0,
                    color: AppColors.secondaryColor,
                    width: Ui.width(context),
                    shouldClip: false,
                    padding: EdgeInsets.all(24),
                    child: DriverTile(
                        isPhone: true,
                        driver: controller.currentDelivery.value.driver!),
                  ),
          ],
        ),
        button: Obx(() {
          return controller.currentDlvStatus.value ==
                  DeliveryStates.searchingForDriver
              ? FilledButton(
                  disabled: controller.currentDelivery.value.cost == 0,
                  onPressed: () {
                    if (controller.currentDeliveryMode == DeliveryMode.errand) {
                      Get.to(LoadingScreen(
                          "Connecting you to a driver...",
                          () async {
                            final c = await controller.searchForDriver();
                            return c;
                          },
                          HomeScreen(),
                          onBack: () async {
                            await controller.terminateRide();
                            Get.back();
                          }));
                    } else {
                      Get.to(DeliveryRecipientScreen());
                    }
                  },
                  text: "Continue",
                )
              : Column(
                  children: [
                    FilledButton(
                      onPressed: () {
                        Get.to(MapWidget(
                            deliveryMode:
                                controller.currentDeliveryMode.value));
                      },
                      text: "Track Driver",
                    ),
                    Ui.boxHeight(24),
                    FilledButton.outline(
                      () {
                        controller.cancelRide();
                      },
                      "Cancel Order",
                    )
                  ],
                );
        }));
  }
}
