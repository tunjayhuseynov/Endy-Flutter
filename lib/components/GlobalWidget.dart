import 'package:auto_route/auto_route.dart';
import 'package:endy/MainBloc/GlobalBloc.dart';
import 'package:endy/Pages/main/Home/SearchPage/Search.dart';
import 'package:endy/Pages/main/Home/SearchPage/Search_Page_Bloc.dart';
import 'package:endy/components/Navbar.dart';
import 'package:endy/main.dart';
import 'package:endy/utils/index.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tap_canvas/tap_canvas.dart';
import 'package:typesense/typesense.dart';
import 'dart:math' as Math;

class GlobalWidgetRoute extends StatefulWidget {
  const GlobalWidgetRoute({
    super.key,
  });

  @override
  State<GlobalWidgetRoute> createState() => _GlobalWidgetRouteState();
}

class _GlobalWidgetRouteState extends State<GlobalWidgetRoute> {
  final client = Client(typesenseConfig);
  double _top = 0;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return TapCanvas(
      child: BlocConsumer<GlobalBloc, GlobalState>(
        listener: (context, state) {
          if (state.internetConnectionLost) {
            ShowTopSnackBar(
                context,
                error: state.internetConnectionLost,
                info: !state.internetConnectionLost,
                state.internetConnectionLost == true
                    ? "Internet əlaqəsi yoxdur"
                    : "Internet əlaqəsi quruldu");
          }

          if (state.userData != null &&
              !kIsWeb &&
              state.userData!.subscribedCompanies.length > 0) {
            for (var sub in state.userData!.subscribedCompanies) {
              FirebaseMessaging.instance.subscribeToTopic(sub);
            }
          }
        },
        listenWhen: (previous, current) =>
            previous.internetConnectionLost != current.internetConnectionLost ||
            previous.authStatus != current.authStatus,
        builder: (context, state) {
          if (state.categories.isEmpty ||
              state.companies.isEmpty ||
              state.authStatus == GlobalAuthStatus.loading) {
            return const Scaffold(
              body: Align(
                alignment: Alignment.center,
                child: SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(
                      color: Color(mainColor),
                    )),
              ),
            );
          }
          return w < 1024
              ? AutoRouter()
              : Scaffold(
                  backgroundColor: Colors.white,
                  body: Column(
                      // controller: controller,
                      // shrinkWrap: true,
                      children: [
                        Navbar(),
                        Flexible(
                          child: AutoRouter(
                            placeholder: (c) {
                              return Align(
                                alignment: Alignment.center,
                                child: SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: CircularProgressIndicator(
                                      color: Color(mainColor),
                                    )),
                              );
                            },
                          ),
                        ),
                      ]),
                );
        },
      ),
    );
  }
}


//  Stack(
//                       // controller: controller,
//                       // shrinkWrap: true,
//                       children: [
//                         AnimatedPositioned(
//                             duration: const Duration(milliseconds: 333),
//                             top: _top,
//                             child: Navbar()),
//                         NotificationListener<ScrollNotification>(
//                           onNotification: (notification) {
//                             final metrices = notification.metrics;
//                             if (metrices.axis == Axis.vertical) {
//                               if (metrices.pixels < 75 && _top == -75) {
//                                 setState(() {
//                                   _top = 0;
//                                 });
//                               }
//                               if (metrices.pixels >= 75 && _top != -75) {
//                                 setState(() {
//                                   _top = -75;
//                                 });
//                               }
//                             }

//                             return false;
//                           },
//                           child: AnimatedPadding(
//                             duration: const Duration(milliseconds: 333),
//                             padding:
//                                 EdgeInsets.only(top: Math.max(0, _top + 75)),
//                             child: AutoRouter(
//                               placeholder: (c) {
//                                 return Align(
//                                   alignment: Alignment.center,
//                                   child: SizedBox(
//                                       width: 50,
//                                       height: 50,
//                                       child: CircularProgressIndicator(
//                                         color: Color(mainColor),
//                                       )),
//                                 );
//                               },
//                             ),
//                           ),
//                         ),
//                       ])