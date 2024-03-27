import 'package:udrive/src/global/model/trip.dart';
import 'package:udrive/src/src_barrel.dart';

class Booking {
  UdriveService? udriveService;
  Trip? trip;
  String? carType;
  int? noOfDays, noOfVehicles, cost;

  Booking(
      {this.udriveService,
      this.trip,
      this.carType,
      this.noOfDays,
      this.noOfVehicles,
      this.cost});
}
