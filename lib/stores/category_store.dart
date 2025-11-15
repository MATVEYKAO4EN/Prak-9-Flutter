import 'package:mobx/mobx.dart';
import '../models/category.dart';

part 'category_store.g.dart';

class CategoryStore = _CategoryStore with _$CategoryStore;

abstract class _CategoryStore with Store {
  @observable
  ObservableList<Category> categories = ObservableList<Category>();

  @action
  void addCategory(String name) {
    final category = Category(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
    );
    categories.add(category);
  }

  @action
  void removeCategory(String id) {
    categories.removeWhere((category) => category.id == id);
  }

  @action
  void addProductToCategory(String categoryId, String productId) {
    final category = categories.firstWhere(
          (cat) => cat.id == categoryId,
      orElse: () => Category(id: '', name: ''),
    );
    if (category.id.isNotEmpty) {
      category.addProduct(productId);
    }
  }

  Category? getCategoryById(String id) {
    try {
      return categories.firstWhere((category) => category.id == id);
    } catch (e) {
      return null;
    }
  }
}