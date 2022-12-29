
class Category {
  late String id;
  late String name;
  late String logo;
  late List<dynamic> subcategory = [];
  late int productCount;
  late int createdAt;
  late int order;
  bool isAllCategories = false;
  bool isAllBrands = false;

  Category(
      {required this.id,
      required this.name,
      required this.logo,
      required this.productCount,
      required this.createdAt,
      required this.isAllBrands,
      required this.isAllCategories});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    logo = json['logo'];
    subcategory = json['subcategory'];
    productCount = json['productCount'];
    createdAt = json['created_at'];
    order = json['order'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['logo'] = logo;
    data['productCount'] = productCount;
    data['created_at'] = createdAt;
    data['order'] = order;
    return data;
  }
}

class Subcategory {
  late String id;
  late String name;
  String? logo;
  late dynamic category;
  late List<dynamic> products;
  late int createdAt;

  Subcategory({
    required this.id,
    required this.name,
    this.logo,
    required this.category,
    required this.products,
    required this.createdAt,
  });

  Subcategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    logo = json['logo'];
    category = json['category'];
    products = json['products'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['logo'] = logo;
    data['created_at'] = createdAt;
    return data;
  }
}
