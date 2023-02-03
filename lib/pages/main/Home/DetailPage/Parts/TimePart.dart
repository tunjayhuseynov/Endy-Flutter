import 'package:cached_network_image/cached_network_image.dart';
import 'package:endy/types/company.dart';
import 'package:endy/types/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';

class TimePart extends StatelessWidget {
  const TimePart({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product? product;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
              color: Colors.grey, width: 1, style: BorderStyle.solid),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ProductTimerWidget(product: product),
          ProductCompanyWidget(product: product)
        ],
      ),
    );
  }
}

class ProductCompanyWidget extends StatelessWidget {
  const ProductCompanyWidget({
    super.key,
    required this.product,
  });

  final Product? product;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: (product?.company as Company).logo,
      width: 50,
      height: 50,
    );
  }
}

class ProductTimerWidget extends StatelessWidget {
  const ProductTimerWidget({
    super.key,
    required this.product,
  });

  final Product? product;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.access_time),
        const SizedBox(width: 10),
        Center(
          child: CountdownTimer(
            endTime: product!.deadline * 1000,
            endWidget: const Text(
              "Bitdi",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            widgetBuilder:
                (BuildContext context, CurrentRemainingTime? time) {
              if (time == null) {
                return const Text(
                  "Bitdi",
                  style: TextStyle(fontWeight: FontWeight.w500),
                );
              }
              return Text(
                (time.days ?? 0) != 0
                    ? "Son ${time.days} gün ${time.hours} saat"
                    : "Son ${time.hours != null ? "${time.hours} saat " : ""}${time.min} dəqiqə",
                style: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 15),
              );
            },
          ),
        ),
      ],
    );
  }
}
