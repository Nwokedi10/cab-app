import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import '/src/src_barrel.dart';

enum PasswordStrength {
  normal,
  weak,
  okay,
  strong,
}

enum FPL {
  email(TextInputType.emailAddress),
  number(TextInputType.number),
  text(TextInputType.text),
  password(TextInputType.visiblePassword),
  multi(TextInputType.multiline, maxLength: 1000, maxLines: 5),
  phone(TextInputType.phone),
  money(TextInputType.number),

  //card details
  cvv(TextInputType.number, maxLength: 4),
  cardNo(TextInputType.number, maxLength: 20),
  dateExpiry(TextInputType.datetime, maxLength: 5);

  final TextInputType textType;
  final int? maxLength, maxLines;

  const FPL(this.textType, {this.maxLength, this.maxLines = 1});
}

enum CardType {
  masterCard(Assets.mastercard),
  visa(Assets.visa),
  verve(Assets.verve),
  invalid("");

  final String icon;
  const CardType(this.icon);
}

enum PrivacyItems {
  camera("Camera", IconlyBold.camera, AppColors.secondaryColor),
  audio("Audio", IconlyBold.voice_2, AppColors.accentColor);

  final String name;
  final IconData icon;
  final Color color;

  const PrivacyItems(this.name, this.icon, this.color);
}

enum UdriveService {
  escort("Escorts", Assets.escort, Assets.escortBig, 1.5, Alignment.centerLeft),
  groupTransport("Group Transport", Assets.groupTransport,
      Assets.groupTransportBig, 1, Alignment.center),
  aeroTrip("AeroTrips", Assets.aeroTrip, Assets.aeroTripBig, 1.5,
      Alignment.centerRight);

  final String name, icon, bigIcon;
  final double scale;
  final Alignment align;

  const UdriveService(
      this.name, this.icon, this.bigIcon, this.scale, this.align);
}

enum VerificationProcess {
  initial,
  inProgress,
  accepted,
  rejected,
}

enum RideStates {
  searchingForDriver(0.5, 0), //0
  foundDriver(0.5, 0), //1
  driverArrived(0.5, 0), //2
  rideStarted(0.24, 2), //3
  rideChanged(1.0, 3), //4 destination changed
  rideCanceled(1.0, 3), //5 from user or driver
  rideFinished(1.0, 3); //6

  final double size;
  final int screen;
  const RideStates(this.size, this.screen);
}

enum DeliveryStates {
  searchingForDriver(0.12, 0),
  foundDriver(0.12, 0),
  driverArrived(0.12, 0), //2
  dlvStarted(0.24, 1), //3
  dlvCanceled(1.0, 2), //5 from user or driver
  dlvFinished(1.0, 2); //6

  final double size;
  final int screen;
  const DeliveryStates(this.size, this.screen);
}

enum DeliveryMode {
  delivery("Delivery", "Package Delivery",
      "Get items delivered from one location to another using Udrive Delivery Service."),
  errand("Errand", "Errands",
      "Send our trusted delivery agents to pickup any item from any store within our reach."),
  none("Ride", "Current Location", "");

  final String name, clname, desc;
  const DeliveryMode(this.name, this.clname, this.desc);
}

enum VehicleTypes {
  car(Assets.carDef, Assets.carRide, Assets.car, "Car"),
  keke(Assets.kekeDef, Assets.kekeRide, Assets.keke, "Keke"),
  bike(Assets.bikeDef, Assets.bikeRide, Assets.bike, "Bike");

  final String image, imageRide, homeIcons, name;

  const VehicleTypes(this.image, this.imageRide, this.homeIcons, this.name);
}
