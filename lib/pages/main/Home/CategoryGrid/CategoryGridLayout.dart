import 'package:endy/components/DiscountCard/DiscountCard.dart';
import 'package:endy/pages/main/Home/CategoryGrid/Category_Grid_Bloc.dart';
import 'package:endy/pages/main/Home/CategoryGrid/Category_Grid_Cache_Bar_Bloc.dart';
import 'package:endy/pages/main/Home/FilterPage/Filter_Page_Bloc.dart';
import 'package:endy/streams/products.dart';
import 'package:endy/types/product.dart';
import 'package:endy/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryGridLayout extends StatelessWidget {
  const CategoryGridLayout({Key? key, this.text}) : super(key: key);

  final String? text;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryGridBloc, CategoryGridState>(
      builder: (context, state) {
        return BlocBuilder<CategoryGridCacheBloc, CategoryGridCacheAndBarState>(
          buildWhen: (previous, current) =>
              previous.searchWidth == current.searchWidth,
          builder: (cacheContext, cacheState) {
            return BlocBuilder<FilterPageBloc, FilterPageState>(
              builder: (filterContext, filterState) {
                return FutureBuilder<List<Product>>(
                    future: cacheContext
                        .read<CategoryGridCacheBloc>()
                        .getProducts(state.category, state.subcategory,
                            filterState, state.company, text),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child: CircularProgressIndicator(
                          color: Color(mainColor),
                        ));
                      }
                      if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                        return Column(
                          children: [
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const ScrollPhysics(),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: (250 / 430),
                                      mainAxisSpacing: 15,
                                      crossAxisSpacing: 15),
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) => DiscountCard(
                                product: snapshot.data![index],
                              ),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                          ],
                        );
                      }
                      return const Text('Məlumat tapılmadı');
                    });
              },
            );
          },
        );
      },
    );
  }
}
