import 'package:endy/MainBloc/GlobalBloc.dart';
import 'package:endy/components/DiscountCard/DiscountCard.dart';
import 'package:endy/Pages/main/Home/SearchPage/Search_Page_Bloc.dart';
import 'package:endy/components/Footer.dart';
import 'package:endy/components/Navbar.dart';
import 'package:endy/main.dart';
import 'package:endy/types/product.dart';
import 'package:endy/utils/index.dart';
import 'package:endy/utils/responsivness/container.dart';
import 'package:endy/utils/responsivness/searchCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:typesense/typesense.dart';
import 'package:visibility_detector/visibility_detector.dart';

class SearchPageRoute extends StatefulWidget {
  final String? categoryId;
  final String? subcategoryId;
  final String? companyId;
  final String params;
  final bool? noTabbar;

  SearchPageRoute({
    super.key,
    this.noTabbar,
    this.categoryId,
    this.subcategoryId,
    this.companyId,
    this.params = '',
  });

  @override
  State<SearchPageRoute> createState() => _SearchPageRouteState();
}

class _SearchPageRouteState extends State<SearchPageRoute> {
  final client = Client(typesenseConfig);
  TextEditingController editingController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }

  void onVisible(VisibilityInfo info) {
    if (info.visibleFraction > 0.5) {
      context
          .read<SearchPageBloc>()
          .getSearchResult(widget.params, widget.categoryId, widget.companyId,
              widget.subcategoryId, client);
    }
  }

  @override
  void initState() {
    super.initState();
    editingController.text = widget.params;
    context.read<SearchPageBloc>().getSearchResult(widget.params,
        widget.categoryId, widget.companyId, widget.subcategoryId, client,
        resetListOnEachRequest: true);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final gridCount = getSearchCardCount(w);

    return Material(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            if (w >= 1024) const Navbar(),
            Container(
              constraints: w >= 1024
                  ? BoxConstraints(minHeight: size.height - 75)
                  : null,
              padding: EdgeInsets.symmetric(
                  horizontal: getContainerSize(w), vertical: 20),
              child: BlocBuilder<GlobalBloc, GlobalState>(
                  builder: (globalContext, globalState) {
                return BlocConsumer<SearchPageBloc, SearchPageState>(
                  listener: (ctx, state) {
                    if (state.search.length > 0) {
                      context.read<SearchPageBloc>().getSearchResult(
                            widget.params,
                            widget.categoryId,
                            widget.companyId,
                            widget.subcategoryId,
                            client,
                            resetListOnEachRequest: true,
                          );
                    }
                  },
                  listenWhen: (previous, current) =>
                      previous.search != current.search,
                  builder: (context, state) {
                    return LayoutBuilder(builder: (context, constraints) {
                      return Column(
                        children: [
                          if (w < 1024 && widget.noTabbar != true)
                            // TopBar(editingController: editingController),
                            if (state.products.isEmpty && state.isSearching)
                              const Center(
                                  child: CircularProgressIndicator(
                                color: Color(mainColor),
                              )),
                          if (state.products.isEmpty && !state.isSearching)
                            const Center(
                              child: Text(
                                "Nəticə tapılmadı",
                                style: TextStyle(
                                  color: Color(mainColor),
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          if (state.products.isNotEmpty)
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const ScrollPhysics(),
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, bottom: 20),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: gridCount,
                                      childAspectRatio: (200 / 350),
                                      mainAxisSpacing: 15,
                                      crossAxisSpacing: 15),
                              itemCount: state.products.length,
                              itemBuilder: (context, index) {
                                final data = state.products[index];
                                if (index == state.products.length - 1)
                                  return VisibilityDetector(
                                      key: Key(data.id),
                                      child: DiscountCard(
                                          product: Product(
                                              availablePlaces: [],
                                              category: globalState.categories
                                                  .where((element) =>
                                                      "categories/${element.id}" ==
                                                      data.category)
                                                  .first,
                                              company: globalState.companies
                                                  .where((element) =>
                                                      "companies/${element.id}" ==
                                                      data.company)
                                                  .first,
                                              createdAt: data.createdAt,
                                              deadline: data.deadline,
                                              isPrime: false,
                                              discount: data.discount,
                                              discountedPrice:
                                                  data.discountedPrice,
                                              id: data.id,
                                              images: [],
                                              primaryImage: data.primaryImage,
                                              name: data.name,
                                              price: data.price,
                                              subcategory: null,
                                              link: null)),
                                      onVisibilityChanged: onVisible);
                                else
                                  return DiscountCard(
                                      product: Product(
                                          availablePlaces: [],
                                          category: globalState.categories
                                              .where((element) =>
                                                  "categories/${element.id}" ==
                                                  data.category)
                                              .first,
                                          company: globalState.companies
                                              .where((element) =>
                                                  "companies/${element.id}" ==
                                                  data.company)
                                              .first,
                                          createdAt: data.createdAt,
                                          deadline: data.deadline,
                                          isPrime: false,
                                          discount: data.discount,
                                          discountedPrice: data.discountedPrice,
                                          id: data.id,
                                          images: [],
                                          primaryImage: data.primaryImage,
                                          name: data.name,
                                          price: data.price,
                                          subcategory: null,
                                          link: null));
                              },
                            ),
                          if (state.products.isNotEmpty && !state.isLastPage)
                            const Center(
                                child: CircularProgressIndicator(
                              color: Color(mainColor),
                            )),
                          const SizedBox(height: 120),
                        ],
                      );
                    });
                  },
                );
              }),
            ),
            if (w >= 1024) const Footer()
          ],
        ),
      ),
    );
  }
}
