import 'package:endy/MainBloc/GlobalBloc.dart';
import 'package:endy/Pages/main/Home/ProductList/Category_Grid_Bloc.dart';
import 'package:endy/Pages/main/Home/ProductList/components/GridBody.dart';
import 'package:endy/Pages/main/Home/ProductList/components/ScrollableCategoryList.dart';
import 'package:endy/Pages/main/Home/ProductList/components/TopBody.dart';
import 'package:endy/Pages/main/Home/SearchPage/Search.dart';
import 'package:endy/Pages/main/Home/SearchPage/Search_Page_Bloc.dart';
import 'package:endy/components/Footer.dart';
import 'package:endy/components/Loader.dart';
import 'package:endy/components/Navbar.dart';
import 'package:endy/main.dart';
import 'package:endy/model/category.dart';
import 'package:endy/utils/index.dart';
import 'package:endy/utils/responsivness/container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:typesense/typesense.dart';
import 'package:endy/Pages/main/Home/ProductList/components/TabBar.dart' as tab;
import 'package:collection/collection.dart';

class CategoryGrid extends StatefulWidget {
  final String categoryId;
  final String? subcategoryId;

  const CategoryGrid({
    Key? key,
    required this.categoryId,
    this.subcategoryId,
  }) : super(key: key);

  @override
  State<CategoryGrid> createState() => _CategoryGridState();
}

class _CategoryGridState extends State<CategoryGrid> {
  TextEditingController editingController = TextEditingController();
  final client = Client(typesenseConfig);
  var focusNode = FocusNode();
  Subcategory? subcategory = null;
  late Category category;

  Future<Map<String, dynamic>> fetchData(
      {required String categoryId,
      // String? subcategoryId,
      required GlobalState state}) async {
    // if (subcategoryId != null) {
    //   subcategory = state.subcategories
    //       .firstWhereOrNull((element) => element.id == subcategoryId);
    //   context.read<CategoryGridBloc>().setSelectedId(subcategoryId);
    // }

    return {
      "category": state.categories
          .firstWhereOrNull((element) => element.id == categoryId)
    };
  }

  @override
  void initState() {
    // if (context.router.stackData.length > 1) {
    //   context.read<FilterPageBloc>().changeFilter(FilterPageState.none);
    // }

    category = context
        .read<GlobalBloc>()
        .state
        .categories
        .firstWhere((element) => element.id == widget.categoryId);
    super.initState();
  }

  @override
  void dispose() {
    // context.read<CategoryCacheBloc>().setClose();
    editingController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return ScaffoldWrapper(
      hPadding: 0,
      appBar: tab.AppBarCategoryList(
          category: category,
          subcategory: subcategory,
          focusNode: focusNode,
          editingController: editingController,
          w: w),
      backgroundColor: Colors.white,
      body: w < 1024
          ? Column(
              children: buildBody(w: w, category: category),
            )
          : SingleChildScrollView(
              child: Column(
                children: buildBody(w: w, category: category),
              ),
            ),
    );
  }

  List<Widget> buildBody({required double w, required Category? category}) {
    return [
      if (w >= 1024) const Navbar(),
      if (category == null && subcategory == null)
        Center(
          child: CircularProgressIndicator(
            color: Color(mainColor),
          ),
        ),
      if (w < 1024 && (category != null || subcategory != null))
        Expanded(child: body(w: w, category: category)),
      if (w >= 1024 && (category != null || subcategory != null))
        body(w: w, category: category),
      if (w >= 1024) const Footer(),
    ];
  }

  Widget body({required double w, required Category? category}) {
    return Column(
      // padding: EdgeInsets.symmetric(horizontal: getContainerSize(w)),
      children: [
        if (w >= 1024) const Padding(padding: EdgeInsets.only(top: 50)),
        Visibility(
            visible: category != null,
            child: ScrollableList(
              category: category,
              subcategory: subcategory,
              company: null,
              client: client,
            )),
        const Padding(padding: EdgeInsets.only(top: 20)),
        TopBody(company: null),
        Expanded(
            child: BlocBuilder<SearchPageBloc, SearchPageState>(
                buildWhen: (previous, current) =>
                    previous.search != current.search,
                builder: (context, searchState) {
                  return BlocBuilder<CategoryGridBloc, CategoryGridState>(
                      builder: (context, gridState) {
                    return searchState.search.isNotEmpty
                        ? SearchPageRoute(
                            categoryId: widget.categoryId,
                            noTabbar: true,
                            subcategoryId: gridState.selectedId,
                            params: searchState.search,
                          )
                        : GridBody(
                            key: Key(gridState.selectedId.isEmpty
                                ? "ALL"
                                : gridState.selectedId),
                            client: client,
                            categoryId: widget.categoryId,
                            subcategoryId: widget.subcategoryId,
                          );
                  });
                }))
      ],
    );
  }
}
