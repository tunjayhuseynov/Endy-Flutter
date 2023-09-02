// import 'dart:html';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:endy/MainBloc/GlobalBloc.dart';
import 'package:endy/model/user.dart';
import 'package:endy/route/router_names.dart';
import 'package:endy/utils/index.dart';
import 'package:endy/utils/responsivness/container.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

class BonusHomeRoute extends StatefulWidget {
  const BonusHomeRoute({Key? key}) : super(key: key);

  @override
  State<BonusHomeRoute> createState() => _BonusHomeRouteState();
}

class _BonusHomeRouteState extends State<BonusHomeRoute> {
  onAdd() async {
    if (!kIsWeb && await Permission.camera.request().isGranted) {
      await context.pushNamed(APP_PAGE.BONUS_CARD_CAMERA.toName);
    }

    // if (kIsWeb) {
    //   window.navigator.mediaDevices
    //       ?.getUserMedia([
    //     {"audio": false},
    //     {"video": true}
    //   ] as Map<dynamic, dynamic>)
    //       .then((value) {
    //     context.router.pushNamed('/bonus/camera');
    //   }).catchError((e) {
    //     ScaffoldMessenger.of(context)
    //         .showSnackBar(SnackBar(content: Text("Kamera icazə verilmədi")));
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GlobalBloc, GlobalState>(
      builder: (context, state) {
        return Scaffold(
          body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            height: MediaQuery.of(context).size.height,
            child: Stack(children: [
              ListView(
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                children: [
                  const SizedBox(height: 25),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Bonus Kartlarım",
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (state.userData != null)
                    ListView.builder(
                        physics: const ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: state.userData?.bonusCard.length,
                        itemBuilder: (context, index) {
                          return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Bonus(
                                card: state.userData!.bonusCard[index],
                              ));
                        }),
                  const SizedBox(height: 120),
                ],
              ),
              Positioned(
                  right: 0,
                  bottom: 120,
                  child: TextButton(
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(horizontal: 20)),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color(mainColor))),
                      onPressed: onAdd,
                      child: const Text(
                        "+ Kart əlavə et",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w700),
                      ))),
            ]),
          ),
        );
      },
    );
  }
}

class Bonus extends StatefulWidget {
  final BonusCard card;
  const Bonus({Key? key, required this.card}) : super(key: key);

  @override
  State<Bonus> createState() => BonusState();
}

class BonusState extends State<Bonus> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => context.pushNamed(APP_PAGE.BONUS_CARD_DETAIL.toName,
          pathParameters: {"id": widget.card.cardNumber}),
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: getContainerSize(size.width), vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                width: size.width * 0.35,
                height: (size.width * 0.45) / 2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10), // Image border
                  child: SizedBox(
                    // color: boxColor,
                    child: widget.card.cardFront != null
                        ? CachedNetworkImage(
                            imageUrl: widget.card.cardFront!,
                            fit: BoxFit.cover,
                          )
                        : widget.card.cardBack != null
                            ? CachedNetworkImage(
                                imageUrl: widget.card.cardBack!)
                            : BarcodeWidget(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10, top: 10),
                                backgroundColor: Colors.white,
                                barcode: Barcode.code128(),
                                data: widget.card.cardNumber,
                              ),
                  ),
                )),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                AutoSizeText(widget.card.cardName,
                    maxFontSize: 18,
                    minFontSize: 14,
                    style: const TextStyle(
                        color: Colors.black87, fontWeight: FontWeight.w600)),
                AutoSizeText(widget.card.cardNumber,
                    maxFontSize: 16,
                    minFontSize: 12,
                    style: const TextStyle(
                        color: Colors.black87, fontWeight: FontWeight.w500)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
