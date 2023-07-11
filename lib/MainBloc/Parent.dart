import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:endy/MainBloc/GlobalBloc.dart';
import 'package:endy/types/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Parent extends Cubit<GlobalState> {
  Parent()
      : super(GlobalState(
            categories: [], subcategories: [], companies: [], panels: []));

  void addList(UserList list) {
    if (state.userData != null) {
      var data = UserData.fromInstance(state.userData!);
      data.list.add(list);
      emit(state.copyWith(userData: data));
      updateUser(data);
    }
  }

  void removeList(UserList list) {
    if (state.userData != null) {
      var data = UserData.fromInstance(state.userData!);
      data.list.remove(list);
      emit(state.copyWith(userData: data));
      updateUser(data);
    }
  }

  void addListDetail(UserList userList, UserListDetail detail) {
    if (state.userData != null) {
      var data = UserData.fromInstance(state.userData!);
      data.list
          .firstWhere((list) => list.id == userList.id)
          .details
          .add(detail);
      emit(state.copyWith(userData: data));
      updateUser(data);
    }
  }

  void changeDetailStatus(UserList userList, UserListDetail detail) {
    if (state.userData != null) {
      var data = UserData.fromInstance(state.userData!);
      data.list
          .firstWhere((list) => list.id == userList.id)
          .details
          .firstWhere((d) => d.id == detail.id)
          .isDone = !detail.isDone;
      emit(state.copyWith(userData: data));
      updateUser(data);
    }
  }

  //delete detail from list
  void removeDetail(UserList userList, UserListDetail detail) {
    if (state.userData != null) {
      var data = UserData.fromInstance(state.userData!);
      data.list
          .firstWhere((list) => list.id == userList.id)
          .details
          .removeWhere((d) => d.id == detail.id);
      emit(state.copyWith(userData: data));
      updateUser(data);
    }
  }

  void reorderDetail(UserList userList, UserListDetail detail, int index) {
    if (state.userData != null) {
      var data = UserData.fromInstance(state.userData!);
      data.list
          .firstWhere((list) => list.id == userList.id)
          .details
          .removeWhere((d) => d.id == detail.id);
      data.list
          .firstWhere((list) => list.id == userList.id)
          .details
          .insert(index, detail);
      emit(state.copyWith(userData: data));
      updateUser(data);
    }
  }

  Future<void> updateUser(UserData user, {bool? emitting}) async {
    if (state.isAnonymous) {
      print(user.toJson());
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("userData", json.encode(user.toJson()));
    } else {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.id)
          .update(UserData.fromInstance(user).toJson());
    }

    if (emitting != null && emitting) {
      emit(state.copyWith(userData: user));
    }
  }
}
