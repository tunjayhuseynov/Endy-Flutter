import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:endy/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../MainBloc/GlobalBloc.dart';
import '../streams/notifications.dart';

class AuthStream {
  static Future<void> initiateStream(BuildContext context) async {
    var global = context.read<GlobalBloc>();
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user == null) {
        global.set(global.state.copyWith(
            authStatus: GlobalAuthStatus.notLoggedIn,
            user: null,
            isAnonymous: false,
            userData: null));
      } else if (!user.isAnonymous) {
        var value = await FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get();

        if (value.exists && value.data() != null) {
          var data = UserData.fromJson(value.data()!);
          var notifications = await NotificationCrud.getNotifications(
              data.subscribedCompanies, data.createdAt);

          int count = notifications
              .where((element) => element.createdAt > data.notificationSeenTime)
              .length;
          global.set(global.state.copyWith(
              notifications: notifications,
              unseenNotificationCount: count,
              isAnonymous: false,
              authStatus: GlobalAuthStatus.loggedIn,
              user: user,
              userData: data));
        } else {
          // FirebaseAuth.instance.setPersistence(Persistence.NONE);
          global.set(global.state.copyWith(
              authStatus: GlobalAuthStatus.loggedIn,
              isAnonymous: false,
              user: null));
        }
      } else {
        UserData data;
        final prefs = await SharedPreferences.getInstance();
        if (prefs.containsKey("userData")) {
          data = UserData.fromJson(json.decode(prefs.getString("userData")!));
        } else {
          data = UserData(
              id: user.uid,
              role: "user",
              name: "Anonim istifadəçi",
              phone: "anonymous",
              mail: "anonymous",
              birthDate: 0,
              isFirstEnter: false,
              list: [],
              bonusCard: [],
              liked: [],
              subscribedCompanies: [],
              notifications: [],
              createdAt: 0,
              notificationSeenTime: 0);
        }
        global.set(global.state.copyWith(
            authStatus: GlobalAuthStatus.loggedIn,
            user: null,
            isAnonymous: true,
            userData: data));
      }
    });
  }
}
