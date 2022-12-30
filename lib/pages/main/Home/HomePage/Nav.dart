import 'package:badges/badges.dart';
import 'package:endy/MainBloc/GlobalBloc.dart';
import 'package:endy/Pages/main/Home/HomePage/Home_Page_Bloc.dart';
import 'package:endy/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Nav extends StatelessWidget {
  Nav({Key? key}) : super(key: key);

  final iconsLeft = <Map>[
    {
      "icon": const AssetImage("assets/icons/navbar/home.png"),
      "index": 0,
      "title": "Ana Səhfə"
    },
    {
      "icon": const AssetImage("assets/icons/navbar/card.png"),
      "index": 1,
      "title": "Bonus Kart"
    },
  ];

  final iconsRight = <Map>[
    {
      "icon": const AssetImage("assets/icons/navbar/list.png"),
      "index": 2,
      "title": "List"
    },
    {
      "icon": const AssetImage("assets/icons/navbar/dots.png"),
      "index": 3,
      "title": "Daha çox",
      "badge": "2"
    },
  ];

  @override
  Widget build(BuildContext context) {
    final currentIndex = context.read<HomePageNavBloc>();

    final Size size = MediaQuery.of(context).size;

    generateMapping(GlobalState state) {
      return (e) => GestureDetector(
            onTap: () {
              currentIndex.setIndex(e["index"]);
            },
            child: BlocBuilder<HomePageNavBloc, int>(
              builder: (navContext, navState) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    e["badge"] != null && state.unseenNotificationCount > 0
                        ? Badge(
                            badgeContent: Text(
                                state.unseenNotificationCount.toString(),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400)),
                            toAnimate: true,
                            animationDuration:
                                const Duration(milliseconds: 500),
                            animationType: BadgeAnimationType.scale,
                            badgeColor: const Color(mainColor),
                            child: ImageIcon(
                              e["icon"],
                              color: navState == e["index"]
                                  ? const Color(mainColor)
                                  : Colors.grey.shade400,
                            ))
                        : ImageIcon(
                            e["icon"],
                            color: navState == e["index"]
                                ? const Color(mainColor)
                                : Colors.grey.shade400,
                          ),
                    Text(e["title"],
                        style: TextStyle(
                          fontSize: 11,
                          color: navState == e["index"]
                              ? const Color(mainColor)
                              : Colors.grey.shade400,
                        ))
                  ],
                );
              },
            ),
          );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            child: SizedBox(
              width: size.width,
              height: 80,
              child: Stack(
                children: [
                  CustomPaint(
                    size: Size(size.width, 80),
                    painter: BNBCustomPainter(),
                  ),
                  Center(
                    heightFactor: 0.3,
                    child: SizedBox(
                      width: 65,
                      height: 65,
                      child: FloatingActionButton(
                          heroTag: currentIndex.state,
                          shape: const CircleBorder(),
                          backgroundColor: const Color(mainColor),
                          elevation: 0.1,
                          child: const Icon(Icons.favorite, size: 35),
                          onPressed: () {
                            currentIndex.setIndex(4);
                          }),
                    ),
                  ),
                  BlocBuilder<GlobalBloc, GlobalState>(
                    builder: (context, state) {
                      return SizedBox(
                        width: size.width,
                        height: 80,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ...iconsLeft.map(generateMapping(state)),
                            Container(
                              width: size.width * 0.20,
                            ),
                            ...iconsRight.map(generateMapping(state)),
                          ],
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class BNBCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, 0); // Start
    path.lineTo(size.width * 0.25, 0);
    path.quadraticBezierTo(size.width * 0.35, 0, size.width * 0.38, 25);
    path.arcToPoint(Offset(size.width * 0.62, 25),
        radius: const Radius.circular(50), clockwise: false);
    path.quadraticBezierTo(size.width * 0.65, 0, size.width * 0.72, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 20);
    canvas.drawShadow(path, Colors.black, 10, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
