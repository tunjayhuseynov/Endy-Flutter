import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:endy/Pages/Sign/Register/Register_Bloc.dart';
import 'package:endy/components/tools/button.dart';
import 'package:endy/components/tools/input.dart';
import 'package:endy/route/router_names.dart';
import 'package:endy/types/user.dart';
import 'package:endy/utils/index.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class Registration extends StatefulWidget {
  const Registration({Key? key}) : super(key: key);

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  TextEditingController name = TextEditingController();
  TextEditingController mail = TextEditingController();

  Future<void> register(
      {required String name,
      required String? mail,
      required String phone,
      required DateTime? selectedDate}) async {
    try {
      if (selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Doğum tarixini daxil edin")));
        return;
      }
      await context.read<RegisterBloc>().phoneVerification(name);
      var result = await context
          .pushNamed(APP_PAGE.OTP.toName, pathParameters: {"phone": phone});
      if (result != null) {
        var data = await FirebaseAuth.instance
            .signInWithCredential(result as PhoneAuthCredential);
        UserData newUser;
        newUser = UserData(
          id: data.user!.uid,
          birthDate: (selectedDate.millisecondsSinceEpoch / 1000).round(),
          role: "user",
          name: name,
          phone: phone,
          mail: mail ?? "",
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
            .doc(data.user?.uid)
            .set(newUser.toJson());
        context.pushNamed(APP_PAGE.HOME.toName);
      }
    } catch (e) {
      showTopSnackBar(
        Overlay.of(context),
        displayDuration: const Duration(milliseconds: 1000),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomSnackBar.error(
              message: e.toString().replaceAll("Exception: ", ""),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    name.dispose();
    mail.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    name.addListener(() {
      context.read<RegisterBloc>().setName(name.text);
    });

    mail.addListener(() {
      context.read<RegisterBloc>().setMail(mail.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocBuilder<RegisterBloc, RegisterState>(
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () async {
            context.pushNamed(APP_PAGE.SIGN_MAIN.toName);
            return false;
          },
          child: Scaffold(
              backgroundColor: Colors.white,
              body: Stack(
                children: [
                  Center(
                      child: SizedBox(
                    width: size.width < 768
                        ? size.width * 0.85
                        : size.width * 0.30,
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        SizedBox(height: size.height * 0.09),
                        const Text('Qeydiyyatdan keç',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1)),
                        const SizedBox(height: 15),
                        const Text("Qeydiyyat üçün məlumatlarınızı daxil edin",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey,
                                letterSpacing: 0.1)),
                        const SizedBox(height: 15),
                        CustomTextField(
                          hintText: "Ad",
                          controller: name,
                          error: validationWithEmpty(name.text),
                          errorText: "Minimum 3 hərf lazımdır",
                        ),
                        const SizedBox(height: 15),
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
                            hintStyle: TextStyle(fontSize: 15),
                            labelStyle: TextStyle(fontSize: 15),
                            helperText: "Misal: 50 765 43 21",
                            hintText: "Nömrənizi daxil edin",
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
                            context.read<RegisterBloc>().setPhone(phone.number
                                    .startsWith("0")
                                ? phone.countryCode + phone.number.substring(1)
                                : phone.completeNumber);
                          },
                        ),
                        const SizedBox(height: 15),
                        CustomTextField(
                          hintText: "E-mail",
                          controller: mail,
                          keyboardType: TextInputType.emailAddress,
                          // error: item["error"],
                          errorText: "Düzgün e-mail daxil edin",
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        ElevatedButton(
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all<
                                      EdgeInsetsGeometry?>(
                                  const EdgeInsets.all(20.0)),
                              elevation: MaterialStateProperty.all<double?>(0),
                              backgroundColor:
                                  MaterialStateProperty.all<Color?>(
                                Colors.grey[200],
                              ),
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              minimumSize: MaterialStateProperty.all<Size>(
                                  Size((size.width * 0.7), 60)),
                            ),
                            onPressed: () {
                              context
                                  .read<RegisterBloc>()
                                  .setDatePicker(context);
                            },
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                state.selectedDate == null
                                    ? 'Doğum Tarixi'
                                    : DateFormat('yyyy-MM-dd')
                                        .format(state.selectedDate!),
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Colors.grey[500], fontSize: 16),
                              ),
                            )),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                await launchUrl(Uri.parse(state.docLink),
                                    mode: LaunchMode.externalApplication);
                              },
                              child: Text(
                                "Gizlilik müqaviləsi",
                                style: TextStyle(
                                    color: Colors.blue[300],
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                            Checkbox(
                              value: state.isPrivacyChecked,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              onChanged: (val) {
                                if (val != null) {
                                  context
                                      .read<RegisterBloc>()
                                      .setIsPrivacyChecked(val);
                                }
                              },
                              activeColor: const Color(mainColor),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        PrimaryButton(
                            text: "Qeydiyyatdan keç",
                            isLoading: state.isLoading,
                            fn: () async {
                              context.read<RegisterBloc>().setIsLoading(true);
                              await register(
                                  mail: state.mail,
                                  name: state.name,
                                  phone: state.phone,
                                  selectedDate: state.selectedDate!);
                              context.read<RegisterBloc>().setIsLoading(false);
                            }),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Hesabınız var? ",
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500),
                            ),
                            GestureDetector(
                              onTap: () {
                                context.pushNamed(APP_PAGE.SIGN_IN.toName);
                              },
                              child: const Text(
                                "Daxil olun",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Color(mainColor)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                      ],
                    ),
                  ))
                ],
              )),
        );
      },
    );
  }
}
