import 'package:endy/MainBloc/GlobalBloc.dart';
import 'package:endy/components/DiscountCard/DiscountCard.dart';
import 'package:endy/streams/products.dart';
import 'package:endy/types/product.dart';
import 'package:endy/utils/index.dart';
import 'package:endy/utils/responsivness/searchCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoriteMain extends StatelessWidget {
  const FavoriteMain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return ScaffoldWrapper(
      backgroundColor: Colors.white,
      body: ListView(
        shrinkWrap: true,
        children: [
          const SizedBox(height: 25),
          Align(
            alignment: w < 1024 ? Alignment.centerLeft : Alignment.center,
            child: Padding(
              padding: EdgeInsets.only(left: w < 1024 ? 20.0 : 0),
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
                    if (snapshot.hasData &&
                        snapshot.data != null &&
                        snapshot.data!.isNotEmpty) {
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: getSearchCardCount(w),
                            childAspectRatio: (200 / 350),
                            mainAxisSpacing: 15,
                            crossAxisSpacing: 15),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) => DiscountCard(
                          product: snapshot.data![index],
                        ),
                      );
                    }
                    return const Text('Məlumat tapılmadı', textAlign: TextAlign.center,);
                  })),
          const SizedBox(height: 25),
        ],
      ),
    );
  }
}
