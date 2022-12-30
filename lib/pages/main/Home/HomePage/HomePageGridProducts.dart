import 'package:auto_size_text/auto_size_text.dart';
import 'package:endy/MainBloc/GlobalBloc.dart';
import 'package:endy/components/DiscountCard/DiscountCard.dart';
import 'package:endy/Pages/main/Home/CategoryGrid/Category_Grid_Bloc.dart';
import 'package:endy/Pages/main/Home/FilterPage/Filter_Page_Bloc.dart';
import 'package:endy/Pages/main/Home/HomePage/Home_Page_Bloc.dart';
import 'package:endy/types/product.dart';
import 'package:endy/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePageGridProducts extends StatelessWidget {
  const HomePageGridProducts({
    Key? key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final categories = context.read<GlobalBloc>().state.categories;

    categories.sort((a, b) => a.order.compareTo(b.order));
    return BlocBuilder<HomePageCacheBloc, HomePageCacheState>(
      builder: (context, state) {
        return Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: ListView(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              children: [
                FutureBuilder<List<Product>>(
                    future: context
                        .read<HomePageCacheBloc>()
                        .getMostViewedProducts(
                            categories, FilterPageState.none),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container();
                      } else if (snapshot.connectionState ==
                              ConnectionState.done &&
                          snapshot.data != null) {
                        return MostViwed(snap: snapshot);
                      } else if (snapshot.connectionState ==
                              ConnectionState.done &&
                          snapshot.data == null) {
                        return Container();
                      }
                      return const Center(
                        child: Text("Yüklənir..."),
                      );
                    }),
                FutureBuilder<List<List<Product>>>(
                    future: context
                        .read<HomePageCacheBloc>()
                        .getProducts(categories, FilterPageState.none),
                    // Future.wait(categories.map((e) =>
                    //     ProductsCrud.getProducts(
                    //         null, 4, e, null, filter.mode, null))),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child: CircularProgressIndicator(
                          color: Color(mainColor),
                        ));
                      }

                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.hasData) {
                        final data = snapshot.data!
                            .where((element) => element.isNotEmpty)
                            .toList();

                        return ProductListFourGrid(data: data);
                      } else if (snapshot.connectionState ==
                              ConnectionState.done &&
                          !snapshot.hasData) {
                        return const Center(
                          child: Text("Məhsul Yoxdur"),
                        );
                      }

                      return const Center(
                          child: CircularProgressIndicator(
                        color: Color(mainColor),
                      ));
                    }),
              ],
            ));
      },
    );
  }
}

class ProductListFourGrid extends StatelessWidget {
  const ProductListFourGrid({
    Key? key,
    required this.data,
  }) : super(key: key);

  final List<List<Product>> data;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        itemCount: data.length,
        itemBuilder: (ctx, index) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            margin: const EdgeInsets.only(bottom: 20),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: AutoSizeText(
                        data[index][0].category.name,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
                    GestureDetector(
                        onTap: () async {
                          // Navigator.pushNamed(context, "home/category",
                          //     arguments: productList[index].keys.first);
                          context
                              .read<CategoryGridBloc>()
                              .set(category: data[index][0].category);
                          await Navigator.pushNamed(context, '/home/main/all');
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: const [
                              Text("Hamısına baxın",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12)),
                              Icon(Icons.arrow_forward_ios, size: 25)
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: (250 / 430),
                      mainAxisSpacing: 15,
                      crossAxisSpacing: 15),
                  itemCount: data[index].length,
                  itemBuilder: (context, i) => DiscountCard(
                    product: data[index][i],
                  ),
                ),
              ],
            ),
          );
        });
  }
}

class MostViwed extends StatelessWidget {
  final AsyncSnapshot<List<Product>> snap;
  const MostViwed({
    Key? key,
    required this.snap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.white,
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              AutoSizeText(
                "Ən çox baxılanlar",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 320,
            child: ListView(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              children: snap.data!
                  .map((e) => Container(
                        width: 200,
                        // height: 290,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 10),
                        child: DiscountCard(
                          product: e,
                        ),
                      ))
                  .toList(),
            ),
          )
        ],
      ),
    );
  }
}
