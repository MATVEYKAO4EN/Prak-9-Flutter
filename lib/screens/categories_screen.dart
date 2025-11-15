import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import '../stores/category_store.dart';
import '../stores/product_store.dart';
import 'category_products_screen.dart';

class CategoriesScreen extends StatelessWidget {
  final TextEditingController _categoryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final categoryStore = Provider.of<CategoryStore>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Категории'),
      ),
      body: Observer(
        builder: (context) => categoryStore.categories.isEmpty
            ? Center(
          child: Text(
            'Нет категорий\nДобавьте первую категорию',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        )
            : ListView.builder(
          itemCount: categoryStore.categories.length,
          itemBuilder: (context, index) {
            final category = categoryStore.categories[index];
            return Card(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: ListTile(
                leading: CircleAvatar(
                  child: Text(
                    category.productIds.length.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                title: Text(
                  category.name,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteCategory(context, category.id),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategoryProductsScreen(category: category),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddCategoryDialog(context),
        child: Icon(Icons.add),
        tooltip: 'Добавить категорию',
      ),
    );
  }

  void _showAddCategoryDialog(BuildContext context) {
    final categoryStore = Provider.of<CategoryStore>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Добавить категорию'),
        content: TextField(
          controller: _categoryController,
          decoration: InputDecoration(
            hintText: 'Название категории',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _categoryController.clear();
            },
            child: Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_categoryController.text.trim().isNotEmpty) {
                categoryStore.addCategory(_categoryController.text.trim());
                _categoryController.clear();
                Navigator.pop(context);
              }
            },
            child: Text('Добавить'),
          ),
        ],
      ),
    );
  }

  void _deleteCategory(BuildContext context, String categoryId) {
    final categoryStore = Provider.of<CategoryStore>(context, listen: false);
    final productStore = Provider.of<ProductStore>(context, listen: false);

    final category = categoryStore.getCategoryById(categoryId);
    final productCount = category?.productIds.length ?? 0;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Удалить категорию?'),
        content: Text(
          productCount > 0
              ? 'Категория "${category?.name}" содержит $productCount продуктов. Все они будут удалены.'
              : 'Вы уверены, что хотите удалить категорию "${category?.name}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Отмена'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              // Удаляем все продукты категории
              final productsToRemove = productStore.products
                  .where((product) => product.categoryId == categoryId)
                  .toList();

              for (final product in productsToRemove) {
                productStore.removeProduct(product.id);
              }

              categoryStore.removeCategory(categoryId);
              Navigator.pop(context);
            },
            child: Text('Удалить', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}