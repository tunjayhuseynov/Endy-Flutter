import 'dart:ui';

 
import 'package:cached_network_image/cached_network_image.dart';
import 'package:endy/components/Footer.dart';
import 'package:endy/components/Navbar.dart';
import 'package:endy/model/catalog.dart';
import 'package:endy/utils/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class CatalogSingleBody extends StatefulWidget {
  final Catalog catalog;

  CatalogSingleBody({super.key, required this.catalog});

  @override
  State<CatalogSingleBody> createState() => _CatalogSingleBodyState();
}

class _CatalogSingleBodyState extends State<CatalogSingleBody> {
  int currentPage = 0;
  late PageController _pageController;

  @override
  void initState() {
    var pixelRatio = window.devicePixelRatio;
    var logicalScreenSize = window.physicalSize / pixelRatio;
    var logicalWidth = logicalScreenSize.width;

    _pageController =
        PageController(viewportFraction: logicalWidth < 1024 ? 1 : 0.5);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    return Column(
      children: [
        if (w >= 1024) const Navbar(),
        Expanded(
          child: ScaffoldWrapper(
              backgroundColor: Colors.white,
              appBar: AppBar(
                leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      context.pop();
                    }),
                title: Text(
                  widget.catalog.name,
                  style: TextStyle(color: Colors.black),
                ),
                // leading: const CupertinoNavigationBarBackButton(),
                actions: [
                  Container(
                      margin: const EdgeInsets.only(right: 20),
                      child: Center(
                          child: Text(
                              "${currentPage + 1}/${widget.catalog.images.length} səhifə")))
                ],
              ),
              body: Container(
                constraints: BoxConstraints(minHeight: size.height - 75),
                child: Stack(
                  children: [
                    Container(
                      height: w < 1024 ? null : 700,
                      padding:
                          EdgeInsets.symmetric(horizontal: w < 1024 ? 0 : 80),
                      margin: EdgeInsets.only(top: w < 1024 ? 0 : 75),
                      child: SizedBox.expand(
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: PhotoViewGallery.builder(
                            loadingBuilder: (context, event) {
                              return Center(
                                child: Container(
                                  width: 25,
                                  height: 25,
                                  child: CircularProgressIndicator(
                                    color: Color(mainColor),
                                    value: event == null
                                        ? 0
                                        : event.cumulativeBytesLoaded /
                                            (event.expectedTotalBytes ?? 1),
                                  ),
                                ),
                              );
                            },
                            pageController: _pageController,
                            itemCount: widget.catalog.images.length,
                            builder: (context, index) {
                              return PhotoViewGalleryPageOptions(
                                  onTapUp: (c, p, v) async {
                                    if (kIsWeb) {
                                      await showDialog(
                                          context: context,
                                          builder: (_) => ImageDialog(
                                                image: widget
                                                    .catalog.images[index],
                                              ));
                                    }
                                  },
                                  imageProvider: CachedNetworkImageProvider(
                                      widget.catalog.images[index]),
                                  minScale:
                                      PhotoViewComputedScale.contained * 1,
                                  maxScale:
                                      PhotoViewComputedScale.contained * 4,
                                  // heroAttributes: PhotoViewHeroAttributes(
                                  //     tag: index.toString())
                                      );
                            },
                            scrollDirection: Axis.horizontal,
                            onPageChanged: ((index) {
                              setState(() {
                                currentPage = index;
                              });
                            }),
                            scrollPhysics: const BouncingScrollPhysics(),
                            backgroundDecoration: BoxDecoration(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (w >= 1024)
                      Positioned(
                          left: 0,
                          top: 350,
                          child: IconButton(
                              mouseCursor: SystemMouseCursors.click,
                              onPressed: () {
                                _pageController.previousPage(
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.linear);
                              },
                              icon: Icon(
                                CupertinoIcons.back,
                                color: Colors.black,
                              ))),
                    if (w >= 1024)
                      Positioned(
                          right: 0,
                          top: 350,
                          child: IconButton(
                              mouseCursor: SystemMouseCursors.click,
                              onPressed: () {
                                _pageController.nextPage(
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.linear);
                              },
                              icon: Icon(
                                CupertinoIcons.forward,
                                color: Colors.black,
                              )))
                  ],
                ),
              )),
        ),
        if (w >= 1024) const Footer(),
      ],
    );
  }
}

class ImageDialog extends StatelessWidget {
  final String image;
  ImageDialog({required this.image});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Dialog(
      backgroundColor: Colors.transparent,
      child: AspectRatio(
        aspectRatio: 2 / 3,
        child: Container(
          height: size.height * 0.9,
          // width: size.width * 0.5,
          decoration: BoxDecoration(
              color: Colors.transparent,
              image: DecorationImage(
                  image: CachedNetworkImageProvider(image),
                  fit: BoxFit.contain)),
        ),
      ),
    );
  }
}
