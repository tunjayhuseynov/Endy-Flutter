// ignore: must_be_immutable
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:endy/MainBloc/GlobalBloc.dart';
import 'package:endy/components/DiscountCard/DiscountCard.dart';
import 'package:endy/types/company.dart';
import 'package:endy/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ImagePart extends StatefulWidget {
  const ImagePart({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final DiscountCard widget;

  @override
  State<ImagePart> createState() => _ImagePartState();
}

class _ImagePartState extends State<ImagePart> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.antiAlias,
      fit: StackFit.loose,
      alignment: AlignmentDirectional.center,
      children: [
        Center(
          child: Container(
            height: 190,
            padding: const EdgeInsets.only(left: 20, right: 20, top: 40),
            child: CachedNetworkImage(
              imageUrl: widget.widget.product.primaryImage,
              placeholder: (context, url) => const Center(
                  child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Color(mainColor),
                      ))),
              width: 150,
            ),
          ),
        ),
        Positioned(
            left: 0,
            top: 0,
            width: 40,
            height: 40,
            child: CachedNetworkImage(
                imageUrl: (widget.widget.product.company as Company).logo,
                placeholder: (context, url) => const Center(
                    child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Color(mainColor),
                        ))))),
        Positioned(
            right: 0,
            top: 0,
            child: BlocBuilder<GlobalBloc, GlobalState>(
              builder: (context, state) {
                final isLiked = state.userData != null &&
                    state.userData!.liked.contains(FirebaseFirestore.instance
                        .collection('products')
                        .doc(widget.widget.product.id));
                return GestureDetector(
                  onTap: () => {
                    if (!isLiked)
                      {
                        context
                            .read<GlobalBloc>()
                            .addFavorite(widget.widget.product),
                      }
                    else
                      {
                        context
                            .read<GlobalBloc>()
                            .removeFavorite(widget.widget.product),
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
            )),
      ],
    );
  }
}
