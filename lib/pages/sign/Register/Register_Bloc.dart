import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:endy/utils/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class RegisterState {
  DateTime? selectedDate;
  bool isLoading = false;
  String phone;

  bool isPrivacyChecked = false;

  RegisterState(
      {this.selectedDate,
      this.isLoading = false,
      this.phone = "",
      this.isPrivacyChecked = false});

  RegisterState copyWith(
      {DateTime? selectedDate,
      bool? isLoading,
      bool? isPrivacyChecked,
      String? phone}) {
    return RegisterState(
      selectedDate: selectedDate ?? this.selectedDate,
      isLoading: isLoading ?? this.isLoading,
      phone: phone ?? this.phone,
      isPrivacyChecked: isPrivacyChecked ?? this.isPrivacyChecked,
    );
  }
}

class RegisterBloc extends Cubit<RegisterState> {
  RegisterBloc() : super(RegisterState());

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

  void setDatePicker(BuildContext context) {
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime(1950, 1, 1),
        maxTime: DateTime(2050, 12, 31),
        onChanged: (date) {}, onConfirm: (date) {
      setSelectedDate(date);
    },
        currentTime: state.selectedDate ?? DateTime.now(),
        locale: LocaleType.az);
  }

  Future<void> phoneVerification(String name) async {
    if (validation(name) == true ||
        state.selectedDate == null ||
        state.isPrivacyChecked != true ||
        !RegExp(r'(^(?:[+0])?[0-9]{10,12}$)').hasMatch(state.phone)) {
      throw Exception("Zəhmət olmasa bütün xanaları doldurun");
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
