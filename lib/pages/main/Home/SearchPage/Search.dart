import 'package:algolia/algolia.dart';
import 'package:endy/MainBloc/GlobalBloc.dart';
import 'package:endy/components/DiscountCard/DiscountCard.dart';
import 'package:endy/Pages/main/Home/SearchPage/Search_Page_Bloc.dart';
import 'package:endy/types/product.dart';
import 'package:endy/types/search.dart';
import 'package:endy/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SearchPage extends StatelessWidget {
  final Algolia _algoliaClient = Algolia.init(
      applicationId: "N7B70FFDHT",
      apiKey: dotenv.env['ALGOLIA_API_KEY'] as String);

  SearchPage({super.key});

  Future<List<SearchHit>> _getSearchResult(
      BuildContext context, SearchPageState state) async {
    if (state.search == '') return [];

    try {
      AlgoliaQuery algoliaQuery =
          _algoliaClient.instance.index("endirim_sebeti").query(state.search);
      if (state.category != null) {
        algoliaQuery = algoliaQuery
            .facetFilter('category:categories/${state.category?.id}');
      }
      if (state.company != null) {
        algoliaQuery =
            algoliaQuery.facetFilter('company:companies/${state.company?.id}');
      }
      if (state.subcategory != null) {
        algoliaQuery = algoliaQuery
            .facetFilter('subcategory:subcategories/${state.subcategory?.id}');
      }
      AlgoliaQuerySnapshot snapshot = await algoliaQuery.getObjects();
      if (snapshot.empty) {
        return [];
      }
      final rawHits = snapshot.toMap()['hits'] as List;
      final hits =
          List<SearchHit>.from(rawHits.map((hit) => SearchHit.fromJson(hit)));
      return hits;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchPageBloc, SearchPageState>(
      builder: (context, state) {
        return FutureBuilder<List<SearchHit>>(
            future: _getSearchResult(context, state),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: Color(mainColor),
                ));
              }
              if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                return ListView(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  children: [
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: (250 / 400),
                              mainAxisSpacing: 15,
                              crossAxisSpacing: 15),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final data = snapshot.data![index];
                        return DiscountCard(
                            product: Product(
                                availablePlaces: [],
                                category: context
                                    .read<GlobalBloc>()
                                    .state
                                    .categories
                                    .where((element) =>
                                        "categories/${element.id}" ==
                                        data.category)
                                    .first,
                                company: context
                                    .read<GlobalBloc>()
                                    .state
                                    .companies
                                    .where((element) =>
                                        "companies/${element.id}" ==
                                        data.company)
                                    .first,
                                createdAt: data.created_at,
                                deadline: data.deadline,
                                isPrime: false,
                                discount: (data.discount as num).toDouble(),
                                discountedPrice:
                                    (data.discountedPrice as num).toDouble(),
                                id: data.objectID,
                                images: [],
                                primaryImage: data.primaryImage,
                                name: data.name,
                                price: (data.price as num).toDouble(),
                                subcategory: null,
                                link: null));
                      },
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
  }
}
