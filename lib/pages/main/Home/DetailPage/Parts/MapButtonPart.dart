import 'package:auto_route/auto_route.dart';
import 'package:endy/types/product.dart';
import 'package:endy/utils/index.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class MapWidget extends StatelessWidget {
  const MapWidget({
    Key? key,
    required this.mounted,
    required this.product,
  }) : super(key: key);

  final bool mounted;
  final Product? product;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
              color: Colors.grey, width: 1, style: BorderStyle.solid),
        ),
      ),
      child: ProductMapWidget(mounted: mounted, product: product),
    );
  }
}

class ProductMapWidget extends StatelessWidget {
  const ProductMapWidget({
    super.key,
    required this.mounted,
    required this.product,
  });

  final bool mounted;
  final Product? product;

  onClick(BuildContext context) async {
    bool serviceEnabled;
    if (!kIsWeb) {
      final res = await Permission.locationWhenInUse.request();
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!mounted) return;

      if (res != PermissionStatus.granted || !serviceEnabled) {
        return ShowTopSnackBar(
            error: true,
            context,
            "Zəhmət olmasa lokasyon servisini aktivləşdirin");
      }

      context.router.pushNamed('/detail/map/' + product!.id);
    } else {
      context.router.pushNamed('/detail/map/' + product!.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.location_on_sharp,
          color: Color(mainColor),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () => onClick(context),
          child: const Text(
            "Endirim olan məkanlar",
            style: TextStyle(
                fontWeight: FontWeight.w600, fontSize: 15, letterSpacing: .75),
          ),
        ),
      ],
    );
  }
}
