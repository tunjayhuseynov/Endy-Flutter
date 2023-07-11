import 'package:endy/Pages/main/Home/FilterPage/Filter_Page_Bloc.dart';
import 'package:endy/Pages/main/Home/ProductList/Category_Fetch_Bloc.dart';
import 'package:endy/components/DiscountCard/DiscountCard.dart';
import 'package:endy/Pages/main/Home/ProductList/Category_Grid_Bloc.dart';
import 'package:endy/utils/index.dart';
import 'package:endy/utils/responsivness/categoryCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:typesense/typesense.dart';
import 'package:visibility_detector/visibility_detector.dart';

class GridBody extends StatefulWidget {
  final Client client;
  late final String? companyId;
  late final String? categoryId;
  late final String? subcategoryId;

  GridBody({
    Key? key,
    required this.client,
    this.companyId,
    this.subcategoryId,
    this.categoryId
  }) : super(key: key);

  @override
  State<GridBody> createState() => _GridBodyState();
}

class _GridBodyState extends State<GridBody> {
  Future<void> fetch() async {
    CategoryFetchBloc.fetch(
        context: context,
        client: widget.client,
        categoryId: widget.categoryId,
        companyId: widget.companyId,
        subcategoryId: widget.subcategoryId,
        resetProduct: true);
  }

  @override
  void initState() {
    fetch();
    super.initState();
  }

  void onVisible(VisibilityInfo info, String subcategoryId) {
    if (info.visibleFraction > 0.5) {
      CategoryFetchBloc.fetch(
          context: context,
          client: widget.client,
          categoryId: widget.categoryId,
          companyId: widget.companyId,
          subcategoryId: subcategoryId);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final gridCount = getCategoryCardCount(w);

    return Container(
      constraints: BoxConstraints(minHeight: size.height - 175),
      child: BlocListener<FilterPageBloc, FilterPageState>(
        listener: (context, state) {
          fetch();
        },
        listenWhen: (previous, current) => previous != current,
        child: BlocBuilder<CategoryGridBloc, CategoryGridState>(
          builder: (context, state) {
            return BlocBuilder<CategoryFetchBloc, CategoryFetchState>(
              builder: (cacheContext, cacheState) {
                if (cacheState.isSearching && cacheState.products.isEmpty) {
                  return const Center(
                      child: CircularProgressIndicator(
                    color: Color(mainColor),
                  ));
                }
                if (!cacheState.isSearching && cacheState.products.isEmpty)
                  return const Center(
                    child: Text(
                      'Məhsul tapılmadı',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                return Column(
                  children: [
                    GridView.builder(
                      shrinkWrap: true,
                      primary: true,
                      physics: ScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: gridCount,
                          childAspectRatio: (200 / 350),
                          mainAxisSpacing: 15,
                          crossAxisSpacing: 15),
                      itemCount: cacheState.products.length,
                      itemBuilder: (context, index) {
                        if (index == cacheState.products.length - 1)
                          return VisibilityDetector(
                            onVisibilityChanged: (info) =>
                                onVisible(info, state.selectedId),
                            key: Key('item $index'),
                            child: DiscountCard(
                              product: cacheState.products[index],
                            ),
                          );

                        return DiscountCard(
                          product: cacheState.products[index],
                        );
                      },
                    ),
                    if (cacheState.isSearching &&
                        cacheState.isLastPage == false &&
                        cacheState.products.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: const Center(
                            child: CircularProgressIndicator(
                          color: Color(mainColor),
                        )),
                      ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
