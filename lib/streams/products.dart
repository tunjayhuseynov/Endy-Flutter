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
    DocumentSnapshot? lastProduct,
  ]) async {
    try {
      // DocumentSnapshot? lastSnap;
      QuerySnapshot<Map<String, dynamic>> products;

      final subcategoryRes = subcategory != null
          ? FirebaseFirestore.instance
              .collection("subcategories")
              .doc(subcategory.id)
          : null;

      final categoryRes = category != null
          ? FirebaseFirestore.instance.collection("categories").doc(category.id)
          : null;

      final lastDayTime = mode != null && mode == FilterPageState.lastDay
          ? (DateTime.now()
                      .add(const Duration(hours: 24))
                      .millisecondsSinceEpoch /
                  1000)
              .round()
          : null;

      final more20Percent =
          mode != null && mode == FilterPageState.moreThan20 ? 20 : null;

      final lastAdded =
          mode != null && mode == FilterPageState.lastAdded ? true : null;

      int currentTime =
          (DateTime.now().millisecondsSinceEpoch.toInt() / 1000).round();

      Query<Map<String, dynamic>> query =
          FirebaseFirestore.instance.collection('products');

      if (category != null) {
        query = query.where('category', isEqualTo: categoryRes);
      }

      if (company != null) {
        query = query.where("companyId", isEqualTo: company.id);
      }

      // More than 20 Filter
      // More than 20 Filter
      // More than 20 Filter
      if (more20Percent != null) {
        var startArr = [
          false,
          // (lastProduct?.discount ?? 100) >= more20Percent
          //     ? (lastProduct?.discount ?? 100)
          //     : more20Percent
        ];
        var endArr = [false, more20Percent];

        // if (lastProduct != null) {
        //   startArr.addAll([lastProduct.deadline, lastProduct.createdAt]);
        // }

        query = query
            .orderBy("isPrime", descending: true)
            .orderBy("discount", descending: true)
            .orderBy("deadline", descending: false)
            .orderBy("created_at", descending: true)
            .startAt(startArr)
            .endAt(endArr);
      }

      // Last Day Filter
      // Last Day Filter
      // Last Day Filter
      if (lastDayTime != null) {
        var startArr = [false, currentTime];
        var endArr = [false, lastDayTime];

        // if (lastProduct != null) {
        //   startArr.addAll([lastProduct.discount, lastProduct.createdAt]);
        // }

        query = query
            .orderBy("isPrime", descending: true)
            .orderBy("deadline", descending: false)
            .orderBy("discount", descending: true)
            .orderBy("created_at", descending: true)
            .startAt(startArr)
            .endAt(endArr);
      }

      // Last Add Day Filter
      // Last Add Day Filter
      // Last Add Day Filter
      if (lastAdded != null) {
        query = query
            .orderBy("isPrime", descending: true)
            .orderBy("created_at", descending: true)
            .orderBy("deadline", descending: false);
      }

      if (subcategoryRes != null) {
        query = query.where('subcategory', isEqualTo: subcategoryRes);
      }

      // Without Filter
      // Without Filter
      // Without Filter
      if (more20Percent == null && lastDayTime == null && lastAdded == null) {
        List<dynamic> startAt = [true];
        // if (lastProduct != null) {
        //   startAt.addAll([lastProduct.deadline, lastProduct.createdAt]);
        // }
        query = query
            .orderBy("isPrime", descending: true)
            .orderBy("deadline", descending: false)
            .orderBy("created_at", descending: true)
            .startAt(startAt);
        // .endAt([false, oneYearTime]);

        if (lastProduct != null) {
          query.startAfterDocument(lastProduct);
        }
      }

      if (limit != null) {
        query = query.limit(limit);
      }

      products = await query.get();
      List<Product> myProducts = [];

      // More than 20 Filter Addition
      // More than 20 Filter Addition
      // More than 20 Filter Addition
      if (more20Percent != null && category != null) {
        var snaps = FirebaseFirestore.instance
            .collection('products')
            .where('category', isEqualTo: categoryRes);

        if (company != null) {
          snaps = snaps.where("companyId", isEqualTo: company.id);
        }

        var startArr = [
          true,
          // (lastProduct?.discount ?? 100) >= more20Percent
          //     ? (lastProduct?.discount ?? 100)
          //     : more20Percent
        ];
        var endArr = [true, more20Percent];

        // if (lastProduct != null) {
        //   startArr.addAll([lastProduct.deadline, lastProduct.createdAt]);
        // }

        snaps = snaps
            .orderBy("isPrime", descending: true)
            .orderBy("discount", descending: true)
            .orderBy("deadline", descending: false)
            .orderBy("created_at", descending: true)
            .startAt(startArr)
            .endAt(endArr);

        if (subcategoryRes != null) {
          snaps = snaps.where('subcategory', isEqualTo: subcategoryRes);
        }

        if (limit != null) {
          snaps = snaps.limit(limit);
        }
        final fetchedSnaps = await snaps.get();
        final allSnaps = await Future.wait(
          fetchedSnaps.docs.map((e) => renderProduct(e.data())),
        );

        myProducts.addAll(allSnaps);
      }

      // Last Day Filter Addition
      // Last Day Filter Addition
      // Last Day Filter Addition
      if (lastDayTime != null && category != null) {
        var snaps = FirebaseFirestore.instance
            .collection('products')
            .where('category', isEqualTo: categoryRes);

        if (subcategoryRes != null) {
          snaps = snaps.where('subcategory', isEqualTo: subcategoryRes);
        }
        if (company != null) {
          snaps = snaps.where("companyId", isEqualTo: company.id);
        }

        var startArr = [true, currentTime];
        var endArr = [true, lastDayTime];

        // if (lastProduct != null) {
        //   startArr.addAll([lastProduct.discount, lastProduct.createdAt]);
        // }

        snaps = snaps
            .orderBy("isPrime", descending: true)
            .orderBy("deadline", descending: false)
            .orderBy("discount", descending: true)
            .orderBy("created_at", descending: true)
            .startAt(startArr)
            .endAt(endArr);

        if (limit != null) {
          snaps = snaps.limit(limit);
        }

        var fetchedSnaps = await snaps.get();
        // lastSnap = fetchedSnaps.docs.last;
        var allSnaps = await Future.wait(
            fetchedSnaps.docs.map((e) => renderProduct(e.data())));
        myProducts.addAll(allSnaps);
      }

      if (limit == null || myProducts.length < limit) {
        var docs = products.docs;
        if (limit != null) {
          docs = docs.take((myProducts.length - limit).abs()).toList();
        }
        // lastSnap = docs.last;
        var rendered =
            await Future.wait(docs.map((e) => renderProduct(e.data())));
        myProducts.addAll(rendered);
      }
      // if (getLastSnap == true) {
      //   return [myProducts, products.docs.last];
      // }
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
          .orderBy('seenTimes', descending: true)
          .limit(20)
          .get();
      List<Product> myProducts = [];
      myProducts =
          await Future.wait(products.docs.map((e) => renderProduct(e.data())));
      return myProducts;
    } catch (e) {
      throw Error();
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

    product.company = await CompanyCrud.getCompanyPure(
        product.company.runtimeType == String
            ? product.company.toString().split("/")[1]
            : product.company.id);

    product.category = await CategoryCrud.getCategory(
        product.category.runtimeType == String
            ? product.category.toString().split("/")[1]
            : product.category.id);
    product.subcategory = await SubcategoryCrud.getSubcategory(
        product.subcategory.runtimeType == String
            ? product.subcategory.toString().split("/")[1]
            : product.subcategory.id);

    return product;
  }

  static Future<Product> getProductPure(String id) {
    return FirebaseFirestore.instance
        .collection('products')
        .doc(id)
        .get()
        .then((snapshot) => Product.fromJson(snapshot.data() ?? {}));
  }

  static Future<Product> getProduct(String id) async {
    final snapshot =
        await FirebaseFirestore.instance.collection('products').doc(id).get();

    final data = snapshot.data();
    if (data == null) throw Exception('Product not found');

    return await renderProduct(data);
  }

  static Future<List<Product>> getSpecificProducts(List<String> ids) async {
    try {
      List<Product> products = [];
      products = await Future.wait(ids.map((e) => getProduct(e)));

      return products;
    } catch (e) {
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
