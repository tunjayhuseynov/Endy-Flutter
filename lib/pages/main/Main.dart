import 'dart:io';

import 'package:endy/MainBloc/GlobalBloc.dart';
import 'package:endy/pages/main/Home/HomePage/HomePageContainer.dart';
import 'package:endy/pages/onboard.dart';
import 'package:endy/pages/sign/main.dart';

import 'package:endy/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainProvider extends StatelessWidget {
  const MainProvider({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GlobalBloc, GlobalState>(
        builder: (BuildContext context, state) {
      if (state.authStatus == GlobalAuthStatus.loggedIn ||
          state.authStatus == GlobalAuthStatus.loading) {
        if (state.categories.isEmpty ||
            state.companies.isEmpty ||
            state.authStatus == GlobalAuthStatus.loading) {
          return const Scaffold(
            body: Align(
              alignment: Alignment.center,
              child: SizedBox(
                  width: 50,
                  height: 50,
                  child: CircularProgressIndicator(
                    color: Color(mainColor),
                  )),
            ),
          );
        }
        return state.userData != null && state.userData!.isFirstEnter
            ? const Onboard()
            : const MainContainer();
      }
      return const Sign();
    });
  }
}
