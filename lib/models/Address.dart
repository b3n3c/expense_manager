import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';


class Address extends HiveObject {
  String name;
  double? latitude;
  double? longitude;

  static const SZEGED_LATLNG = LatLng(46.2587, 20.14222);

  Address({
    required this.name,
    this.latitude,
    this.longitude
  });

  set latLng(LatLng latLng) {
    latitude = latLng.latitude;
    longitude = latLng.longitude;
  }

  LatLng get latLng {
    if (latitude == null || longitude == null) {
      return SZEGED_LATLNG;
    }
    return LatLng(latitude!, longitude!);
  }
}