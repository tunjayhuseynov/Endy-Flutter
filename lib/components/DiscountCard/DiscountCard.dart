import 'package:endy/components/DiscountCard/ImagePart.dart';
import 'package:endy/components/DiscountCard/NamePart.dart';
import 'package:endy/components/DiscountCard/PricePart.dart';
import 'package:endy/components/DiscountCard/TimePart.dart';
import 'package:endy/types/product.dart';
import 'package:flutter/material.dart';

class DiscountCard extends StatefulWidget {
  final Product product;
  const DiscountCard({Key? key, required this.product}) : super(key: key);

  @override
  State<DiscountCard> createState() => _DiscountCardState();
}

class _DiscountCardState extends State<DiscountCard> {
  double spread = 1.0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (value) {
        setState(() {
          spread = 3.75;
        });
      },
      onExit: (value) {
        setState(() {
          spread = 1;
        });
      },
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context,
              '/home/detail?id=${widget.product.id}&name=${widget.product.name}',
              arguments: widget.product.id);
        },
        child: FittedBox(
          fit: BoxFit.contain,
          child: Container(
            width: 200,
            // height: c.maxWidth * 1.5,
            padding: const EdgeInsets.only(right: 10, left: 10, top: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  offset: const Offset(1, 2),
                  blurRadius: 5,
                  spreadRadius: spread,
                  color: Colors.black.withOpacity(0.2),
                ),
              ],
            ),
            child: Wrap(
              children: [
                ImagePart(widget: widget),
                const SizedBox(height: 5),
                TimePart(widget: widget),
                const SizedBox(height: 10),
                NamePart(size: size, widget: widget),
                const SizedBox(height: 25),
                PricePart(widget: widget),
                Container(height: 15)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
