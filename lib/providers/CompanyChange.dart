import 'package:endy/streams/companies.dart';
import 'package:endy/types/company.dart';
import 'package:flutter/material.dart';

class CompanyChange extends ChangeNotifier {
  List<Company> companies = [];

  CompanyChange() {
    CompanyCrud.getCompanies()
        .then((value) => {companies = value, notifyListeners()});
  }

  setCompanies(List<Company> companies) {
    this.companies = companies;
    notifyListeners();
  }
}
