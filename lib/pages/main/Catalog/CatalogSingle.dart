import 'package:auto_route/auto_route.dart';
import 'package:endy/Pages/main/Catalog/CatalogSingleBody.dart';
import 'package:endy/streams/catalogs.dart';
import 'package:endy/types/catalog.dart';
import 'package:endy/utils/index.dart';
import 'package:flutter/material.dart';

class CatalogSingleRoute extends StatefulWidget {
  final String? id;

  CatalogSingleRoute({super.key, @pathParam this.id});

  @override
  State<CatalogSingleRoute> createState() => _CatalogSingleRouteState();
}

class _CatalogSingleRouteState extends State<CatalogSingleRoute> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Catalog?>(
        future: CatalogsCrud.getCatalog(widget.id ?? ""),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            if (snapshot.data == null)
              return ScaffoldWrapper(
                appBar: AppBar(
                  title: Text("Kataloq tapılmadı"),
                ),
                body: Center(
                  child: Text("Kataloq tapılmadı"),
                ),
              );
            return CatalogSingleBody(catalog: snapshot.data!);
          }
          return ScaffoldWrapper(
            body: Center(
              child: CircularProgressIndicator(color: Color(mainColor)),
            ),
          );
        });
  }
}
