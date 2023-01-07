import 'dart:async';

import 'package:endy/types/company.dart';
import 'package:endy/types/place.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';

import 'package:maps_launcher/maps_launcher.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class MapPage extends StatefulWidget {
  final List<Place> places;
  final Company company;

  const MapPage({Key? key, required this.places, required this.company})
      : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Completer<GoogleMapController> _controller = Completer();
  final List<Marker> _marker = <Marker>[];
  double _height = 175;
  final double _const_height = 175;
  Position? location;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(40.409264, 49.867092),
    zoom: 12.0,
  );

  @override
  void initState() {
    loadData();
    super.initState();
  }

  loadData() async {
    location = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);

    Uint8List image = await loadNetworkImage(widget.company.logo);
    final ui.Codec markerImageCodec = await ui.instantiateImageCodec(
        image.buffer.asUint8List(),
        targetHeight: 75,
        targetWidth: 75);
    final ui.FrameInfo frameInfo = await markerImageCodec.getNextFrame();
    final ByteData? byteData =
        await frameInfo.image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List resizedImageMarker = byteData!.buffer.asUint8List();

    for (var element in widget.places) {
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
    setState(() {});
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
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 175),
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
                    Navigator.pop(context);
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
              width: MediaQuery.of(context).size.width,
              color: Colors.grey[100],
              child: Flex(
                direction: Axis.vertical,
                children: [
                  GestureDetector(
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
                  Flexible(
                    flex: 5,
                    fit: FlexFit.tight,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.places.length,
                      itemBuilder: (context, index) {
                        final place = widget.places[index];
                        return Column(
                          children: [
                            ListTile(
                              onTap: () async {
                                try {
                                  await MapsLauncher.launchCoordinates(
                                      place.lat, place.lng, "Məkan");
                                } catch (e) {
                                  showTopSnackBar(
                                    Overlay.of(context)!,
                                    displayDuration:
                                        const Duration(milliseconds: 1000),
                                    const CustomSnackBar.error(
                                      message:
                                          "Xəritəyə qoşulurken xəta baş verdi",
                                    ),
                                  );
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
