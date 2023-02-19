import 'package:auto_route/auto_route.dart';
import 'package:endy/MainBloc/GlobalBloc.dart';
import 'package:endy/Pages/main/Home/HomePage/HomePageContainer.dart';
import 'package:endy/Pages/main/Onboard/Onboard.dart';
import 'package:endy/Pages/sign/Main.dart';
import 'package:endy/utils/index.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainProvider extends StatefulWidget {
  const MainProvider({Key? key}) : super(key: key);

  @override
  State<MainProvider> createState() => _MainProviderState();
}

class _MainProviderState extends State<MainProvider> {
  @override
  void initState() {
    if (!kIsWeb) {
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        if (message.data["onClick"] != null) {
          context.router.pushNamed("/home/detail/" + message.data["onClick"]);
        }
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GlobalBloc, GlobalState>(
        listenWhen: (previous, current) =>
            previous.authStatus != current.authStatus,
        listener: (context, state) {
          if (state.userData != null &&
              !kIsWeb &&
              state.userData!.subscribedCompanies.length > 0) {
            for (var sub in state.userData!.subscribedCompanies) {
              FirebaseMessaging.instance.subscribeToTopic(sub);
            }
          }
        },
        builder: (BuildContext context, state) {
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
                ? const OnboardRoute()
                : const MainContainerRoute();
          }
          return const SignRoute();
        });
  }
}
