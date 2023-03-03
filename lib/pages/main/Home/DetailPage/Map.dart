import 'dart:async';

import 'package:async/async.dart';
import 'package:auto_route/auto_route.dart';
import 'package:endy/streams/products.dart';
import 'package:endy/types/product.dart';
import 'package:endy/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';

import 'package:maps_launcher/maps_launcher.dart';

class MapPageRoute extends StatefulWidget {
  final String? id;

  const MapPageRoute({Key? key, @pathParam required this.id}) : super(key: key);

  @override
  State<MapPageRoute> createState() => _MapPageRouteState();
}

class _MapPageRouteState extends State<MapPageRoute> {
  final Completer<GoogleMapController> _controller = Completer();
  CancelableOperation? _operation;
  final List<Marker> _marker = <Marker>[];
  double _height = 175;
  final double _const_height = 175;
  Position? location;
  Product? product;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(40.409264, 49.867092),
    zoom: 12.0,
  );

  @override
  void initState() {
    _operation = CancelableOperation.fromFuture(loadData(widget.id ?? "0"))
        .then((p0) => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    _operation?.cancel();
    super.dispose();
  }

  loadData(String id) async {
    Product p = await ProductsCrud.getProduct(id);
    product = p;
    location = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);

    Uint8List image = await loadNetworkImage(p.company.logo);
    final ui.Codec markerImageCodec = await ui.instantiateImageCodec(
        image.buffer.asUint8List(),
        targetHeight: 75,
        targetWidth: 75);
    final ui.FrameInfo frameInfo = await markerImageCodec.getNextFrame();
    final ByteData? byteData =
        await frameInfo.image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List resizedImageMarker = byteData!.buffer.asUint8List();

    for (var element in p.availablePlaces) {
      _marker.add(Marker(
        markerId: MarkerId(element.id),
        icon: BitmapDescriptor.fromBytes(resizedImageMarker),
        position: LatLng(
          element.lat,
          element.lng,
        ),
        infoWindow: InfoWindow(title: element.name, snippet: element.name),
      ));
    }
  }

  Future<Uint8List> loadNetworkImage(path) async {
    final completed = Completer<ImageInfo>();
    var image = NetworkImage(path);
    image.resolve(const ImageConfiguration()).addListener(
        ImageStreamListener((info, _) => completed.complete(info)));
    final imageInfo = await completed.future;
    final byteData =
        await imageInfo.image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return ScaffoldWrapper(
      hPadding: 0,
      body: Stack(
        children: [
          Container(
            padding: w >= 1024 ? null : const EdgeInsets.only(bottom: 175),
            child: GoogleMap(
              mapType: MapType.terrain,
              rotateGesturesEnabled: false,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              markers: _marker.toSet(),
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
          ),
          Positioned(
              top: 20,
              child: IconButton(
                  onPressed: () {
                    if (context.router.stackData.length == 1) {
                      context.router
                          .pushNamed("/home/detail/" + (widget.id ?? ""));
                    } else {
                      context.router.pop();
                    }
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_outlined,
                    color: Colors.black,
                    size: 25,
                  ))),
          Positioned(
            bottom: 0,
            left: 0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 350),
              height: _height,
              width: w >= 1024 ? w * 0.33 : w,
              color: Colors.grey[100],
              child: Flex(
                direction: Axis.vertical,
                children: [
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _height =
                              _height == MediaQuery.of(context).size.height * 0.8
                                  ? _const_height
                                  : MediaQuery.of(context).size.height * 0.8;
                        });
                      },
                      onVerticalDragStart: (details) {
                        setState(() {
                          _height =
                              _height == MediaQuery.of(context).size.height * 0.8
                                  ? _const_height
                                  : MediaQuery.of(context).size.height * 0.8;
                        });
                      },
                      child: Container(
                        height: 50,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              spreadRadius: 5,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            "Məkan siyahısı",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 5,
                    fit: FlexFit.tight,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: product?.availablePlaces.length ?? 0,
                      itemBuilder: (context, index) {
                        final place = product?.availablePlaces[index];
                        return Column(
                          children: [
                            if (place != null)
                              ListTile(
                                onTap: () async {
                                  try {
                                    await MapsLauncher.launchCoordinates(
                                        place.lat, place.lng, "Məkan");
                                  } catch (e) {
                                    ShowTopSnackBar(context,
                                        "Xəritəyə qoşulurken xəta baş verdi",
                                        error: true);
                                  }
                                },
                                title: Text(place.name),
                                subtitle: Text(
                                    "${(Geolocator.distanceBetween(place.lat, place.lng, location?.latitude ?? 0, location?.longitude ?? 0).roundToDouble() / 1000).toStringAsFixed(2)} km"),
                              ),
                            const Divider(
                              thickness: 1,
                            )
                          ],
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: _goToTheLake,
      //   label: const Text('To the lake!'),
      //   icon: const Icon(Icons.directions_boat),
      // ),
    );
  }
}
