import 'package:carousel_slider/carousel_slider.dart';
import 'package:endy/MainBloc/GlobalBloc.dart';
import 'package:endy/Pages/main/Home/DetailPage/Detail_Page_Bloc.dart';
import 'package:endy/Pages/main/Home/DetailPage/Parts/CompanyWeb.dart';
import 'package:endy/Pages/main/Home/DetailPage/Parts/FeaturesPart.dart';
import 'package:endy/Pages/main/Home/DetailPage/Parts/HyperlinkPart.dart';
import 'package:endy/Pages/main/Home/DetailPage/Parts/ImagePart.dart';
import 'package:endy/Pages/main/Home/DetailPage/Parts/MapButtonPart.dart';
import 'package:endy/Pages/main/Home/DetailPage/Parts/PricePart.dart';
import 'package:endy/Pages/main/Home/DetailPage/Parts/SimilarProductsPart.dart';
import 'package:endy/Pages/main/Home/DetailPage/Parts/TimePart.dart';
import 'package:endy/components/Footer.dart';
import 'package:endy/components/Navbar.dart';
import 'package:endy/types/product.dart';
import 'package:endy/utils/index.dart';
import 'package:endy/utils/responsivness/container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_portal/flutter_portal.dart';

class DetailPageWeb extends StatefulWidget {
  final Product? product;
  const DetailPageWeb({Key? key, this.product}) : super(key: key);

  @override
  State<DetailPageWeb> createState() => DetailState();
}

class DetailState extends State<DetailPageWeb> {
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
            return ListView(
              children: [
                const Navbar(),
                ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                      horizontal: getContainerSize(size.width), vertical: 75),
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                // smooth black border
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.black.withOpacity(0.15)),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ImagePart(
                                    buttonCarouselController:
                                        buttonCarouselController,
                                    size: size,
                                    images: images,
                                    product: product),
                              ),
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
                                            margin:
                                                const EdgeInsets.only(right: 5),
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
                                    child: Text(
                                        "${(state.current ?? 0) + 1}/${images.length}")),
                              ),
                              const SizedBox(height: 20),
                              Container(
                                  width: 200,
                                  child: HyperlinkWidget(
                                      product: product, horizontalPadding: 0)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: PortalTarget(
                            visible: true,
                            anchor: Aligned(
                                offset: Offset(
                                    size.width >= 1440
                                        ? getContainerSize(size.width) / 2
                                        : 0,
                                    115),
                                follower: Alignment.center,
                                target: Alignment.topRight),
                            portalFollower: CompanyWeb(product: product),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 40,
                                ),
                                ProductNameWidget(
                                    product: product,
                                    textAlign: TextAlign.left,
                                    fontSize: 28),
                                const SizedBox(height: 20),
                                Padding(
                                  padding: const EdgeInsets.only(right: 150),
                                  child:
                                      ProductPercentageWidget(product: product),
                                ),
                                const SizedBox(height: 20),
                                // ProductCompanyWidget(product: product),
                                const SizedBox(height: 20),
                                ProductTimerWidget(product: product),
                                const SizedBox(height: 20),
                                if (globalState.isMapDisabled == false &&
                                    product.availablePlaces.length > 0)
                                  ProductMapWidget(
                                      mounted: mounted, product: product),
                                const SizedBox(height: 20),
                                FeatuersWidget(product: product),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 50),
                    SimilarProducts(product: product),
                    const SizedBox(height: 20),
                  ],
                ),
                const Footer(),
              ],
            );
          },
        );
      },
    );
  }
}
