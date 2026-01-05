// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'services_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$servicesHash() => r'9dce015263b9ac42e9f6d4073952336782f1cfb2';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [services].
@ProviderFor(services)
const servicesProvider = ServicesFamily();

/// See also [services].
class ServicesFamily extends Family<AsyncValue<List<ServiceModel>>> {
  /// See also [services].
  const ServicesFamily();

  /// See also [services].
  ServicesProvider call({String? categoryId, String? subCategoryId}) {
    return ServicesProvider(
      categoryId: categoryId,
      subCategoryId: subCategoryId,
    );
  }

  @override
  ServicesProvider getProviderOverride(covariant ServicesProvider provider) {
    return call(
      categoryId: provider.categoryId,
      subCategoryId: provider.subCategoryId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'servicesProvider';
}

/// See also [services].
class ServicesProvider extends AutoDisposeFutureProvider<List<ServiceModel>> {
  /// See also [services].
  ServicesProvider({String? categoryId, String? subCategoryId})
    : this._internal(
        (ref) => services(
          ref as ServicesRef,
          categoryId: categoryId,
          subCategoryId: subCategoryId,
        ),
        from: servicesProvider,
        name: r'servicesProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$servicesHash,
        dependencies: ServicesFamily._dependencies,
        allTransitiveDependencies: ServicesFamily._allTransitiveDependencies,
        categoryId: categoryId,
        subCategoryId: subCategoryId,
      );

  ServicesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.categoryId,
    required this.subCategoryId,
  }) : super.internal();

  final String? categoryId;
  final String? subCategoryId;

  @override
  Override overrideWith(
    FutureOr<List<ServiceModel>> Function(ServicesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ServicesProvider._internal(
        (ref) => create(ref as ServicesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        categoryId: categoryId,
        subCategoryId: subCategoryId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<ServiceModel>> createElement() {
    return _ServicesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ServicesProvider &&
        other.categoryId == categoryId &&
        other.subCategoryId == subCategoryId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, categoryId.hashCode);
    hash = _SystemHash.combine(hash, subCategoryId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ServicesRef on AutoDisposeFutureProviderRef<List<ServiceModel>> {
  /// The parameter `categoryId` of this provider.
  String? get categoryId;

  /// The parameter `subCategoryId` of this provider.
  String? get subCategoryId;
}

class _ServicesProviderElement
    extends AutoDisposeFutureProviderElement<List<ServiceModel>>
    with ServicesRef {
  _ServicesProviderElement(super.provider);

  @override
  String? get categoryId => (origin as ServicesProvider).categoryId;
  @override
  String? get subCategoryId => (origin as ServicesProvider).subCategoryId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
