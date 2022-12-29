import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:endy/components/tools/button.dart';
import 'package:endy/components/tools/input.dart';
import 'package:endy/utils/index.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewPassword extends StatefulWidget {
  const NewPassword({Key? key}) : super(key: key);

  @override
  State<NewPassword> createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  TextEditingController password = TextEditingController();
  TextEditingController repeatPass = TextEditingController();

  @override
  void dispose() {
    password.dispose();
    repeatPass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    List<Map<String, dynamic>> textFields = [
      {
        "hintText": "Yeni Şifrə",
        "controller": password,
        "error": validationWithEmpty(password.text, num: 6),
        "errorText": "Minimum 6 hərf lazımdır"
      },
      {
        "hintText": "Təkrar şifrə",
        "controller": repeatPass,
        "error": repeatPasswordValidation(password.text, repeatPass.text),
        "errorText": "Şifrə eyni deyil"
      }
    ];
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
                  "Yeni Şifrə",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: size.width * 0.7,
                  child: Text(
                    "Yeni şifrənizi daxil edib təstiqləyərək davam edin",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w400),
                  ),
                ),
                const SizedBox(height: 40),
                ...textFields.map((item) {
                  return Column(
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      CustomTextField(
                        hintText: item["hintText"],
                        controller: item["controller"],
                        initValue: item["initValue"],
                        inputFormatter: item["inputFormatter"],
                        keyboardType: item["keyboardType"],
                        error: item["error"],
                        errorText: item["errorText"],
                      )
                    ],
                  );
                }),
                const SizedBox(height: 40),
                PrimaryButton(
                  text: 'Növbəti',
                  fn: () async {
                    if (validationWithEmpty(password.text, num: 6) != true &&
                        repeatPasswordValidation(
                                password.text, repeatPass.text) !=
                            true) {
                      final user = FirebaseAuth.instance.currentUser;

                      if (user != null) {
                        await user.updatePassword(password.text);
                      }
                      if (!mounted) return;
                      await Navigator.pushNamedAndRemoveUntil(
                          context, "/home", (route) => false);
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
