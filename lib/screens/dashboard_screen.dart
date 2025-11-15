import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import '../stores/dashboard_store.dart';
import '../stores/category_store.dart';
import '../stores/product_store.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final categoryStore = Provider.of<CategoryStore>(context);
    final productStore = Provider.of<ProductStore>(context);
    final dashboardStore = Provider.of<DashboardStore>(context);


    dashboardStore.updateDashboardStats(
      categoryStore.categories.length,
      productStore.totalProductsCount,
      productStore.totalProductsQuantity,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Observer(
        builder: (context) => Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildStatCard(
                Colors.green,
                Icons.inventory,
              ),
              SizedBox(height: 16),
              _buildStatCard(
                'Общее количество',
                dashboardStore.totalQuantity.toString(),
                Colors.orange,
                Icons.shopping_cart,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color, IconData icon) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 40, color: color),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 16, color: Colors.grey)),
                Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}