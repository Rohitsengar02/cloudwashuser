import 'package:cloud_user/core/models/location_model.dart';
import 'package:cloud_user/core/services/location_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:geocoding/geocoding.dart' as geo;

part 'location_provider.g.dart';

@Riverpod(keepAlive: true)
class UserLocation extends _$UserLocation {
  @override
  LocationModel? build() {
    return null;
  }

  void setLocation(LocationModel location) {
    state = location;
  }

  Future<void> determinePosition() async {
    final service = LocationService();
    final hasPermission = await service.requestPermission();
    
    if (hasPermission) {
      final position = await service.getCurrentPosition();
      if (position != null) {
        try {
          // Use Geocoding package to get address
          List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(
            position.latitude,
            position.longitude,
          );
          
          String address = "Unknown Location";
          if (placemarks.isNotEmpty) {
            final place = placemarks.first;
            address = "${place.street}, ${place.locality}, ${place.country}";
          }

          state = LocationModel(
            latitude: position.latitude,
            longitude: position.longitude,
            address: address,
            city: placemarks.firstOrNull?.locality,
            state: placemarks.firstOrNull?.administrativeArea,
            pincode: placemarks.firstOrNull?.postalCode,
          );
        } catch (e) {
             state = LocationModel(
                latitude: position.latitude,
                longitude: position.longitude,
                address: "Current Location (${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)})",
             );
        }
      }
    }
  }
}
