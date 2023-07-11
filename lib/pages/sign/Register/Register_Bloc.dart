import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:endy/utils/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterState {
  DateTime? selectedDate;
  bool isLoading = false;
  String phone;
  String name;
  String? mail;
  String docLink;

  bool isPrivacyChecked = false;

  RegisterState(
      {this.selectedDate,
      this.isLoading = false,
      this.phone = "",
      this.name = "",
      this.mail,
      this.docLink = "",
      this.isPrivacyChecked = false});

  RegisterState copyWith(
      {DateTime? selectedDate,
      bool? isLoading,
      bool? isPrivacyChecked,
      String? name,
      String? mail,
      String? docLink,
      String? phone}) {
    return RegisterState(
      selectedDate: selectedDate ?? this.selectedDate,
      isLoading: isLoading ?? this.isLoading,
      phone: phone ?? this.phone,
      isPrivacyChecked: isPrivacyChecked ?? this.isPrivacyChecked,
      name: name ?? this.name,
      docLink: docLink ?? this.docLink,
      mail: mail ?? this.mail,
    );
  }
}

class RegisterBloc extends Cubit<RegisterState> {
  RegisterBloc() : super(RegisterState());

  void setDocLink(String docLink) {
    emit(state.copyWith(docLink: docLink));
  }

  void loadDocLink() async {
    var linkDoc = await FirebaseFirestore.instance
        .collection("utils")
        .doc("privacyLink")
        .get();
    var link = linkDoc.data()?["value"];
    setDocLink(link);
  }

  void setSelectedDate(DateTime selectedDate) {
    emit(state.copyWith(selectedDate: selectedDate));
  }

  void setIsLoading(bool isLoading) {
    emit(state.copyWith(isLoading: isLoading));
  }

  void setIsPrivacyChecked(bool isPrivacyChecked) {
    emit(state.copyWith(isPrivacyChecked: isPrivacyChecked));
  }

  void setPhone(String phone) {
    emit(state.copyWith(phone: phone));
  }

  void setName(String name) {
    emit(state.copyWith(name: name));
  }

  void setMail(String mail) {
    emit(state.copyWith(mail: mail));
  }

  void setDatePicker(BuildContext context) {
    if (MediaQuery.of(context).size.width < 1024) {
      showCupertinoDatepickerDialog(
          CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            use24hFormat: true,
            // This shows day of week alongside day of month
            showDayOfWeek: true,
            minimumDate: DateTime(1940, 1, 1),
            maximumDate: DateTime.now().add(Duration(days: 365 * -13)),
            // This is called when the user changes the date.
            onDateTimeChanged: (DateTime newDate) {
              setSelectedDate(newDate);
            },
          ),
          context);
      // DatePicker.showDatePicker(context,
      //     showTitleActions: true,
      //     minTime: DateTime(1940, 1, 1),
      //     maxTime: DateTime.now().add(Duration(days: 365 * -13)),
      //     onChanged: (date) {}, onConfirm: (date) {
      //   setSelectedDate(date);
      // },
      //     currentTime: state.selectedDate ?? DateTime.now(),
      //     locale: LocaleType.az);
    } else {
      showDatePicker(
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
              initialDate: state.selectedDate ??
                  DateTime.now().add(Duration(days: 365 * -13)),
              firstDate: DateTime.utc(1940),
              lastDate: DateTime.now().add(Duration(days: 365 * -13)))
          .then((date) {
        if (date != null) {
          setSelectedDate(date);
        }
      });
    }
  }

  Future<void> phoneVerification(String name) async {
    if (validation(name) == true ||
        state.selectedDate == null ||
        state.isPrivacyChecked != true ||
        !RegExp(r'(^(?:[+0])?[0-9]{10,12}$)').hasMatch(state.phone)) {
      throw Exception("Zəhmət olmasa bütün xanaları doldurun");
    }

    if (state.mail != null &&
        state.mail!.isNotEmpty &&
        !RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
            .hasMatch(state.mail!)) {
      throw Exception("Zəhmət olmasa doğru mail daxil edin");
    }

    if (state.selectedDate == null) {
      throw Exception("Zəhmət olmasa doğum tarixini seçin");
    }

    final list = await FirebaseFirestore.instance
        .collection("users")
        .where("phone", isEqualTo: state.phone)
        .get();
    if (list.docs.isNotEmpty) {
      throw Exception("Bu istifadəçi artıq mövcuddur");
    }
  }
}
