import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:endy/providers/CompanyChange.dart';
import 'package:endy/streams/places.dart';
import 'package:endy/streams/products.dart';
import 'package:endy/types/company.dart';
import 'package:endy/types/place.dart';
import 'package:endy/types/product.dart';
import 'package:provider/provider.dart';

class CompanyCrud {
  static Future<Company> getCompany(String id) async {
    final companyData =
        await FirebaseFirestore.instance.collection('companies').doc(id).get();
    final data = companyData.data();
    if (data == null) throw Exception('Company not found');

    Company company = Company.fromJson(data);
    for (var i = 0; i < company.places.length; i++) {
      Place element = company.places[i];
      Place place = await PlaceCrud.getPlace((element as DocumentReference).id);
      element = place;
    }
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

  static Future<List<Company>> getCompanies() async {
    final companies = await FirebaseFirestore.instance
        .collection('companies')
        .orderBy('name')
        .get();


    List<Company> myCompanies = [];
    for (var i = 0; i < companies.docs.length; i++) {
      var company = Company.fromJson(companies.docs[i].data());
      company.places = await Future.wait(
          company.places.map((e) => PlaceCrud.getPlace(e.id)));
      // company.products = await Future.wait(
      //     company.products.map((e) => ProductsCrud.getProduct(e.id)));

      // for (var q = 0; q < company.places.length; q++) {
      //   DocumentReference element = company.places[q];
      //   Place place = await PlaceCrud.getPlace(element.id);
      //   company.places[q] = place;
      // }

      // for (var q = 0; q < company.products.length; q++) {
      //   // DocumentReference element = company.products[q];
      //   // Product product = await ProductsCrud.getProduct(element.id);
      //   // company.products[q] = product;
      //   if (!company.subcategories.any(
      //       (element) => element.id == company.products[q].subcategory.id)) {
      //     company.subcategories.add(company.products[q].subcategory);
      //   }
      // }
      myCompanies.add(company);
    }

    return myCompanies;
  }
}
