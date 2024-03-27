import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:udrive/src/features/home/controllers/delivery_controller.dart';
import 'package:udrive/src/features/home/views/current_location_screen.dart';
import 'package:udrive/src/features/home/views/delivery/delivery_summary_screen.dart';
import 'package:udrive/src/features/home/views/order_ride_screen.dart';
import 'package:udrive/src/features/home/views/widgets/header_tile.dart';
import 'package:udrive/src/features/home/views/widgets/payment_dropdown.dart';
import 'package:udrive/src/features/home/views/widgets/searchfields.dart';
import 'package:udrive/src/global/ui/ui_barrel.dart';
import 'package:udrive/src/global/ui/widgets/others/containers.dart';
import 'package:udrive/src/src_barrel.dart';

class DeliveryOptionsScreen extends StatefulWidget {
  const DeliveryOptionsScreen({super.key});

  @override
  State<DeliveryOptionsScreen> createState() => _DeliveryOptionsScreenState();
}

class _DeliveryOptionsScreenState extends State<DeliveryOptionsScreen> {
  final controller = Get.find<DeliveryController>();
  List<String> screens = ["Package \nDelivery", "Errands\n"];
  List<String> screensIcon = [Assets.cube, Assets.shoppingCart];
  List<Color> screensColor = PrivacyItems.values.map((e) => e.color).toList();

  @override
  Widget build(BuildContext context) {
    return SinglePageScaffold(
      title: "Delivery Options",
      child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          padding: EdgeInsets.all(24),
          child: Column(
            children: [
              Ui.boxHeight(14),
              SizedText(
                child: AppText.thin(
                    "Select one of the delivery options below to continue."),
              ),
              Ui.boxHeight(24),
              Ui.padding(
                padding: 0,
                child: Row(
                  children: List.generate(
                      screens.length,
                      (i) => Expanded(
                              child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: CurvedContainer(
                              radius: 8,
                              onPressed: () {
                                controller
                                    .setDeliveryMode(DeliveryMode.values[i]);
                                Get.to(CurrentLocationScreen(
                                  deliveryMode: DeliveryMode.values[i],
                                ));
                              },
                              color: screensColor[i],
                              child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      AppText.thin(screens[i]),
                                      Ui.boxHeight(24),
                                      SvgPicture.asset(
                                        screensIcon[i],
                                        width: 36,
                                        height: 36,
                                        color: AppColors.white,
                                      ),
                                      Ui.boxHeight(24),
                                    ],
                                  )),
                            ),
                          ))),
                ),
              ),
            ],
          )),
    );
  }
}
