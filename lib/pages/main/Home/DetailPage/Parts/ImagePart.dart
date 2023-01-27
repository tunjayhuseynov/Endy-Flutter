import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:endy/MainBloc/GlobalBloc.dart';
import 'package:endy/Pages/main/Home/DetailPage/Detail_Page_Bloc.dart';
import 'package:endy/types/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ImagePart extends StatelessWidget {
  const ImagePart({
    Key? key,
    required this.buttonCarouselController,
    required this.size,
    required this.images,
    required this.product,
  }) : super(key: key);

  final CarouselController buttonCarouselController;
  final Size size;
  final List<String> images;
  final Product? product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 45.0),
            child: CarouselSlider(
              carouselController: buttonCarouselController,
              options: CarouselOptions(
                  onPageChanged: (index, reason) {
                    context.read<DetailPageBloc>().changeCurrent(index);
                  },
                  viewportFraction: 1,
                  height: size.height * 0.4),
              items: images.map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return AspectRatio(
                      aspectRatio: 1 / 1,
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: CachedNetworkImage(
                            imageUrl: i,
                            fit: BoxFit.contain,
                          )),
                    );
                  },
                );
              }).toList(),
            ),
          ),
          Positioned(
            top: 0,
            left: 10,
            child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios)),
          ),
          Positioned(
              right: 25,
              top: 7.5,
              child: SizedBox(
                width: 35,
                height: 35,
                child: BlocBuilder<GlobalBloc, GlobalState>(
                  builder: (context, state) {
                    final isLiked = state.userData != null &&
                        state.userData!.liked.contains(FirebaseFirestore
                            .instance
                            .collection('products')
                            .doc(product!.id));
                    return GestureDetector(
                      onTap: () => {
                        if (state.userData == null)
                          {Navigator.pushNamed(context, '/needregister', arguments: true)}
                        else
                          {
                            if (!isLiked)
                              {context.read<GlobalBloc>().addFavorite(product!)}
                            else
                              {
                                context
                                    .read<GlobalBloc>()
                                    .removeFavorite(product!)
                              }
                          }
                      },
                      child: Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              // box shadow
                              boxShadow: [
                                BoxShadow(
                                  offset: const Offset(1, 2),
                                  blurRadius: 5,
                                  spreadRadius: 1,
                                  color: Colors.black.withOpacity(0.2),
                                ),
                              ],
                              borderRadius: BorderRadius.circular(50)),
                          child: isLiked
                              ? const Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                  size: 25,
                                )
                              : const Icon(
                                  Icons.favorite_border,
                                  size: 25,
                                )),
                    );
                  },
                ),
              ))
        ],
      ),
    );
  }
}
