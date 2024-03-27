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

class GroupTransportScreen extends StatelessWidget {
  GroupTransportScreen({super.key});
  final controller = Get.find<BookingController>();

  @override
  Widget build(BuildContext context) {
    return SinglePageScaffold(
      title: "Group Transport",
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        child: Ui.padding(
            child: Column(
          children: [
            SizedText.thin("Book a bus to transport people to a destination."),
            Ui.boxHeight(24),
            Hero(
              tag: "bigIcon",
              child: Image.asset(
                Assets.groupTransportBig,
                width: Ui.width(context),
                height: Ui.height(context) / 3,
              ),
            ),
            Ui.boxHeight(24),
            Row(
              children: [
                Expanded(
                    child: TitleTile(
                  "No Of Passengers",
                  child: CounterWidget(controller.counterController[2]),
                )),
                Ui.boxWidth(16),
                Expanded(
                    child: TitleTile(
                  "No Of Days",
                  child: CounterWidget(controller.counterController[3]),
                ))
              ],
            ),
            BookingFields([
              controller.textEditinController[4],
              controller.textEditinController[5],
              controller.textEditinController[6],
              controller.textEditinController[7],
            ]),
            Ui.boxHeight(48),
            SafeArea(
              child: FilledButton(
                onPressed: () {
                  controller.requestBooking(Booking(
                      // carType: controller.cdd[0].value,
                      cost: 230000,
                      noOfDays: int.parse(
                          controller.counterController[2].value ?? "1"),
                      noOfVehicles: int.parse(
                          controller.counterController[3].value ?? "1"),
                      udriveService: UdriveService.groupTransport,
                      trip: Trip(
                        src: controller.textEditinController[6].value.text,
                        dst: controller.textEditinController[7].value.text,
                        time: controller.textEditinController[5].value.text,
                        date: controller.textEditinController[4].value.text,
                      )));
                },
                text: "Request Group Transport",
              ),
            ),
          ],
        )),
      ),
    );
  }
}
