import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:endy/route/route.gr.dart';

class CameraRoute extends StatefulWidget {
  const CameraRoute({Key? key}) : super(key: key);

  @override
  CameraRouteState createState() => CameraRouteState();
}

class CameraRouteState extends State<CameraRoute> {
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
            // allowDuplicates: false,
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes[0].rawValue == null) {
                debugPrint('Failed to scan Barcode');
              } else {
                final String code = barcodes[0].rawValue!;
                controller.stop();
                context.router.replace(BonusAddRoute(code: code));
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
