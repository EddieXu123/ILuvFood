import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/services.dart' show rootBundle;

part 'restaurants.g.dart';

@JsonSerializable()
class LatLng {
  LatLng({
    this.lat,
    this.lng,
  });

  factory LatLng.fromJson(Map<String, dynamic> json) => _$LatLngFromJson(json);
  Map<String, dynamic> toJson() => _$LatLngToJson(this);

  final double lat;
  final double lng;
}


@JsonSerializable()
class Restaurant {
  Restaurant({
    this.address,
    this.id,
    this.image,
    this.lat,
    this.lng,
    this.name,
    this.phone,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) => _$RestaurantFromJson(json);
  Map<String, dynamic> toJson() => _$RestaurantToJson(this);

  final String address;
  final String id;
  final String image;
  final double lat;
  final double lng;
  final String name;
  final String phone;
}

@JsonSerializable()
class Locations {
  Locations({
    this.restaurants,
  });

  factory Locations.fromJson(Map<String, dynamic> json) => _$LocationsFromJson(json);
  Map<String, dynamic> toJson() => _$LocationsToJson(this);

  final List<Restaurant> restaurants;
}

Future<Locations> getLocations() async {
  String data = await rootBundle.loadString("assets/restaurants.json");
  return Locations.fromJson(json.decode(data));
}