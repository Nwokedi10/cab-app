import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:udrive/src/features/home/controllers/delivery_controller.dart';
import 'package:udrive/src/features/map/controllers/ride_controller.dart';
import 'package:udrive/src/features/map/views/widget/star_rate.dart';
import 'package:udrive/src/global/ui/ui_barrel.dart';
import 'package:udrive/src/src_barrel.dart';

import '../../../utils/utils_barrel.dart';

class TripEndedScreen extends StatefulWidget {
  final DeliveryMode deliveryMode;
  final String? reason;
  const TripEndedScreen(
      {this.deliveryMode = DeliveryMode.none, this.reason, super.key});

  @override
  State<TripEndedScreen> createState() => _TripEndedScreenState();
}

class _TripEndedScreenState extends State<TripEndedScreen> {
  final controller = Get.find<RideController>();
  final dlvController = Get.find<DeliveryController>();
  int price = 0;

  @override
  void initState() {
    if (widget.deliveryMode == DeliveryMode.none) {
      price = controller.currentTrip.value.cost.toInt();
      controller.terminateRide(reason: widget.reason);
    } else {
      price = dlvController.currentDelivery.value.cost.toInt();
      dlvController.terminateRide(reason: widget.reason);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          SizedBox(
            height: Ui.height(context),
            width: Ui.width(context),
          ),
          Positioned(left: -92, top: -92, child: gradCircle()),
          Column(
            children: [
              Ui.boxHeight(120),
              AppText.medium("${widget.deliveryMode.name} Successful",
                  fontSize: 32),
              Ui.boxHeight(44),
              AppText.medium("Your total charge is "),
              Ui.boxHeight(24),
              AppText.medium(price.toCurrency(),
                  fontFamily: 'Roboto', fontSize: 48),
              Image.asset(
                Assets.ss1,
                width: Ui.width(context),
              ),
            ],
          ),
          Positioned(
              right: -92,
              bottom: -92,
              child: gradCircle(boxColor: Color(0xFF7B1EA7))),
          Positioned(
            bottom: 64,
            child: Column(
              children: [
                SizedBox(
                    width: Ui.width(context),
                    child: Center(child: AppText.medium("Rate your driver"))),
                Ui.boxHeight(16),
                StarRateWidget(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Container gradCircle({Color boxColor = AppColors.secondaryColor}) {
    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
              colors: [const Color(0xFF0D0363), const Color(0xFF0C0162)]),
          boxShadow: [
            BoxShadow(blurRadius: 250, spreadRadius: 205, color: boxColor)
          ]),
    );
  }
}
