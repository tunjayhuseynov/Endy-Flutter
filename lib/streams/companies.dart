import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:endy/streams/catalogs.dart';
import 'package:endy/streams/places.dart';
import 'package:endy/streams/products.dart';
import 'package:endy/types/company.dart';
import 'package:endy/types/product.dart';

class CompanyCrud {
  static Future<Company> getCompany(String id) async {
    final companyData =
        await FirebaseFirestore.instance.collection('companies').doc(id).get();
    final data = companyData.data();
    if (data == null) throw Exception('Company not found');

    Company company = Company.fromJson(data);
    company.places =
        (await Future.wait(company.places.map((e) => PlaceCrud.getPlace(e.id))))
            .where((element) => element != null)
            .toList();
    for (var i = 0; i < company.products.length; i++) {
      Product element = company.products[i];
      Product product =
          await ProductsCrud.getProduct((element as DocumentReference).id);
      element = product;
    }
    return company;
  }

  static Future<Company> getCompanyPure(String id) {
    return FirebaseFirestore.instance
        .collection('companies')
        .doc(id)
        .get()
        .then((snapshot) => Company.fromJson(snapshot.data() ?? {}));
  }

  static Future<List<CompanyLabel>> getCompanyLabels() {
    return FirebaseFirestore.instance.collection('companyLabels').get().then(
        (snapshot) =>
            snapshot.docs.map((e) => CompanyLabel.fromJson(e.data())).toList());
  }

  static Future<List<Company>> getCompanies() async {
    final companies = await FirebaseFirestore.instance
        .collection('companies')
        .where("isVisible", isEqualTo: true)
        .orderBy('name')
        .get();

    List<Company> myCompanies = [];
    for (var i = 0; i < companies.docs.length; i++) {
      var company = Company.fromJson(companies.docs[i].data());
      company.places = await Future.wait(
          company.places.map((e) => PlaceCrud.getPlace(e.id)));
      company.catalogs = (await Future.wait(
              company.catalogs.map((e) => CatalogsCrud.getCatalog(e.id))))
          .where((element) => element != null)
          .toList();

      myCompanies.add(company);
    }

    return myCompanies;
  }
}
