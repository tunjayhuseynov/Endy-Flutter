import 'package:auto_size_text/auto_size_text.dart';
import 'package:endy/MainBloc/GlobalBloc.dart';
import 'package:endy/Pages/main/Home/FilterPage/Filter_Page_Bloc.dart';
import 'package:endy/Pages/main/Home/HomePage/Home_Page_Bloc.dart';
import 'package:endy/Pages/main/Home/ProductList/Category_Grid_Bloc.dart';
import 'package:endy/components/DiscountCard/DiscountCard.dart';
import 'package:endy/components/Loader.dart';
import 'package:endy/route/router_names.dart';
import 'package:endy/types/category.dart';
import 'package:endy/types/product.dart';
import 'package:endy/utils/responsivness/homeCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ProductListFourGrid extends StatelessWidget {
  const ProductListFourGrid({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final gridCount = getHomeGridCardCount(w);

    var categories = context.read<GlobalBloc>().state.categories;
    categories.sort((a, b) => a.order.compareTo(b.order));

    return FutureBuilder<List<List<Product>>>(
        future: context
            .read<HomePageCacheBloc>()
            .getProducts(categories, FilterPageState.none),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }
          if (snapshot.hasData == false || snapshot.data?.length == 0)
            Center(
              child: Text("No data"),
            );
          return ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.only(
                  bottom: MediaQuery.maybeOf(context)?.padding.bottom ?? 80),
              physics: const ScrollPhysics(),
              itemCount: snapshot.data?.length,
              itemBuilder: (ctx, index) {
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 0),
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: w < 1024
                            ? MainAxisAlignment.spaceBetween
                            : MainAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            // width: MediaQuery.of(context).size.width * 0.4,
                            child: AutoSizeText(
                              snapshot.data?[index][0].category.name,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                          ),
                          InkWell(
                              mouseCursor: SystemMouseCursors.click,
                              onTap: () async {
                                context.read<CategoryGridBloc>().set(
                                    prevPath: "",
                                    category: snapshot.data?[index][0].category,
                                    subcategory: null,
                                    id: "");
                                await context.pushNamed(
                                    APP_PAGE.CATEGORY_PRODUCTS_LIST.toName,
                                    pathParameters: {
                                      "id": (snapshot.data?[index][0].category
                                              as Category)
                                          .id
                                    });
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  children: const [
                                    Text("Hamısına baxın",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12)),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 18,
                                    )
                                  ],
                                ),
                              ))
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: gridCount,
                            childAspectRatio: (200 / 350),
                            mainAxisSpacing: 15,
                            crossAxisSpacing: 15),
                        itemCount: snapshot.data![index]
                            .take(w < 768 ? gridCount * 2 : gridCount)
                            .length,
                        itemBuilder: (context, i) => DiscountCard(
                          product: snapshot.data![index]
                              .take(w < 768 ? gridCount * 2 : gridCount)
                              .elementAt(i),
                        ),
                      )
                    ],
                  ),
                );
              });
        });
  }
}
