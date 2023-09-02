import 'package:cached_network_image/cached_network_image.dart';
import 'package:endy/route/router_names.dart';
import 'package:endy/model/company.dart';
import 'package:endy/model/product.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CompanyWeb extends StatefulWidget {
  final Product product;
  const CompanyWeb({super.key, required this.product});

  @override
  State<CompanyWeb> createState() => _CompanyWebState();
}

class _CompanyWebState extends State<CompanyWeb> {
  @override
  Widget build(BuildContext context) {
    final company = widget.product.company as Company;
    final width = MediaQuery.of(context).size.width;
    return Visibility(
      visible: width >= 1280,
      child: Container(
        //padding
        padding: const EdgeInsets.all(10),
        //card effect
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        width: width < 1280 ? 125 : 200,
        height: width < 1280 ? 100 : 150,
        child: Column(
          children: [
            CachedNetworkImage(
                imageUrl: company.logo, height: width < 1280 ? 50 : 100),
            // Text(company.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            InkWell(
                mouseCursor: SystemMouseCursors.click,
                onTap: () => context.pushNamed(
                    APP_PAGE.COMPANY_PRODUCTS_LIST.toName,
                    pathParameters: {"id": company.id}),
                child: Text("Mağazaya get",
                    style: const TextStyle(
                        fontSize: 14,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold))),
          ],
        ),
      ),
    );
  }
}
