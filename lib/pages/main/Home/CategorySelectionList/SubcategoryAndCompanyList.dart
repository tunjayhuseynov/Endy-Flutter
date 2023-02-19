import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:endy/MainBloc/GlobalBloc.dart';
import 'package:endy/Pages/main/Home/CategoryGrid/Category_Grid_Bloc.dart';
import 'package:endy/Pages/main/Home/CategorySelectionList/Category_Selection_List_Bloc.dart';
import 'package:endy/types/category.dart';
import 'package:endy/types/company.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:collection/collection.dart';

class SubcategoryListRoute extends StatefulWidget {
  final String? id;
  final String? type;
  const SubcategoryListRoute(
      {Key? key, @pathParam this.id, @pathParam this.type})
      : super(key: key);

  @override
  State<SubcategoryListRoute> createState() => _SubcategoryListRouteState();
}

class _SubcategoryListRouteState extends State<SubcategoryListRoute> {
  TextEditingController editingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<CategorySelectionListBloc>().search("");
  }

  @override
  void dispose() {
    editingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return BlocSelector<CategorySelectionListBloc, CategorySelectionListState,
        CategorySelectionListState>(
      selector: (state) {
        var isBrand = widget.type == "company";
        var isSubcategory = widget.type == "subcategory";
        var category = context
            .read<GlobalBloc>()
            .state
            .categories
            .firstWhereOrNull((element) => element.id == widget.id);
        var companies = context.read<GlobalBloc>().state.companies;
        return state.copyWith(
          isBrand: isBrand,
          isSubcategory: isSubcategory,
          selectedCategory: category,
          categories: state.categories
              .where((element) => state.searchValue != ""
                  ? element.name
                      .toLowerCase()
                      .contains(state.searchValue.toLowerCase())
                  : true)
              .toList(),
          subcategories: category?.subcategory
              .where((element) => state.searchValue != ""
                  ? element.name
                      .toLowerCase()
                      .contains(state.searchValue.toLowerCase())
                  : true)
              .toList(),
          companies: companies
              .where((element) => state.searchValue != ""
                  ? element.name
                      .toLowerCase()
                      .contains(state.searchValue.toLowerCase())
                  : true)
              .toList(),
        );
      },
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () async {
            return true;
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              surfaceTintColor: Colors.white,
              toolbarHeight: 80,
              leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    if (context.router.stackData.length == 1) {
                      context.router.pushNamed('/');
                    } else {
                      context.router.pop(context);
                    }
                  }),
              title: Text(state.selectedCategory?.name ?? "",
                  style: const TextStyle(
                      fontSize: 25, fontWeight: FontWeight.w500)),
            ),
            body: Container(
              padding: w < 768
                  ? null
                  : EdgeInsets.symmetric(horizontal: (w - 768) / 2),
              child: Column(
                children: [
                  Container(
                    width: w < 768 ? null : 300,
                    padding: const EdgeInsets.all(8.0),
                    child: CupertinoSearchTextField(
                      placeholder: "Axtarış",
                      onChanged: (value) {
                        context.read<CategorySelectionListBloc>().search(value);
                      },
                      controller: editingController,
                      prefixInsets: const EdgeInsets.only(left: 20),
                      borderRadius: const BorderRadius.all(Radius.circular(50)),
                    ),
                  ),
                  state.isSubcategory
                      ? Expanded(
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: state.subcategories.isNotEmpty
                                  ? state.subcategories.length + 1
                                  : 0,
                              itemBuilder: (BuildContext context, int index) {
                                return SubcategoryItem(
                                  selectAll: index == 0,
                                  subcategory: state.subcategories[
                                      index > 0 ? index - 1 : index],
                                  category: state.selectedCategory!,
                                );
                              }),
                        )
                      : state.isBrand
                          ? Expanded(
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: state.companies.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return CompanyItem(
                                      company: state.companies[index],
                                    );
                                  }),
                            )
                          : Container()
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class CompanyItem extends StatelessWidget {
  final Company company;
  const CompanyItem({Key? key, required this.company}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final amountOfSub = company.products.length;
    return InkWell(
      mouseCursor: SystemMouseCursors.click,
      onTap: () {
        context
            .read<CategoryGridBloc>()
            .set(prevPath: context.router.currentPath);
        context.router.pushNamed('company/products/${company.id}/all');
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 15),
              width: 45,
              height: 45,
              child: CachedNetworkImage(imageUrl: company.logo),
            ),
            Expanded(flex: 2, child: Text(company.name)),
            Text(amountOfSub.toString(),
                style: const TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}

class SubcategoryItem extends StatelessWidget {
  final Subcategory subcategory;
  final Category category;
  final bool? selectAll;
  const SubcategoryItem(
      {Key? key,
      required this.subcategory,
      required this.category,
      this.selectAll})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      mouseCursor: SystemMouseCursors.click,
      onTap: () async {
        context
            .read<CategoryGridBloc>()
            .set(prevPath: context.router.currentPath);
        context.router.pushNamed(
            'category/products/${category.id}/${selectAll == true ? "all" : subcategory.id}');
      },
      child: Container(
        height: 45,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Container(
            //   margin: const EdgeInsets.only(right: 15),
            //   width: 45,
            //   height: 45,
            //   child: selectAll != true && subcategory.logo != null
            //       ? CachedNetworkImage(imageUrl: subcategory.logo!)
            //       : Container(),
            // ),
            Expanded(
                flex: 2,
                child: Text(
                  selectAll == true ? "Hamısı" : subcategory.name,
                  style: TextStyle(fontSize: 16),
                )),
            Text(
                selectAll == true ? "" : subcategory.products.length.toString(),
                style: const TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
