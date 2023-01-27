import 'package:endy/types/place.dart';
import 'package:endy/types/product.dart';
import 'package:endy/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

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
      child: Row(
        children: [
          const Icon(
            Icons.location_on_sharp,
            color: Color(mainColor),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () async {
              bool serviceEnabled;
              final res = await Permission.locationWhenInUse.request();
              serviceEnabled = await Geolocator.isLocationServiceEnabled();
              if (!mounted) return;

              if (res != PermissionStatus.granted || !serviceEnabled) {
                return ShowTopSnackBar(
                    error: true,
                    context,
                    "Zəhmət olmasa lokasyon servisini aktivləşdirin");
              }

              Navigator.pushNamed(context, '/home/map', arguments: [
                product?.availablePlaces.cast<Place>().toList(),
                product?.company
              ]);
            },
            child: const Text(
              "Endirim olan məkanlar",
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  letterSpacing: .75),
            ),
          ),
        ],
      ),
    );
  }
}
