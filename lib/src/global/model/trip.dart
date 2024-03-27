import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:udrive/src/utils/date/date_util.dart';

import 'user.dart';

class Trip {
  String src, dst;
  String? time, date, id;
  DateTime? srcDateRaw, dstDateRaw;
  Driver? driver;
  Duration? duration;
  num distance;
  num cost;
  LatLng srcLLNG, dstLLNG;
  final df = DateFormat("dd-MM-yy");
  final tf = DateFormat("hh:mma");

  Trip({
    this.src = "Mary Slessor",
    this.dst = "Ozumba Mbadiwe",
    this.srcLLNG = const LatLng(6.333, 4.345),
    this.dstLLNG = const LatLng(6.666, 4.456),
    this.distance = 0,
    this.cost = 0,
    this.time,
    this.id,
    this.date,
    this.duration,
    this.driver,
    this.srcDateRaw,
    this.dstDateRaw,
  });

  String get srcDate => df.format(srcDateRaw ?? dstDateRaw!);
  String get dstDate => date ?? df.format(dstDateRaw!);
  String get srcTime =>
      tf.format(srcDateRaw ?? dstDateRaw!.subtract(duration!));
  String get dstTime => time ?? tf.format(dstDateRaw!);
  List<double> get moneyRange => [cost - 300, cost + 300];

  String get dstLongDate {
    final sd = DateFormat("E d M, y").format(dstDateRaw!);
    final dateDay = sd.split(" ");
    dateDay[1] = DateUtils.dayOfMonth(int.parse(dateDay[1]));

    return date ?? dateDay.join(" ");
  }

  factory Trip.fromJSON(Map<String, dynamic> c) {
    return Trip(
      src: c["start_location_name"] ?? "",
      dst: c["stop_location_name"] ?? "",
      srcLLNG: LatLng(double.parse(c["start_latitude"]),
          double.parse(c["start_longitude"])),
      dstLLNG: LatLng(
          double.parse(c["stop_latitude"]), double.parse(c["stop_longitude"])),
      distance: c["distance"] ?? 0,
      duration: Duration(seconds: (c["expected_duration"] ?? 0).round()),
      driver: Driver(
        firstName: c["driver_data"]?["first_name"] ?? "",
        lastName: c["driver_data"]?["last_name"] ?? "",
        image: c["driver_data"]?["profile_pic"] ?? "",
        rating: c["driver_rating"],
      ),
      id: c["id"],
      cost: c["cost"],
      srcDateRaw: c["start_time"] == null
          ? DateTime.now().subtract(
              Duration(seconds: (c["expected_duration"] ?? 0).round()))
          : DateTime.tryParse(c["start_time"]),
      dstDateRaw: c["end_time"] == null
          ? DateTime.now()
          : DateTime.tryParse(c["end_time"]),
    );
  }
}
