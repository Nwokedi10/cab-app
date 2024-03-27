import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:udrive/src/features/home/views/booking/aero_screen.dart';
import 'package:udrive/src/features/home/views/booking/gtrans_screen.dart';
import 'package:udrive/src/global/model/loc.dart';
import 'package:udrive/src/global/model/user.dart';
import 'package:udrive/src/global/services/http_service.dart';
import 'package:udrive/src/global/services/mypref.dart';
import 'package:udrive/src/src_barrel.dart';

import '../../../global/model/trip.dart';
import '../views/booking/escort_screen.dart';

import 'package:intl/intl.dart';
import 'package:collection/collection.dart';

class HomeController extends GetxController {
  Rx<User> currentUser = User().obs;
  RxList<Trip> userRegularTrips = <Trip>[].obs;
  List<Loc> srcDst = [
    Loc(name: TextEditingController()),
    Loc(name: TextEditingController())
  ];
  List<Loc> stopLocations = [];

  static const List<String> vehicleTypes = ["Car", "Keke", "Bike"];
  Rx<VehicleTypes> currentVehicleType = VehicleTypes.car.obs;

  // List<TextEditingController> textControllers =
  //     List.generate(2, (index) => TextEditingController());
  final screens = [EscortScreen(), GroupTransportScreen(), AeroTripScreen()];

  //ride history
  RxList<Trip> userTrips = <Trip>[].obs;
  Map<String, List<Trip>> get msgs => _getGroupedList(userTrips);
  List<String> get msgKeys => msgs.keys.toList();

  @override
  void onInit() {
    currentUser.value = MyPrefs.localUser();
    getTripHistory();
    super.onInit();
  }

  _sortInboxByTime() {
    userTrips.sort(((a, b) => b.dstDateRaw!.compareTo(a.dstDateRaw!)));
  }

  Map<String, List<Trip>> _getGroupedList(List<Trip> soms) {
    final groupedInbox = groupBy(soms, (Trip ele) {
      return DateUtils.weekInString(ele.dstDateRaw!);
    });
    return groupedInbox;
  }

  List<Trip> getMsg(int i) {
    return msgs[msgKeys[i]]!;
  }

  getTripHistory() async {
    final d = MyPrefs.isRawLoggedIn();
    if (!d) return;
    final c = await HttpService.getRideHistory();
    userTrips.value = c;
    if (c.isEmpty) return;

    _sortInboxByTime();
  }

  getRegularTripHistory() async {
    final d = MyPrefs.isRawLoggedIn();
    if (!d) return;
    // final c = await HttpService.getRegularTrips();
    final c = <Trip>[];
    await Future.delayed(Duration(seconds: 5), () {});
    userRegularTrips.value = c;
    if (c.isEmpty) return;

    _sortInboxByTime();
  }
}
