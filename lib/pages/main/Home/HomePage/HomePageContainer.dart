import 'dart:io';

import 'package:endy/Pages/main/Home/HomePage/Nav.dart';
import 'package:endy/Pages/main/Home/SearchPage/Search_Page_Bloc.dart';
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
  static final _children = [
    HomePage(),
    BonusHome(),
    ListHome(),
    Setting(),
    FavoriteMain()
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomePageNavBloc, int>(builder: (context, state) {
      return BlocProvider<SearchPageBloc>(
          lazy: false,
          create: (context) => SearchPageBloc(),
          child: BlocBuilder<SearchPageBloc, SearchPageState>(
            buildWhen: (previous, current) => previous.search != current.search,
            builder: (searchContext, searchState) {
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
                    if (searchState.search.isNotEmpty) {
                      searchContext.read<SearchPageBloc>().reset();
                      return false;
                    }
                    if (Platform.isAndroid) {
                      await SystemNavigator.pop();
                    } else if (Platform.isIOS) {
                      exit(0);
                    }
                    return true;
                  });
            },
          ));
    });
  }
}
