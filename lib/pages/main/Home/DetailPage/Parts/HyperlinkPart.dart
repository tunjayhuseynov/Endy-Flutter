import 'package:endy/components/tools/button.dart';
import 'package:endy/types/product.dart';
import 'package:flutter/cupertino.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class HyperlinkWidget extends StatelessWidget {
  const HyperlinkWidget({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product? product;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: product?.link != null && product?.link != "",
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 60),
        child: PrimaryButton(
          prefix: const Icon(CupertinoIcons.link),
          fontSize: 20,
          text: "Məhsula Get",
          fn: () async {
            if (!await launchUrl(Uri.parse(product?.link ?? ""),
                mode: LaunchMode.externalApplication)) {
              showTopSnackBar(
                  Overlay.of(context)!,
                  const CustomSnackBar.error(
                    message:
                        "Linkə daxil olarkən xəta baş verdi. Xahiş edirik yenidən cəhd edin.",
                  ));
            }
          },
          width: 100,
        ),
      ),
    );
  }
}
