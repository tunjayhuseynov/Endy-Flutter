import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class Camera extends StatefulWidget {
  const Camera({Key? key}) : super(key: key);

  @override
  CameraState createState() => CameraState();
}

class CameraState extends State<Camera> {
  MobileScannerController controller = MobileScannerController();

  CustomPaint _getCustomPaintOverlay(BuildContext context) {
    return CustomPaint(
        size: MediaQuery.of(context).size, painter: RectanglePainter());
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MobileScanner(
            controller: controller,
            allowDuplicates: false,
            onDetect: (barcode, args) {
              if (barcode.rawValue == null) {
                debugPrint('Failed to scan Barcode');
              } else {
                final String code = barcode.rawValue!;
                controller.stop();
                Navigator.pushReplacementNamed(context, "/bonus/add",
                    arguments: code);
              }
            }),
        _getCustomPaintOverlay(context),
        const Center(
          child: Text("Bar kodu oxudun",
              style: TextStyle(
                  decoration: TextDecoration.none,
                  color: Colors.white,
                  fontSize: 20)),
        )
      ],
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class RectanglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black54;

    canvas.drawPath(
        Path.combine(
          PathOperation.difference, //simple difference of following operations
          //bellow draws a rectangle of full screen (parent) size
          Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
          //bellow clips out the circular rectangle with center as offset and dimensions you need to set
          Path()
            ..addRRect(RRect.fromRectAndRadius(
                Rect.fromCenter(
                    center: Offset(size.width * 0.5, size.height * 0.5),
                    width: size.width * 0.85,
                    height: size.height * 0.3),
                const Radius.circular(15)))
            ..close(),
        ),
        paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
