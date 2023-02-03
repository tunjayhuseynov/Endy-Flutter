import 'package:endy/Pages/main/Home/CategoryGrid/Category_Cache_Bloc.dart';
import 'package:endy/Pages/main/Home/FilterPage/Filter_Page_Bloc.dart';
import 'package:endy/components/DiscountCard/DiscountCard.dart';
import 'package:endy/Pages/main/Home/CategoryGrid/Category_Grid_Bloc.dart';
import 'package:endy/utils/index.dart';
import 'package:endy/utils/responsivness/categoryCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:typesense/typesense.dart';
import 'package:async/async.dart';

class CategoryGridLayout extends StatefulWidget {
  final Client client;

  const CategoryGridLayout({Key? key, required this.client}) : super(key: key);

  @override
  State<CategoryGridLayout> createState() => _CategoryGridLayoutState();
}

class _CategoryGridLayoutState extends State<CategoryGridLayout> {
  @override
  void initState() {
    super.initState();
    var ctx = context.read<CategoryCacheBloc>();
    var state = context.read<CategoryGridBloc>().state;
    var filterState = context.read<FilterPageBloc>().state;
    var c = CancelableOperation.fromFuture(context
        .read<CategoryCacheBloc>()
        .getResult(
            state.category, state.company, state.subcategory, widget.client,
            mode: filterState));
    ctx.setCancelableoperation(c);
    c.value.then((value) {
      if (value != null) {
        ctx.setState(value);
      }
    });
  }

  @override
  void dispose() {
    var ctx = context.read<CategoryCacheBloc>();
    if (ctx.state.cancellableOperation != null)
      ctx.state.cancellableOperation!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final gridCount = getCategoryCardCount(w);
 
    return BlocBuilder<CategoryGridBloc, CategoryGridState>(
      builder: (context, state) {
        return BlocBuilder<CategoryCacheBloc, CategoryCacheState>(
          builder: (cacheContext, cacheState) {
            if (cacheState.isSearching && cacheState.products.isEmpty) {
              return const Center(
                  child: CircularProgressIndicator(
                color: Color(mainColor),
              ));
            }
            return LayoutBuilder(builder: (context, constraints) {
              return Column(
                children: [
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: gridCount,
                        childAspectRatio: (200 / 350),
                        mainAxisSpacing: 15,
                        crossAxisSpacing: 15),
                    itemCount: cacheState.products.length,
                    itemBuilder: (context, index) => DiscountCard(
                      product: cacheState.products[index],
                    ),
                  ),
                  if (!cacheState.isLastPage && cacheState.products.isNotEmpty)
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
            });
          },
        );
      },
    );
  }
}
