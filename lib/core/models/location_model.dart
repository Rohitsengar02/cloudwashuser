import 'package:json_annotation/json_annotation.dart';

part 'location_model.g.dart';

@JsonSerializable()
class LocationModel {
  final double latitude;
  final double longitude;
  final String address;
  final String? city;
  final String? state;
  final String? pincode;

  LocationModel({
    required this.latitude,
    required this.longitude,
    required this.address,
    this.city,
    this.state,
    this.pincode,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) => _$LocationModelFromJson(json);
  Map<String, dynamic> toJson() => _$LocationModelToJson(this);
}
