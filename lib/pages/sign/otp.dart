import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:endy/MainBloc/GlobalBloc.dart';
import 'package:endy/providers/UserChange.dart';
import 'package:endy/types/user.dart';
import 'package:endy/utils/index.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class OtpParams {
  String phone;
  String? name;
  String? mail;
  DateTime? selectedDate;
  String password;
  bool? isForgotPassword = false;

  OtpParams(
      {required this.phone,
      this.name,
      this.mail,
      this.selectedDate,
      this.isForgotPassword,
      required this.password});
}

class OTP extends StatefulWidget {
  final OtpParams params;
  const OTP({Key? key, required this.params}) : super(key: key);

  @override
  State<OTP> createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  String error = "";
  String code = "";

  Future<bool> verify(String sms, String code, DateTime? selectedDate,
      String? name, String phone, String? mail, String password,
      [bool? isForgotPassword = false]) async {
    try {
      PhoneAuthCredential credential =
          PhoneAuthProvider.credential(verificationId: code, smsCode: sms);

      final userData = await FirebaseFirestore.instance
          .collection("users")
          .where("phone", isEqualTo: phone)
          .get();

      final userExist = userData.docs.isNotEmpty;

      if (isForgotPassword == true) {
        if (!userExist) throw Exception("User not found");
        await FirebaseAuth.instance.signInWithCredential(credential);
        if (!mounted) return false;
        await Navigator.pushNamedAndRemoveUntil(
            context, "/sign/new-password", (route) => false);
        return true;
      }

      UserCredential user;
      if (name != null) {
        if (userExist) throw Exception("User already exists");
        user = await FirebaseAuth.instance.signInWithCredential(credential);
      } else {
        if (!userExist) throw Exception("User not found");
        user = await FirebaseAuth.instance.signInWithCredential(credential);
      }

      if (user.user?.uid != null) {
        UserData newUser;
        if (selectedDate != null && name != null && mail != null) {
          newUser = UserData(
            id: user.user!.uid,
            birthDate: (selectedDate.millisecondsSinceEpoch / 1000).round(),
            role: "user",
            name: name,
            phone: phone,
            mail: mail,
            isFirstEnter: true,
            list: [],
            bonusCard: [],
            liked: [],
            subscribedCompanies: [],
            notifications: [],
            notificationSeenTime:
                (DateTime.now().millisecondsSinceEpoch / 1000).round(),
            createdAt: (DateTime.now().millisecondsSinceEpoch / 1000).round(),
          );

          await FirebaseFirestore.instance
              .collection("users")
              .doc(user.user?.uid)
              .set(newUser.toJson());
        } else {
          newUser = UserData.fromJson((await FirebaseFirestore.instance
                  .collection("users")
                  .doc(user.user!.uid)
                  .get())
              .data()!);
        }

        if (!mounted) return false;
        context.read<GlobalBloc>().setAll();
      }
      if (!mounted) return false;
      await Navigator.pushNamedAndRemoveUntil(
          context, "/home", (route) => false);
      return true;
    } catch (e) {
      throw Future.error(Exception(e));
    }
  }

  @override
  void initState() {
    super.initState();
    resend(widget.params.phone);
  }

  resend(String phone) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      timeout: const Duration(seconds: 120),
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential credential) async {},
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          code = verificationId;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final defaultPinTheme = PinTheme(
      width: 48,
      height: 48,
      textStyle: const TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(232, 232, 232, 1),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color(mainColor)),
      borderRadius: BorderRadius.circular(20),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: const Color.fromRGBO(234, 239, 243, 1),
      ),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.only(top: 100),
          width: size.width,
          height: size.height,
          child: Column(
            children: [
              const Text(
                "Mobil nömrənizə OTP kodu göndərildi",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: size.width * 0.7,
                child: Text(
                  "Mobil nömrənizə göndərilmiş kodu daxil edin",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w400),
                ),
              ),
              const SizedBox(height: 40),
              Pinput(
                length: 6,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusedPinTheme,
                submittedPinTheme: submittedPinTheme,
                pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                showCursor: true,
                errorText: error,
                forceErrorState: error.isNotEmpty,
                onCompleted: (pin) async {
                  try {
                    await verify(
                        pin,
                        code,
                        widget.params.selectedDate,
                        widget.params.name,
                        widget.params.phone,
                        widget.params.mail,
                        widget.params.password,
                        widget.params.isForgotPassword);
                    setState(() {
                      error = "PIN kodu düzgün deyil";
                    });
                  } catch (e) {}
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Kodu almadınız?",
                      style: TextStyle(color: Colors.grey[700])),
                  TextButton(
                      onPressed: () => {
                            resend(widget.params.phone),
                          },
                      child: const Text("Yenidən göndər",
                          style: TextStyle(color: Color(mainColor))))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
