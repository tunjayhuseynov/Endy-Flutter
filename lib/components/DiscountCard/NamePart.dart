import 'package:endy/components/DiscountCard/DiscountCard.dart';
import 'package:flutter/cupertino.dart';

class NamePart extends StatelessWidget {
  const NamePart({
    Key? key,
    required this.size,
    required this.widget,
  }) : super(key: key);

  final Size size;
  final DiscountCard widget;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width,
      child: Text(
        widget.product.name,
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }
}
