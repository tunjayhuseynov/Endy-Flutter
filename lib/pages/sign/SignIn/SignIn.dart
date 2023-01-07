import 'package:endy/Pages/Sign/SignIn/Signin_Bloc.dart';
import 'package:endy/components/tools/button.dart';
import 'package:endy/Pages/sign/OTP/OTP.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class SignIn extends StatelessWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => SigninBloc(),
      child: BlocBuilder<SigninBloc, SigninState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: false,
            body: Stack(
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 25),
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
                            helperText: "Misal: 50 765 43 21",
                            hintText: "Nömrənizi daxil edin",
                            hintStyle: TextStyle(fontSize: 15),
                            labelStyle: TextStyle(fontSize: 15),
                            fillColor: Colors.grey[200],
                            border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                              borderSide: BorderSide(
                                width: 0,
                                style: BorderStyle.none,
                              ),
                            ),
                          ),
                          initialCountryCode: 'AZ',
                          invalidNumberMessage: 'Nömrə düzgün deyil',
                          onChanged: (phone) {
                            context.read<SigninBloc>().setPhone(phone.number
                                    .startsWith("0")
                                ? phone.countryCode + phone.number.substring(1)
                                : phone.completeNumber);
                          },
                        ),
                        state.error
                            ? Container(
                                margin: const EdgeInsets.only(bottom: 15),
                                child: const Text(
                                    "Məlumatlarınızı düzgün deyil",
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
                              var navigator = Navigator.of(context);
                              await context.read<SigninBloc>().login();

                              await navigator.pushNamed('/sign/otp',
                                  arguments: OtpParams(phone: state.phone));
                            } catch (e) {
                              showTopSnackBar(
                                Overlay.of(context)!,
                                displayDuration:
                                    const Duration(milliseconds: 1000),
                                CustomSnackBar.error(
                                  message: e
                                      .toString()
                                      .replaceAll("Exception: ", ""),
                                ),
                              );
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
      ),
    );
  }
}
