import 'package:async/async.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:endy/MainBloc/GlobalBloc.dart';
import 'package:endy/Pages/main/Home/CategoryGrid/AnimatedSearchBox.dart';
import 'package:endy/Pages/main/Home/CategoryGrid/CategoryGridBody.dart';
import 'package:endy/Pages/main/Home/CategoryGrid/Category_Grid_Bloc.dart';
import 'package:endy/Pages/main/Home/CategoryGrid/Category_Grid_Bar_Bloc.dart';
import 'package:endy/Pages/main/Home/CategoryGrid/ScrollableCategoryList.dart';
import 'package:endy/Pages/main/Home/FilterPage/FilterPage.dart';
import 'package:endy/Pages/main/Home/FilterPage/FilterPageScaffold.dart';
import 'package:endy/Pages/main/Home/FilterPage/Filter_Page_Bloc.dart';
import 'package:endy/Pages/main/Home/SearchPage/Search.dart';
import 'package:endy/Pages/main/Home/SearchPage/Search_Page_Bloc.dart';
import 'package:endy/components/Footer.dart';
import 'package:endy/components/Navbar.dart';
import 'package:endy/main.dart';
import 'package:endy/types/category.dart';
import 'package:endy/types/company.dart';
import 'package:endy/utils/index.dart';
import 'package:endy/utils/responsivness/container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:tap_canvas/tap_canvas.dart';
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
  CancelableOperation? _operation;
  TextEditingController editingController = TextEditingController();
  final client = Client(typesenseConfig);
  var focusNode = FocusNode();
  Company? company = null;
  Category? category = null;
  Subcategory? subcategory = null;

  Future<void> fetchData(
      {String? categoryId,
      String? companyId,
      String? subcategoryId,
      required GlobalState state}) async {
    if (categoryId != null) {
      category = state.categories
          .firstWhereOrNull((element) => element.id == categoryId);
    }

    if (companyId != null) {
      company = state.companies
          .firstWhereOrNull((element) => element.id == companyId);
    }

    if (subcategoryId != null) {
      subcategory = state.subcategories
          .firstWhereOrNull((element) => element.id == subcategoryId);
      context.read<CategoryGridBloc>().setSelectedId(subcategoryId);
    }
  }

  @override
  void initState() {
    if (context.router.stackData.length > 1) {
      context.read<FilterPageBloc>().changeFilter(FilterPageState.none);
    }
    _operation = CancelableOperation.fromFuture(fetchData(
            state: context.read<GlobalBloc>().state,
            categoryId: widget.categoryId,
            companyId: widget.companyId,
            subcategoryId: widget.subcategoryId))
        .then((value) => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    // context.read<CategoryCacheBloc>().setClose();
    editingController.dispose();
    focusNode.dispose();
    _operation?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
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
          body: w < 1024
              ? Column(
                  children: buildBody(selectedId: state.selectedId, w: w),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: buildBody(selectedId: state.selectedId, w: w),
                  ),
                ),
        );
      },
    );
  }

  List<Widget> buildBody({
    required String selectedId,
    required double w,
  }) {
    return [
      if (w >= 1024) const Navbar(),
      if (company == null && category == null && subcategory == null)
        Center(
          child: CircularProgressIndicator(
            color: Color(mainColor),
          ),
        ),
      if (w < 1024 &&
          (company != null || category != null || subcategory != null))
        Expanded(child: body(w, selectedId)),
      if (w >= 1024 &&
          (company != null || category != null || subcategory != null))
        body(w, selectedId),
      if (w >= 1024) const Footer(),
    ];
  }

  Widget body(double w, String selectedId) {
    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(horizontal: getContainerSize(w)),
      children: [
        if (w >= 1024) const Padding(padding: EdgeInsets.only(top: 50)),
        Visibility(
            visible: category != null,
            child: ScrollableCategoryList(
              category: category,
              subcategory: subcategory,
              selectedId: selectedId,
              company: company,
              client: client,
            )),
        const Padding(padding: EdgeInsets.only(top: 20)),
        TopBody(company: company),
        BlocBuilder<SearchPageBloc, SearchPageState>(
            buildWhen: (previous, current) => previous.search != current.search,
            builder: (context, searchState) {
              return searchState.search.isNotEmpty
                  ? SearchPageRoute(
                      categoryId: widget.categoryId,
                      companyId: widget.companyId,
                      noTabbar: true,
                      subcategoryId: widget.subcategoryId,
                      params: searchState.search,
                    )
                  : CategoryGridBody(
                      client: client,
                      categoryId: widget.categoryId,
                      subcategoryId: widget.subcategoryId,
                      companyId: widget.companyId,
                    );
            })
      ],
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

class TopBody extends StatefulWidget {
  final Company? company;
  const TopBody({super.key, required this.company});

  @override
  State<TopBody> createState() => _TopBodyState();
}

class _TopBodyState extends State<TopBody> {
  bool isFilterOpened = false;

  Widget FilterIcon(double w) {
    return InkWell(
      mouseCursor: SystemMouseCursors.click,
      hoverColor: Colors.transparent,
      onTap: () {
        if (w < 1024)
          context.router.pushNamed("/home/filter");
        else {
          setState(() {
            isFilterOpened = !isFilterOpened;
          });
        }
      },
      child: Image.asset(
        "assets/icons/filter.png",
        height: 20,
        width: 20,
      ),
    );
  }

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
              if (w >= 1024)
                PortalTarget(
                    visible: isFilterOpened,
                    anchor: Aligned(
                        offset: Offset(0, 330),
                        follower: Alignment.bottomCenter,
                        target: Alignment.center),
                    portalFollower: TapOutsideDetectorWidget(
                      onTappedOutside: () => setState(() {
                        isFilterOpened = false;
                      }),
                      child: Container(
                        width: 400,
                        height: 300,
                        //Card shadow
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: FilterPage(isModal: true),
                      ),
                    ),
                    child: FilterIcon(w)),
              if (w < 1024) FilterIcon(w),
              if (w >= 1024)
                const SizedBox(
                  width: 20,
                ),
              if (widget.company != null)
                CachedNetworkImage(
                  imageUrl: widget.company?.logo ?? "",
                  width: 40,
                ),
            ],
          )),
    );
  }
}
