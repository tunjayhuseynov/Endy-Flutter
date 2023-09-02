import 'dart:async';

import 'package:endy/Pages/main/Home/FilterPage/Filter_Page_Bloc.dart';
import 'package:endy/Pages/main/Home/ProductList/Category_Fetch_Bloc.dart';
import 'package:endy/components/DiscountCard/DiscountCard.dart';
import 'package:endy/Pages/main/Home/ProductList/Category_Grid_Bloc.dart';
import 'package:endy/model/product.dart';
import 'package:endy/model/productFetch.dart';
import 'package:endy/utils/index.dart';
import 'package:endy/utils/responsivness/categoryCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:typesense/typesense.dart';



class GridBody extends StatefulWidget {
  final Client client;
  late final String? companyId;
  late final String? categoryId;
  late final String? subcategoryId;

  GridBody(
      {Key? key,
      required this.client,
      this.companyId,
      this.subcategoryId,
      this.categoryId})
      : super(key: key);

  @override
  State<GridBody> createState() => _GridBodyState();
}

class _GridBodyState extends State<GridBody> {
  final PagingController<int, Product> _pagingController =
      PagingController(firstPageKey: 1);
  StreamSubscription<ProductFetch>? _cancelableOperation;

  Stream<ProductFetch> fetch(
      {required int page,
      required FilterPageState filter,
      required PagingController<int, Product> pagingController}) {
    return CategoryFetchBloc.fetch(
            context: context,
            client: widget.client,
            categoryId: widget.categoryId,
            companyId: widget.companyId,
            filter: filter,
            subcategoryId: context.read<CategoryGridBloc>().state.selectedId,
            currentPage: page)
        .asStream();
  }

  void listener(pageKey) {
    _cancelableOperation = fetch(
            page: pageKey,
            filter: context.read<FilterPageBloc>().state,
            pagingController: _pagingController)
        .listen((productFetch) {
      if (!mounted) return;
      final isLastPage = productFetch.isLastPage;
      if (isLastPage) {
        _pagingController.appendLastPage(productFetch.products);
      } else {
        _pagingController.appendPage(productFetch.products, pageKey + 1);
      }
    });
  }

  @override
  void initState() {
    _pagingController.addPageRequestListener(listener);
    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    _cancelableOperation?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final gridCount = getCategoryCardCount(w);

    return Container(
      constraints: BoxConstraints(minHeight: size.height - 175),
      child: BlocBuilder<CategoryFetchBloc, CategoryFetchState>(
        builder: (cacheContext, cacheState) {
          // if (!cacheState.isSearching && cacheState.products.isEmpty)
          //   return const Center(
          //     child: Text(
          //       'Məhsul tapılmadı',
          //       style: TextStyle(
          //         fontSize: 20,
          //         fontWeight: FontWeight.bold,
          //       ),
          //     ),
          //   );
          return PagedGridView<int, Product>(
              pagingController: _pagingController,
              // physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: gridCount,
                  childAspectRatio: (200 / 350),
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15),
              builderDelegate: PagedChildBuilderDelegate(
                itemBuilder: (context, item, index) {
                  return DiscountCard(
                    product: item,
                  );
                },
                noItemsFoundIndicatorBuilder: (context) => const Center(
                  child: Text(
                    'Məhsul tapılmadı',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                firstPageProgressIndicatorBuilder: (_) => Center(
                    child: CircularProgressIndicator(color: Color(mainColor))),
                newPageProgressIndicatorBuilder: (_) => Center(
                    child: CircularProgressIndicator(color: Color(mainColor))),
              ));
        },
      ),
    );
  }
}
