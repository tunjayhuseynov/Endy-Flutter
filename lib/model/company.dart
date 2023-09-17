import 'package:endy/model/category.dart';
import 'package:endy/model/story.dart';

class Company {
  late String id;
  late String role;
  late String name;
  late String logo;
  late String label;
  late List<dynamic> places;
  late List<dynamic> products;
  List<Subcategory> subcategories = [];
  List<dynamic> catalogs = [];
  late List<Story> stories = [];
  late int createdAt;
  late bool isCustomPassword;

  Company(
      {required this.id,
      required this.role,
      required this.name,
      required this.catalogs,
      required this.logo,
      required this.createdAt,
      required this.isCustomPassword});

  Company.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    role = json['role'];
    catalogs = json['catalogs'];
    label = json['label'];
    name = json['name'];
    logo = json['logo'];
    places = json['places'];
    products = json['products'];
    createdAt = json['created_at'];
    isCustomPassword = json['isCustomPassword'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['role'] = role;
    data['catalogs'] = catalogs;
    data['name'] = name;
    data['label'] = label;
    data['logo'] = logo;
    data['places'] = places;
    data['products'] = products;
    data['created_at'] = createdAt;
    data['isCustomPassword'] = isCustomPassword;
    return data;
  }
}

class CompanyLabel {
  late String id;
  late String label;

  CompanyLabel({required this.id, required this.label});

  CompanyLabel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    label = json['label'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['label'] = label;
    return data;
  }
}
