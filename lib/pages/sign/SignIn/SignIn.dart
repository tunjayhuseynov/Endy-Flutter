import 'package:endy/Pages/Sign/OTP/OTP.dart';
import 'package:endy/Pages/Sign/SignIn/Signin_Bloc.dart';
import 'package:endy/components/tools/button.dart';
import 'package:endy/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class SignIn extends StatelessWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => SigninBloc(),
      child: BlocBuilder<SigninBloc, SigninState>(
        builder: (context, state) {
          return ScaffoldWrapper(
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
      ),
    );
  }
}
