import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:udrive/src/utils/date/date_util.dart';

import 'user.dart';

class Delivery {
  String src, dst;
  String? time, date, id, recpName, recpPhone, item;
  DateTime? srcDateRaw, dstDateRaw;
  Driver? driver;
  num cost;
  num distance;
  bool isErrand;
  Duration? duration;
  LatLng srcLLNG, dstLLNG;
  final df = DateFormat("dd-MM-yy");
  final tf = DateFormat("hh:mma");

  Delivery({
    this.src = "Mary Slessor",
    this.dst = "Ozumba Mbadiwe",
    this.srcLLNG = const LatLng(6.333, 4.345),
    this.dstLLNG = const LatLng(6.666, 4.456),
    this.time,
    this.id,
    this.cost = 0,
    this.recpName,
    this.recpPhone,
    this.item,
    this.distance = 0,
    this.isErrand = true,
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

  factory Delivery.fromJSON(Map<String, dynamic> c) {
    return Delivery(
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
