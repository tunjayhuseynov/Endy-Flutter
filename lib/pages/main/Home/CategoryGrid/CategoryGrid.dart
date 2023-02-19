import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:endy/MainBloc/GlobalBloc.dart';
import 'package:endy/Pages/main/Home/CategoryGrid/AnimatedSearchBox.dart';
import 'package:endy/Pages/main/Home/CategoryGrid/CategoryGridBody.dart';
import 'package:endy/Pages/main/Home/CategoryGrid/Category_Grid_Bloc.dart';
import 'package:endy/Pages/main/Home/CategoryGrid/Category_Grid_Bar_Bloc.dart';
import 'package:endy/Pages/main/Home/CategoryGrid/ScrollableCategoryList.dart';
import 'package:endy/Pages/main/Home/FilterPage/Filter_Page_Bloc.dart';
import 'package:endy/Pages/main/Home/SearchPage/Search_Page_Bloc.dart';
import 'package:endy/main.dart';
import 'package:endy/types/category.dart';
import 'package:endy/types/company.dart';
import 'package:endy/utils/index.dart';
import 'package:endy/utils/responsivness/container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:typesense/typesense.dart';
import 'package:endy/Pages/main/Home/CategoryGrid/TabBar.dart' as tab;
import 'package:collection/collection.dart';

class CategoryGrid extends StatefulWidget {
  final String? categoryId;
  final String? subcategoryId;
  final String? companyId;

  const CategoryGrid({
    Key? key,
    this.categoryId,
    this.subcategoryId,
    this.companyId,
  }) : super(key: key);

  @override
  State<CategoryGrid> createState() => _CategoryGridState();
}

class _CategoryGridState extends State<CategoryGrid> {
  TextEditingController editingController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final client = Client(typesenseConfig);
  var focusNode = FocusNode();
  Company? company = null;
  Category? category = null;
  Subcategory? subcategory = null;

  fetchData() async {
    var state = context.read<GlobalBloc>().state;
    if (widget.categoryId != null) {
      category = state.categories
          .firstWhereOrNull((element) => element.id == widget.categoryId);
    }

    if (widget.companyId != null) {
      company = state.companies
          .firstWhereOrNull((element) => element.id == widget.companyId);
    }

    if (widget.subcategoryId != null) {
      subcategory = state.subcategories
          .firstWhereOrNull((element) => element.id == widget.subcategoryId);
      context
          .read<CategoryGridBloc>()
          .setSelectedId(widget.subcategoryId ?? "");
    }
    setState(() {});
  }

  @override
  void initState() {
    if (context.router.stackData.length > 1) {
      context.read<FilterPageBloc>().changeFilter(FilterPageState.none);
    }
    fetchData();
    super.initState();
  }

  // Future<void> filterClick(CategoryGridState state) async {
  //   await context.router.pushNamed("/home/filter");

  //   if (state != FilterPageState.none) {
  //     // final ctx = context.read<CategoryCacheBloc>();
  //     // ctx.reset();

  //     CategoryCacheBloc.fetch(context, client, resetProduct: true);
  //   }
  // }

  @override
  void dispose() {
    // context.read<CategoryCacheBloc>().setClose();
    editingController.dispose();
    scrollController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return BlocBuilder<SearchPageBloc, SearchPageState>(
      buildWhen: (previous, current) => previous.search != current.search,
      builder: (searchContext, searchState) {
        return BlocBuilder<CategoryGridBloc, CategoryGridState>(
          builder: (context, state) {
            return ScaffoldWrapper(
              hPadding: 0,
              appBar: AppBarCategoryList(
                  category: category,
                  company: company,
                  subcategory: subcategory,
                  focusNode: focusNode,
                  editingController: editingController,
                  w: w),
              backgroundColor: Colors.white,
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    if (company == null &&
                        category == null &&
                        subcategory == null)
                      Center(
                        child: CircularProgressIndicator(
                          color: Color(mainColor),
                        ),
                      ),
                    if (company != null ||
                        category != null ||
                        subcategory != null)
                      ListView(
                        shrinkWrap: true,
                        controller: scrollController,
                        padding: EdgeInsets.symmetric(
                            horizontal: getContainerSize(w)),
                        children: [
                          if (w >= 1024)
                            const Padding(padding: EdgeInsets.only(top: 50)),
                          Visibility(
                              visible: category != null,
                              child: ScrollableCategoryList(
                                category: category,
                                subcategory: subcategory,
                                selectedId: state.selectedId,
                                company: company,
                                client: client,
                              )),
                          const Padding(padding: EdgeInsets.only(top: 20)),
                          TopBody(company: company),
                          CategoryGridBody(
                            client: client,
                            categoryId: widget.categoryId,
                            subcategoryId: widget.subcategoryId,
                            companyId: widget.companyId,
                          )
                        ],
                      )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class AppBarCategoryList extends StatelessWidget
    implements PreferredSizeWidget {
  const AppBarCategoryList({
    super.key,
    required this.focusNode,
    required this.editingController,
    required this.w,
    this.category,
    this.subcategory,
    this.company,
  });

  final FocusNode focusNode;
  final TextEditingController editingController;
  final double w;
  final Category? category;
  final Subcategory? subcategory;
  final Company? company;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      surfaceTintColor: Colors.white,
      backgroundColor: Colors.white,
      toolbarHeight: 80,
      leadingWidth: 56,
      // titleSpacing: 35,
      leading: BlocBuilder<CategoryGridBloc, CategoryGridState>(
          builder: (context, state) {
        return IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              context.router
                  .pushNamed(state.prevPath.isEmpty ? "/" : state.prevPath);
            });
      }),
      centerTitle: true,
      title: BlocBuilder<CategoryGridBarBloc, CategoryGridBarState>(
        builder: (cacheContext, cacheState) {
          return cacheState.title
              ? tab.TabBar(
                  category: category,
                  company: company,
                  subcategory: subcategory,
                )
              : Container();
        },
      ),
      actions: <Widget>[
        AnimatedSearchBox(
            focusNode: focusNode, editingController: editingController),
        if (w > 1024)
          InkWell(
            mouseCursor: SystemMouseCursors.click,
            hoverColor: Colors.transparent,
            onTap: () {
              context.router.pushNamed("/home/filter");
            },
            child: Image.asset(
              "assets/icons/filter.png",
              height: 20,
              width: 20,
            ),
          ),
        if (w > 1024)
          SizedBox(
            width: w / 2 - 150,
          )
      ],
    );
  }

  @override
  Size get preferredSize => Size(w, 80);
}

class TopBody extends StatelessWidget {
  final Company? company;
  const TopBody({super.key, required this.company});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: Row(
            mainAxisAlignment: w >= 1024
                ? MainAxisAlignment.start
                : MainAxisAlignment.spaceBetween,
            children: [
              const Text("100-dən çox məhsul",
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400)),
              const SizedBox(
                width: 20,
              ),
              InkWell(
                mouseCursor: SystemMouseCursors.click,
                hoverColor: Colors.transparent,
                onTap: () {
                  context.router.pushNamed("/home/filter");
                },
                child: Image.asset(
                  "assets/icons/filter.png",
                  height: 20,
                  width: 20,
                ),
              ),
              if (company != null)
                CachedNetworkImage(
                  imageUrl: company?.logo ?? "",
                  width: 40,
                ),
            ],
          )),
    );
  }
}
