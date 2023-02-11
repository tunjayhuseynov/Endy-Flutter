import 'package:endy/MainBloc/GlobalBloc.dart';
import 'package:endy/Pages/main/Home/SearchPage/Search.dart';
import 'package:endy/Pages/main/Home/SearchPage/Search_Page_Bloc.dart';
import 'package:endy/Pages/main/Onboard/Onboard.dart';
import 'package:endy/components/Navbar.dart';
import 'package:endy/main.dart';
import 'package:endy/utils/index.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tap_canvas/tap_canvas.dart';
import 'package:typesense/typesense.dart';

class GlobalWidget extends StatefulWidget {
  final Widget child;
  final bool disallowAnonym;
  final String urlPath;
  const GlobalWidget(
      {super.key,
      required this.child,
      required this.disallowAnonym,
      required this.urlPath});

  @override
  State<GlobalWidget> createState() => _GlobalWidgetState();
}

class _GlobalWidgetState extends State<GlobalWidget> {
  final client = Client(typesenseConfig);

  Widget render(double w) {
    return w < 1024
        ? widget
        : Scaffold(
            backgroundColor: Colors.white,
            body: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: ListView(
                  // controller: controller,
                  shrinkWrap: true,
                  children: [
                    // if (setting.name != null &&
                    //     !setting.name!.contains("/sign") &&
                    //     !needSign)
                    Navbar(),
                    BlocBuilder<SearchPageBloc, SearchPageState>(
                        buildWhen: (previous, current) =>
                            (previous.search.isEmpty &&
                                current.search.isNotEmpty) ||
                            (previous.search.isNotEmpty &&
                                current.search.isEmpty),
                        builder: (context, state) {
                          return Padding(
                              padding: const EdgeInsets.only(top: 40),
                              child: state.search.length > 0
                                  ? SearchPage(client: client)
                                  : widget);
                        }),
                  ]),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
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
        // buildWhen: (previous, current) =>
        //     current.authStatus == GlobalAuthStatus.loggedIn,
        builder: (context, state) {
          if (state.authStatus == GlobalAuthStatus.loggedIn ||
              state.authStatus == GlobalAuthStatus.loading) {
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
            return state.userData != null && state.userData!.isFirstEnter
                ? const Onboard()
                : widget.child;
          }
          return widget.child;
        },
      ),
    );
  }
}
