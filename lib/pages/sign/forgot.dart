import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:endy/components/tools/button.dart';
import 'package:endy/components/tools/input.dart';
import 'package:endy/pages/sign/otp.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class Forgot extends StatefulWidget {
  const Forgot({Key? key}) : super(key: key);

  @override
  State<Forgot> createState() => _ForgotState();
}

class _ForgotState extends State<Forgot> {
  MaskTextInputFormatter phone = MaskTextInputFormatter(
      mask: "#### ## ###-##-##",
      filter: {"#": RegExp(r'[0-9] +')},
      initialText: "+994",
      type: MaskAutoCompletionType.lazy);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Center(
          child: Container(
            padding: const EdgeInsets.only(top: 100),
            width: size.width / 1.3,
            height: size.height,
            child: Column(
              children: [
                const Text(
                  "Şifrəni Sıfırla",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: size.width * 0.7,
                  child: Text(
                    "Yeni şifrə yaratmaq üçün mobil nömrənizi daxil edin",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w400),
                  ),
                ),
                const SizedBox(height: 40),
                CustomTextField(
                  keyboardType: TextInputType.phone,
                  hintText: "Mobil nömrəniz",
                  // controller: phone,
                  inputFormatter: phone,
                  initValue: "+994",
                ),
                const SizedBox(height: 40),
                PrimaryButton(
                  text: 'Göndər',
                  fn: () async {
                    try {
                      final userData = await FirebaseFirestore.instance
                          .collection("users")
                          .where("phone", isEqualTo: phone)
                          .get();

                      final userExist = userData.docs.isNotEmpty;
                      if (userExist) {
                        if (!mounted) return;
                        await Navigator.of(context).pushNamed('/sign/otp',
                            arguments: OtpParams(
                                phone: phone.getUnmaskedText(),
                                password: "",
                                isForgotPassword: true));
                      }
                    } catch (e) {
                      
                    }
                  },
                  width: size.width,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
