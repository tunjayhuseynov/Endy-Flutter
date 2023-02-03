import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:endy/types/catalog.dart';
import 'package:endy/utils/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class CatalogSingle extends StatefulWidget {
  final Catalog catalog;

  CatalogSingle({super.key, required this.catalog});

  @override
  State<CatalogSingle> createState() => _CatalogSingleState();
}

class _CatalogSingleState extends State<CatalogSingle> {
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
    final w = MediaQuery.of(context).size.width;
    return ScaffoldWrapper(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(widget.catalog.name),
          actions: [
            Container(
                margin: const EdgeInsets.only(right: 20),
                child: Center(
                    child: Text(
                        "${currentPage + 1}/${widget.catalog.images.length} səhifə")))
          ],
        ),
        body: Stack(
          children: [
            Container(
              height: w < 1024 ? null : 700,
              padding: EdgeInsets.symmetric(horizontal: w < 1024 ? 0 : 80),
              child: SizedBox.expand(
                child: MouseRegion(
                  cursor: SystemMouseCursors.zoomIn,
                  child: PhotoViewGallery.builder(
                    pageController: _pageController,
                    itemCount: widget.catalog.images.length,
                    builder: (context, index) {
                      return PhotoViewGalleryPageOptions(
                        imageProvider: CachedNetworkImageProvider(
                            widget.catalog.images[index]),
                        minScale: PhotoViewComputedScale.contained * 1,
                        maxScale: PhotoViewComputedScale.contained * 4,
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
        ));
  }
}
