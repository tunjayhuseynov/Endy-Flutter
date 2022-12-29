import 'dart:io';

import 'package:endy/MainBloc/GlobalBloc.dart';
import 'package:endy/components/tools/button.dart';
import 'package:endy/components/tools/input.dart';
import 'package:endy/pages/main/Setting/Profile_Bloc.dart';
import 'package:endy/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController name = TextEditingController();
  TextEditingController phoneEditing = TextEditingController();
  MaskTextInputFormatter phone = MaskTextInputFormatter(
      mask: "#### ## ###-##-##",
      filter: {"#": RegExp(r'[0-9 +]')},
      initialText: "+994",
      type: MaskAutoCompletionType.lazy);
  TextEditingController mail = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController repeatPass = TextEditingController();

  @override
  void initState() {
    final user = context.read<GlobalBloc>().state.userData;
    if (user != null) {
      name.text = user.name;
      phoneEditing.text = phone.maskText(user.phone);
      mail.text = user.mail;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    List<Map<String, dynamic>> textFields = [
      {
        "hintText": "Ad",
        "controller": name,
        "error": validationWithEmpty(name.text),
        "errorText": "Minimum 3 hərf lazımdır",
        "isVisible": true
      },
      {
        "hintText": "Mobil nömrə",
        "inputFormatter": phone,
        "controller": phoneEditing,
        "initValue": "+994",
        "keyboardType": TextInputType.phone,
        "errorText": "Minimum 3 hərf lazımdır",
        "isVisible": true
      },
      {
        "hintText": "E-mail",
        "controller": mail,
        "keyboardType": TextInputType.emailAddress,
        "errorText": "Düzgün e-mail daxil edin",
        "isVisible": true
      },
    ];

    return BlocBuilder<GlobalBloc, GlobalState>(
      builder: (globalContext, globalState) {
        ImageProvider img = (globalState.userData != null &&
                globalState.userData!.profilePic != null &&
                globalState.userData!.profilePic!.isNotEmpty)
            ? NetworkImage(globalState.userData!.profilePic!)
            : const NetworkImage(
                "https://firebasestorage.googleapis.com/v0/b/endirimsebeti.appspot.com/o/noimage.jpg?alt=media&token=14382611-4d06-4301-baf0-a4a9da0f2ecd");

        return BlocProvider(
          create: (context) => ProfileBloc(globalState.userData!),
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              return Scaffold(
                  backgroundColor: Colors.white,
                  body: state.isComponentLoading
                      ? Center(
                          child: Container(
                            width: 28,
                            height: 28,
                            padding: const EdgeInsets.all(2.0),
                            child: const CircularProgressIndicator(
                              color: Color(mainColor),
                              strokeWidth: 3,
                            ),
                          ),
                        )
                      : ListView(
                          children: [
                            SizedBox(height: size.height * 0.02),
                            Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(Icons.arrow_back_ios)),
                                const Text('Profil',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 2))
                              ],
                            ),
                            Center(
                                child: SizedBox(
                              width: size.width * 0.85,
                              child: ListView(
                                shrinkWrap: true,
                                physics: const ScrollPhysics(),
                                children: [
                                  Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          final url = await context
                                              .read<ProfileBloc>()
                                              .takePhoto();
                                          if (url != null) {
                                            if (!mounted) return;
                                            context
                                                .read<GlobalBloc>()
                                                .updatePP(url);
                                          }
                                        },
                                        child: Stack(
                                          children: [
                                            Container(
                                              clipBehavior: Clip.hardEdge,
                                              width: 100,
                                              height: 100,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: img,
                                                  )),
                                              child: Stack(
                                                children: [
                                                  Positioned(
                                                    bottom: 0,
                                                    child: Container(
                                                      width: 100,
                                                      height: 30,
                                                      color: Colors.black26,
                                                      child: Center(
                                                          child: Icon(
                                                        Icons.camera_alt,
                                                        color: Colors.grey[300],
                                                      )),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 16,
                                      ),
                                      Visibility(
                                        visible: !state.editEnabled,
                                        child: GestureDetector(
                                          onTap: () {
                                            context
                                                .read<ProfileBloc>()
                                                .toggleDisabled();
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: const [
                                              Icon(
                                                Icons.edit_sharp,
                                                size: 18,
                                                color: Color(mainColor),
                                              ),
                                              SizedBox(
                                                width: 4,
                                              ),
                                              Text("Düzəliş et",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Color(mainColor))),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 16,
                                      ),
                                      // User name
                                      Text(
                                        globalState.userData!.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  ...textFields.map((item) {
                                    return item["isVisible"]
                                        ? Column(
                                            children: [
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              CustomTextField(
                                                hintText: item["hintText"],
                                                controller: item["controller"],
                                                initValue: item["initValue"],
                                                inputFormatter:
                                                    item["inputFormatter"],
                                                keyboardType:
                                                    item["keyboardType"],
                                                error: item["error"],
                                                errorText: item["errorText"],
                                                isDisabled: state.editEnabled,
                                              )
                                            ],
                                          )
                                        : Container();
                                  }),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  ElevatedButton(
                                      style: ButtonStyle(
                                        padding: MaterialStateProperty.all<
                                                EdgeInsetsGeometry?>(
                                            const EdgeInsets.all(20.0)),
                                        elevation:
                                            MaterialStateProperty.all<double?>(
                                                0),
                                        backgroundColor:
                                            MaterialStateProperty.all<Color?>(
                                          Colors.grey[200],
                                        ),
                                        foregroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.white),
                                        minimumSize:
                                            MaterialStateProperty.all<Size>(
                                                Size((size.width * 0.7), 60)),
                                      ),
                                      onPressed: () {
                                        if (!state.editEnabled) return;
                                        DatePicker.showDatePicker(context,
                                            showTitleActions: true,
                                            minTime: DateTime(1950, 1, 1),
                                            maxTime: DateTime.now(),
                                            onChanged: (date) {
                                          context
                                              .read<ProfileBloc>()
                                              .setDate(date);
                                        },
                                            onConfirm: (date) {},
                                            currentTime: state.selectedDate ??
                                                DateTime.now(),
                                            locale: LocaleType.az);
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
                                              color: Colors.grey[800],
                                              fontSize: 16),
                                        ),
                                      )),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  Visibility(
                                      visible: state.editEnabled,
                                      child: PrimaryButton(
                                          text: "Yadda saxla",
                                          isLoading: state.isLoading,
                                          fn: () async {
                                            if (globalState.userData != null) {
                                              context
                                                  .read<ProfileBloc>()
                                                  .setLoading(true);
                                              final newUser = await context
                                                  .read<ProfileBloc>()
                                                  .saveChanges(
                                                      globalState.userData!,
                                                      name.text,
                                                      phoneEditing.text
                                                          .replaceAll(
                                                              RegExp(r'[\s-]'),
                                                              ""),
                                                      mail.text);
                                              if (!mounted) return;
                                              context
                                                  .read<ProfileBloc>()
                                                  .set(false, false);
                                              context
                                                  .read<GlobalBloc>()
                                                  .updateUser(newUser,
                                                      emitting: true);
                                            }
                                          })),
                                  const SizedBox(
                                    height: 40,
                                  ),
                                ],
                              ),
                            ))
                          ],
                        ));
            },
          ),
        );
      },
    );
  }
}
