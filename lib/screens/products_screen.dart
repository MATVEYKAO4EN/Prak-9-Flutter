import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import '../stores/product_store.dart';
import '../stores/category_store.dart';
import '../models/product.dart';

class ProductsScreen extends StatefulWidget {
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  String? _selectedCategoryId;

  @override
  Widget build(BuildContext context) {
    final productStore = Provider.of<ProductStore>(context);
    final categoryStore = Provider.of<CategoryStore>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Продукты'),
      ),
      body: Observer(
        builder: (context) => ListView.builder(
          itemCount: productStore.products.length,
          itemBuilder: (context, index) {
            final product = productStore.products[index];
            final category = categoryStore.getCategoryById(product.categoryId);

            return Card(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: ListTile(
                title: Text(product.name),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Количество: ${product.quantity}'),
                    Text('Категория: ${category?.name ?? 'Неизвестно'}'),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _showEditProductDialog(context, product),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteProduct(context, product.id),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddProductDialog(context),
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddProductDialog(BuildContext context) {
    final productStore = Provider.of<ProductStore>(context, listen: false);
    final categoryStore = Provider.of<CategoryStore>(context, listen: false);

    _nameController.clear();
    _quantityController.clear();
    _selectedCategoryId = null;

    showDialog(
      context: context,
      builder: (context) => Observer(
        builder: (context) => AlertDialog(
          title: Text('Добавить продукт'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(hintText: 'Название продукта'),
              ),
              TextField(
                controller: _quantityController,
                decoration: InputDecoration(hintText: 'Количество'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategoryId,
                hint: Text('Выберите категорию'),
                items: categoryStore.categories.map((category) {
                  return DropdownMenuItem(
                    value: category.id,
                    child: Text(category.name),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedCategoryId = value),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                if (_nameController.text.isNotEmpty &&
                    _quantityController.text.isNotEmpty &&
                    _selectedCategoryId != null) {
                  productStore.addProduct(
                    _nameController.text,
                    int.parse(_quantityController.text),
                    _selectedCategoryId!,
                  );
                  Navigator.pop(context);
                }
              },
              child: Text('Добавить'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditProductDialog(BuildContext context, Product product) {
    final productStore = Provider.of<ProductStore>(context, listen: false);

    _nameController.text = product.name;
    _quantityController.text = product.quantity.toString();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Редактировать продукт'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(hintText: 'Название продукта'),
            ),
            TextField(
              controller: _quantityController,
              decoration: InputDecoration(hintText: 'Количество'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              if (_nameController.text.isNotEmpty &&
                  _quantityController.text.isNotEmpty) {
                productStore.updateProductQuantity(
                  product.id,
                  int.parse(_quantityController.text),
                );
                Navigator.pop(context);
              }
            },
            child: Text('Сохранить'),
          ),
        ],
      ),
    );
  }

  void _deleteProduct(BuildContext context, String productId) {
    final productStore = Provider.of<ProductStore>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Удалить продукт?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              productStore.removeProduct(productId);
              Navigator.pop(context);
            },
            child: Text('Удалить'),
          ),
        ],
      ),
    );
  }
}