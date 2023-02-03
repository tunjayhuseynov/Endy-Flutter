import 'package:auto_size_text/auto_size_text.dart';
import 'package:endy/components/DiscountCard/DiscountCard.dart';
import 'package:endy/utils/index.dart';
import 'package:flutter/material.dart';

class PricePart extends StatelessWidget {
  const PricePart({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final DiscountCard widget;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            height: 40,
            decoration: const BoxDecoration(
              color: Color(mainColor),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: AutoSizeText(
              minFontSize: 14,
              maxFontSize: 18,
              wrapWords: false,
              "${widget.product.discount.runtimeType == double ? (widget.product.discount as double).toStringAsFixed(0) : widget.product.discount}%",
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 17,
                  color: Colors.white),
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
                width: w * 0.25,
                child: FittedBox(
                  alignment: Alignment.centerLeft,
                  fit: BoxFit.scaleDown,
                  child: AutoSizeText(
                    presetFontSizes: [14, 12, 10],
                    wrapWords: false,
                    "${widget.product.price.toStringAsFixed(2)} AZN",
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        // decorationColor: Colors.red[800],
                        overflow: TextOverflow.ellipsis,
                        decorationThickness: 1,
                        decoration: TextDecoration.lineThrough),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
                width: w * 0.25,
                child: FittedBox(
                  alignment: Alignment.centerLeft,
                  fit: BoxFit.scaleDown,
                  child: AutoSizeText(
                    presetFontSizes: [18, 16, 14],
                    maxLines: 1,
                    "${widget.product.discountedPrice.toStringAsFixed(2)} AZN",
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
