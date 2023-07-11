import 'package:cached_network_image/cached_network_image.dart';
import 'package:endy/Pages/main/Home/FilterPage/FilterPage.dart';
import 'package:endy/route/router_names.dart';
import 'package:endy/types/company.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:go_router/go_router.dart';
import 'package:tap_canvas/tap_canvas.dart';

class TopBody extends StatefulWidget {
  final Company? company;
  const TopBody({super.key, required this.company});

  @override
  State<TopBody> createState() => _TopBodyState();
}

class _TopBodyState extends State<TopBody> {
  bool isFilterOpened = false;

  Widget FilterIcon(double w) {
    return InkWell(
      mouseCursor: SystemMouseCursors.click,
      hoverColor: Colors.transparent,
      onTap: () {
        if (w < 1024) {
          context.pushNamed(APP_PAGE.FILTER.toName);
        } else {
          setState(() {
            isFilterOpened = !isFilterOpened;
          });
        }
      },
      child: Image.asset(
        "assets/icons/filter.png",
        height: 20,
        width: 20,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: Row(
            mainAxisAlignment: w >= 1024
                ? MainAxisAlignment.start
                : MainAxisAlignment.spaceBetween,
            children: [
              const Text("100-dən çox məhsul",
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400)),
              const SizedBox(
                width: 20,
              ),
              if (w >= 1024)
                PortalTarget(
                    visible: isFilterOpened,
                    anchor: Aligned(
                        offset: Offset(0, 330),
                        follower: Alignment.bottomCenter,
                        target: Alignment.center),
                    portalFollower: TapOutsideDetectorWidget(
                      onTappedOutside: () => setState(() {
                        isFilterOpened = false;
                      }),
                      child: Container(
                        width: 400,
                        height: 300,
                        //Card shadow
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: FilterPage(isModal: true),
                      ),
                    ),
                    child: FilterIcon(w)),
              if (w < 1024) FilterIcon(w),
              if (w >= 1024)
                const SizedBox(
                  width: 20,
                ),
              if (widget.company != null)
                CachedNetworkImage(
                  imageUrl: widget.company?.logo ?? "",
                  width: 40,
                ),
            ],
          )),
    );
  }
}
