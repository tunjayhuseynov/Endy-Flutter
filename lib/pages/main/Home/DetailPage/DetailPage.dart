import 'package:carousel_slider/carousel_slider.dart';
import 'package:endy/MainBloc/GlobalBloc.dart';
import 'package:endy/Pages/main/Home/DetailPage/Detail_Page_Bloc.dart';
import 'package:endy/Pages/main/Home/DetailPage/Parts/FeaturesPart.dart';
import 'package:endy/Pages/main/Home/DetailPage/Parts/HyperlinkPart.dart';
import 'package:endy/Pages/main/Home/DetailPage/Parts/ImagePart.dart';
import 'package:endy/Pages/main/Home/DetailPage/Parts/MapButtonPart.dart';
import 'package:endy/Pages/main/Home/DetailPage/Parts/PricePart.dart';
import 'package:endy/Pages/main/Home/DetailPage/Parts/TimePart.dart';
import 'package:endy/model/product.dart';
import 'package:endy/utils/index.dart';
import 'package:endy/utils/responsivness/container.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailPage extends StatefulWidget {
  final Product? product;
  const DetailPage({Key? key, this.product}) : super(key: key);

  @override
  State<DetailPage> createState() => DetailState();
}

class DetailState extends State<DetailPage> {
  CarouselController buttonCarouselController = CarouselController();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    Product? product = widget.product;

    if (product == null) return const Text("Məlumat yoxdur");
    List<String> images = [product.primaryImage, ...product.images];

    return BlocBuilder<GlobalBloc, GlobalState>(
      builder: (globalContext, globalState) {
        return BlocBuilder<DetailPageBloc, DetailPageState>(
          builder: (context, state) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: getContainerSize(size.width)),
              child: ListView(
                shrinkWrap: true,
                physics: size.width >= 1024 ? const NeverScrollableScrollPhysics() : const ScrollPhysics(),
                children: [
                  ImagePart(
                      buttonCarouselController: buttonCarouselController,
                      size: size,
                      images: images,
                      product: product),
                  Container(
                    margin: const EdgeInsets.only(top: 15),
                    height: 13,
                    width: size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: images
                          .asMap()
                          .entries
                          .map((e) => Container(
                                margin: const EdgeInsets.only(right: 5),
                                width: 13,
                                height: 13,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: state.current == e.key
                                        ? const Color(mainColor)
                                        : Colors.grey[300]),
                              ))
                          .toList(),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    height: 15,
                    width: size.width,
                    child: Center(
                        child:
                            Text("${(state.current ?? 0) + 1}/${images.length}")),
                  ),
                  const SizedBox(height: 10),
                  PricePart(product: product),
                  TimePart(product: product),
                  if (globalState.isMapDisabled == false &&
                      product.availablePlaces.length > 0 && !kIsWeb)
                    MapWidget(mounted: mounted, product: product),
                  const SizedBox(height: 20),
                  FeatuersWidget(product: product),
                  const SizedBox(height: 20),
                  HyperlinkWidget(product: product),
                  const SizedBox(height: 30),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
