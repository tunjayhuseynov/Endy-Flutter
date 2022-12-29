import 'package:auto_size_text/auto_size_text.dart';
import 'package:endy/utils/index.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final void Function() fn;
  final double? width;
  final double? fontSize;
  final bool isLoading;
  final Widget? prefix;
  const PrimaryButton(
      {Key? key,
      required this.text,
      required this.fn,
      this.prefix,
      this.width,
      this.fontSize,
      this.isLoading = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ElevatedButton(
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all<Color>(const Color(mainColor)),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          minimumSize: MaterialStateProperty.all<Size>(
              Size((width ?? size.width * 0.7), 60)),
        ),
        onPressed: fn,
        child: isLoading
            ? Container(
                width: 24,
                height: 24,
                padding: const EdgeInsets.all(2.0),
                child: const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              )
            : prefix != null
                ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    prefix!,
                    const SizedBox(width: 10),
                    AutoSizeText(
                      minFontSize: 10,
                      maxFontSize: 16,
                      text,
                      style: TextStyle(fontSize: fontSize ?? 18),
                    )
                  ])
                : AutoSizeText(
                    minFontSize: 10,
                    maxFontSize: 16,
                    text,
                    style: TextStyle(fontSize: fontSize ?? 18),
                  ));
  }
}

class SecondaryButton extends StatelessWidget {
  final String text;
  final void Function() fn;
  final double? width;

  const SecondaryButton(
      {Key? key, required this.text, required this.fn, this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100.0),
              side: const BorderSide(
                color: Color(mainColor),
                width: 1.0,
              ),
            ),
          ),
          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
          foregroundColor:
              MaterialStateProperty.all<Color>(const Color(mainColor)),
          minimumSize: MaterialStateProperty.all<Size>(
              Size((width ?? size.width * 0.7), 60)),
        ),
        onPressed: fn,
        child: AutoSizeText(
          minFontSize: 10,
          maxFontSize: 16,
          text,
          style: const TextStyle(fontSize: 18),
        ));
  }
}
