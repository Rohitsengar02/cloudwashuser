import 'package:json_annotation/json_annotation.dart';

part 'booking_model.g.dart';

@JsonSerializable()
class BookingModel {
  @JsonKey(name: '_id')
  final String id;
  final String userId;
  final String? vendorId;
  final String serviceId;
  final String serviceName;
  final String status; // pending, accepted, ongoing, completed, cancelled
  final DateTime date;
  final String time;
  final double totalAmount;
  final String address;

  BookingModel({
    required this.id,
    required this.userId,
    this.vendorId,
    required this.serviceId,
    required this.serviceName,
    required this.status,
    required this.date,
    required this.time,
    required this.totalAmount,
    required this.address,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) => _$BookingModelFromJson(json);
  Map<String, dynamic> toJson() => _$BookingModelToJson(this);
}
