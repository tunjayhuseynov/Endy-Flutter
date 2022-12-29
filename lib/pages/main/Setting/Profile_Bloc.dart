import 'dart:io';

import 'package:endy/types/user.dart';
import 'package:endy/utils/index.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfileState {
  DateTime? selectedDate;
  bool isLoading;
  bool editEnabled;
  bool isComponentLoading;

  ProfileState({
    this.selectedDate,
    this.isLoading = false,
    this.editEnabled = false,
    this.isComponentLoading = false,
  });

  ProfileState copyWith({
    DateTime? selectedDate,
    bool? isLoading,
    bool? editEnabled,
    bool? isComponentLoading,
  }) {
    return ProfileState(
      selectedDate: selectedDate ?? this.selectedDate,
      isLoading: isLoading ?? this.isLoading,
      editEnabled: editEnabled ?? this.editEnabled,
      isComponentLoading: isComponentLoading ?? this.isComponentLoading,
    );
  }
}

class ProfileBloc extends Cubit<ProfileState> {
  ProfileBloc(UserData userData) : super(ProfileState()) {
    emit(state.copyWith(
        selectedDate:
            DateTime.fromMillisecondsSinceEpoch(userData.birthDate * 1000)));
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

  Future<UserData> saveChanges(UserData user, String nameInput,
      String phoneInput, String mailInput) async {
    if (validation(nameInput) == true || phoneInput.length != 13) {
      throw Exception("Zəhmət olmasa boşluqları doldurun");
    }

    if (state.selectedDate == null) {
      throw Exception("Zəhmət olmasa doğum tarixini seçin");
    }

    user.birthDate =
        (state.selectedDate!.millisecondsSinceEpoch / 1000).floor();
    user.name = nameInput;
    user.phone =
        phoneInput.replaceAll(RegExp(r'[\s-]'), ""); //phone.unmaskText();
    user.mail = mailInput;

    return user;
  }

  Future<String?> takePhoto() async {
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
          File file = File(croppedFile.path);
          await pp.putFile(file).whenComplete(() => null);
          String url = await pp.getDownloadURL();
          await user.updatePhotoURL(url);
          setLoading(false);
          return url;
        }
        // return null;
      // }
    } catch (e) {
      setLoading(false);
      throw Exception(e);
    }
    return null;
  }
}
