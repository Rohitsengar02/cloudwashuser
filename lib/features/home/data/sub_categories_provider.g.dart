// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sub_categories_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$subCategoriesByCategoryHash() =>
    r'81df6fa0d2084aff37be29fc09098b55fa6c7a3a';

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

/// See also [subCategoriesByCategory].
@ProviderFor(subCategoriesByCategory)
const subCategoriesByCategoryProvider = SubCategoriesByCategoryFamily();

/// See also [subCategoriesByCategory].
class SubCategoriesByCategoryFamily
    extends Family<AsyncValue<List<SubCategoryModel>>> {
  /// See also [subCategoriesByCategory].
  const SubCategoriesByCategoryFamily();

  /// See also [subCategoriesByCategory].
  SubCategoriesByCategoryProvider call(String categoryId) {
    return SubCategoriesByCategoryProvider(categoryId);
  }

  @override
  SubCategoriesByCategoryProvider getProviderOverride(
    covariant SubCategoriesByCategoryProvider provider,
  ) {
    return call(provider.categoryId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'subCategoriesByCategoryProvider';
}

/// See also [subCategoriesByCategory].
class SubCategoriesByCategoryProvider
    extends AutoDisposeFutureProvider<List<SubCategoryModel>> {
  /// See also [subCategoriesByCategory].
  SubCategoriesByCategoryProvider(String categoryId)
    : this._internal(
        (ref) => subCategoriesByCategory(
          ref as SubCategoriesByCategoryRef,
          categoryId,
        ),
        from: subCategoriesByCategoryProvider,
        name: r'subCategoriesByCategoryProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$subCategoriesByCategoryHash,
        dependencies: SubCategoriesByCategoryFamily._dependencies,
        allTransitiveDependencies:
            SubCategoriesByCategoryFamily._allTransitiveDependencies,
        categoryId: categoryId,
      );

  SubCategoriesByCategoryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.categoryId,
  }) : super.internal();

  final String categoryId;

  @override
  Override overrideWith(
    FutureOr<List<SubCategoryModel>> Function(
      SubCategoriesByCategoryRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SubCategoriesByCategoryProvider._internal(
        (ref) => create(ref as SubCategoriesByCategoryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        categoryId: categoryId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<SubCategoryModel>> createElement() {
    return _SubCategoriesByCategoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SubCategoriesByCategoryProvider &&
        other.categoryId == categoryId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, categoryId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SubCategoriesByCategoryRef
    on AutoDisposeFutureProviderRef<List<SubCategoryModel>> {
  /// The parameter `categoryId` of this provider.
  String get categoryId;
}

class _SubCategoriesByCategoryProviderElement
    extends AutoDisposeFutureProviderElement<List<SubCategoryModel>>
    with SubCategoriesByCategoryRef {
  _SubCategoriesByCategoryProviderElement(super.provider);

  @override
  String get categoryId =>
      (origin as SubCategoriesByCategoryProvider).categoryId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
