// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ProductStore on _ProductStore, Store {
  late final _$productsAtom =
      Atom(name: '_ProductStore.products', context: context);

  @override
  ObservableList<Product> get products {
    _$productsAtom.reportRead();
    return super.products;
  }

  @override
  set products(ObservableList<Product> value) {
    _$productsAtom.reportWrite(value, super.products, () {
      super.products = value;
    });
  }

  late final _$_ProductStoreActionController =
      ActionController(name: '_ProductStore', context: context);

  @override
  void addProduct(String name, int quantity, String categoryId) {
    final _$actionInfo = _$_ProductStoreActionController.startAction(
        name: '_ProductStore.addProduct');
    try {
      return super.addProduct(name, quantity, categoryId);
    } finally {
      _$_ProductStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeProduct(String id) {
    final _$actionInfo = _$_ProductStoreActionController.startAction(
        name: '_ProductStore.removeProduct');
    try {
      return super.removeProduct(id);
    } finally {
      _$_ProductStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateProductQuantity(String id, int newQuantity) {
    final _$actionInfo = _$_ProductStoreActionController.startAction(
        name: '_ProductStore.updateProductQuantity');
    try {
      return super.updateProductQuantity(id, newQuantity);
    } finally {
      _$_ProductStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
products: ${products}
    ''';
  }
}
