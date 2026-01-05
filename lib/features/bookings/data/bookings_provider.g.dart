// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookings_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$upcomingBookingsHash() => r'be65c61ed84ba49749d19703dfa0b667f9b47936';

/// See also [upcomingBookings].
@ProviderFor(upcomingBookings)
final upcomingBookingsProvider =
    AutoDisposeProvider<List<BookingModel>>.internal(
      upcomingBookings,
      name: r'upcomingBookingsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$upcomingBookingsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UpcomingBookingsRef = AutoDisposeProviderRef<List<BookingModel>>;
String _$pastBookingsHash() => r'f6bea9389fb32604733630014fd363d32677fe7e';

/// See also [pastBookings].
@ProviderFor(pastBookings)
final pastBookingsProvider = AutoDisposeProvider<List<BookingModel>>.internal(
  pastBookings,
  name: r'pastBookingsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$pastBookingsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PastBookingsRef = AutoDisposeProviderRef<List<BookingModel>>;
String _$bookingsHash() => r'36c917ed38b1f0a396cf4896dff2168f43abe14d';

/// See also [Bookings].
@ProviderFor(Bookings)
final bookingsProvider =
    AutoDisposeNotifierProvider<Bookings, List<BookingModel>>.internal(
      Bookings.new,
      name: r'bookingsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$bookingsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$Bookings = AutoDisposeNotifier<List<BookingModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
