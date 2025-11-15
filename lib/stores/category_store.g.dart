// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CategoryStore on _CategoryStore, Store {
  late final _$categoriesAtom =
      Atom(name: '_CategoryStore.categories', context: context);

  @override
  ObservableList<Category> get categories {
    _$categoriesAtom.reportRead();
    return super.categories;
  }

  @override
  set categories(ObservableList<Category> value) {
    _$categoriesAtom.reportWrite(value, super.categories, () {
      super.categories = value;
    });
  }

  late final _$_CategoryStoreActionController =
      ActionController(name: '_CategoryStore', context: context);

  @override
  void addCategory(String name) {
    final _$actionInfo = _$_CategoryStoreActionController.startAction(
        name: '_CategoryStore.addCategory');
    try {
      return super.addCategory(name);
    } finally {
      _$_CategoryStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeCategory(String id) {
    final _$actionInfo = _$_CategoryStoreActionController.startAction(
        name: '_CategoryStore.removeCategory');
    try {
      return super.removeCategory(id);
    } finally {
      _$_CategoryStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addProductToCategory(String categoryId, String productId) {
    final _$actionInfo = _$_CategoryStoreActionController.startAction(
        name: '_CategoryStore.addProductToCategory');
    try {
      return super.addProductToCategory(categoryId, productId);
    } finally {
      _$_CategoryStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
categories: ${categories}
    ''';
  }
}
