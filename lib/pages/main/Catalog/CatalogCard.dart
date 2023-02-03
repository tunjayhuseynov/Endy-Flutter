import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:endy/types/catalog.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class CatalogCard extends StatefulWidget {
  final Catalog catalog;
  const CatalogCard({super.key, required this.catalog});

  @override
  State<CatalogCard> createState() => _CatalogCardState();
}

class _CatalogCardState extends State<CatalogCard> {
  @override
  void initState() {
    initializeDateFormatting("az", null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, "/catalog/single",
              arguments: this.widget.catalog);
        },
        child: LayoutBuilder(
          builder: (ctx, con) {
            return Column(
              children: [
                SizedBox(
                    width: con.maxWidth,
                    height: con.maxHeight * 0.85,
                    child: CachedNetworkImage(
                      fit: BoxFit.fitWidth,
                      alignment: Alignment.topCenter,
                      imageUrl: this.widget.catalog.logo,
                      // height: 100,
                      // width: 100,
                    )),
                SizedBox(
                  height: con.maxHeight * 0.15,
                  child: Column(
                    mainAxisAlignment: this.widget.catalog.name.isEmpty
                        ? MainAxisAlignment.center
                        : MainAxisAlignment.end,
                    children: [
                      if (this.widget.catalog.name.isNotEmpty)
                        AutoSizeText(
                          this.widget.catalog.name,
                          maxLines: 1,
                          maxFontSize: 14,
                          minFontSize: 10,
                          style: TextStyle(
                              fontWeight: FontWeight.w600),
                        ),
                      Text(
                          "${DateFormat("dd MMMM", "az").format(DateTime.fromMillisecondsSinceEpoch((this.widget.catalog.startDate * 1e3).toInt()))} - ${DateFormat("dd MMMM", "az").format(DateTime.fromMillisecondsSinceEpoch((this.widget.catalog.endDate * 1e3).toInt()))}",
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 12)),
                    ],
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
