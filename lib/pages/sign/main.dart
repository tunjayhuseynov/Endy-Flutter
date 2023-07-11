import 'package:auto_size_text/auto_size_text.dart';
import 'package:endy/MainBloc/GlobalBloc.dart';
import 'package:endy/components/tools/button.dart';
import 'package:endy/route/router_names.dart';
import 'package:endy/utils/index.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SignRoute extends StatefulWidget {
  const SignRoute({Key? key}) : super(key: key);

  @override
  State<SignRoute> createState() => _SignRouteState();
}

class _SignRouteState extends State<SignRoute> {
  anonymSignIn() async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
      print("Signed in with temporary account.");
      context.read<GlobalBloc>().setAuthLoading(GlobalAuthStatus.loggedIn);
      context.pushNamed(APP_PAGE.HOME.toName);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          print("Anonymous auth hasn't been enabled for this project.");
          break;
        default:
          print("Unknown error.");
      }
    }
  }

  String label =
      "1000-dən çox market və mağazalardakı endirimlərdən yararlanın";
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              height:
                  size.width < 768 ? size.height * 0.55 : size.height * 0.35,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: AlignmentDirectional.center,
                children: [
                  if (size.width < 768)
                    Positioned(
                        top: -100,
                        width: size.width,
                        height: size.height * 0.60,
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: Image.asset('assets/sign.png'),
                        )),
                  Positioned(
                    bottom: 0,
                    child: Padding(
                        padding: const EdgeInsets.only(left: 7),
                        child: Image.asset('assets/logos/logod.png',
                            width: size.width * 0.3)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: (size.width * 0.75),
              child: AutoSizeText(
                  maxLines: 2,
                  maxFontSize: 16,
                  minFontSize: 8,
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Color(mainColor), fontWeight: FontWeight.w500)),
            ),
            const SizedBox(height: 20),
            // PrimaryButton(
            //   width: size.width < 768 ? size.width * 0.75 : null,
            //   text: "Daxil ol",
            //   fn: () async => {context.router.pushNamed('/sign/signin')},
            // ),
            // const SizedBox(height: 20),
            // SecondaryButton(
            //     text: "Hesab aç",
            //     width: size.width < 768 ? size.width * 0.75 : null,
            //     fn: () => {context.router.pushNamed("/sign/registration")}),
            // const SizedBox(height: 20),
            SecondaryButton(
                color: 0xFFFFFFFF,
                text: "Davam et",
                // text: "Qeydiyyatsız dəvam et",
                width: size.width < 768 ? size.width * 0.75 : null,
                fn: () => {anonymSignIn()}),
          ],
        ),
      ),
    );
  }
}
