import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pusher_beams/pusher_beams.dart';
import 'package:udrive/src/features/home/controllers/home_controller.dart';
import 'package:udrive/src/features/map/views/cancel_ride_screen.dart';
import 'package:udrive/src/features/map/views/trip_ended_screen.dart';
import 'package:udrive/src/global/controller/custom_ride_controller.dart';
import 'package:udrive/src/global/model/loc.dart';
import 'package:udrive/src/global/model/user.dart';
import 'package:udrive/src/global/services/http_service.dart';
import 'package:udrive/src/global/ui/ui_barrel.dart';
import 'package:udrive/src/src_barrel.dart';

import '../../../global/model/trip.dart';

class RideController extends CustomRideController {
  Rx<RideStates> currentRideStatus = RideStates.searchingForDriver.obs;
  Rx<Trip> currentTrip = Trip().obs;
  Rx<LatLng> driversLocation = const LatLng(6.8604, 7.4119).obs;
  Rx<Directions> directions = const Directions().obs;
  int get currentRSI => RideStates.values.indexOf(currentRideStatus.value);
  bool get hasEnded => currentRideStatus.value == RideStates.rideFinished;
  Rx<PusherNotif> currentNotif = PusherNotif().obs;

  @override
  onInit() {
    // currentRideStatus.listen((p0) {
    //   if (p0 == RideStates.foundClient) {}
    // });
    currentNotif.listen((p0) async {
      await handleRideNotif(p0);
    });
    super.onInit();
  }

  setTrip(Trip trip) {
    currentTrip.value = trip;
  }

  setDriversLocation(LatLng lng) {
    driversLocation.value = lng;
  }

  changeState(RideStates rs, [bool shouldAnimate = true]) {
    currentRideStatus.value = rs;
    if (shouldAnimate) {
      dragController.animateTo(rs.size,
          duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
    }
  }

  endRide() {
    changeState(RideStates.rideFinished, false);
    changeState(RideStates.searchingForDriver, false);
    Get.to(TripEndedScreen());
  }

  cancelRide() {
    // changeState(RideStates.rideCanceled, false);
    Get.to(CancelRideScreen());
  }

  terminateRide({String? reason}) async {
    changeState(RideStates.searchingForDriver, false);
    final c = currentTrip.value.id ?? "";
    if (c == "") return;
    currentTrip.value = Trip();
    directions.value = Directions();

    if (reason != null) {
      await HttpService.cancelRide(c, reason);
    }
  }

  startRide() {
    changeState(RideStates.rideStarted);
  }

  bool isGreaterThan(RideStates rs) {
    final c = RideStates.values.indexOf(rs);
    return currentRSI >= c;
  }

  bool isIn(List<RideStates> rs) {
    return rs.contains(currentRideStatus.value);
  }

  Future getTripDetails() async {
    directions.value = await HttpService.getDirections(
        homeController.srcDst[0].llng!, homeController.srcDst[1].llng!);
    print(directions.value);
    totalTime.value = directions.value.totalDuration;
    currentTrip.value.duration =
        Duration(seconds: directions.value.totalDuration);
    currentTrip.value.distance = directions.value.totalDistance;
    //get cost
    final cost = await HttpService.getCost(
        currentTrip.value.duration!.inSeconds,
        currentTrip.value.distance.toInt());
    currentTrip.value.cost = cost;
  }

  Future searchForDriver() async {
    //request ride to get job id
    final c = await HttpService.requestRide(
        homeController.srcDst[0], homeController.srcDst[1], directions.value);
    if (c == "") {
      return false;
    }
    currentTrip.value.id = c;

    currentTrip.value.srcDateRaw = DateTime.now();
    currentTrip.value.src = homeController.srcDst[0].name?.value.text ?? "";
    currentTrip.value.dst = homeController.srcDst[1].name?.value.text ?? "";
    currentTrip.value.srcLLNG = homeController.srcDst[0].llng!;
    currentTrip.value.dstLLNG = homeController.srcDst[1].llng!;

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
    if (mp.type != DeliveryMode.none) return;
    switch (mp.action) {
      case "ACCEPT_JOB":
        Driver? foundDriver =
            await HttpService.getDriverDetail(currentTrip.value.id!);
        if (foundDriver == null) return;

        foundDriver.locationData = mp.loc;

        currentTrip.value.driver = foundDriver;
        // directions.value = await HttpService.getDirections(
        //     homeController.srcDst[0].llng!, homeController.srcDst[1].llng!);
        // totalTime.value = directions.value.totalDuration;
        // currentTrip.value.duration =
        //     Duration(seconds: directions.value.totalDuration);

        Ui.showSnackBar(
            "Your ride request has been accepted. Your driver is on their way.",
            isError: false);
        changeState(RideStates.foundDriver, false);
        break;
      case "PICKUP":
        changeState(RideStates.driverArrived, false);
        Ui.showSnackBar("Your driver has arrived and is waiting for you.",
            isError: false);
        break;
      case "START_JOB":
        startRide();
        Ui.showSnackBar("Your ride has started", isError: false);
        break;
      case "UPDATE_LOCATION":
        currentTrip.value.driver!.locationData = mp.loc;

        break;
      case "DROP_OFF":
        currentTrip.value.dstDateRaw = DateTime.now();
        Ui.showSnackBar("You are at your destination", isError: false);
        // currentTrip.value.cost = HttpService.getCost(,)
        endRide();
        break;
      case "CANCEL":
        Get.to(TripEndedScreen());
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

class PusherNotif {
  String id, action;
  DeliveryMode type;
  Loc? loc;
  PusherNotif(
      {this.id = "",
      this.action = "",
      this.type = DeliveryMode.none,
      this.loc});

  factory PusherNotif.fromJSON(Map<dynamic, dynamic> c) {
    return PusherNotif(
      id: c["data"]["job"],
      action: c["data"]["action"],
      loc: Loc(
          llng: LatLng(double.tryParse(c["data"]["latitude"]) ?? 0.0,
              double.tryParse(c["data"]["longitude"]) ?? 0.0),
          heading: double.tryParse(c["data"]["heading"]) ?? 0.0),
      type: DeliveryMode.values.firstWhere(
          (element) => element.name.toUpperCase() == c["data"]["type"]),
    );
  }
}
