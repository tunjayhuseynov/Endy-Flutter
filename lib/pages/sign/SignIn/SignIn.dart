import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:endy/MainBloc/GlobalBloc.dart';
import 'package:endy/Pages/Sign/SignIn/Signin_Bloc.dart';
import 'package:endy/components/tools/button.dart';
import 'package:endy/route/router_names.dart';
import 'package:endy/utils/index.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class SignInRoute extends StatelessWidget {
  const SignInRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => SigninBloc(), child: SignInRouteWrapper());
  }
}

class SignInRouteWrapper extends StatelessWidget {
  const SignInRouteWrapper({Key? key}) : super(key: key);

  Future<void> onLogIn(
      BuildContext context, BuildContext stateContext, String phone) async {
    try {
      await stateContext.read<SigninBloc>().login();
      var c = await context
          .pushNamed(APP_PAGE.OTP.toName, pathParameters: {"phone": phone});
      if (c != null) {
        context.read<SigninBloc>().setLoading(true);

        final userData = await FirebaseFirestore.instance
            .collection("users")
            .where("phone", isEqualTo: phone)
            .get();
        final userExist = userData.docs.isEmpty;
        if (userExist) {
          throw Exception("İstifadəçi mövcud deyil");
        }
        await FirebaseAuth.instance
            .signInWithCredential(c as PhoneAuthCredential);
        stateContext.read<GlobalBloc>().setAll();
        context.pushNamed(APP_PAGE.HOME.toName);
      }
    } catch (e) {
      print(e);
      ShowTopSnackBar(
          context, error: true, e.toString().replaceAll("Exception: ", ""));
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocBuilder<SigninBloc, SigninState>(
      builder: (ctx, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 25),
                  width:
                      size.width < 768 ? size.width / 1.2 : size.width * 0.30,
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
                      IntlPhoneField(
                        pickerDialogStyle: PickerDialogStyle(
                          searchFieldInputDecoration: const InputDecoration(
                            hintText: "Axtarış",
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        disableLengthCheck: true,
                        style: TextStyle(fontSize: 15),
                        decoration: InputDecoration(
                          filled: true,
                          helperText: "Misal: 77 123 45 67",
                          hintText: "Nömrənizi daxil edin",
                          hintStyle: TextStyle(fontSize: 15),
                          labelStyle: TextStyle(fontSize: 15),
                          fillColor: Colors.grey[200],
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            borderSide: BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                        ),
                        initialCountryCode: 'AZ',
                        invalidNumberMessage: 'Nömrə düzgün deyil',
                        onChanged: (phone) {
                          ctx.read<SigninBloc>().setPhone(phone.number
                                  .startsWith("0")
                              ? phone.countryCode + phone.number.substring(1)
                              : phone.completeNumber);
                        },
                      ),
                      state.error
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
                        fn: () async {
                          try {
                            onLogIn(context, ctx, state.phone);
                            context.read<SigninBloc>().setLoading(false);
                          } catch (e) {
                            print(e);
                            context.read<SigninBloc>().setLoading(false);
                            ShowTopSnackBar(
                                context,
                                error: true,
                                e.toString().replaceAll("Exception: ", ""));
                          }
                        },
                        width: size.width,
                        isLoading: state.isLoading,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
