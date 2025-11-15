class Category {
  final String id;
  String name;
  final List<String> productIds;

  Category({
    required this.id,
    required this.name,
    List<String>? productIds,
  }) : productIds = productIds ?? [];

  void addProduct(String productId) {
    productIds.add(productId);
  }

  void removeProduct(String productId) {
    productIds.remove(productId);
  }
}