import 'package:flutter/material.dart' hide FilledButton;
import 'package:get/get.dart';
import 'package:udrive/src/features/home/controllers/booking_controller.dart';
import 'package:udrive/src/features/home/models/booking.dart';
import 'package:udrive/src/features/home/views/home_page.dart';
import 'package:udrive/src/features/home/views/widgets/def_order_ride_page.dart';
import 'package:udrive/src/features/home/views/widgets/header_tile.dart';
import 'package:udrive/src/features/home/views/widgets/single_trip_tile.dart';
import 'package:udrive/src/global/ui/widgets/others/containers.dart';
import 'package:udrive/src/src_barrel.dart';

import '../../../../global/ui/ui_barrel.dart';

class DefBookingActionScreen extends StatefulWidget {
  final Booking booking;
  final int position;

  const DefBookingActionScreen(this.booking, {this.position = 0, super.key});

  @override
  State<DefBookingActionScreen> createState() => _DefBookingActionScreenState();
}

class _DefBookingActionScreenState extends State<DefBookingActionScreen> {
  int i = 0;
  List<String> btnTxts = ["Confirm Booking", "Back To Home", "Cancel Booking"];
  final controller = Get.find<BookingController>();

  @override
  void initState() {
    i = widget.position;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefOrderPage(
      appBar: i == 1
          ? null
          : backAppBar(
              title: widget.booking.udriveService!.name,
            ),
      trip: i != 1 ? SingleTripTile() : null,
      image: Hero(
        tag: "bigIcon",
        child: Image.asset(
          widget.booking.udriveService!.bigIcon,
          width: Ui.width(context),
          scale: widget.booking.udriveService!.scale,
          alignment: widget.booking.udriveService!.align,
        ),
      ),
      desc: i == 1 ? buildSuccess() : buildPriceItem(),
      button: FilledButton(
        onPressed: () {
          if (i == 0) {
            controller.addNewBooking(widget.booking);
            setState(() {
              i++;
            });
          } else if (i == 1) {
            Get.offAll(HomeScreen());
          } else if (i == 2) {
            Ui.showBottomSheet(
                "Cancel Booking",
                "Are you sure you want to cancel your booking?",
                HomeScreen(), yesBtn: () {
              controller.removeBooking(widget.booking);
            });
          }
        },
        text: btnTxts[i],
      ),
    );
  }

  buildPriceItem() {
    String desc =
        "${widget.booking.noOfVehicles} vehicles for ${widget.booking.noOfDays} days";
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppText.medium("Price"),
        Ui.boxHeight(12),
        AppText(
          widget.booking.cost!.toCurrency(),
          fontFamily: 'Roboto',
          fontSize: 27,
        ),
        Ui.boxHeight(12),
        AppText.thin(desc, color: AppColors.white40)
      ],
    );
  }

  buildSuccess() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppText.bold("Booking Successful", fontSize: 24),
        Ui.boxHeight(16),
        SizedText.thin("You can view your booking details in the booking list")
      ],
    );
  }
}
