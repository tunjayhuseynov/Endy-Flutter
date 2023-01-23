import 'package:cached_network_image/cached_network_image.dart';
import 'package:endy/types/catalog.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        body: LayoutBuilder(builder: (context, constraints) {
          return SizedBox.expand(
            child: PhotoViewGallery.builder(
              itemCount: widget.catalog.images.length,
              builder: (context, index) {
                return PhotoViewGalleryPageOptions(
                  imageProvider:
                      CachedNetworkImageProvider(widget.catalog.images[index]),
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
                color: Theme.of(context).canvasColor,
              ),
            ),
          );
        }));
  }
}