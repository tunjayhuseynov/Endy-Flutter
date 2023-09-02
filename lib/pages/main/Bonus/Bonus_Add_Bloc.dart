import 'package:endy/model/user.dart';
import 'package:endy/utils/index.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class BonusAddState {
  CroppedFile? front;

  bool isLoading = false;
  bool isComponentLoading = false;

  BonusAddState(
      {this.front, this.isLoading = false, this.isComponentLoading = false});

  BonusAddState copyWith(
      {CroppedFile? front, bool? isLoading, bool? isComponentLoading}) {
    return BonusAddState(
      front: front ?? this.front,
      isLoading: isLoading ?? this.isLoading,
      isComponentLoading: isComponentLoading ?? this.isComponentLoading,
    );
  }
}

class BonusAddBloc extends Cubit<BonusAddState> {
  BonusAddBloc() : super(BonusAddState());

  void setLoading(bool loading) {
    emit(state.copyWith(isLoading: loading));
  }

  void set(bool componentLoading, CroppedFile? front) {
    emit(state.copyWith(front: front, isComponentLoading: componentLoading));
  }

  void setComponentLoading(bool loading) {
    emit(state.copyWith(isComponentLoading: loading));
  }

  void setFront(CroppedFile? front) {
    emit(state.copyWith(front: front));
  }

  takePhotoFront() async {
    try {
      if (await Permission.camera.request().isGranted) {
        setComponentLoading(true);
        final ImagePicker picker = ImagePicker();
        final ImageCropper cropper = ImageCropper();
        final XFile? photo = await picker.pickImage(
            source: ImageSource.camera, maxWidth: 800, maxHeight: 600);
        CroppedFile? croppedFile = await cropper.cropImage(
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
        set(false, croppedFile);
      }
    } catch (e) {
      setComponentLoading(false);
      throw Exception(e);
    }
  }

  Future<BonusCard> submit(UserData? user, List<BonusCard>? cards,
      String cardName, String cardNumber) async {
    try {
      setLoading(true);
      if (user == null) throw Exception("User is null");
      if (cardName.isEmpty) {
        throw Exception("Mağaza adını daxil edin");
      }
      if (cardNumber.isEmpty) {
        throw Exception("Bonus kodunu daxil edin");
      }
      if (cards != null &&
          cards.any((element) => cardNumber == element.cardNumber)) {
        throw Exception("Bu bonus kodu artıq istifadədədir");
      }
      // if (state.front == null) throw Exception("Ön Şəkil əlavə edin");

      // final backRef = storageRef.child("${user.id}/$cardNumber/back.jpg");

      Reference? frontRef;

      if (state.front != null) {
        final storageRef = FirebaseStorage.instance.ref();

        frontRef = storageRef.child("${user.id}/$cardNumber/front.jpg");
        await frontRef.putData(await state.front!.readAsBytes());
      }

      final card = BonusCard(
          cardFront: await frontRef?.getDownloadURL(),
          cardBack: null,
          cardName: cardName,
          cardNumber: cardNumber);

      return card;
    } on Exception catch (e) {
      setLoading(false);
      throw Exception(e);
    }
  }
}
