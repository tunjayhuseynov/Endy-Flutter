import 'package:auto_size_text/auto_size_text.dart';
import 'package:endy/model/product.dart';
import 'package:flutter/material.dart';

class PricePart extends StatelessWidget {
  const PricePart({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product? product;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.only(top: 5, left: 25, right: 25),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
              color: Colors.grey, width: 1, style: BorderStyle.solid),
          top: BorderSide(
              color: Colors.grey, width: 1, style: BorderStyle.solid),
        ),
      ),
      height: 80,
      child: Flex(
        direction: w < 1024 ? Axis.horizontal : Axis.vertical,
        children: [
          Expanded(
            flex: 2,
            child: ProductPercentageWidget(product: product),
          ),
          Expanded(
            flex: 1,
            child: ProductNameWidget(product: product),
          ),
        ],
      ),
    );
  }
}

class ProductNameWidget extends StatelessWidget {
  final TextAlign? textAlign;
  final double? fontSize;
  const ProductNameWidget({super.key, required this.product, this.textAlign, this.fontSize});

  final Product? product;

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(product!.name,
        textAlign: textAlign ?? TextAlign.center,
        style: TextStyle(fontSize: fontSize ?? 18, fontWeight: FontWeight.bold));
  }
}

class ProductPercentageWidget extends StatelessWidget {
  const ProductPercentageWidget({
    super.key,
    required this.product,
  });

  final Product? product;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            width: 60,
            height: 40,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
              color: Color.fromARGB(255, 255, 17, 0),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Center(
              widthFactor: 60,
              heightFactor: 40,
              child: AutoSizeText(
                "${product?.discount.runtimeType == double ? (product?.discount as double).toStringAsFixed(0) : product?.discount}%",
                textAlign: TextAlign.center,
                minFontSize: 15,
                overflow: TextOverflow.fade,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, color: Colors.white),
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          flex: 2,
          child: Wrap(
            direction: Axis.vertical,
            spacing: 0,
            crossAxisAlignment: WrapCrossAlignment.start,
            children: [
              SizedBox(
                height: 15,
                child: Text(
                  "${product?.price.toStringAsFixed(2)} AZN",
                  style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      overflow: TextOverflow.ellipsis,
                      decorationThickness: 2.85,
                      decoration: TextDecoration.lineThrough),
                ),
              ),
              SizedBox(
                height: 20,
                // width: 100,
                child: Text(
                  "${product?.discountedPrice.toStringAsFixed(2)} AZN",
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 18),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
