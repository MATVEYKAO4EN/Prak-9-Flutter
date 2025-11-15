import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import '../models/category.dart';
import '../stores/product_store.dart';
import '../stores/category_store.dart';
import '../models/product.dart';
class CategoryProductsScreen extends StatelessWidget {
  final Category category;

  CategoryProductsScreen({required this.category});

  @override
  Widget build(BuildContext context) {
    final productStore = Provider.of<ProductStore>(context);
    final categoryStore = Provider.of<CategoryStore>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showAddProductDialog(context, category),
            tooltip: 'Добавить продукт',
          ),
        ],
      ),
      body: Observer(
        builder: (context) {
          final categoryProducts = productStore.getProductsByCategory(category.id);
          final updatedCategory = categoryStore.getCategoryById(category.id);

          return Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                color: Colors.blue[50],
                child: Column(
                  children: [
                    Text(
                      'Общая статистика',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem('Продуктов', categoryProducts.length.toString()),
                        _buildStatItem(
                            'Общее количество',
                            categoryProducts.fold(0, (sum, product) => sum + product.quantity).toString()
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Expanded(
                child: categoryProducts.isEmpty
                    ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inventory_2, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'Нет продуктов',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Нажмите + чтобы добавить первый продукт',
                        style: TextStyle(color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
                    : ListView.builder(
                  itemCount: categoryProducts.length,
                  itemBuilder: (context, index) {
                    final product = categoryProducts[index];
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: _getQuantityColor(product.quantity),
                          child: Text(
                            product.quantity.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          product.name,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text('Количество: ${product.quantity}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _showEditProductDialog(context, product),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteProduct(context, product),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddProductDialog(context, category),
        child: Icon(Icons.add),
        tooltip: 'Добавить продукт',
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  Color _getQuantityColor(int quantity) {
    if (quantity == 0) return Colors.red;
    if (quantity < 10) return Colors.orange;
    return Colors.green;
  }

  void _showAddProductDialog(BuildContext context, Category category) {
    final productStore = Provider.of<ProductStore>(context, listen: false);
    final TextEditingController nameController = TextEditingController();
    final TextEditingController quantityController = TextEditingController();

    // Переменная для отслеживания валидности
    bool isQuantityValid = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Добавить продукт в ${category.name}'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Название продукта',
                    border: OutlineInputBorder(),
                  ),
                  autofocus: true,
                ),
                SizedBox(height: 12),
                TextField(
                  controller: quantityController,
                  decoration: InputDecoration(
                    labelText: 'Количество',
                    border: OutlineInputBorder(),
                    errorText: isQuantityValid ? null : 'Введите корректное число',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    // Проверяем, что введено корректное число
                    final parsedValue = int.tryParse(value);
                    setState(() {
                      isQuantityValid = parsedValue != null && parsedValue >= 0;
                    });
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Отмена'),
              ),
              ElevatedButton(
                onPressed: isQuantityValid && nameController.text.trim().isNotEmpty
                    ? () {
                  final quantity = int.parse(quantityController.text);

                  productStore.addProduct(
                    nameController.text.trim(),
                    quantity,
                    category.id,
                  );

                  Navigator.pop(context);
                }
                    : null,
                child: Text('Добавить'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showEditProductDialog(BuildContext context, Product product) {
    final productStore = Provider.of<ProductStore>(context, listen: false);
    final TextEditingController nameController = TextEditingController(text: product.name);
    final TextEditingController quantityController = TextEditingController(text: product.quantity.toString());

    String? quantityError;
    bool isFormValid = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          // Функция для проверки валидности формы
          void validateForm() {
            final nameValid = nameController.text.trim().isNotEmpty;
            final quantityText = quantityController.text.trim();

            if (quantityText.isEmpty) {
              setState(() {
                quantityError = 'Введите количество';
                isFormValid = false;
              });
              return;
            }

            final parsedValue = int.tryParse(quantityText);
            if (parsedValue == null) {
              setState(() {
                quantityError = 'Введите корректное число';
                isFormValid = false;
              });
            }
            else {
              setState(() {
                quantityError = null;
                isFormValid = nameValid;
              });
            }
          }

          return AlertDialog(
            title: Text('Редактировать продукт'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Название продукта',
                    border: OutlineInputBorder(),
                    errorText: nameController.text.isEmpty ? 'Введите название' : null,
                  ),
                  onChanged: (value) => validateForm(),
                ),
                SizedBox(height: 12),
                TextField(
                  controller: quantityController,
                  decoration: InputDecoration(
                    labelText: 'Количество',
                    border: OutlineInputBorder(),
                    errorText: quantityError,
                    hintText: 'Введите число (0-9999)',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => validateForm(),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Отмена'),
              ),
              ElevatedButton(
                onPressed: isFormValid
                    ? () {
                  final newName = nameController.text.trim();
                  final newQuantity = int.parse(quantityController.text);

                  productStore.updateProductQuantity(product.id, newQuantity);

                  if (newName != product.name) {
                    productStore.removeProduct(product.id);
                    productStore.addProduct(newName, newQuantity, product.categoryId);
                  }

                  Navigator.pop(context);
                }
                    : null,
                child: Text('Сохранить'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _deleteProduct(BuildContext context, Product product) {
    final productStore = Provider.of<ProductStore>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Удалить продукт?'),
        content: Text('Вы уверены, что хотите удалить "${product.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Отмена'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              productStore.removeProduct(product.id);
              Navigator.pop(context);
            },
            child: Text('Удалить', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}