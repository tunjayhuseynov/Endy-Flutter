import 'package:endy/components/DiscountCard/DiscountCard.dart';
import 'package:endy/main.dart';
import 'package:endy/streams/products.dart';
import 'package:endy/types/product.dart';
import 'package:endy/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:typesense/typesense.dart';

class SimilarProducts extends StatefulWidget {
  const SimilarProducts({super.key, required this.product});
  final Product product;

  @override
  State<SimilarProducts> createState() => _SimilarProductsState();
}

class _SimilarProductsState extends State<SimilarProducts> {
  Client client = Client(typesenseConfig);

  Future<List<Product>> getProducts() async {
    var list = await ProductsCrud.getProductsFromTypesense(client, "", 1, 5,
        categoryId: widget.product.category.id);

    List<Product> hits = await Future.wait(list['hits'].map<Future<Product>>(
        (e) => ProductsCrud.renderProduct(e["document"])));
    return hits.where((element) => element.id != widget.product.id).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Text("Bənzər məhsullar", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          height: 300,
          child: FutureBuilder<List<Product>>(
              future: getProducts(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    height: 350,
                    child: ListView(
                      // controller: _scrollController,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      children: snapshot.data!
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
                  );
                } else if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    child: Center(
                      child: CircularProgressIndicator(color: Color(mainColor)),
                    ),
                  );
                } else {
                  return Container(
                    child: Text("Bənzər məhsul tapılmadı"),
                  );
                }
              }),
        ),
      ],
    );
  }
}
