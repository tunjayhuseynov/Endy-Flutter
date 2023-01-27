import 'package:endy/MainBloc/GlobalBloc.dart';
import 'package:endy/components/DiscountCard/DiscountCard.dart';
import 'package:endy/Pages/main/Home/SearchPage/Search_Page_Bloc.dart';
import 'package:endy/types/category.dart';
import 'package:endy/types/company.dart';
import 'package:endy/types/product.dart';
import 'package:endy/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:typesense/typesense.dart';

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
  // final client = Client(typesenseConfig);

  @override
  void dispose() {
    context.read<SearchPageBloc>().setClose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    context.read<SearchPageBloc>().getSearchResult(
        widget.category, widget.company, widget.subcategory, widget.client);
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final gridCount = w < 768 ? 2 :  w < 1124  ? 4 : w < 1526 ? 6 : 8;
    final gridRatio = w < 768 ? w * 0.66 / 450 : w < 1124 ? w * 0.33 / 460 :w < 1526 ? w * 0.33 / 670 : w * 0.33 / 890;
    return BlocConsumer<SearchPageBloc, SearchPageState>(
      listener: (context, state) {
        if (state.search.isNotEmpty && state.isSearching == true) {
          context.read<SearchPageBloc>().getSearchResult(widget.category,
              widget.company, widget.subcategory, widget.client);
        }
      },
      builder: (context, state) {
        if (state.isSearching) {
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
                physics: const ScrollPhysics(),
                padding:
                    const EdgeInsets.only(left: 10, right: 10, bottom: 20),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: gridCount,
                    childAspectRatio: gridRatio,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 15),
                itemCount: state.products.length,
                itemBuilder: (context, index) {
                  final data = state.products[index];
                  return DiscountCard(
                      product: Product(
                          availablePlaces: [],
                          category: context
                              .read<GlobalBloc>()
                              .state
                              .categories
                              .where((element) =>
                                  "categories/${element.id}" == data.category)
                              .first,
                          company: context
                              .read<GlobalBloc>()
                              .state
                              .companies
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
  }
}
