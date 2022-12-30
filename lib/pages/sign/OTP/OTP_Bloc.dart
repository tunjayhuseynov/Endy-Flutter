import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:endy/types/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OTPState {
  String errorMessage = "";
  String code = "";

  OTPState({this.errorMessage = "", this.code = ""});

  OTPState copyWith({String? errorMessage, String? code}) {
    return OTPState(
      errorMessage: errorMessage ?? this.errorMessage,
      code: code ?? this.code,
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

  Future<bool> verify(String sms, String code, DateTime? selectedDate,
      String? name, String phone, String? mail) async {
    try {
      PhoneAuthCredential credential =
          PhoneAuthProvider.credential(verificationId: code, smsCode: sms);

      final userData = await FirebaseFirestore.instance
          .collection("users")
          .where("phone", isEqualTo: phone)
          .get();

      final userExist = userData.docs.isNotEmpty;

      UserCredential user;
      user = await FirebaseAuth.instance.signInWithCredential(credential);
      if (name != null && userExist) {
        throw Exception("İstifadəçi artıq mövcuddur");
      } else if (name == null && !userExist) {
        throw Exception("İstifadəçi tapılmadı");
      }

      if (user.user?.uid != null) {
        UserData newUser;
        if (selectedDate != null && name != null && mail != null) {
          newUser = UserData(
            id: user.user!.uid,
            birthDate: (selectedDate.millisecondsSinceEpoch / 1000).round(),
            role: "user",
            name: name,
            phone: phone,
            mail: mail,
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
              .doc(user.user?.uid)
              .set(newUser.toJson());
        } else {
          newUser = UserData.fromJson((await FirebaseFirestore.instance
                  .collection("users")
                  .doc(user.user!.uid)
                  .get())
              .data()!);
        }
      }
      return true;
    } catch (e) {
      if (e.toString().contains("firebase_auth/invalid-verification")) {
        throw Exception("Kod yanlışdır");
      }
      throw Exception(e);
    }
  }
}
