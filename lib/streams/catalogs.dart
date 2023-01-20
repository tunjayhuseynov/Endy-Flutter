import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:endy/types/catalog.dart';

class CatalogsCrud {
  static Future<List<Catalog>> getCatalogs(
      {DocumentReference? companyId}) async {
    try {
      var query = FirebaseFirestore.instance
          .collection("catalogs")
          .where("status", isEqualTo: "approved");

      if (companyId != null) {
        query = query.where("companyId", isEqualTo: companyId);
      }

      final catalogs = await query.get();

      return catalogs.docs
          .map((element) => Catalog.fromJson(element.data()))
          .toList();
    } catch (e) {
      print(e);
      throw Exception('Error getting catalogs');
    }
  }

  static Future<Catalog> getCatalog(String id) async {
    try {
      var query = FirebaseFirestore.instance.collection("catalogs").doc(id);

      final catalog = await query.get();

      return Catalog.fromJson(catalog.data() ?? {});
    } catch (e) {
      print(e);
      throw Exception('Error getting catalogs');
    }
  }
}
