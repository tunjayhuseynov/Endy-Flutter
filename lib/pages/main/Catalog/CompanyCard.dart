import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:endy/types/company.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

class CompanyCard extends StatefulWidget {
  final Company? company;
  const CompanyCard({super.key, this.company});

  @override
  State<CompanyCard> createState() => _CompanyCardState();
}

class _CompanyCardState extends State<CompanyCard> {
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
          context.router
              .pushNamed("/catalog/detail/" + (this.widget.company?.id ?? ""));
        },
        child: Card(
          color: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 5,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: CachedNetworkImage(
              imageUrl: this.widget.company?.logo ?? "",
              height: 100,
              width: 150,
            ),
          ),
        ),
      ),
    );
  }
}
