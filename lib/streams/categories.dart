import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:endy/streams/subcategories.dart';
import 'package:endy/model/category.dart';

class CategoryCrud {
  static Future<List<Category>> getCategories() async {
    try {
      final categories = await FirebaseFirestore.instance
          .collection('categories')
          .where('isInvisible', isEqualTo: false)
          .orderBy('created_at')
          .get();

      List<Category> myCategories = [];
      for (var i = 0; i < categories.size; i++) {
        final element = categories.docs[i].data();

        final category = Category.fromJson(element);
        category.subcategory = await Future.wait(category.subcategory
            .map((e) => SubcategoryCrud.getSubcategoryPure(e.id)));

        myCategories.add(category);
      }
      myCategories.sort((a, b) => a.iconOrder.compareTo(b.iconOrder));
      return myCategories;
    } catch (e) {
      throw Exception('Error getting categories');
    }
  }

  static Future<Category> getCategoryPure(String id) async {
    return FirebaseFirestore.instance
        .collection('categories')
        .doc(id)
        .get()
        .then((snapshot) => Category.fromJson(snapshot.data() ?? {}));
  }

  static Future<Category> getCategory(String id) async {
    final doc =
        await FirebaseFirestore.instance.collection('categories').doc(id).get();

    if (doc.exists) {
      final data = doc.data();
      if (data == null) throw Exception('Category not found');

      Category category = Category.fromJson(data);

      for (var i = 0; i < category.subcategory.length; i++) {
        var e = category.subcategory[i];
        Subcategory c =
            await SubcategoryCrud.getSubcategory((e as DocumentReference).id);
        category.subcategory[i] = c;
      }

      return category;
    }
    throw Exception('Category not found');
  }
}
