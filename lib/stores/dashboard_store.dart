import 'package:mobx/mobx.dart';

part 'dashboard_store.g.dart';

class DashboardStore = _DashboardStore with _$DashboardStore;

abstract class _DashboardStore with Store {
  @observable
  int totalCategories = 0;

  @observable
  int totalProducts = 0;

  @observable
  int totalQuantity = 0;

  @action
  void updateDashboardStats(int categories, int products, int quantity) {
    totalCategories = categories;
    totalProducts = products;
    totalQuantity = quantity;
  }
}