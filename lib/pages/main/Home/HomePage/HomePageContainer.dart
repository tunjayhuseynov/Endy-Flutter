import 'dart:io';

import 'package:endy/MainBloc/GlobalBloc.dart';
import 'package:endy/Pages/main/Catalog/CatalogMain.dart';
import 'package:endy/Pages/main/Home/HomePage/Nav.dart';
import 'package:endy/Pages/main/Home/HomePage/Rail.dart';
import 'package:endy/Pages/main/Home/SearchPage/Search_Page_Bloc.dart';
import 'package:endy/Pages/main/NeedRegister/index.dart';
import 'package:endy/Pages/main/bonus/bonusHome.dart';
import 'package:endy/Pages/main/favorite/FavoriteMain.dart';
import 'package:endy/Pages/main/Home/HomePage/Home_Page_Bloc.dart';
import 'package:endy/Pages/main/Home/HomePage/HomePage.dart';
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
  static _children(bool disallowAnonymous, BuildContext context) {
    return [
      HomePage(),
      disallowAnonymous ? NeedRegister() : BonusHome(),
      CatalogMain(),
      // ListHome(),
      Setting(),
      disallowAnonymous ? NeedRegister() : FavoriteMain()
    ];
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return BlocBuilder<GlobalBloc, GlobalState>(
      buildWhen: (previous, current) =>
          current.authStatus == GlobalAuthStatus.loggedIn,
      builder: (globalContext, globalState) {
        return BlocBuilder<HomePageNavBloc, int>(builder: (context, state) {
          return BlocProvider<SearchPageBloc>(
              lazy: false,
              create: (context) => SearchPageBloc(),
              child: BlocBuilder<SearchPageBloc, SearchPageState>(
                buildWhen: (previous, current) =>
                    previous.search != current.search,
                builder: (searchContext, searchState) {
                  return WillPopScope(
                      child: Scaffold(
                          backgroundColor: Colors.white,
                          extendBody: true,
                          bottomNavigationBar: width < 768
                              ? SizedBox(
                                  height: 80,
                                  child: Nav(),
                                )
                              : null,
                          body: width < 768
                              ? _children(
                                  globalState.authStatus ==
                                          GlobalAuthStatus.loggedIn &&
                                      globalState.userData == null,
                                  context)[state]
                              : Row(
                                  children: [
                                    NavRail(state, context),
                                    Expanded(
                                        child: _children(
                                            globalState.authStatus ==
                                                    GlobalAuthStatus.loggedIn &&
                                                globalState.userData == null,
                                            context)[state])
                                  ],
                                )),
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
      },
    );
  }
}
