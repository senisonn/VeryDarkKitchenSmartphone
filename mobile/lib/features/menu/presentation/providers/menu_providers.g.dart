// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$menuRemoteDataSourceHash() =>
    r'b71d19479167cfe7b4680c14c6d724487e407bf1';

/// See also [menuRemoteDataSource].
@ProviderFor(menuRemoteDataSource)
final menuRemoteDataSourceProvider =
    AutoDisposeProvider<MenuRemoteDataSource>.internal(
  menuRemoteDataSource,
  name: r'menuRemoteDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$menuRemoteDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MenuRemoteDataSourceRef = AutoDisposeProviderRef<MenuRemoteDataSource>;
String _$menuRepositoryHash() => r'c484db377298dee11bbb52ac885719f5e2bb81cb';

/// See also [menuRepository].
@ProviderFor(menuRepository)
final menuRepositoryProvider = AutoDisposeProvider<MenuRepository>.internal(
  menuRepository,
  name: r'menuRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$menuRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MenuRepositoryRef = AutoDisposeProviderRef<MenuRepository>;
String _$menuItemsHash() => r'88a78a8654d9ffb78652adff0e678036284dfc91';

/// Provides all menu items.
///
/// Copied from [menuItems].
@ProviderFor(menuItems)
final menuItemsProvider = AutoDisposeFutureProvider<List<MenuItem>>.internal(
  menuItems,
  name: r'menuItemsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$menuItemsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MenuItemsRef = AutoDisposeFutureProviderRef<List<MenuItem>>;
String _$menuItemHash() => r'937250a3ad815a309427a2bf1800f5eaeb8eb432';

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

/// Provides a specific menu item by ID.
///
/// Copied from [menuItem].
@ProviderFor(menuItem)
const menuItemProvider = MenuItemFamily();

/// Provides a specific menu item by ID.
///
/// Copied from [menuItem].
class MenuItemFamily extends Family<AsyncValue<MenuItem>> {
  /// Provides a specific menu item by ID.
  ///
  /// Copied from [menuItem].
  const MenuItemFamily();

  /// Provides a specific menu item by ID.
  ///
  /// Copied from [menuItem].
  MenuItemProvider call(
    String id,
  ) {
    return MenuItemProvider(
      id,
    );
  }

  @override
  MenuItemProvider getProviderOverride(
    covariant MenuItemProvider provider,
  ) {
    return call(
      provider.id,
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
  String? get name => r'menuItemProvider';
}

/// Provides a specific menu item by ID.
///
/// Copied from [menuItem].
class MenuItemProvider extends AutoDisposeFutureProvider<MenuItem> {
  /// Provides a specific menu item by ID.
  ///
  /// Copied from [menuItem].
  MenuItemProvider(
    String id,
  ) : this._internal(
          (ref) => menuItem(
            ref as MenuItemRef,
            id,
          ),
          from: menuItemProvider,
          name: r'menuItemProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$menuItemHash,
          dependencies: MenuItemFamily._dependencies,
          allTransitiveDependencies: MenuItemFamily._allTransitiveDependencies,
          id: id,
        );

  MenuItemProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    FutureOr<MenuItem> Function(MenuItemRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MenuItemProvider._internal(
        (ref) => create(ref as MenuItemRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<MenuItem> createElement() {
    return _MenuItemProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MenuItemProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MenuItemRef on AutoDisposeFutureProviderRef<MenuItem> {
  /// The parameter `id` of this provider.
  String get id;
}

class _MenuItemProviderElement
    extends AutoDisposeFutureProviderElement<MenuItem> with MenuItemRef {
  _MenuItemProviderElement(super.provider);

  @override
  String get id => (origin as MenuItemProvider).id;
}

String _$menuItemsByCategoryHash() =>
    r'ade28b48fb05fc2c3ff5eb9d7b712d34cc38864c';

/// Provides menu items filtered by category.
///
/// Copied from [menuItemsByCategory].
@ProviderFor(menuItemsByCategory)
const menuItemsByCategoryProvider = MenuItemsByCategoryFamily();

/// Provides menu items filtered by category.
///
/// Copied from [menuItemsByCategory].
class MenuItemsByCategoryFamily extends Family<AsyncValue<List<MenuItem>>> {
  /// Provides menu items filtered by category.
  ///
  /// Copied from [menuItemsByCategory].
  const MenuItemsByCategoryFamily();

  /// Provides menu items filtered by category.
  ///
  /// Copied from [menuItemsByCategory].
  MenuItemsByCategoryProvider call(
    String? categoryId,
  ) {
    return MenuItemsByCategoryProvider(
      categoryId,
    );
  }

  @override
  MenuItemsByCategoryProvider getProviderOverride(
    covariant MenuItemsByCategoryProvider provider,
  ) {
    return call(
      provider.categoryId,
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
  String? get name => r'menuItemsByCategoryProvider';
}

/// Provides menu items filtered by category.
///
/// Copied from [menuItemsByCategory].
class MenuItemsByCategoryProvider
    extends AutoDisposeFutureProvider<List<MenuItem>> {
  /// Provides menu items filtered by category.
  ///
  /// Copied from [menuItemsByCategory].
  MenuItemsByCategoryProvider(
    String? categoryId,
  ) : this._internal(
          (ref) => menuItemsByCategory(
            ref as MenuItemsByCategoryRef,
            categoryId,
          ),
          from: menuItemsByCategoryProvider,
          name: r'menuItemsByCategoryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$menuItemsByCategoryHash,
          dependencies: MenuItemsByCategoryFamily._dependencies,
          allTransitiveDependencies:
              MenuItemsByCategoryFamily._allTransitiveDependencies,
          categoryId: categoryId,
        );

  MenuItemsByCategoryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.categoryId,
  }) : super.internal();

  final String? categoryId;

  @override
  Override overrideWith(
    FutureOr<List<MenuItem>> Function(MenuItemsByCategoryRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MenuItemsByCategoryProvider._internal(
        (ref) => create(ref as MenuItemsByCategoryRef),
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
  AutoDisposeFutureProviderElement<List<MenuItem>> createElement() {
    return _MenuItemsByCategoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MenuItemsByCategoryProvider &&
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
mixin MenuItemsByCategoryRef on AutoDisposeFutureProviderRef<List<MenuItem>> {
  /// The parameter `categoryId` of this provider.
  String? get categoryId;
}

class _MenuItemsByCategoryProviderElement
    extends AutoDisposeFutureProviderElement<List<MenuItem>>
    with MenuItemsByCategoryRef {
  _MenuItemsByCategoryProviderElement(super.provider);

  @override
  String? get categoryId => (origin as MenuItemsByCategoryProvider).categoryId;
}

String _$searchMenuItemsHash() => r'ed6fb42465425cb8d6e4b8ab753b5a113772aeb1';

/// Provides search results for menu items.
///
/// Copied from [searchMenuItems].
@ProviderFor(searchMenuItems)
const searchMenuItemsProvider = SearchMenuItemsFamily();

/// Provides search results for menu items.
///
/// Copied from [searchMenuItems].
class SearchMenuItemsFamily extends Family<AsyncValue<List<MenuItem>>> {
  /// Provides search results for menu items.
  ///
  /// Copied from [searchMenuItems].
  const SearchMenuItemsFamily();

  /// Provides search results for menu items.
  ///
  /// Copied from [searchMenuItems].
  SearchMenuItemsProvider call(
    String query,
  ) {
    return SearchMenuItemsProvider(
      query,
    );
  }

  @override
  SearchMenuItemsProvider getProviderOverride(
    covariant SearchMenuItemsProvider provider,
  ) {
    return call(
      provider.query,
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
  String? get name => r'searchMenuItemsProvider';
}

/// Provides search results for menu items.
///
/// Copied from [searchMenuItems].
class SearchMenuItemsProvider
    extends AutoDisposeFutureProvider<List<MenuItem>> {
  /// Provides search results for menu items.
  ///
  /// Copied from [searchMenuItems].
  SearchMenuItemsProvider(
    String query,
  ) : this._internal(
          (ref) => searchMenuItems(
            ref as SearchMenuItemsRef,
            query,
          ),
          from: searchMenuItemsProvider,
          name: r'searchMenuItemsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$searchMenuItemsHash,
          dependencies: SearchMenuItemsFamily._dependencies,
          allTransitiveDependencies:
              SearchMenuItemsFamily._allTransitiveDependencies,
          query: query,
        );

  SearchMenuItemsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.query,
  }) : super.internal();

  final String query;

  @override
  Override overrideWith(
    FutureOr<List<MenuItem>> Function(SearchMenuItemsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SearchMenuItemsProvider._internal(
        (ref) => create(ref as SearchMenuItemsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        query: query,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<MenuItem>> createElement() {
    return _SearchMenuItemsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchMenuItemsProvider && other.query == query;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SearchMenuItemsRef on AutoDisposeFutureProviderRef<List<MenuItem>> {
  /// The parameter `query` of this provider.
  String get query;
}

class _SearchMenuItemsProviderElement
    extends AutoDisposeFutureProviderElement<List<MenuItem>>
    with SearchMenuItemsRef {
  _SearchMenuItemsProviderElement(super.provider);

  @override
  String get query => (origin as SearchMenuItemsProvider).query;
}

String _$menuCategoriesHash() => r'422e808e3fd65a11370d2aa80c1baf495694998c';

/// Provides all menu categories.
///
/// Copied from [menuCategories].
@ProviderFor(menuCategories)
final menuCategoriesProvider =
    AutoDisposeFutureProvider<List<MenuCategory>>.internal(
  menuCategories,
  name: r'menuCategoriesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$menuCategoriesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MenuCategoriesRef = AutoDisposeFutureProviderRef<List<MenuCategory>>;
String _$filteredMenuItemsHash() => r'c7a1b5e7f0a3327c69be3c6e863b88f6f28ab100';

/// Provides filtered menu items based on selected category.
///
/// Copied from [filteredMenuItems].
@ProviderFor(filteredMenuItems)
final filteredMenuItemsProvider =
    AutoDisposeFutureProvider<List<MenuItem>>.internal(
  filteredMenuItems,
  name: r'filteredMenuItemsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$filteredMenuItemsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FilteredMenuItemsRef = AutoDisposeFutureProviderRef<List<MenuItem>>;
String _$displayedMenuItemsHash() =>
    r'dc2f5c9fc84ad7ac3784e8450d8ba88979f051b2';

/// Provides search results or filtered items based on search state.
///
/// Copied from [displayedMenuItems].
@ProviderFor(displayedMenuItems)
final displayedMenuItemsProvider =
    AutoDisposeFutureProvider<List<MenuItem>>.internal(
  displayedMenuItems,
  name: r'displayedMenuItemsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$displayedMenuItemsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DisplayedMenuItemsRef = AutoDisposeFutureProviderRef<List<MenuItem>>;
String _$availableItemsCountHash() =>
    r'77c7749965d5a2cc2e9b8695e9802aaef506f740';

/// Provides available menu items count.
///
/// Copied from [availableItemsCount].
@ProviderFor(availableItemsCount)
final availableItemsCountProvider = AutoDisposeFutureProvider<int>.internal(
  availableItemsCount,
  name: r'availableItemsCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$availableItemsCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AvailableItemsCountRef = AutoDisposeFutureProviderRef<int>;
String _$filteredMenuItemsWithDietaryHash() =>
    r'95ff09db06233b2df0075f466ce2dddc08afa22b';

/// Provides menu items with dietary filters applied.
///
/// Copied from [filteredMenuItemsWithDietary].
@ProviderFor(filteredMenuItemsWithDietary)
final filteredMenuItemsWithDietaryProvider =
    AutoDisposeFutureProvider<List<MenuItem>>.internal(
  filteredMenuItemsWithDietary,
  name: r'filteredMenuItemsWithDietaryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$filteredMenuItemsWithDietaryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FilteredMenuItemsWithDietaryRef
    = AutoDisposeFutureProviderRef<List<MenuItem>>;
String _$selectedCategoryHash() => r'a47cd2de07ad285d4b73b2294ba954cb1cdd8e4c';

/// Provides the currently selected category ID.
///
/// Returns null if "All" is selected.
///
/// Copied from [SelectedCategory].
@ProviderFor(SelectedCategory)
final selectedCategoryProvider =
    AutoDisposeNotifierProvider<SelectedCategory, String?>.internal(
  SelectedCategory.new,
  name: r'selectedCategoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedCategoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedCategory = AutoDisposeNotifier<String?>;
String _$searchQueryHash() => r'b07ebd22fb9cb0db36c8d833cc6e21f4fcbd9b7b';

/// Provides the current search query.
///
/// Copied from [SearchQuery].
@ProviderFor(SearchQuery)
final searchQueryProvider =
    AutoDisposeNotifierProvider<SearchQuery, String>.internal(
  SearchQuery.new,
  name: r'searchQueryProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$searchQueryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SearchQuery = AutoDisposeNotifier<String>;
String _$dietaryFiltersHash() => r'5db38c001147342c66a839de5feabffb17c4c672';

/// Provides dietary filter options.
///
/// Copied from [DietaryFilters].
@ProviderFor(DietaryFilters)
final dietaryFiltersProvider =
    AutoDisposeNotifierProvider<DietaryFilters, Set<DietaryFilter>>.internal(
  DietaryFilters.new,
  name: r'dietaryFiltersProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$dietaryFiltersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DietaryFilters = AutoDisposeNotifier<Set<DietaryFilter>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
