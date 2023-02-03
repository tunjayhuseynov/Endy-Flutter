import 'package:endy/Pages/main/Home/DetailPage/DetailPageWeb.dart';
import 'package:endy/Pages/main/Home/DetailPage/Detail_Page_Bloc.dart';
import 'package:endy/Pages/main/home/DetailPage/detailPage.dart';
import 'package:endy/streams/products.dart';
import 'package:endy/types/product.dart';
import 'package:endy/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailPageContainer extends StatefulWidget {
  final String id;
  const DetailPageContainer({Key? key, required this.id}) : super(key: key);

  @override
  State<DetailPageContainer> createState() => DetailPageContainerState();
}

class DetailPageContainerState extends State<DetailPageContainer> {
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return BlocProvider<DetailPageBloc>(
      create: (context) => DetailPageBloc()..increaseSeenTime(widget.id),
      child: Material(
        color: Colors.white,
        child: FutureBuilder<Product>(
            future: ProductsCrud.getProduct(widget.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Color(mainColor),
                  ),
                );
              }
              if (snapshot.hasData) {
                Product? product = snapshot.data;
                return w >= 1024
                    ? DetailPageWeb(
                        product: product,
                      )
                    : DetailPage(product: product);
              }

              return const Text("Məlumat yoxdur");
            }),
      ),
    );
  }
}
