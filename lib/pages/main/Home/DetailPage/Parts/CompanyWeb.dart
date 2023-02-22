import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:endy/types/company.dart';
import 'package:endy/types/product.dart';
import 'package:flutter/material.dart';

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
    return Container(
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
      width: 200,
      height: 150,
      child: Column(
        children: [
          CachedNetworkImage(imageUrl: company.logo, height: 100),
          // Text(company.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          InkWell(
              mouseCursor: SystemMouseCursors.click,
              onTap: () =>
                  context.router.pushNamed('/company/list/' + company.id),
              child: Text("Mağazaya get",
                  style: const TextStyle(
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }
}
