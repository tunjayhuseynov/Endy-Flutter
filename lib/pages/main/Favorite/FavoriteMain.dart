import 'package:endy/MainBloc/GlobalBloc.dart';
import 'package:endy/components/DiscountCard/DiscountCard.dart';
import 'package:endy/components/Footer.dart';
import 'package:endy/components/Navbar.dart';
import 'package:endy/model/product.dart';
import 'package:endy/streams/products.dart';
import 'package:endy/utils/index.dart';
import 'package:endy/utils/responsivness/container.dart';
import 'package:endy/utils/responsivness/searchCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoriteMainRoute extends StatelessWidget {
  const FavoriteMainRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Body();
  }
}

class Body extends StatelessWidget {
  const Body({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          shrinkWrap: true,
          children: [
            if (w >= 1024) const Navbar(),
            const SizedBox(height: 30),
            Align(
              alignment: w < 1024 ? Alignment.centerLeft : Alignment.center,
              child: Padding(
                padding: EdgeInsets.only(left: getContainerSize(w)),
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
                constraints: BoxConstraints(minHeight: size.height - 175),
                padding: EdgeInsets.symmetric(horizontal: getContainerSize(w)),
                child: FutureBuilder<List<Product>>(
                    future: ProductsCrud.getSpecificProducts(
                        (context.read<GlobalBloc>().state.userData?.liked ?? [])
                            .map((e) => e is String ? e : e.id)
                            .toList()
                            .cast<String>()),
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
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: getSearchCardCount(w),
                                  childAspectRatio: (200 / 350),
                                  mainAxisSpacing: 15,
                                  crossAxisSpacing: 15),
                          itemCount: snapshot.data?.length ?? 0,
                          itemBuilder: (context, index) => DiscountCard(
                            product: snapshot.data![index],
                          ),
                        );
                      }
                      return const Text(
                        'Məlumat tapılmadı',
                        textAlign: TextAlign.center,
                      );
                    })),
            const SizedBox(height: 25),
            if (w >= 1024) const Footer(),
          ],
        ),
      ),
    );
  }
}
