import 'package:endy/MainBloc/GlobalBloc.dart';
import 'package:endy/Pages/main/Home/HomePage/HomePage.dart';
import 'package:endy/utils/index.dart';
import 'package:endy/utils/responsivness/container.dart';
import 'package:endy/utils/responsivness/navbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluto_menu_bar/pluto_menu_bar.dart';
import 'dart:math' as Math;

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => NavbarState();
}

getRouteIndex(String route) {
  if (route == "/") {
    return 0;
  } else if (route == "/catalog") {
    return 1;
  } else if (route == "/cart") {
    return 2;
  } else if (route == "/profile") {
    return 3;
  } else if (route == "/favorite") {
    return 3;
  } else if (route == "/about") {
    return 3;
  } else {
    return 0;
  }
}

class NavbarState extends State<Navbar> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final editingController = TextEditingController();
    final route = getRouteIndex(ModalRoute.of(context)?.settings.name ?? "/");

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
                    onTap: () => Navigator.of(context).pushNamed("/"),
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
              Expanded(
                flex: getNavbarSearchFlex(w),
                child: TopBar(size: size, editingController: editingController),
              ),
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
                      selectedTopMenuTextStyle:
                          TextStyle(color: Color(mainColor)),
                      enableSelectedTopMenu: true,
                      initialSelectedTopMenuIndex: route,
                      selectedTopMenuIconColor: Color(mainColor),
                    ),
                    borderColor: Colors.transparent,
                    menus: [
                      PlutoMenuItem(
                        title: "Ana səhifə",
                        icon: Icons.home,
                        onTap: () {
                          Navigator.of(context).pushNamed("/");
                        },
                      ),
                      PlutoMenuItem(
                        title: "Kataloq",
                        icon: Icons.menu_book_rounded,
                        onTap: () {
                          Navigator.of(context).pushNamed("/catalog");
                        },
                      ),
                      PlutoMenuItem(
                        title: "",
                        icon: Icons.more_horiz,
                        enable: false,
                        children: [
                          if (state.userData != null)
                            PlutoMenuItem(
                              title: "Profil",
                              icon: Icons.person,
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed("/profile");
                              },
                            ),
                          if (state.userData == null)
                            PlutoMenuItem(
                              title: "Daxil ol",
                              icon: Icons.login,
                              onTap: () {
                                FirebaseAuth.instance.signOut();
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    "/sign/main", (route) => false);
                              },
                            ),
                          PlutoMenuItem(
                            title: "Seçimlərim",
                            icon: Icons.favorite,
                            onTap: () {
                              Navigator.of(context).pushNamed("/favorite");
                            },
                          ),
                          // PlutoMenuItem(
                          //   title: "Alış-veriş listim",
                          //   icon: Icons.list,
                          //   onTap: () {
                          //     Navigator.of(context).pushNamed("/list");
                          //   },
                          // ),
                          PlutoMenuItem(
                            title: "Haqqımızda",
                            icon: Icons.info,
                            onTap: () {
                              Navigator.of(context).pushNamed("/about");
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
