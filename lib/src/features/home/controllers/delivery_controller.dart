import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pusher_beams/pusher_beams.dart';
import 'package:udrive/src/features/home/views/home_page.dart';
import 'package:udrive/src/features/map/controllers/ride_controller.dart';
import 'package:udrive/src/features/map/views/cancel_ride_screen.dart';
import 'package:udrive/src/features/map/views/trip_ended_screen.dart';
import 'package:udrive/src/global/controller/custom_ride_controller.dart';
import 'package:udrive/src/global/model/delivery.dart';
import 'package:udrive/src/global/model/loc.dart';
import 'package:udrive/src/global/model/user.dart';
import 'package:udrive/src/global/services/http_service.dart';
import 'package:udrive/src/global/ui/ui_barrel.dart';
import 'package:udrive/src/src_barrel.dart';

import '../views/widgets/loading_screen.dart';

class DeliveryController extends CustomRideController {
  Rx<DeliveryStates> currentDlvStatus = DeliveryStates.searchingForDriver.obs;
  Rx<Delivery> currentDelivery = Delivery().obs;
  Rx<DeliveryMode> currentDeliveryMode = DeliveryMode.delivery.obs;
  Rx<LatLng> driversLocation = LatLng(6.4738, 4.543).obs;
  List<TextEditingController> conts =
      List.generate(3, (index) => TextEditingController());
  final formKey = GlobalKey<FormState>();

  int get currentRSI => DeliveryStates.values.indexOf(currentDlvStatus.value);
  bool get hasEnded => currentDlvStatus.value == DeliveryStates.dlvFinished;
  Rx<PusherNotif> currentNotif = PusherNotif().obs;
  Rx<Directions> directions = Directions().obs;

  resetData() {
    currentDlvStatus.value = DeliveryStates.searchingForDriver;
    currentDelivery.value = Delivery();
    currentDeliveryMode.value = DeliveryMode.delivery;
    driversLocation.value = LatLng(6.4738, 4.543);

    currentNotif.value = PusherNotif();
    directions.value = Directions();
  }

  @override
  onInit() {
    // currentRideStatus.listen((p0) {
    //   if (p0 == DeliveryStates.foundClient) {}
    // });
    currentNotif.listen((p0) async {
      await handleRideNotif(p0);
    });
    super.onInit();
  }

  setDelivery(Delivery dlv) {
    currentDelivery.value = dlv;
    changeState(DeliveryStates.foundDriver, false);
  }

  setDeliveryMode(DeliveryMode dlvMode) {
    currentDeliveryMode.value = dlvMode;
  }

  setDriversLocation(LatLng lng) {
    driversLocation.value = lng;
  }

  bool confirmOrder() {
    final form = formKey.currentState!;
    if (form.validate()) {
      //Login
      currentDelivery.value.isErrand = false;
      currentDelivery.value.recpName = conts[0].value.text;
      currentDelivery.value.recpPhone = conts[1].value.text;
      currentDelivery.value.item = conts[2].value.text;
      UtilFunctions.clearTextEditingControllers(conts);
      return true;
    }
    return false;
  }

  changeState(DeliveryStates rs, [bool shouldAnimate = true]) {
    currentDlvStatus.value = rs;
    if (shouldAnimate) {
      dragController.animateTo(rs.size,
          duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
    }
  }

  endRide() {
    changeState(DeliveryStates.dlvFinished, false);
    changeState(DeliveryStates.searchingForDriver, false);
    Get.to(TripEndedScreen(
      deliveryMode: currentDeliveryMode.value,
    ));
  }

  startRide() {
    changeState(DeliveryStates.dlvStarted, false);
  }

  cancelRide() {
    // changeState(DeliveryStates.dlvCanceled, false);
    Get.to(CancelRideScreen(
      deliveryMode: currentDeliveryMode.value,
    ));
  }

  terminateRide({String? reason}) async {
    changeState(DeliveryStates.searchingForDriver, false);
    final c = currentDelivery.value.id ?? "";
    if (c == "") return;
    currentDelivery.value = Delivery();
    directions.value = Directions();

    if (reason != null) {
      if (currentDelivery.value.isErrand) {
        await HttpService.cancelErrand(c, reason);
      } else {
        await HttpService.cancelDelivery(c, reason);
      }
    }
  }

  bool isGreaterThan(DeliveryStates rs) {
    final c = DeliveryStates.values.indexOf(rs);
    return currentRSI >= c;
  }

  bool isIn(List<DeliveryStates> rs) {
    return rs.contains(currentDlvStatus.value);
  }

  Future getDeliveryDetails() async {
    directions.value = await HttpService.getDirections(
        homeController.srcDst[0].llng!, homeController.srcDst[1].llng!);
    print(directions.value);
    totalTime.value = directions.value.totalDuration;
    currentDelivery.value.duration =
        Duration(seconds: directions.value.totalDuration);
    currentDelivery.value.distance = directions.value.totalDistance;
    //get cost
    final cost = await HttpService.getCost(
        currentDelivery.value.duration!.inSeconds,
        currentDelivery.value.distance.toInt());
    currentDelivery.value.cost = cost;
  }

  Future searchForDriver() async {
    //request ride to get job id
    String c = "";
    if (currentDelivery.value.isErrand) {
      c = await HttpService.requestErrand(
          homeController.srcDst[0], homeController.srcDst[1], directions.value);
    } else {
      c = await HttpService.requestDelivery(
          homeController.srcDst[0],
          homeController.srcDst[1],
          directions.value,
          currentDelivery.value.recpName!,
          currentDelivery.value.recpPhone!,
          currentDelivery.value.item!);
    }

    if (c == "") {
      return false;
    }
    currentDelivery.value.id = c;

    currentDelivery.value.srcDateRaw = DateTime.now();
    currentDelivery.value.src = homeController.srcDst[0].name?.value.text ?? "";
    currentDelivery.value.dst = homeController.srcDst[1].name?.value.text ?? "";
    currentDelivery.value.srcLLNG = homeController.srcDst[0].llng!;
    currentDelivery.value.dstLLNG = homeController.srcDst[1].llng!;

    bool isNotif = false;
    final completer = Completer();
    PusherBeams.instance.onMessageReceivedInTheForeground((notification) async {
      isNotif = true;
      print(notification);
      final dc = PusherNotif.fromJSON(notification);
      await handleRideNotif(dc);
      completer.complete();
    });

    final ct = DateTime.now().millisecondsSinceEpoch + 100000;

    while (DateTime.now().millisecondsSinceEpoch < ct && !isNotif) {
      await Future.delayed(const Duration(
          milliseconds:
              100)); // add a small delay to prevent blocking the main thread
    }
    if (!isNotif) {
      // Ui.showSnackBar("Timeout");
      return false;
    }
    await completer.future;
    return true;
  }

  Future handleRideNotif(PusherNotif mp) async {
    if (mp.type == DeliveryMode.none) return;
    switch (mp.action) {
      case "ACCEPT_JOB":
        Driver? foundDriver = await HttpService.getDeliveryDriverDetail(
            currentDelivery.value.id!, mp.type);
        if (foundDriver == null) return;

        foundDriver.locationData = mp.loc;
        // await HttpService.getDriverLocation(currentDelivery.value.id!);

        currentDelivery.value.driver = foundDriver;

        Ui.showSnackBar(
            "Your delivery driver is on the way. View the delivery details in the delivery service tab.",
            isError: false);
        changeState(DeliveryStates.foundDriver, false);
        break;
      case "PICKUP":
        changeState(DeliveryStates.driverArrived, false);
        Ui.showSnackBar("Your driver has arrived and is waiting for you.",
            isError: false);
        break;
      case "START_JOB":
        startRide();
        Ui.showSnackBar("Your delivery has started", isError: false);
        break;
      case "UPDATE_LOCATION":
        currentDelivery.value.driver!.locationData = mp.loc;

        break;
      case "DROP_OFF":
        currentDelivery.value.dstDateRaw = DateTime.now();
        Ui.showSnackBar("Delivery reached ", isError: false);
        // currentDelivery.value.cost = HttpService.getCost(,)
        endRide();
        break;
      case "CANCEL":
        Get.to(TripEndedScreen(
          deliveryMode: currentDeliveryMode.value,
        ));
        break;
      default:
    }
  }

  getNotif() async {
    final c = await PusherBeams.instance.getInitialMessage();
    if (c == null) return;
    currentNotif.value = PusherNotif.fromJSON(c);
  }
}
