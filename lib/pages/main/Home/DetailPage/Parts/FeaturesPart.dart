import 'package:endy/types/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class FeatuersWidget extends StatelessWidget {
  const FeatuersWidget({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product? product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          const Text("Xüsusiyyətlər:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          Html(
            data: product?.description,
            style: {
              "p": Style(
                margin: Margins.only(bottom: 0),
              )
            },
          )
        ],
      ),
    );
  }
}
