import 'package:auto_size_text/auto_size_text.dart';
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
      width: size.width * 0.75,
      height: 30,
      child: AutoSizeText(
        stepGranularity: 1,
        presetFontSizes: [16, 14, 12],
        maxLines: 3,
        widget.product.name,
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
