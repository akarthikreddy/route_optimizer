import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'route_stop.dart';

class DriverRoute {
  DriverRoute({
    required this.driverIndex,
    required this.color,
    required this.stops,
    required this.polyline,
    required this.totalDistanceKm,
  });

  final int driverIndex;
  final Color color;
  final List<RouteStop> stops;
  final List<LatLng> polyline;
  final double totalDistanceKm;

  String get driverLabel => 'Driver ${driverIndex + 1}';

  DriverRoute copyWith({List<RouteStop>? stops}) => DriverRoute(
        driverIndex: driverIndex,
        color: color,
        stops: stops ?? this.stops,
        polyline: polyline,
        totalDistanceKm: totalDistanceKm,
      );
}
