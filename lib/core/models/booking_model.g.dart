// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingModel _$BookingModelFromJson(Map<String, dynamic> json) => BookingModel(
  id: json['_id'] as String,
  userId: json['userId'] as String,
  vendorId: json['vendorId'] as String?,
  serviceId: json['serviceId'] as String,
  serviceName: json['serviceName'] as String,
  status: json['status'] as String,
  date: DateTime.parse(json['date'] as String),
  time: json['time'] as String,
  totalAmount: (json['totalAmount'] as num).toDouble(),
  address: json['address'] as String,
);

Map<String, dynamic> _$BookingModelToJson(BookingModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'userId': instance.userId,
      'vendorId': instance.vendorId,
      'serviceId': instance.serviceId,
      'serviceName': instance.serviceName,
      'status': instance.status,
      'date': instance.date.toIso8601String(),
      'time': instance.time,
      'totalAmount': instance.totalAmount,
      'address': instance.address,
    };
