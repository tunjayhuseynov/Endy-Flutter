import 'package:endy/components/tools/button.dart';
import 'package:endy/model/product.dart';
import 'package:endy/utils/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

class HyperlinkWidget extends StatelessWidget {
  final double? horizontalPadding;
  final double? width;
  const HyperlinkWidget({
    Key? key,
    required this.product,
    this.horizontalPadding,
    this.width,
  }) : super(key: key);

  final Product? product;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: product?.link != null && product?.link != "",
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding ?? 60),
        child: PrimaryButton(
          prefix: const Icon(CupertinoIcons.link),
          fontSize: 20,
          text: "Məhsula Get",
          fn: () async {
            if (!await launchUrl(Uri.parse(product?.link ?? ""),
                mode: LaunchMode.externalApplication)) {
              ShowTopSnackBar(
                context,
                error: true,
                "Linkə daxil olarkən xəta baş verdi. Xahiş edirik yenidən cəhd edin.",
              );
            }
          },
          width: width ?? 100,
        ),
      ),
    );
  }
}
