// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$DashboardStore on _DashboardStore, Store {
  late final _$totalCategoriesAtom =
      Atom(name: '_DashboardStore.totalCategories', context: context);

  @override
  int get totalCategories {
    _$totalCategoriesAtom.reportRead();
    return super.totalCategories;
  }

  @override
  set totalCategories(int value) {
    _$totalCategoriesAtom.reportWrite(value, super.totalCategories, () {
      super.totalCategories = value;
    });
  }

  late final _$totalProductsAtom =
      Atom(name: '_DashboardStore.totalProducts', context: context);

  @override
  int get totalProducts {
    _$totalProductsAtom.reportRead();
    return super.totalProducts;
  }

  @override
  set totalProducts(int value) {
    _$totalProductsAtom.reportWrite(value, super.totalProducts, () {
      super.totalProducts = value;
    });
  }

  late final _$totalQuantityAtom =
      Atom(name: '_DashboardStore.totalQuantity', context: context);

  @override
  int get totalQuantity {
    _$totalQuantityAtom.reportRead();
    return super.totalQuantity;
  }

  @override
  set totalQuantity(int value) {
    _$totalQuantityAtom.reportWrite(value, super.totalQuantity, () {
      super.totalQuantity = value;
    });
  }

  late final _$_DashboardStoreActionController =
      ActionController(name: '_DashboardStore', context: context);

  @override
  void updateDashboardStats(int categories, int products, int quantity) {
    final _$actionInfo = _$_DashboardStoreActionController.startAction(
        name: '_DashboardStore.updateDashboardStats');
    try {
      return super.updateDashboardStats(categories, products, quantity);
    } finally {
      _$_DashboardStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
totalCategories: ${totalCategories},
totalProducts: ${totalProducts},
totalQuantity: ${totalQuantity}
    ''';
  }
}
