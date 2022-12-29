import 'package:endy/components/DiscountCard/DiscountCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';

class TimePart extends StatelessWidget {
  const TimePart({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final DiscountCard widget;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 25,
        child: CountdownTimer(
          endTime: widget.product.deadline * 1000,
          endWidget: const Center(child: Text("Bitdi")),
          widgetBuilder: (BuildContext context, CurrentRemainingTime? time) {
            if (time == null) {
              return const Center(child: Text("Bitdi"));
            }
            return Center(
              child: Text(
                (time.days ?? 0) != 0
                    ? "Son ${time.days} gün ${time.hours} saat"
                    : "Son ${time.hours != null ? "${time.hours} saat " : ""}${time.min} dəqiqə",
                style:
                    const TextStyle(fontWeight: FontWeight.w400, fontSize: 13),
              ),
            );
          },
        ),
      ),
    );
  }
}
