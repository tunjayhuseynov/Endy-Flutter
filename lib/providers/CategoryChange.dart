import 'package:endy/streams/categories.dart';
import 'package:endy/types/category.dart';
import 'package:flutter/cupertino.dart';

class CategoryChange extends ChangeNotifier {
  List<Category> myCategories = [];

  CategoryChange() {
    CategoryCrud.getCategories()
        .then((value) => {myCategories = value, notifyListeners()});
  }

  void setCategories(List<Category> categories) {
    myCategories = categories;
    notifyListeners();
  }
}
