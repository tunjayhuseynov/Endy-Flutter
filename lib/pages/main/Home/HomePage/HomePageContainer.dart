import 'dart:io';
import 'package:endy/MainBloc/GlobalBloc.dart';
import 'package:endy/Pages/main/Bonus/BonusHome.dart';
import 'package:endy/Pages/main/Catalog/CatalogMain.dart';
import 'package:endy/Pages/main/Home/HomePage/Nav.dart';
import 'package:endy/Pages/main/Home/SearchPage/Search_Page_Bloc.dart';
import 'package:endy/Pages/main/NeedRegister/index.dart';
import 'package:endy/Pages/main/favorite/FavoriteMain.dart';
import 'package:endy/Pages/main/Home/HomePage/Home_Page_Bloc.dart';
import 'package:endy/Pages/main/Home/HomePage/HomePage.dart';
import 'package:endy/Pages/main/setting/Setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utils/index.dart';

class MainContainerRoute extends StatefulWidget {
  const MainContainerRoute({Key? key}) : super(key: key);

  @override
  State<MainContainerRoute> createState() => _MainContainerRouteState();
}

class _MainContainerRouteState extends State<MainContainerRoute> {
  static _children(BuildContext context) {
    return [
      HomePage(),
      BonusHomeRoute(),
      CatalogMainRoute(),
      // ListHome(),
      SettingRoute(),
      FavoriteMainRoute()
    ];
  }

  static List<int> get blacklist => [1, 4];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GlobalBloc, GlobalState>(
      buildWhen: (previous, current) =>
          current.authStatus == GlobalAuthStatus.loggedIn,
      builder: (globalContext, globalState) {
        final disallowed =
            globalState.authStatus == GlobalAuthStatus.loggedIn &&
                globalState.userData == null;
        return BlocBuilder<HomePageNavBloc, int>(builder: (context, state) {
          return BlocBuilder<SearchPageBloc, SearchPageState>(
            buildWhen: (previous, current) => previous.search != current.search,
            builder: (searchContext, searchState) {
              return WillPopScope(
                  child: ScaffoldWrapper(
                    hPadding: 0,
                    backgroundColor: Colors.white,
                    extendBody: true,
                    bottomNavigationBar: SizedBox(
                      height: 80,
                      child: Nav(),
                    ),
                    body: blacklist.contains(state) && disallowed
                        ? NeedRegisterRoute()
                        : SingleChildScrollView(
                            child: _children(context)[state]),
                  ),
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
          );
        });
      },
    );
  }
}
