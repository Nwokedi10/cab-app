import 'package:location/location.dart';
import 'package:udrive/src/global/model/loc.dart';
import 'package:udrive/src/src_barrel.dart';

class User {
  String firstName, lastName, phone, image, id, email;
  User(
      {this.firstName = "Jagaban",
      this.lastName = "Jagaban",
      this.image = Assets.defUser,
      this.id = "",
      this.email = "",
      this.phone = ""});

  String get fullName => firstName + " " + lastName;
}

class Driver extends User {
  num rating;
  Car car;
  Loc? locationData;

  Driver(
      {this.rating = 4.9,
      super.firstName,
      super.image,
      super.lastName,
      this.locationData,
      this.car = const Car(),
      super.phone});
}

class Car {
  final String name, image, plateNo;
  const Car(
      {this.name = "Black Toyota Camry",
      this.image = "",
      this.plateNo = "7YULGI 4L8 F3E"});
}
