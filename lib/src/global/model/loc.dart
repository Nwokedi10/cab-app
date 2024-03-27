import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:udrive/src/src_barrel.dart';

class Loc {
  TextEditingController? name;
  LatLng? llng;
  double? heading;

  Loc({this.name, this.heading, this.llng});
}

class Directions {
  final LatLngBounds? bounds;
  final List<LatLng> polylinePoints;
  final int totalDistance;
  final int totalDuration;

  const Directions({
    this.bounds,
    this.polylinePoints = const [],
    this.totalDistance = 0,
    this.totalDuration = 0,
  });

  factory Directions.fromMap(Map<String, dynamic> map) {
    // Check if route is not available
    if ((map['routes'] as List).isEmpty) return Directions();

    // Get route information
    final data = Map<String, dynamic>.from(map['routes'][0]);

    // Bounds
    final northeast = data['bounds']['northeast'];
    final southwest = data['bounds']['southwest'];
    final bounds = LatLngBounds(
      northeast: LatLng(northeast['lat'], northeast['lng']),
      southwest: LatLng(southwest['lat'], southwest['lng']),
    );

    // Distance & Duration
    int distance = 0;
    int duration = 0;
    if ((data['legs'] as List).isNotEmpty) {
      final leg = data['legs'][0];
      distance = leg['distance']['value'];
      duration = leg['duration']['value'];
    }

    return Directions(
      bounds: bounds,
      polylinePoints: UtilFunctions.decodeEncodedPolyline(
          data['overview_polyline']['points']),
      totalDistance: distance,
      totalDuration: duration,
    );
  }
}
