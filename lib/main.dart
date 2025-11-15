import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/categories_screen.dart';
import 'screens/dashboard_screen.dart';
import 'stores/category_store.dart';
import 'stores/product_store.dart';
import 'stores/dashboard_store.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<CategoryStore>(create: (_) => CategoryStore()),
        Provider<ProductStore>(create: (_) => ProductStore()),
        Provider<DashboardStore>(create: (_) => DashboardStore()),
      ],
      child: MaterialApp(
        title: 'Складской учёт',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MainScreen(),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    CategoriesScreen(),
    DashboardScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Категории',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
        ],
      ),
    );
  }
}