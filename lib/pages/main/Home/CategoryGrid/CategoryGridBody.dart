import 'package:endy/Pages/main/Home/CategoryGrid/Category_Fetch_Bloc.dart';
import 'package:endy/components/DiscountCard/DiscountCard.dart';
import 'package:endy/Pages/main/Home/CategoryGrid/Category_Grid_Bloc.dart';
import 'package:endy/utils/index.dart';
import 'package:endy/utils/responsivness/categoryCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:typesense/typesense.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../FilterPage/Filter_Page_Bloc.dart';

class CategoryGridBody extends StatefulWidget {
  final Client client;
  late final String? companyId;
  late final String? categoryId;
  late final String? subcategoryId;

  CategoryGridBody({
    Key? key,
    required this.client,
    this.categoryId,
    this.companyId,
    this.subcategoryId,
  }) : super(key: key);

  @override
  State<CategoryGridBody> createState() => _CategoryGridBodyState();
}

class _CategoryGridBodyState extends State<CategoryGridBody> {
  fetch() {
    CategoryFetchBloc.fetch(context, widget.client, widget.categoryId,
        widget.companyId, widget.subcategoryId,
        resetProduct: true);
  }

  @override
  void initState() {
    fetch();
    super.initState();
  }

  void onVisible(VisibilityInfo info) {
    if (info.visibleFraction > 0.5) {
      CategoryFetchBloc.fetch(context, widget.client, widget.categoryId,
          widget.companyId, widget.subcategoryId);
    }
  }

  @override
  void dispose() {
    // var ctx = context.read<CategoryFetchBloc>();
    // if (ctx.state.cancellableOperation != null &&
    //     ctx.state.cancellableOperation!.isCompleted == false &&
    //     ctx.state.cancellableOperation!.isCanceled == false) {
    //   ctx.state.cancellableOperation!.cancel();
    // }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final gridCount = getCategoryCardCount(w);

    return BlocListener<FilterPageBloc, FilterPageState>(
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
              return ListView(
                shrinkWrap: true,
                children: [
                  GridView.builder(
                    shrinkWrap: true,
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
                          onVisibilityChanged: onVisible,
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
                  if (cacheState.isSearching && cacheState.products.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: const Center(
                          child: CircularProgressIndicator(
                        color: Color(mainColor),
                      )),
                    ),
                  if (!cacheState.isSearching && cacheState.products.isEmpty)
                    const Center(
                      child: Text(
                        'Məhsul tapılmadı',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
