import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:udrive/src/features/home/controllers/others.dart';
import 'package:udrive/src/features/home/models/booking.dart';

import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import 'package:udrive/src/features/home/views/booking/def_pages.dart';
import 'package:udrive/src/global/ui/ui_barrel.dart';
import 'package:udrive/src/utils/enums/enum_barrel.dart';

class BookingController extends GetxController {
  List<TextEditingController> textEditinController =
      List.generate(12, (index) => TextEditingController());
  List<CustomDropDownController> cdd =
      List.generate(3, (index) => CustomDropDownController());
  List<CounterController> counterController =
      List.generate(6, (index) => CounterController());

  RxList<Booking> allBooking = <Booking>[].obs;

  Map<UdriveService, List<Booking>> get bookings => _getGroupedList(allBooking);
  List<UdriveService> get bookingKeys => bookings.keys.toList();

  resetData() {
    allBooking.value = [];
  }

  requestBooking(Booking booking) {
    List<TextEditingController> conts = [];
    switch (booking.udriveService!) {
      case UdriveService.escort:
        conts = textEditinController.sublist(0, 4);
        break;
      case UdriveService.groupTransport:
        conts = textEditinController.sublist(4, 8);
        break;
      case UdriveService.aeroTrip:
        conts = textEditinController.sublist(8);
        break;
    }
    final c = Validators.validateAllTextFields(conts);
    if (c == null) {
      Get.to(DefBookingActionScreen(booking));
    } else {
      Ui.showSnackBar(c);
    }
  }

  addNewBooking(Booking booking) {
    allBooking.add(booking);
  }

  removeBooking(Booking booking) {
    allBooking.remove(booking);
  }

  // _sortInboxByTime() {
  //   allBooking.sort(((a, b) => a.time.compareTo(b.time)));
  // }

  Map<UdriveService, List<Booking>> _getGroupedList(List<Booking> soms) {
    final groupedInbox = groupBy(soms, (Booking ele) {
      return ele.udriveService!;
    });
    return groupedInbox;
  }

  List<Booking> getBooking(int i) {
    return bookings[bookingKeys[i]]!;
  }
}
