import 'package:cached_network_image/cached_network_image.dart';
import 'package:endy/MainBloc/GlobalBloc.dart';
import 'package:endy/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdSlider extends StatefulWidget {
  const AdSlider({Key? key}) : super(key: key);

  @override
  State<AdSlider> createState() => _AdSliderState();
}

class _AdSliderState extends State<AdSlider> {
  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GlobalBloc, GlobalState>(
      builder: (context, state) {
        return Visibility(
          visible: state.panels.isNotEmpty,
          child: LayoutBuilder(builder: (context, c) {
            return InkWell(
              mouseCursor: SystemMouseCursors.grab,
              child: Container(
                width: c.maxWidth < 768 ? c.maxWidth : 768,
                child: Card(
                  surfaceTintColor: Colors.white,
                  child: Container(
                      // clipBehavior: Clip.antiAliasWithSaveLayer,
                      // decoration: BoxDecoration(
                      //   border: Border.all(color: const Color(mainColor), width: 2),
                      //   borderRadius: BorderRadius.circular(22),
                      // ),
                      child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Stack(alignment: AlignmentDirectional.center, children: [
                      CarouselSlider(
                        options: CarouselOptions(
                            autoPlay: true,
                            autoPlayInterval: const Duration(milliseconds: 4000),
                            viewportFraction: 1,
                            onPageChanged: (index, reason) {
                              setState(() {
                                _current = index;
                              });
                            }),
                        items: context
                            .read<GlobalBloc>()
                            .state
                            .panels
                            .map((item) => Center(
                                child: CachedNetworkImage(
                                    imageUrl: item.photo,
                                    fit: BoxFit.cover,
                                    width: 1000)))
                            .toList(),
                      ),
                      Positioned(
                          bottom: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: context
                                .read<GlobalBloc>()
                                .state
                                .panels
                                .asMap()
                                .entries
                                .map((entry) {
                              return GestureDetector(
                                onTap: () => _controller.animateToPage(entry.key),
                                child: Container(
                                  width: 12.0,
                                  height: 12.0,
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 4.0),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: (_current != entry.key
                                              ? Colors.black12
                                              : const Color(mainColor))
                                          .withOpacity(
                                              _current == entry.key ? 1 : 0.4)),
                                ),
                              );
                            }).toList(),
                          ))
                    ]),
                  )),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
