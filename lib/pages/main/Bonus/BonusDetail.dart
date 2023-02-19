import 'package:auto_route/auto_route.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:endy/MainBloc/GlobalBloc.dart';
import 'package:endy/components/tools/dialog.dart';
import 'package:endy/types/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BonusDetailPageRoute extends StatefulWidget {
  final BonusCard card;
  const BonusDetailPageRoute({Key? key, required this.card}) : super(key: key);

  @override
  State<BonusDetailPageRoute> createState() => _BonusDetailPageRouteState();
}

class _BonusDetailPageRouteState extends State<BonusDetailPageRoute> {
  Widget cardInfo(context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              insetPadding: const EdgeInsets.all(0),
              child: SizedBox(
                width: size.width,
                height: size.width / 2,
                // color: boxColor,
                child: BarcodeWidget(
                  padding: const EdgeInsets.all(40),
                  backgroundColor: Colors.white,
                  barcode: Barcode.code128(),
                  data: widget.card.cardNumber,
                ),
              ),
            );
          },
        );
      },
      child: SizedBox(
        width: size.width,
        height: size.width,
        // color: boxColor,
        child: BarcodeWidget(
          padding: const EdgeInsets.all(40),
          backgroundColor: Colors.white,
          barcode: Barcode.telepen(),
          data: widget.card.cardNumber,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocBuilder<GlobalBloc, GlobalState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 60,
            actions: [
              IconButton(
                iconSize: 30,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: () async {
                  final response = await Dialogs.showRemoveDialog(context);
                  if (response == true) {
                    if (!mounted) return;
                    context.read<GlobalBloc>().removeBonusCard(widget.card);
                    context.router.pop(context);
                  }
                },
                icon: const Icon(CupertinoIcons.delete, color: Colors.red),
              )
            ],
            leading: IconButton(
                onPressed: () {
                  context.router.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios)),
          ),
          body: DebitCardPart(size: size, widget: widget),
        );
      },
    );
  }
}

class DebitCardPart extends StatelessWidget {
  const DebitCardPart({
    Key? key,
    required this.size,
    required this.widget,
  }) : super(key: key);

  final Size size;
  final BonusDetailPageRoute widget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0.0),
      child: Container(
        alignment: Alignment.center,
        width: size.width,
        height: size.height * 0.33,
        color: Colors.white,
        child: Stack(alignment: Alignment.center, children: [
          Container(
              padding: const EdgeInsets.only(bottom: 20),
              width: size.width * 0.8,
              height: 180,
              clipBehavior: Clip.hardEdge,
              // Box Shadow with circular border
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: BarcodeWidget(
                padding: const EdgeInsets.all(40),
                backgroundColor: Colors.white,
                barcode: Barcode.code128(),
                data: widget.card.cardNumber,
              )),
          Positioned(
            bottom: 20,
            left: 40,
            child: Text.rich(TextSpan(children: [
              const TextSpan(text: "Kart Adı:  "),
              TextSpan(
                  text: widget.card.cardName,
                  style: const TextStyle(
                      letterSpacing: 1, fontWeight: FontWeight.w600))
            ])),
          )
        ]),
      ),
    );
  }
}
