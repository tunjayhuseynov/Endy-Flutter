import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:endy/types/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OTPState {
  String errorMessage;
  String code;
  bool isFinised;
  int timer;

  OTPState(
      {this.errorMessage = "",
      this.code = "",
      this.isFinised = false,
      this.timer = 60});

  OTPState copyWith(
      {String? errorMessage, String? code, bool? isFinished, int? timer}) {
    return OTPState(
      errorMessage: errorMessage ?? this.errorMessage,
      code: code ?? this.code,
      isFinised: isFinished ?? this.isFinised,
      timer: timer ?? this.timer,
    );
  }
}

class OTPBloc extends Cubit<OTPState> {
  OTPBloc() : super(OTPState());

  void setErrorMessage(String errorText) {
    emit(state.copyWith(errorMessage: errorText));
  }

  void setCode(String code) {
    emit(state.copyWith(code: code));
  }

  void setFinished(bool isFinished) {
    emit(state.copyWith(isFinished: isFinished));
  }

  void setTimer(int timer) {
    emit(state.copyWith(timer: timer));
  }

  Future<PhoneAuthCredential> verify(
    String sms,
    String code,
  ) async {
    try {
      PhoneAuthCredential credential =
          PhoneAuthProvider.credential(verificationId: code, smsCode: sms);

      return credential;
    } catch (e) {
      if (e.toString().contains("firebase_auth/invalid-verification")) {
        throw Exception("Kod yanlışdır");
      }
      throw Exception(e);
    }
  }
}




  // Future<UserData?> verify(String sms, String code, DateTime? selectedDate,
  //     String? name, String phone, String? mail) async {
  //   try {
  //     PhoneAuthCredential credential =
  //         PhoneAuthProvider.credential(verificationId: code, smsCode: sms);

  //     final userData = await FirebaseFirestore.instance
  //         .collection("users")
  //         .where("phone", isEqualTo: phone)
  //         .get();

  //     final userExist = userData.docs.isNotEmpty;

  //     UserCredential user;
  //     user = await FirebaseAuth.instance.signInWithCredential(credential);
  //     if (name != null && userExist) {
  //       throw Exception("İstifadəçi artıq mövcuddur");
  //     } else if (name == null && !userExist) {
  //       throw Exception("İstifadəçi tapılmadı");
  //     }

  //     UserData? newUser;
  //     if (user.user?.uid != null) {
  //       if (selectedDate != null && name != null && mail != null) {
  //         newUser = UserData(
  //           id: user.user!.uid,
  //           birthDate: (selectedDate.millisecondsSinceEpoch / 1000).round(),
  //           role: "user",
  //           name: name,
  //           phone: phone,
  //           mail: mail,
  //           isFirstEnter: true,
  //           list: [],
  //           bonusCard: [],
  //           liked: [],
  //           subscribedCompanies: [],
  //           notifications: [],
  //           notificationSeenTime:
  //               (DateTime.now().millisecondsSinceEpoch / 1000).round(),
  //           createdAt: (DateTime.now().millisecondsSinceEpoch / 1000).round(),
  //         );

  //         await FirebaseFirestore.instance
  //             .collection("users")
  //             .doc(user.user?.uid)
  //             .set(newUser.toJson());
  //       } else {
  //         newUser = UserData.fromJson((await FirebaseFirestore.instance
  //                 .collection("users")
  //                 .doc(user.user!.uid)
  //                 .get())
  //             .data()!);
  //       }
  //     }
  //     return newUser;
  //   } catch (e) {
  //     if (e.toString().contains("firebase_auth/invalid-verification")) {
  //       throw Exception("Kod yanlışdır");
  //     }
  //     throw Exception(e);
  //   }
  // }