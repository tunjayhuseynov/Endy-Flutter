import 'dart:io';

import 'package:endy/model/user.dart';
import 'package:endy/utils/index.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_cropper_platform_interface/image_cropper_platform_interface.dart';
import 'package:image_picker/image_picker.dart';

class ProfileState {
  DateTime? selectedDate;
  bool isDateSelectorOpen;
  bool isLoading;
  bool editEnabled;
  bool isComponentLoading;
  String phoneNumber;

  ProfileState({
    this.selectedDate,
    this.phoneNumber = "",
    this.isLoading = false,
    this.isDateSelectorOpen = false,
    this.editEnabled = false,
    this.isComponentLoading = false,
  });

  ProfileState copyWith({
    DateTime? selectedDate,
    bool? isLoading,
    bool? editEnabled,
    bool? isDateSelectorOpen,
    bool? isComponentLoading,
    String? phoneNumber,
  }) {
    return ProfileState(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      selectedDate: selectedDate ?? this.selectedDate,
      isDateSelectorOpen: isDateSelectorOpen ?? this.isDateSelectorOpen,
      isLoading: isLoading ?? this.isLoading,
      editEnabled: editEnabled ?? this.editEnabled,
      isComponentLoading: isComponentLoading ?? this.isComponentLoading,
    );
  }

  List<Object?> get props => [
        selectedDate,
        isLoading,
        editEnabled,
        isDateSelectorOpen,
        isComponentLoading,
        phoneNumber,
      ];
}

class ProfileBloc extends Cubit<ProfileState> {
  ProfileBloc(UserData userData) : super(ProfileState()) {
    emit(state.copyWith(
        selectedDate:
            DateTime.fromMillisecondsSinceEpoch(userData.birthDate * 1000)));
  }

  void setPhoneNumber(String phoneNumber) {
    emit(state.copyWith(phoneNumber: phoneNumber));
  }

  void set(bool? editEnabled, bool? isLoading) {
    emit(state.copyWith(
        editEnabled: editEnabled ?? state.editEnabled,
        isLoading: isLoading ?? state.isLoading));
  }

  void toggleDisabled() {
    emit(state.copyWith(editEnabled: !state.editEnabled));
  }

  void setDate(DateTime date) {
    emit(state.copyWith(selectedDate: date));
  }

  void setLoading(bool isLoading) {
    emit(state.copyWith(isLoading: isLoading));
  }

  void setDateSelector(bool isDateSelectorOpen) {
    emit(state.copyWith(isDateSelectorOpen: isDateSelectorOpen));
  }

  Future<UserData> saveChanges(
      UserData user, String nameInput, String mailInput) async {
    if (validation(nameInput) == true ||
        !RegExp(r'(^(?:[+0])?[0-9]{10,12}$)').hasMatch(state.phoneNumber)) {
      throw Exception("Zəhmət olmasa boşluqları doldurun");
    }

    if (state.selectedDate == null) {
      throw Exception("Zəhmət olmasa doğum tarixini seçin");
    }

    user.birthDate =
        (state.selectedDate!.millisecondsSinceEpoch / 1000).floor();
    user.name = nameInput;
    user.phone = state.phoneNumber;
    user.mail = mailInput;

    return user;
  }

  Future<String?> takePhoto(BuildContext context) async {
    try {
      // if (await Permission.photos.request().isGranted) {
      setLoading(true);
      final ImagePicker picker = ImagePicker();
      final XFile? photo = await picker.pickImage(
          source: ImageSource.gallery, maxWidth: 800, maxHeight: 600);

      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: photo!.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.ratio4x3,
        ],
        uiSettings: [
          WebUiSettings(
            context: context,
            translations: WebTranslations(
              cropButton: 'Kəs',
              cancelButton: 'Ləğv et',
              title: 'Profil şəkli',
              rotateLeftTooltip: 'Sola çevir',
              rotateRightTooltip: 'Sağa çevir',
            ),
          ),
          AndroidUiSettings(
              toolbarTitle: 'Kəs',
              toolbarColor: const Color(mainColor),
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.ratio4x3,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Kəs',
            aspectRatioLockEnabled: false,
          ),
        ],
      );
      final user = FirebaseAuth.instance.currentUser;
      if (croppedFile != null && user != null) {
        final storageRef = FirebaseStorage.instance.ref();
        final pp = storageRef.child("pp/${user.uid}/pp_image.png");
        if (!kIsWeb) {
          File file = File(croppedFile.path);
          await pp.putFile(file).whenComplete(() => null);
        } else {
          await pp
              .putData(await croppedFile.readAsBytes())
              .whenComplete(() => null);
        }
        String url = await pp.getDownloadURL();
        await user.updatePhotoURL(url);
        setLoading(false);
        return url;
      }
      setLoading(false);
      // return null;
      // }
    } catch (e) {
      setLoading(false);
      throw Exception(e);
    }
    return null;
  }
}
