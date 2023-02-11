import 'package:async/async.dart';
import 'package:endy/MainBloc/GlobalBloc.dart';
import 'package:endy/components/DiscountCard/DiscountCard.dart';
import 'package:endy/Pages/main/Home/SearchPage/Search_Page_Bloc.dart';
import 'package:endy/types/category.dart';
import 'package:endy/types/company.dart';
import 'package:endy/types/product.dart';
import 'package:endy/utils/index.dart';
import 'package:endy/utils/responsivness/container.dart';
import 'package:endy/utils/responsivness/searchCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:typesense/typesense.dart';
import 'package:visibility_detector/visibility_detector.dart';

class SearchPage extends StatefulWidget {
  final Category? category;
  final Subcategory? subcategory;
  final Company? company;
  final Client client;

  SearchPage({
    super.key,
    this.category,
    this.subcategory,
    this.company,
    required this.client,
  });

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late CancelableOperation? _operation;

  @override
  void dispose() {
    _operation?.cancel();
    super.dispose();
  }

  void onVisible(VisibilityInfo info) {
    if (info.visibleFraction > 0.5) {
      _operation = CancelableOperation.fromFuture(context
              .read<SearchPageBloc>()
              .getSearchResult(widget.category, widget.company,
                  widget.subcategory, widget.client))
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
    _operation = CancelableOperation.fromFuture(context
            .read<SearchPageBloc>()
            .getSearchResult(widget.category, widget.company,
                widget.subcategory, widget.client))
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
    final w = MediaQuery.of(context).size.width;
    final gridCount = getSearchCardCount(w);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: getContainerSize(w)),
      child: BlocBuilder<GlobalBloc, GlobalState>(
          builder: (globalContext, globalState) {
        return BlocConsumer<SearchPageBloc, SearchPageState>(
          listener: (ctx, state) {
            if (state.search.length > 0) {
              _operation = CancelableOperation.fromFuture(context
                      .read<SearchPageBloc>()
                      .getSearchResult(widget.category, widget.company,
                          widget.subcategory, widget.client))
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
          listenWhen: (previous, current) => previous.search != current.search,
          builder: (context, state) {
            if (state.products.isEmpty && state.isSearching) {
              return const Center(
                  child: CircularProgressIndicator(
                color: Color(mainColor),
              ));
            }
            if (state.products.isEmpty && !state.isSearching) {
              return const Center(
                child: Text(
                  "Nəticə tapılmadı",
                  style: TextStyle(
                    color: Color(mainColor),
                    fontSize: 20,
                  ),
                ),
              );
            }
            return LayoutBuilder(builder: (context, constraints) {
              return Column(
                children: [
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, bottom: 20),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                                        "companies/${element.id}" == data.company)
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
    );
  }
}
