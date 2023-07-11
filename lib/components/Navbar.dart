import 'package:endy/MainBloc/GlobalBloc.dart';
import 'package:endy/Pages/main/Home/HomePage/HomePage.dart';
import 'package:endy/route/router_names.dart';
import 'package:endy/utils/index.dart';
import 'package:endy/utils/responsivness/container.dart';
import 'package:endy/utils/responsivness/navbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pluto_menu_bar/pluto_menu_bar.dart';
import 'dart:math' as Math;

class Navbar extends StatefulWidget implements PreferredSizeWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => NavbarState();

  @override
  Size get preferredSize => Size(double.infinity, 75);
}

int getRouteIndex(String route) {
  if (route == "/") {
    return 0;
  } else if (route.contains("/catalog")) {
    return 1;
  } else if (route.contains("/cart")) {
    return 2;
  } else if (route.contains("/profile")) {
    return 3;
  } else if (route.contains("/favorite")) {
    return 4;
  } else if (route.contains("/about")) {
    return 5;
  } else {
    return 0;
  }
}

class NavbarState extends State<Navbar> {
  final editingController = TextEditingController();
  @override
  void initState() {
    super.initState();
    // editingController.text =
    //     context.routeData.queryParams.getString("params", "");
  }

  @override
  void dispose() {
    editingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    // final route = getRouteIndex(context.currentPath);

    return BlocBuilder<GlobalBloc, GlobalState>(builder: (context, state) {
      return Material(
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: Math.max(0, getContainerSize(w) - 25)),
          color: Colors.white,
          height: 75,
          width: w,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: getNavbarImageAndMenuFlex(w),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => context.pushNamed(APP_PAGE.HOME.toName),
                    child: Container(
                        alignment: Alignment.bottomCenter,
                        padding: const EdgeInsets.only(right: 40),
                        width: 125,
                        height: 50,
                        child: Image.asset("assets/logos/logod.png",
                            width: 125, height: 50, fit: BoxFit.contain)),
                  ),
                ),
              ),
              // Expanded(
              //   flex: getNavbarSearchFlex(w),
              //   child: TopBar(editingController: editingController),
              // ),
              Flexible(
                flex: getNavbarImageAndMenuFlex(w),
                fit: FlexFit.loose,
                child: Container(
                  padding: const EdgeInsets.only(left: 20),
                  width: double.infinity,
                  // constraints: BoxConstraints(maxWidth: 200),
                  alignment: Alignment.bottomRight,
                  child: PlutoMenuBar(
                    height: 35,
                    mode: PlutoMenuBarMode.hover,
                    itemStyle: PlutoMenuItemStyle(
                      enableSelectedTopMenu: true,
                      // initialSelectedTopMenuIndex: route,
                      selectedTopMenuIconColor: Color(mainColor),
                      selectedTopMenuTextStyle: TextStyle(
                        color: Color(mainColor),
                      ),
                    ),
                    borderColor: Colors.transparent,
                    menus: [
                      PlutoMenuItem(
                        title: "Ana səhifə",
                        icon: Icons.home,
                        onTap: () {
                          context.pushNamed(APP_PAGE.HOME.toName);
                        },
                      ),
                      PlutoMenuItem(
                        title: "Kataloq",
                        icon: Icons.menu_book_rounded,
                        onTap: () {
                          context.pushNamed(APP_PAGE.CATALOG.toName);
                        },
                      ),
                      PlutoMenuItem(
                        title: "",
                        icon: Icons.more_horiz,
                        enable: false,
                        children: [
                          if (!state.isAnonymous)
                            PlutoMenuItem(
                              title: "Profil",
                              icon: Icons.person,
                              onTap: () {
                                context.pushNamed(APP_PAGE.PROFILE.toName);
                              },
                            ),
                          if (state.isAnonymous)
                            PlutoMenuItem(
                              title: "Daxil ol",
                              icon: Icons.login,
                              onTap: () {
                                FirebaseAuth.instance.signOut();
                                context.pushNamed(APP_PAGE.SIGN_MAIN.toName);
                              },
                            ),
                          PlutoMenuItem(
                            title: "Seçimlərim",
                            icon: Icons.favorite,
                            onTap: () {
                              context.pushNamed(APP_PAGE.FAVORITE.toName);
                            },
                          ),
                          PlutoMenuItem(
                            title: "Alış-veriş listim",
                            icon: Icons.list,
                            onTap: () {
                              context.pushNamed(APP_PAGE.SHOPPING_LIST.toName);
                            },
                          ),
                          PlutoMenuItem(
                            title: "Haqqımızda",
                            icon: Icons.info,
                            onTap: () {
                              context.pushNamed(APP_PAGE.ABOUT.toName);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
