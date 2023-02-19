import 'dart:convert';

import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:endy/Pages/main/Home/CategoryGrid/CategoryGrid.dart';
import 'package:endy/Pages/main/Home/CategoryGrid/Category_Fetch_Bloc.dart';
import 'package:endy/Pages/main/Home/CategoryGrid/Category_Grid_Bar_Bloc.dart';
import 'package:endy/Pages/main/Home/SearchPage/Search_Page_Bloc.dart';
import 'package:endy/utils/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class CategoryBlocProviderRoute extends StatelessWidget {
  String? id;
  String? subcategoryId;
  String type;

  CategoryBlocProviderRoute({
    super.key,
    @pathParam this.id,
    @pathParam this.subcategoryId,
    @pathParam required this.type,
  });

  @override
  Widget build(BuildContext context) {
    if (type != 'company' && type != 'category') {
      return ScaffoldWrapper(body: Text("Düzgün bir url giriniz"));
    }
    if (context.router.stackData.length > 1 && subcategoryId != "all") {
      subcategoryId = Uri.decodeComponent(subcategoryId ?? "");
    }
    if (context.router.stackData.length == 1 && subcategoryId != "all") {
      subcategoryId =
          Uri.decodeQueryComponent(Uri.decodeComponent(subcategoryId ?? ""));
    }
    if (context.router.stackData.length > 1) {
      id = Uri.decodeComponent(id ?? "");
    }
    if (context.router.stackData.length == 1) {
      id = Uri.decodeQueryComponent(Uri.decodeComponent(id ?? ""));
    }
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
        child: CategoryGrid(
          subcategoryId: subcategoryId == "all" ? "" : subcategoryId,
          categoryId: type == "category" ? id : null,
          companyId: type == 'company' ? id : null,
        ));
  }
}
