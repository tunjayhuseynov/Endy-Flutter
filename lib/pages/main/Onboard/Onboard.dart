import 'package:auto_route/auto_route.dart';
import 'package:endy/MainBloc/GlobalBloc.dart';
import 'package:endy/components/tools/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardRoute extends StatefulWidget {
  const OnboardRoute({Key? key}) : super(key: key);

  @override
  State<OnboardRoute> createState() => _OnboardRouteState();
}

class _OnboardRouteState extends State<OnboardRoute> {
  final controller = PageController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocBuilder<GlobalBloc, GlobalState>(
      builder: (context, state) {
        return Scaffold(
            backgroundColor: Colors.white,
            body: SizedBox(
                width: size.width,
                height: size.height,
                child: Stack(alignment: AlignmentDirectional.center, children: [
                  Container(
                    padding: const EdgeInsets.only(bottom: 150),
                    child: PageView(
                      controller: controller,
                      children: [
                        _page(
                            "assets/onboard_first.png",
                            0,
                            "Ən Son Endirimlər",
                            "1000-dən çox market və mağazalardakı endirimlərdən yararlanın",
                            size),
                        _page(
                            "assets/onboard_second.png",
                            1,
                            "Bonus Kartlarınız",
                            "Bonus kartlarınız bir yerdə daha əlçatandır",
                            size),
                        _page(
                            "assets/onboard_third.png",
                            2,
                            "Alınacaqlar Siyahısı",
                            "Alınacaq məhsullarınız bir arada",
                            size),
                      ],
                    ),
                  ),
                  Positioned(
                      bottom: 75,
                      child: PrimaryButton(
                          text: "Növbəti",
                          fn: () async => {
                                if (controller.page != null &&
                                    controller.page! < 2)
                                  {
                                    await controller.nextPage(
                                        duration:
                                            const Duration(milliseconds: 500),
                                        curve: Curves.ease)
                                  }
                                else
                                  {
                                    context.read<GlobalBloc>().setFirstEnter(),
                                    context.router.pushNamed("/")
                                  }
                              })),
                ])));
      },
    );
  }
}

Widget _page(
    String image, double offset, String head, String subtext, Size size) {
  return Column(children: [
    const SizedBox(height: 75),
    SizedBox(child: Image.asset(image)),
    const SizedBox(height: 25),
    Center(
        child: SmoothIndicator(
      offset: offset,
      count: 3,
      effect: const SlideEffect(dotWidth: 8, dotHeight: 8),
    )),
    const SizedBox(height: 35),
    Text(head,
        style: const TextStyle(
            color: Colors.black87, fontSize: 28, fontWeight: FontWeight.w700)),
    const SizedBox(height: 15),
    SizedBox(
      width: size.width * 0.65,
      child: Text(subtext,
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: Colors.black38,
              fontSize: 14,
              fontWeight: FontWeight.w400)),
    )
  ]);
}
