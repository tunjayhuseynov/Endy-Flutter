import 'package:endy/MainBloc/GlobalBloc.dart';
import 'package:endy/components/DiscountCard/DiscountCard.dart';
import 'package:endy/streams/products.dart';
import 'package:endy/types/product.dart';
import 'package:endy/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoriteMain extends StatelessWidget {
  const FavoriteMain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          const SizedBox(height: 25),
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: Text(
                "Seçilmişlər",
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
            ),
          ),
          const SizedBox(height: 25),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: FutureBuilder<List<Product>>(
                  future: ProductsCrud.getSpecificProducts(
                      (context.read<GlobalBloc>().state.userData?.liked ?? [])
                          .map((e) => e.id)
                          .toList()),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                          child: CircularProgressIndicator(
                        color: Color(mainColor),
                      ));
                    }
                    if (snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty) {
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
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
                      );
                    }
                    return const Text('Məlumat tapılmadı');
                  })),
          const SizedBox(height: 25),
        ],
      ),
    );
  }
}
