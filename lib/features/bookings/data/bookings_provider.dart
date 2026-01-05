import 'package:cloud_user/core/models/booking_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'bookings_provider.g.dart';

@riverpod
List<BookingModel> upcomingBookings(UpcomingBookingsRef ref) {
  // TODO: Fetch from repository
  final allBookings = ref.watch(bookingsProvider);
  return allBookings
      .where(
        (b) =>
            b.status == 'pending' ||
            b.status == 'accepted' ||
            b.status == 'ongoing',
      )
      .toList();
}

@riverpod
List<BookingModel> pastBookings(PastBookingsRef ref) {
  // TODO: Fetch from repository
  final allBookings = ref.watch(bookingsProvider);
  return allBookings
      .where((b) => b.status == 'completed' || b.status == 'cancelled')
      .toList();
}

@riverpod
class Bookings extends _$Bookings {
  @override
  List<BookingModel> build() {
    return []; // Start with empty list
  }

  void setBookings(List<BookingModel> bookings) {
    state = bookings;
  }
}
