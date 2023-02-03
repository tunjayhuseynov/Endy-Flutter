import 'dart:io';
import 'package:endy/MainBloc/GlobalBloc.dart';
import 'package:endy/Pages/main/Catalog/CatalogMain.dart';
import 'package:endy/Pages/main/Home/HomePage/Nav.dart';
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
  static _children(BuildContext context) {
    return [
      HomePage(),
      BonusHome(),
      CatalogMain(),
      // ListHome(),
      Setting(),
      FavoriteMain()
    ];
  }

  static List<int> get blacklist => [1, 4];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return BlocBuilder<GlobalBloc, GlobalState>(
      buildWhen: (previous, current) =>
          current.authStatus == GlobalAuthStatus.loggedIn,
      builder: (globalContext, globalState) {
        final disallowed =
            globalState.authStatus == GlobalAuthStatus.loggedIn &&
                globalState.userData == null;
        return BlocBuilder<HomePageNavBloc, int>(builder: (context, state) {
          return BlocProvider<SearchPageBloc>(
              lazy: false,
              create: (context) => SearchPageBloc(),
              child: BlocBuilder<SearchPageBloc, SearchPageState>(
                buildWhen: (previous, current) =>
                    previous.search != current.search,
                builder: (searchContext, searchState) {
                  return WillPopScope(
                      child: width < 1024
                          ? Scaffold(
                              backgroundColor: Colors.white,
                              extendBody: true,
                              bottomNavigationBar: SizedBox(
                                height: 80,
                                child: Nav(),
                              ),
                              body: blacklist.contains(state) && disallowed
                                  ? NeedRegister()
                                  : SingleChildScrollView(
                                      child: _children(context)[state]),
                            )
                          : _children(context)[state],
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
