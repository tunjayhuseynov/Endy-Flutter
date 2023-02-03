import 'package:auto_size_text/auto_size_text.dart';
import 'package:endy/MainBloc/GlobalBloc.dart';
import 'package:endy/Pages/main/Home/HomePage/MostViewed.dart';
import 'package:endy/components/DiscountCard/DiscountCard.dart';
import 'package:endy/Pages/main/Home/CategoryGrid/Category_Grid_Bloc.dart';
import 'package:endy/Pages/main/Home/FilterPage/Filter_Page_Bloc.dart';
import 'package:endy/Pages/main/Home/HomePage/Home_Page_Bloc.dart';
import 'package:endy/types/category.dart';
// import 'package:endy/main.dart';
import 'package:endy/types/product.dart';
import 'package:endy/utils/index.dart';
import 'package:endy/utils/responsivness/homeCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:typesense/typesense.dart';

class HomePageGridProducts extends StatefulWidget {
  HomePageGridProducts({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePageGridProducts> createState() => _HomePageGridProductsState();
}

class _HomePageGridProductsState extends State<HomePageGridProducts> {
  // final client = Client(typesenseConfig);
  List<Category> categories = [];

  @override
  void initState() {
    categories = [...context.read<GlobalBloc>().state.categories];
    context
        .read<HomePageCacheBloc>()
        .getMostViewedProducts(categories, FilterPageState.none);

    context
        .read<HomePageCacheBloc>()
        .getProducts(categories, FilterPageState.none, limit: 6);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    final gridCount = getHomeGridCardCount(w);
    categories.sort((a, b) => a.order.compareTo(b.order));
    return BlocBuilder<GlobalBloc, GlobalState>(
      builder: (globalContext, globalState) {
        return BlocConsumer<HomePageCacheBloc, HomePageCacheState>(
          listener: (context, state) {
            if (state.mainProductsConnectionStatus ==
                    ConnectionStatus.Loading &&
                state.mostViewedConnectionStatus == ConnectionStatus.Loading) {
              context
                  .read<HomePageCacheBloc>()
                  .getMostViewedProducts(categories, FilterPageState.none);

              context.read<HomePageCacheBloc>().getProducts(
                  categories, FilterPageState.none,
                  limit: gridCount);
            }
          },
          builder: (context, state) {
            bool isReady = state.mostViewedConnectionStatus ==
                    ConnectionStatus.Connected &&
                state.mainProductsConnectionStatus ==
                    ConnectionStatus.Connected;
            bool isLoading = state.mostViewedConnectionStatus ==
                    ConnectionStatus.Loading &&
                state.mainProductsConnectionStatus == ConnectionStatus.Loading;
            return Container(
                child: ListView(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              children: [
                if (isLoading)
                  const Center(
                      child: CircularProgressIndicator(
                    color: Color(mainColor),
                  )),
                if (isReady && globalState.isMostViewedDisabled == false)
                  MostViwed(snap: state.mostViewedProducts),
                if (isReady)
                  ProductListFourGrid(
                      gridCount: gridCount,
                      data: state.products
                          .where((e) => e.isNotEmpty)
                          .take(gridCount)
                          .toList()),
              ],
            ));
          },
        );
      },
    );
  }
}

class ProductListFourGrid extends StatelessWidget {
  const ProductListFourGrid({
    Key? key,
    required this.data,
    required this.gridCount,
  }) : super(key: key);

  final List<List<Product>> data;
  final int gridCount;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: w < 1024
                      ? MainAxisAlignment.spaceBetween
                      : MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      // width: MediaQuery.of(context).size.width * 0.4,
                      child: AutoSizeText(
                        data[index][0].category.name,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
                    InkWell(
                        mouseCursor: SystemMouseCursors.click,
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
                LayoutBuilder(builder: (context, c) {
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: gridCount,
                        childAspectRatio: (200 / 350),
                        mainAxisSpacing: 15,
                        crossAxisSpacing: 15),
                    itemCount: data[index].length,
                    itemBuilder: (context, i) => DiscountCard(
                      product: data[index][i],
                    ),
                  );
                })
              ],
            ),
          );
        });
  }
}
