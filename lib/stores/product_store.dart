import 'package:mobx/mobx.dart';
import '../models/product.dart';

part 'product_store.g.dart';

class ProductStore = _ProductStore with _$ProductStore;

abstract class _ProductStore with Store {
  @observable
  ObservableList<Product> products = ObservableList<Product>();

  @action
  void addProduct(String name, int quantity, String categoryId) {
    final product = Product(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      quantity: quantity,
      categoryId: categoryId,
    );
    products.add(product);
  }

  @action
  void removeProduct(String id) {
    products.removeWhere((product) => product.id == id);
  }

  @action
  void updateProductQuantity(String id, int newQuantity) {
    final product = products.firstWhere(
          (prod) => prod.id == id,
      orElse: () => Product(id: '', name: '', quantity: 0, categoryId: ''),
    );
    if (product.id.isNotEmpty) {
      product.quantity = newQuantity;
    }
  }

  List<Product> getProductsByCategory(String categoryId) {
    return products
        .where((product) => product.categoryId == categoryId)
        .toList();
  }

  int get totalProductsCount {
    return products.length;
  }

  int get totalProductsQuantity {
    return products.fold(0, (sum, product) => sum + product.quantity);
  }
}