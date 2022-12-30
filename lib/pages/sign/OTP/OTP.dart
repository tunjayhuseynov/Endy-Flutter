import 'package:endy/MainBloc/GlobalBloc.dart';
import 'package:endy/Pages/Sign/OTP/OTP_Bloc.dart';
import 'package:endy/utils/index.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';

class OtpParams {
  String phone;
  String? name;
  String? mail;
  DateTime? selectedDate;
  bool? isForgotPassword = false;

  OtpParams({
    required this.phone,
    this.name,
    this.mail,
    this.selectedDate,
    this.isForgotPassword,
  });
}

class OTP extends StatefulWidget {
  final OtpParams params;
  const OTP({Key? key, required this.params}) : super(key: key);

  @override
  State<OTP> createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  @override
  void initState() {
    super.initState();
    context.read<OTPBloc>().setErrorMessage("");
    resend(widget.params.phone);
  }

  final TextEditingController _smsController = TextEditingController();

  resend(String phone) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      timeout: const Duration(seconds: 120),
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential credential) async {},
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String verificationId, int? resendToken) {
        context.read<OTPBloc>().setCode(verificationId);
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
    return BlocBuilder<OTPBloc, OTPState>(
      builder: (context, state) {
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
                    controller: _smsController,
                    length: 6,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: focusedPinTheme,
                    submittedPinTheme: submittedPinTheme,
                    pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                    showCursor: true,
                    errorText: state.errorMessage,
                    forceErrorState: state.errorMessage.isNotEmpty,
                    onCompleted: (pin) async {
                      try {
                        context
                            .read<GlobalBloc>()
                            .setAuthLoading(GlobalAuthStatus.loading);
                        await context.read<OTPBloc>().verify(
                              pin,
                              state.code,
                              widget.params.selectedDate,
                              widget.params.name,
                              widget.params.phone,
                              widget.params.mail,
                            );
                        if (!mounted) return;
                        context.read<GlobalBloc>().setAll();
                        await Navigator.pushNamedAndRemoveUntil(
                            context, "/home", (route) => false);
                      } catch (e) {
                        context
                            .read<GlobalBloc>()
                            .setAuthLoading(GlobalAuthStatus.notLoggedIn);
                        if (!mounted) return;
                        context.read<OTPBloc>().setErrorMessage(
                            e.toString().replaceAll("Exception: ", ""));
                      }
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
                                context.read<OTPBloc>().setErrorMessage(""),
                                _smsController.clear()
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
      },
    );
  }
}
