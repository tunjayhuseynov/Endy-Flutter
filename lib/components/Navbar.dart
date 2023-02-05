import 'package:endy/Pages/main/Home/HomePage/HomePage.dart';
import 'package:endy/utils/responsivness/container.dart';
import 'package:endy/utils/responsivness/navbar.dart';
import 'package:flutter/material.dart';
import 'package:pluto_menu_bar/pluto_menu_bar.dart';
import 'dart:math' as Math;

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => NavbarState();
}

class NavbarState extends State<Navbar> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final editingController = TextEditingController();
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
                  itemStyle: PlutoMenuItemStyle(),
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
                      onTap: () {
                        // Perform action for settings
                      },
                      children: [
                        PlutoMenuItem(
                          title: "Profil",
                          icon: Icons.person,
                          onTap: () {
                            Navigator.of(context).pushNamed("/setting/profile");
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
                            Navigator.of(context).pushNamed("/setting/about");
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
  }
}
