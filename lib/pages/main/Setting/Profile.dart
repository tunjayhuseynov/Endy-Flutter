 
import 'package:endy/MainBloc/GlobalBloc.dart';
import 'package:endy/components/Footer.dart';
import 'package:endy/components/Navbar.dart';
import 'package:endy/components/tools/button.dart';
import 'package:endy/components/tools/input.dart';
import 'package:endy/Pages/main/Setting/Profile_Bloc.dart';
import 'package:endy/model/user.dart';
import 'package:endy/utils/index.dart';
import 'package:endy/utils/responsivness/container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

extension E on String {
  String lastChars(int n) => substring(length - n);
}

 
class ProfileRoute extends StatefulWidget {
  const ProfileRoute({Key? key}) : super(key: key);

  @override
  State<ProfileRoute> createState() => _ProfileRouteState();
}

class _ProfileRouteState extends State<ProfileRoute> {
  TextEditingController name = TextEditingController();

  TextEditingController mail = TextEditingController();

  TextEditingController phone = TextEditingController();

  @override
  void initState() {
    final user = context.read<GlobalBloc>().state.userData;
    if (user != null) {
      name.text = user.name;
      mail.text = user.mail;
      phone.text = user.phone.lastChars(9);
    }
    super.initState();
  }

  @override
  void dispose() {
    name.dispose();
    mail.dispose();
    phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final mobile = size.width < 1024;

    return BlocBuilder<GlobalBloc, GlobalState>(
      builder: (globalContext, globalState) {
        ImageProvider img = (globalState.isAnonymous == false &&
                globalState.userData != null &&
                globalState.userData!.profilePic != null &&
                globalState.userData!.profilePic!.isNotEmpty)
            ? NetworkImage(globalState.userData!.profilePic!)
            : const NetworkImage(
                "https://firebasestorage.googleapis.com/v0/b/endirimsebeti.appspot.com/o/noimage.jpg?alt=media&token=14382611-4d06-4301-baf0-a4a9da0f2ecd");

        return BlocProvider(
          create: (context) => ProfileBloc(globalState.userData!)
            ..setPhoneNumber(globalState.userData?.phone ?? ""),
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              return ScaffoldWrapper(
                  backgroundColor: Colors.white,
                  hPadding: 0,
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
                      : Column(
                          // shrinkWrap: true,
                          children: [
                            if (!mobile) const Navbar(),
                            SizedBox(height: size.height * 0.015),
                            if (mobile)
                              Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        context.pop(context);
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
                            if (!mobile)
                              Expanded(
                                child: Center(
                                    child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: getContainerSize(size.width)),
                                  width: size.width * 0.85,
                                  height: mobile ? size.height : null,
                                  child: Flex(
                                    direction: mobile
                                        ? Axis.vertical
                                        : Axis.horizontal,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 85),
                                            child: ProfileHeader(
                                                img: img,
                                                editEnabled: !mobile
                                                    ? true
                                                    : state.editEnabled,
                                                name: globalState
                                                        .userData?.name ??
                                                    "",
                                                phone: globalState
                                                        .userData?.phone ??
                                                    ""),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: ProfileBody(
                                            size: size,
                                            name: name,
                                            mail: mail,
                                            editEnabled: !mobile
                                                ? true
                                                : state.editEnabled,
                                            isLoading: state.isLoading,
                                            userData: globalState.userData,
                                            selectedDate: state.selectedDate),
                                      ),
                                    ],
                                  ),
                                )),
                              ),
                            if (mobile)
                              Center(
                                  child: SizedBox(
                                width: size.width * 0.85,
                                child: ListView(
                                  shrinkWrap: true,
                                  children: [
                                    ProfileHeader(
                                        img: img,
                                        editEnabled: state.editEnabled,
                                        name: globalState.userData?.name ?? "",
                                        phone:
                                            globalState.userData?.phone ?? ""),
                                    const SizedBox(height: 15),
                                    ProfileBody(
                                        size: size,
                                        name: name,
                                        mail: mail,
                                        editEnabled: state.editEnabled,
                                        isLoading: state.isLoading,
                                        userData: globalState.userData,
                                        selectedDate: state.selectedDate),
                                    const SizedBox(
                                      height: 40,
                                    ),
                                  ],
                                ),
                              )),
                            if (!mobile) const Footer()
                          ],
                        ));
            },
          ),
        );
      },
    );
  }
}

class ProfileBody extends StatelessWidget {
  const ProfileBody({
    super.key,
    required this.size,
    required this.name,
    required this.mail,
    required this.editEnabled,
    required this.selectedDate,
    required this.isLoading,
    required this.userData,
  });

  final Size size;
  final UserData? userData;
  final TextEditingController name;
  final TextEditingController mail;
  final bool editEnabled;
  final DateTime? selectedDate;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width < 1024 ? size.width * 0.85 : 400,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomTextField(
            isEnabled: editEnabled,
            hintText: "Ad",
            controller: name,
            error: validationWithEmpty(name.text),
            errorText: "Minimum 3 hərf lazımdır",
          ),
          const SizedBox(
            height: 15,
          ),
          CustomTextField(
            isEnabled: editEnabled,
            hintText: "E-mail",
            controller: mail,
            keyboardType: TextInputType.emailAddress,
            error: validationWithEmpty(name.text),
            errorText: "Düzgün e-mail daxil edin",
          ),
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
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                minimumSize: MaterialStateProperty.all<Size>(
                    Size((size.width * 0.7), 60)),
              ),
              onPressed: () async {
                if (!editEnabled) return;
                if (size.width >= 1024) {
                  DateTime? date = await showDatePicker(
                      context: context,
                      cancelText: "Ləğv et",
                      confirmText: "Təsdiqlə",
                      locale: Locale('az', 'AZ'),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: ColorScheme.light(
                              primary: Color(mainColor),
                              onPrimary: Colors.white,
                              onSurface: Colors.black,
                            ),
                            textButtonTheme: TextButtonThemeData(
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.black,
                              ),
                            ),
                          ),
                          child: child!,
                        );
                      },
                      initialDate: selectedDate ??
                          DateTime.now().add(Duration(days: 365 * -13)),
                      firstDate: DateTime.utc(1940),
                      lastDate: DateTime.now().add(Duration(days: 365 * -13)));
                  if (date != null) {
                    context.read<ProfileBloc>().setDate(date);
                  }
                }
                if (size.width < 1024) {
                  showCupertinoDatepickerDialog(
                      CupertinoDatePicker(
                        initialDateTime: DateTime.now(),
                        mode: CupertinoDatePickerMode.date,
                        use24hFormat: true,
                        // This shows day of week alongside day of month
                        showDayOfWeek: true,
                        minimumDate: DateTime(1950, 1, 1),
                        maximumDate: DateTime.now(),
                        // This is called when the user changes the date.
                        onDateTimeChanged: (DateTime newDate) {
                          context.read<ProfileBloc>().setDate(newDate);
                        },
                      ),
                      context);
                  // DatePicker.showDatePicker(context,
                  //     showTitleActions: true,
                  //     minTime: DateTime(1950, 1, 1),
                  //     maxTime: DateTime.now(),
                  //     onChanged: (date) =>
                  //         context.read<ProfileBloc>().setDate(date),
                  //     onConfirm: (date) {},
                  //     currentTime: selectedDate,
                  //     locale: LocaleType.az);
                }
              },
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  selectedDate == null
                      ? 'Doğum Tarixi'
                      : DateFormat('yyyy-MM-dd')
                          .format(selectedDate ?? DateTime.now()),
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.grey[800], fontSize: 16),
                ),
              )),
          const SizedBox(
            height: 30,
          ),
          Visibility(
              visible: editEnabled,
              child: PrimaryButton(
                  width: size.width < 1024 ? null : 200,
                  text: "Yadda saxla",
                  isLoading: isLoading,
                  fn: () async {
                    if (userData != null) {
                      context.read<ProfileBloc>().setLoading(true);
                      final newUser = await context
                          .read<ProfileBloc>()
                          .saveChanges(userData!, name.text, mail.text);
                      context.read<ProfileBloc>().set(false, false);
                      context
                          .read<GlobalBloc>()
                          .updateUser(newUser, emitting: true);
                    }
                  })),
        ],
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.editEnabled,
    required this.img,
    required this.name,
    required this.phone,
  });

  final bool editEnabled;
  final String name;
  final String phone;
  final ImageProvider<Object> img;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          height: 16,
        ),
        GestureDetector(
          onTap: () async {
            final url = await context.read<ProfileBloc>().takePhoto(context);
            if (url != null) {
              context.read<GlobalBloc>().updatePP(url);
            }
          },
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
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
        ),
        const SizedBox(
          height: 16,
        ),
        Visibility(
          visible: !editEnabled,
          child: GestureDetector(
            onTap: () {
              context.read<ProfileBloc>().toggleDisabled();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Icon(
                  Icons.edit_sharp,
                  size: 18,
                  color: Color(mainColor),
                ),
                Text("Düzəliş et",
                    style: TextStyle(fontSize: 16, color: Color(mainColor))),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        // User name
        Text(
          name,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(
          height: 6,
        ),
        // User name
        Text(
          phone,
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
      ],
    );
  }
}
