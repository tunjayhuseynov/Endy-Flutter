import 'package:auto_size_text/auto_size_text.dart';
import 'package:endy/components/DiscountCard/DiscountCard.dart';
import 'package:endy/types/product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MostViwed extends StatefulWidget {
  final List<Product> snap;
  const MostViwed({
    Key? key,
    required this.snap,
  }) : super(key: key);

  @override
  State<MostViwed> createState() => _MostViwedState();
}

class _MostViwedState extends State<MostViwed> {
  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.white,
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              AutoSizeText(
                "Ən çox baxılanlar",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: w >= 1024 ? 50 : 0),
                height: 320,
                child: ListView(
                  controller: _scrollController,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  children: widget.snap
                      .map((e) => Container(
                            width: 200,
                            // height: 290,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 10),
                            child: DiscountCard(
                              product: e,
                            ),
                          ))
                      .toList(),
                ),
              ),
              if (w >= 1024)
                Positioned(
                    left: 0,
                    top: 160,
                    child: IconButton(
                        mouseCursor: SystemMouseCursors.click,
                        onPressed: () {
                          _scrollController.animateTo(_scrollController.offset - 210, duration: Duration(milliseconds: 500), curve: Curves.linear);
                        },
                        icon: Icon(
                          CupertinoIcons.back,
                          color: Colors.black,
                        ))),
              if (w >= 1024)
                Positioned(
                    right: 0,
                    top: 160,
                    child: IconButton(
                        mouseCursor: SystemMouseCursors.click,
                        onPressed: () {
                          _scrollController.animateTo(_scrollController.offset + 210, duration: Duration(milliseconds: 500), curve: Curves.linear);
                        },
                        icon: Icon(
                          CupertinoIcons.forward,
                          color: Colors.black,
                        )))
            ],
          )
        ],
      ),
    );
  }
}
