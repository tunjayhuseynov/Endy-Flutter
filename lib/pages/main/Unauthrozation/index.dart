 
import 'package:endy/components/Footer.dart';
import 'package:endy/components/Navbar.dart';
import 'package:endy/route/router_names.dart';
import 'package:endy/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

 
class UnauthorizationRoute extends StatelessWidget {
  const UnauthorizationRoute({super.key, this.deactivateTab});
  final bool? deactivateTab;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        context.pushNamed(APP_PAGE.HOME.toName);
        return false;
      },
      child: ScaffoldWrapper(
        hPadding: 0,
        appBar: deactivateTab == null || deactivateTab == false
            ? AppBar(
                surfaceTintColor: Colors.white,
                toolbarHeight: 80,
                leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      context.pushNamed(APP_PAGE.HOME.toName);
                    }),
              )
            : null,
        body: Column(
          children: [
            if (w >= 1024) const Navbar(),
            Expanded(
              child: Center(
                child: Container(
                  height: 200,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                          "Bu xidməti istifadə etmək üçün zəhmət olmasa qeydiyyatdan keçin",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1)),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          context.pushNamed(APP_PAGE.SIGN_UP.toName);
                        },
                        child: const Text("Qeydiyyatdan keç",
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(mainColor),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (w >= 1024) const Footer()
          ],
        ),
      ),
    );
  }
}
