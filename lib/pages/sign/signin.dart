import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:endy/components/tools/button.dart';
import 'package:endy/components/tools/input.dart';
import 'package:endy/pages/sign/otp.dart';
import 'package:endy/providers/UserChange.dart';
import 'package:endy/types/user.dart';
import 'package:endy/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  MaskTextInputFormatter phone = MaskTextInputFormatter(
      mask: "#### ## ###-##-##",
      filter: {"#": RegExp(r'[0-9 +]')},
      initialText: "+994",
      type: MaskAutoCompletionType.lazy);
  TextEditingController password = TextEditingController();
  TextEditingController mail = TextEditingController();
  bool isLoading = false;
  bool error = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    password.dispose();
    super.dispose();
  }

  Future<void> login(void Function(UserData? user) setUser) async {
    try {
      if (phone.getUnmaskedText().isEmpty && mail.text.isEmpty) {
        throw Exception(
            "Zəhmət olmasa, mobil nömrəni və ya e-poçt ünvanını düzgün yazın.");
      }

      if (phone.getUnmaskedText().length != 13 && mail.text.isEmpty) {
        throw Exception("Zəhmət olmasa, düzgün nömrəni daxil edin daxil edin");
      }
      // if (!RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
      //         .hasMatch(mail.text) &&
      //     phone.getUnmaskedText().isEmpty) {
      //   throw Exception("Zəhmət olmasa, düzgün e-poçt ünvamı daxil edin");
      // }
      // if (validation(password.text, num: 6) == true) {
      //   throw Exception("Zəhmət olmasa, şifrəni düzgün daxil edin");
      // }
      setState(() {
        isLoading = true;
      });

      var instance = FirebaseFirestore.instance.collection('users');
      Query<Map<String, dynamic>> query;

      // if (mail.text.isEmpty) {
      query = instance.where("phone", isEqualTo: phone.getUnmaskedText());
      // } else {
      //   query = instance.where("mail", isEqualTo: mail.text);
      // }

      final doc = await query.get();

      if (doc.docs.isEmpty) {
        throw Exception("İstifadəçi tapılmadı");
      }

      if (!mounted) throw Exception("Widget is not mounted");

      await Navigator.of(context).pushNamed('/sign/otp',
          arguments: OtpParams(
              phone: doc.docs[0].data()["phone"], password: password.text));

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      showTopSnackBar(
        Overlay.of(context)!,
        CustomSnackBar.error(
          message: e.toString().replaceAll("Exception: ", ""),
        ),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final user = Provider.of<UserChange>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Center(
            child: SizedBox(
              width: size.width / 1.2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: size.height * 0.075),
                  const Text('Daxil ol',
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1)),
                  const SizedBox(height: 10),
                  const Text("Daxil olmaq üçün məlumatlarınızı yazın",
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                          letterSpacing: 0.1)),
                  const SizedBox(height: 30),
                  CustomTextField(
                    keyboardType: TextInputType.phone,
                    hintText: "Mobil nömrəniz",
                    inputFormatter: phone,
                    initValue: "+994",
                  ),
                  // const SizedBox(height: 10),
                  // const Text("Və ya",
                  //     style: TextStyle(
                  //         fontSize: 15,
                  //         color: Colors.grey,
                  //         letterSpacing: 0.1,
                  //         fontWeight: FontWeight.w600)),
                  // const SizedBox(height: 10),
                  // CustomTextField(
                  //     hintText: "E-poçt ünvanınız",
                  //     controller: mail,
                  //     errorText: "Düzgün e-mail daxil edin"),
                  // const SizedBox(height: 30),
                  // CustomTextField(
                  //     hintText: "Şifrə",
                  //     controller: password,
                  //     error: validationWithEmpty(password.text)),
                  // const SizedBox(height: 15),
                  //show error message
                  error
                      ? Container(
                          margin: const EdgeInsets.only(bottom: 15),
                          child: const Text("Məlumatlarınızı düzgün deyil",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.red,
                                  letterSpacing: 0.1)))
                      : const SizedBox(
                          height: 15,
                        ),
                  PrimaryButton(
                    text: 'Daxil ol',
                    fn: () => {
                      login(user.setUser),
                    },
                    width: size.width,
                    isLoading: isLoading,
                  ),
                  const SizedBox(height: 15),
                  // TextButton(
                  //     onPressed: () async =>
                  //         {Navigator.of(context).pushNamed('/sign/forgot')},
                  //     style: ButtonStyle(
                  //         overlayColor: MaterialStateProperty.all<Color>(
                  //             Colors.transparent)),
                  //     child: const Text("Şifrəmi unutmuşam",
                  //         style: TextStyle(color: Colors.grey))),
                  // const SizedBox(height: 45),
                  const Spacer(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
