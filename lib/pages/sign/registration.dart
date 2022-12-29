import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:endy/components/tools/button.dart';
import 'package:endy/components/tools/input.dart';
import 'package:endy/pages/sign/otp.dart';
import 'package:endy/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class Registration extends StatefulWidget {
  const Registration({Key? key}) : super(key: key);

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  TextEditingController name = TextEditingController();
  MaskTextInputFormatter phone = MaskTextInputFormatter(
      mask: "#### ## ###-##-##",
      filter: {"#": RegExp(r'[0-9 +]')},
      initialText: "+994",
      type: MaskAutoCompletionType.lazy);
  TextEditingController mail = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController repeatPass = TextEditingController();

  DateTime? selectedDate;
  bool isLoading = false;

  bool isNeedVerification = false;
  String code = "";

  bool isPrivacyChecked = false;

  @override
  void dispose() {
    name.dispose();
    mail.dispose();
    password.dispose();
    repeatPass.dispose();
    super.dispose();
  }

  //Register a user into firebase authentication
  Future<void> register() async {
    if (validation(name.text) == true ||
        phone.getUnmaskedText().length != 13 ||
        // (mail.text.isNotEmpty && EmailValidator.validate(mail.text)) ||
        // validation(password.text, num: 6) == true ||
        // repeatPasswordValidation(password.text, repeatPass.text) == true ||
        isPrivacyChecked != true) {
      throw Exception("Zəhmət olmasa bütün xanaları doldurun");
    }
    // if (password.text != repeatPass.text) {
    //   throw Exception("Şifrələr eyni deyil");
    // }
    if (selectedDate == null) {
      throw Exception("Zəhmət olmasa doğum tarixini seçin");
    }

    final list = await FirebaseFirestore.instance
        .collection("users")
        .where("phone", isEqualTo: phone.getUnmaskedText())
        .get();
    if (list.docs.isNotEmpty) {
      throw Exception("Bu istifadəçi artıq mövcuddur");
    }
    // if(!mounted) return;

    // await Navigator.of(context).pushNamed('/sign/otp',
    //     arguments: OtpParams(
    //         mail: mail.text,
    //         name: name.text,
    //         selectedDate: selectedDate,
    //         phone: "+994${phone.getUnmaskedText()}",
    //         password: password.text));
    // var user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
    //     email: mail.text, password: password.text);
  }

  //Show date picker
  void showDatePicker() {
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime(1950, 1, 1),
        maxTime: DateTime(2050, 12, 31),
        onChanged: (date) {}, onConfirm: (date) {
      setState(() {
        selectedDate = date;
      });
    }, currentTime: DateTime.now(), locale: LocaleType.en);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    List<Map<String, dynamic>> textFields = [
      {
        "hintText": "Ad",
        "controller": name,
        "error": validationWithEmpty(name.text),
        "errorText": "Minimum 3 hərf lazımdır"
      },
      {
        "hintText": "Mobil nömrə",
        "inputFormatter": phone,
        "initValue": "+994",
        "keyboardType": TextInputType.phone,
        "errorText": "Minimum 3 hərf lazımdır"
      },
      {
        "hintText": "E-mail",
        "controller": mail,
        "keyboardType": TextInputType.emailAddress,
        "errorText": "Düzgün e-mail daxil edin"
      },
      // {
      //   "hintText": "Şifrə",
      //   "controller": password,
      //   "error": validationWithEmpty(password.text, num: 6),
      //   "errorText": "Minimum 6 hərf lazımdır"
      // },
      // {
      //   "hintText": "Təkrar şifrə",
      //   "controller": repeatPass,
      //   "error": repeatPasswordValidation(password.text, repeatPass.text),
      //   "errorText": "Şifrə eyni deyil"
      // }
    ];
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Center(
                child: SizedBox(
              width: size.width * 0.85,
              child: ListView(
                children: [
                  SizedBox(height: size.height * 0.05),
                  const Text('Qeydiyyatdan keç',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1)),
                  const SizedBox(height: 10),
                  const Text("Qeydiyyat üçün məlumatlarınızı daxil edin ",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                          letterSpacing: 0.1)),
                  const SizedBox(height: 10),
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
                  const SizedBox(
                    height: 15,
                  ),
                  ElevatedButton(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry?>(
                            const EdgeInsets.all(20.0)),
                        elevation: MaterialStateProperty.all<double?>(0),
                        backgroundColor: MaterialStateProperty.all<Color?>(
                          Colors.grey[200],
                        ),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        minimumSize: MaterialStateProperty.all<Size>(
                            Size((size.width * 0.7), 60)),
                      ),
                      onPressed: () {
                        DatePicker.showDatePicker(context,
                            showTitleActions: true,
                            minTime: DateTime(1950, 1, 1),
                            maxTime: DateTime.now(), onChanged: (date) {
                          setState(() {
                            selectedDate = date;
                          });
                        },
                            onConfirm: (date) {},
                            currentTime: selectedDate ?? DateTime.now(),
                            locale: LocaleType.az);
                      },
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          selectedDate == null
                              ? 'Doğum Tarixi'
                              : DateFormat('yyyy-MM-dd').format(selectedDate!),
                          textAlign: TextAlign.left,
                          style:
                              TextStyle(color: Colors.grey[500], fontSize: 16),
                        ),
                      )),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text(
                        "Gizlilik müqaviləsi",
                        style: TextStyle(color: Colors.black54),
                      ),
                      Checkbox(
                        value: isPrivacyChecked,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        onChanged: (val) {
                          setState(() {
                            if (val != null) {
                              isPrivacyChecked = val;
                            }
                          });
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
                      isLoading: isLoading,
                      fn: () => {
                            register().then((value) {
                              Navigator.of(context).pushNamed('/sign/otp',
                                  arguments: OtpParams(
                                      phone: phone.getUnmaskedText(),
                                      name: name.text,
                                      mail: mail.text,
                                      selectedDate: selectedDate!,
                                      password: password.text));
                            }).catchError((e) {
                              showTopSnackBar(
                                Overlay.of(context)!,
                                CustomSnackBar.error(
                                  message: e
                                      .toString()
                                      .replaceAll("Exception: ", ""),
                                ),
                              );
                            })
                          }),
                  const SizedBox(
                    height: 20,
                  ),
                  //create text and button to ask user if there is a account already in order to redirect to login page
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Hesabınız var? ",
                        style: TextStyle(
                            color: Colors.black54, fontWeight: FontWeight.w500),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed('/sign/login');
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
        ));
  }
}
