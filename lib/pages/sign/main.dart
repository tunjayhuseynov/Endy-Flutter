import 'package:auto_size_text/auto_size_text.dart';
import 'package:endy/components/tools/button.dart';
import 'package:endy/utils/index.dart';
import 'package:flutter/material.dart';

class Sign extends StatefulWidget {
  const Sign({Key? key}) : super(key: key);

  @override
  State<Sign> createState() => _SignState();
}

class _SignState extends State<Sign> {
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
              height: size.height * 0.60,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: AlignmentDirectional.center,
                children: [
                  Positioned(
                      top: -100,
                      width: size.width,
                      height: size.height * 0.65,
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: Image.asset('assets/sign.png'),
                      )),
                  Positioned(
                    bottom: 0,
                    child: Padding(
                        padding: const EdgeInsets.only(left: 7),
                        child: Image.asset('assets/endimart.az.png',
                            width: size.width * 0.3)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
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
            PrimaryButton(
              width: size.width * 0.75,
              text: "Daxil ol",
              fn: () => {Navigator.pushNamed(context, '/sign/signin')},
            ),
            const SizedBox(height: 20),
            SecondaryButton(
                text: "Hesab aç",
                width: size.width * 0.75,
                fn: () => {Navigator.pushNamed(context, "/sign/registration")}),
          ],
        ),
      ),
    );
  }
}
