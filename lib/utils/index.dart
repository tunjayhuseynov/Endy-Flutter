import 'package:endy/utils/responsivness/container.dart';
import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

const mainColor = 0xfff03034;
const mainColorHex = "#f03034";

// XXL => 1576px - 2560px
// XL => 1440px - 1576px
// LG => 1280px - 1440px
// BASE => 1024px - 1280px
// MD => 890px - 1024px
// SM => 768px - 890px
// XS => 480px - 768px
// XXS => 0px - 480px

// Catalog Main
const xxlCatalogMainGrid = 5;
const xlCatalogMainGrid = 5;
const lgCatalogMainGrid = 5;
const baseCatalogMainGrid = 5;
const mdCatalogMainGrid = 3;
const smCatalogMainGrid = 3;
const xsCatalogMainGrid = 2;
const xxsCatalogMainGrid = 2;

int getCatalogMainGrid(double w) {
  if (w >= 1576) return xxlCatalogMainGrid;
  if (w >= 1440) return xlCatalogMainGrid;
  if (w >= 1280) return lgCatalogMainGrid;
  if (w >= 1024) return baseCatalogMainGrid;
  if (w >= 890) return mdCatalogMainGrid;
  if (w >= 768) return smCatalogMainGrid;
  if (w >= 480) return xsCatalogMainGrid;
  return xxsCatalogMainGrid;
}

bool? validationWithEmpty(String text, {int num = 3}) {
  if (text.length < num && text.isNotEmpty) return true;
  return null;
}

bool? validation(String text, {int num = 3}) {
  if (text.length < num) return true;
  return null;
}

void ShowTopSnackBar(BuildContext context, String message,
    {bool error = false, bool success = false, bool info = false}) {
  Widget snackBar;

  if (error) {
    snackBar = CustomSnackBar.error(message: message);
  } else if (success) {
    snackBar = CustomSnackBar.success(message: message);
  } else if (info) {
    snackBar = CustomSnackBar.info(message: message);
  } else {
    snackBar = CustomSnackBar.info(message: message);
  }

  showTopSnackBar(
    Overlay.of(context),
    Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          width: 500,
          child: snackBar,
        ),
      ),
    ),
    displayDuration: const Duration(milliseconds: 1000),
  );
}

class ScaffoldWrapper extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Color? backgroundColor;
  final bool? resizeToAvoidBottomInset;
  ScaffoldWrapper(
      {required this.body,
      this.appBar,
      this.backgroundColor,
      this.resizeToAvoidBottomInset});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 1024
        ? Padding(
            padding: EdgeInsets.symmetric(horizontal: getContainerSize(width)),
            child: body)
        : Scaffold(
            resizeToAvoidBottomInset: resizeToAvoidBottomInset,
            backgroundColor: backgroundColor,
            appBar: appBar,
            body: body,
          );
  }
}
