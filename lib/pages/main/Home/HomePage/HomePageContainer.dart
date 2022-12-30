import 'dart:io';

import 'package:endy/Pages/main/Home/HomePage/Nav.dart';
import 'package:endy/Pages/main/bonus/bonusHome.dart';
import 'package:endy/Pages/main/favorite/FavoriteMain.dart';
import 'package:endy/Pages/main/Home/HomePage/Home_Page_Bloc.dart';
import 'package:endy/Pages/main/Home/HomePage/HomePage.dart';
import 'package:endy/Pages/main/list/ListHome.dart';
import 'package:endy/Pages/main/setting/Setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainContainer extends StatefulWidget {
  const MainContainer({Key? key}) : super(key: key);

  @override
  State<MainContainer> createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer> {
  static const _children = [
    HomePage(),
    BonusHome(),
    ListHome(),
    Setting(),
    FavoriteMain()
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomePageNavBloc, int>(builder: (context, state) {
      return WillPopScope(
          child: Scaffold(
              backgroundColor: Colors.white,
              extendBody: true,
              bottomNavigationBar: SizedBox(
                height: 80,
                child: Nav(),
              ),
              body: _children[state]),
          onWillPop: () async {
            if (Platform.isAndroid) {
              await SystemNavigator.pop();
            } else if (Platform.isIOS) {
              exit(0);
            }
            return true;
          });
    });
  }
}
