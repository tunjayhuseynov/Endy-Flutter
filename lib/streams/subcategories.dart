import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:endy/streams/products.dart';
import 'package:endy/model/category.dart';
import 'package:endy/model/product.dart';

class SubcategoryCrud {
  static Future<List<Subcategory>> getSubcategories() async {
    final subcategories = await FirebaseFirestore.instance
        .collection('subcategories')
        .orderBy('name')
        .get();

    List<Subcategory> mySubcategories = [];
    for (var i = 0; i < subcategories.size; i++) {
      final element = subcategories.docs[i].data();
      final subcategory = Subcategory.fromJson(element);

      for (var i = 0; i < subcategory.products.length; i++) {
        Product element = subcategory.products[i];
        Product product = await ProductsCrud.getProductPure(element.id);
        subcategory.products[i] = product;
      }

      mySubcategories.add(subcategory);
    }

    return mySubcategories;
  }

  static Future<Subcategory> getSubcategoryPure(String id) {
    return FirebaseFirestore.instance
        .collection('subcategories')
        .doc(id)
        .get()
        .then((snapshot) => Subcategory.fromJson(snapshot.data() ?? {}));
  }

  static Future<Subcategory> getSubcategory(String id) {
    return FirebaseFirestore.instance
        .collection('subcategories')
        .doc(id)
        .get()
        .then((snapshot) {
      final data = snapshot.data();
      if (data == null) throw Exception('Subcategory not found');
      Subcategory subcategory = Subcategory.fromJson(data);
      subcategory.products.map((e) async {
        Product product =
            await ProductsCrud.getProduct((e as DocumentReference).id);
        e = product;
      });
      return subcategory;
    });
  }
}

class SubcategoryStream {
  // Stream Subcategory
  static Stream<List<Subcategory>> getSubcategories() {
    return FirebaseFirestore.instance
        .collection('subcategories')
        .orderBy('name')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final subcategory = Subcategory.fromJson(doc.data());
              return subcategory;
            }).toList());
  }

  // Get Subcategory
  static Stream<Subcategory> getSubcategoryStream(String id) {
    return FirebaseFirestore.instance
        .collection('subcategories')
        .doc(id)
        .snapshots()
        .map((snapshot) => Subcategory.fromJson(snapshot.data() ?? {}));
  }
}
