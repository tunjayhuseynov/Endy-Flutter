import 'package:async/async.dart';
import 'package:auto_route/auto_route.dart';
import 'package:endy/MainBloc/GlobalBloc.dart';
import 'package:endy/Pages/main/Home/HomePage/HomePage.dart';
import 'package:endy/components/DiscountCard/DiscountCard.dart';
import 'package:endy/Pages/main/Home/SearchPage/Search_Page_Bloc.dart';
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

  SearchPageRoute({
    super.key,
    @queryParam this.categoryId,
    @queryParam this.subcategoryId,
    @queryParam this.companyId,
    @queryParam this.params = '',
  });

  @override
  State<SearchPageRoute> createState() => _SearchPageRouteState();
}

class _SearchPageRouteState extends State<SearchPageRoute> {
  late CancelableOperation? _operation;
  final client = Client(typesenseConfig);
  TextEditingController editingController = TextEditingController();

  @override
  void dispose() {
    _operation?.cancel();
    super.dispose();
  }

  void onVisible(VisibilityInfo info) {
    if (info.visibleFraction > 0.5) {
      _operation = CancelableOperation.fromFuture(context
              .read<SearchPageBloc>()
              .getSearchResult(widget.params, widget.categoryId,
                  widget.companyId, widget.subcategoryId, client))
          .then((hits) {
        if (hits.length > 0) {
          final ctx = context.read<SearchPageBloc>();
          ctx.addProducts(hits);
          ctx.set(ctx.state.copyWith(
            currentPage: ctx.state.currentPage + 1,
            isSearching: false,
          ));
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    editingController.text = widget.params;
    _operation = CancelableOperation.fromFuture(context
            .read<SearchPageBloc>()
            .getSearchResult(widget.params, widget.categoryId, widget.companyId,
                widget.subcategoryId, client))
        .then((hits) {
      var state = context.read<SearchPageBloc>().state;
      if (hits.length > 0) {
        context.read<SearchPageBloc>().set(state.copyWith(
              products: [...state.products, ...hits],
              currentPage: state.currentPage + 1,
              isSearching: false,
            ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final gridCount = getSearchCardCount(w);

    return Material(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: getContainerSize(w), vertical: 20),
          child: BlocBuilder<GlobalBloc, GlobalState>(
              builder: (globalContext, globalState) {
            return BlocConsumer<SearchPageBloc, SearchPageState>(
              listener: (ctx, state) {
                if (state.search.length > 0) {
                  _operation = CancelableOperation.fromFuture(context
                          .read<SearchPageBloc>()
                          .getSearchResult(widget.params, widget.categoryId,
                              widget.companyId, widget.subcategoryId, client))
                      .then((hits) {
                    var state = context.read<SearchPageBloc>().state;
                    if (hits.length > 0) {
                      context.read<SearchPageBloc>().set(state.copyWith(
                            products: [...state.products, ...hits],
                            currentPage: state.currentPage + 1,
                            isSearching: false,
                          ));
                    }
                  });
                }
              },
              listenWhen: (previous, current) =>
                  previous.search != current.search,
              builder: (context, state) {
                return LayoutBuilder(builder: (context, constraints) {
                  return Column(
                    children: [
                      if (w < 1024)
                        TopBar(
                            size: size, editingController: editingController),
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
                                          discountedPrice: data.discountedPrice,
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
                      const SizedBox(height: 120)
                    ],
                  );
                });
              },
            );
          }),
        ),
      ),
    );
  }
}
