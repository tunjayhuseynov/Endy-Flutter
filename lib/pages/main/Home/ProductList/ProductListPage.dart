import 'package:endy/Pages/main/Home/ProductList/Category_Fetch_Bloc.dart';
import 'package:endy/Pages/main/Home/ProductList/Category_Grid_Bar_Bloc.dart';
import 'package:endy/Pages/main/Home/ProductList/category/CategoryGrid.dart';
import 'package:endy/Pages/main/Home/ProductList/company/CompanyGrid.dart';
import 'package:endy/Pages/main/Home/SearchPage/Search_Page_Bloc.dart';
import 'package:endy/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable

class ProductListPage extends StatelessWidget {
  final String id;
  final String? subcategoryId;
  final String type;

  const ProductListPage({
    super.key,
    required this.id,
    this.subcategoryId,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    if (type != 'company' && type != 'category') {
      return ScaffoldWrapper(body: Text("Düzgün bir url giriniz"));
    }
    // if (context.router.stackData.length > 1 && subcategoryId != "all") {
    //   subcategoryId = Uri.decodeComponent(subcategoryId ?? "");
    // }
    // if (context.router.stackData.length == 1 && subcategoryId != "all") {
    //   subcategoryId =
    //       Uri.decodeQueryComponent(Uri.decodeComponent(subcategoryId ?? ""));
    // }
    // if (context.router.stackData.length > 1) {
    //   id = Uri.decodeComponent(id ?? "");
    // }
    // if (context.router.stackData.length == 1) {
    //   id = Uri.decodeQueryComponent(Uri.decodeComponent(id ?? ""));
    // }
    return MultiBlocProvider(
        providers: [
          BlocProvider<SearchPageBloc>(
            create: (context) => SearchPageBloc(),
          ),
          BlocProvider<CategoryGridBarBloc>(
            create: (context) => CategoryGridBarBloc(),
          ),
          BlocProvider<CategoryFetchBloc>(
            create: (context) => CategoryFetchBloc(),
          ),
        ],
        child: type == "category"
            ? CategoryGrid(
                categoryId: type == "category" ? id : "",
              )
            : CompanyGrid(
                companyId: type == 'company' ? id : "",
              ));
  }
}
