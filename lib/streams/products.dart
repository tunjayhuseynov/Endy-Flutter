import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:endy/Pages/main/Home/FilterPage/Filter_Page_Bloc.dart';
import 'package:endy/streams/categories.dart';
import 'package:endy/streams/companies.dart';
import 'package:endy/streams/places.dart';
import 'package:endy/streams/subcategories.dart';
import 'package:endy/types/category.dart';
import 'package:endy/types/company.dart';
import 'package:endy/types/place.dart';
import 'package:endy/types/product.dart';

class ProductsCrud {
  static Future<List<Product>> getProducts([
    DateTime? from,
    int? limit,
    Category? category,
    Subcategory? subcategory,
    FilterPageState? mode,
    Company? company,
    bool? getLastSnap,
  ]) async {
    try {
      QuerySnapshot<Map<String, dynamic>> products;

      final subcategoryRes = subcategory != null
          ? FirebaseFirestore.instance
              .collection("subcategories")
              .doc(subcategory.id)
          : null;

      final categoryRes = category != null
          ? FirebaseFirestore.instance.collection("categories").doc(category.id)
          : null;

      Query<Map<String, dynamic>> query = FirebaseFirestore.instance
          .collection('products')
          .where("status", isEqualTo: "approved");

      if (category != null) {
        query = query.where('category', isEqualTo: categoryRes);
      }

      if (company != null) {
        query = query.where("companyId", isEqualTo: company.id);
      }

      if (subcategoryRes != null) {
        query = query.where('subcategory', isEqualTo: subcategoryRes);
      }

      query = query
          .orderBy("isPrime", descending: true)
          .orderBy("deadline", descending: false)
          .orderBy("created_at", descending: true)
          .startAt([true]);

      if (limit != null) {
        query = query.limit(limit);
      }

      products = await query.get();
      List<Product> myProducts = [];

      var docs = products.docs;

      var rendered =
          await Future.wait(docs.map((e) => renderProduct(e.data())));
      myProducts.addAll(rendered);

      return myProducts;
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<List<Product>> getMostViewedProducts() async {
    try {
      QuerySnapshot<Map<String, dynamic>> products;
      products = await FirebaseFirestore.instance
          .collection('products')
          .where("status", isEqualTo: "approved")
          .orderBy('seenTimes', descending: true)
          .limit(20)
          .get();
      List<Product> myProducts = [];
      myProducts =
          await Future.wait(products.docs.map((e) => renderProduct(e.data())));
      return myProducts;
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  static Future<Product> renderProduct(Map<String, dynamic> element) async {
    final product = Product.fromJson(element);

    product.availablePlaces = await Future.wait(product.availablePlaces.map(
        (e) => PlaceCrud.getPlace(
            e.runtimeType == String ? e.toString().split("/")[1] : e.id)));

    // for (var i = 0; i < product.availablePlaces.length; i++) {
    //   DocumentReference element = product.availablePlaces[i];
    //   Place place = await PlaceCrud.getPlace(element.id);
    //   product.availablePlaces[i] = place;
    // }

    if (product.company != null || product.company != "") {
      product.company = await CompanyCrud.getCompanyPure(
          product.company.runtimeType == String
              ? product.company.toString().split("/")[1]
              : product.company.id);
    }

    product.category = await CategoryCrud.getCategory(
        product.category.runtimeType == String
            ? product.category.toString().split("/")[1]
            : product.category.id);
    if (product.subcategory != null) {
      product.subcategory = await SubcategoryCrud.getSubcategory(
          product.subcategory.runtimeType == String
              ? product.subcategory.toString().split("/")[1]
              : product.subcategory.id);
    }

    return product;
  }

  static Future<Product> getProductPure(String id) {
    return FirebaseFirestore.instance
        .collection('products')
        .doc(id)
        .get()
        .then((snapshot) => Product.fromJson(snapshot.data() ?? {}));
  }

  static Future<Product?> getNullableProduct(String id) async {
    final snapshot =
        await FirebaseFirestore.instance.collection('products').doc(id).get();

    final data = snapshot.data();
    if (data == null || !snapshot.exists) return null;

    return await renderProduct(data);
  }

  static Future<Product> getProduct(String id) async {
    final snapshot =
        await FirebaseFirestore.instance.collection('products').doc(id).get();

    final data = snapshot.data();
    if (data == null) throw Exception("Product not found");

    return await renderProduct(data);
  }

  static Future<List<Product>> getSpecificProducts(List<String> ids) async {
    try {
      List<Product> products = [];
      products = (await Future.wait(ids.map((e) => getNullableProduct(e))))
          .where((element) => element != null)
          .toList().cast<Product>();
      return products;
    } catch (e) {
      print(e);
      throw Exception("Products not found");
    }
  }

  static Future<bool> increaseSeenTimes(String id) async {
    try {
      FirebaseFirestore.instance
          .collection('products')
          .doc(id)
          .update({'seenTimes': FieldValue.increment(1)});
      return true;
    } catch (e) {
      throw Exception("Got error when increasing seen times");
    }
  }
}

class ProductParser {
  static Future<Product> parse(Map<String, dynamic> json) async {
    Product product = Product.fromJson(json);
    for (var i = 0; i < product.availablePlaces.length; i++) {
      Place element = product.availablePlaces[i];
      Place place = await PlaceCrud.getPlace((element as DocumentReference).id);
      element = place;
    }
    product.category = await CategoryCrud.getCategory(product.category.id);
    product.subcategory =
        await SubcategoryCrud.getSubcategory(product.subcategory.id);
    return product;
  }
}

class ProductStream {
  static Stream<QuerySnapshot> getProducts() {
    return FirebaseFirestore.instance
        .collection('products')
        .orderBy('created_at')
        .snapshots();
  }
}
