import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SigninState {
  bool isLoading;
  bool error;
  String phone;

  SigninState({this.isLoading = false, this.error = false, this.phone = ""});

  SigninState copyWith({bool? isLoading, bool? error, String? phone}) {
    return SigninState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      phone: phone ?? this.phone,
    );
  }
}

class SigninBloc extends Cubit<SigninState> {
  SigninBloc() : super(SigninState());

  void setLoading(bool loading) {
    emit(state.copyWith(isLoading: loading));
  }

  void setError(bool error) {
    emit(state.copyWith(error: error));
  }

  void setPhone(String phone) {
    emit(state.copyWith(phone: phone));
  }

  Future<void> login() async {
    try {
      if (state.phone.isEmpty ||
          !RegExp(r'(^(?:[+0])?[0-9]{10,12}$)').hasMatch(state.phone)) {
        throw Exception("Zəhmət olmasa, mobil nömrəni düzgün yazın.");
      }

      setLoading(true);

      var instance = FirebaseFirestore.instance.collection('users');
      Query<Map<String, dynamic>> query;

      query = instance.where("phone", isEqualTo: state.phone);

      final doc = await query.get();

      if (doc.docs.isEmpty) {
        throw Exception("İstifadəçi tapılmadı");
      }

      setLoading(false);
    } catch (e) {
      setLoading(false);
      throw Exception(e);
    }
  }
}
