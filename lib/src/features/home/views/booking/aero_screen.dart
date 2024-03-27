import 'package:flutter/material.dart' hide FilledButton;
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:udrive/src/features/home/controllers/booking_controller.dart';
import 'package:udrive/src/features/home/models/booking.dart';
import 'package:udrive/src/features/home/views/booking/def_pages.dart';
import 'package:udrive/src/features/home/views/widgets/cartype_dropdown.dart';
import 'package:udrive/src/features/home/views/widgets/header_tile.dart';
import 'package:udrive/src/features/home/views/widgets/searchfields.dart';
import 'package:udrive/src/global/model/trip.dart';
import 'package:udrive/src/global/ui/functions/ui_functions.dart';
import 'package:udrive/src/global/ui/ui_barrel.dart';
import 'package:udrive/src/global/ui/widgets/fields/custom_textfield.dart';
import 'package:udrive/src/global/ui/widgets/others/containers.dart';
import 'package:udrive/src/src_barrel.dart';

class AeroTripScreen extends StatelessWidget {
  AeroTripScreen({super.key});
  final controller = Get.find<BookingController>();

  @override
  Widget build(BuildContext context) {
    return SinglePageScaffold(
      title: "AeroTrips",
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        child: Column(
          children: [
            Ui.padding(
                child: SizedText.thin(
                    "Travelling to a new city? Book a personal Udrive certified driver for your entire stay.")),
            Hero(
              tag: "bigIcon",
              child: Image.asset(
                Assets.aeroTripBig,
                width: Ui.width(context),
                height: Ui.height(context) / 2,
              ),
            ),
            Ui.padding(child: CarTypeDropDown(controller.cdd[1])),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: [
                  Expanded(
                    child: TitleTile(
                      "No Of Days",
                      child: CounterWidget(controller.counterController[4]),
                    ),
                  ),
                  Expanded(child: SizedBox())
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: BookingFields([
                controller.textEditinController[8],
                controller.textEditinController[9],
                controller.textEditinController[10],
                controller.textEditinController[11],
              ]),
            ),
            Ui.boxHeight(24),
            Ui.padding(
              child: SafeArea(
                child: FilledButton(
                  onPressed: () {
                    controller.requestBooking(Booking(
                        carType: controller.cdd[1].value,
                        cost: 230000,
                        noOfDays: int.parse(
                            controller.counterController[4].value ?? "1"),
                        noOfVehicles: 1,
                        //     int.parse(controller.counterController[1].value ?? "0"),
                        udriveService: UdriveService.aeroTrip,
                        trip: Trip(
                          src: controller.textEditinController[10].value.text,
                          dst: controller.textEditinController[11].value.text,
                          time: controller.textEditinController[9].value.text,
                          date: controller.textEditinController[8].value.text,
                        )));
                  },
                  text: "Request Driver",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
