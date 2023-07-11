 
import 'package:endy/route/router_names.dart';
import 'package:endy/utils/responsivness/container.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Footer extends StatelessWidget {
  const Footer({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: getContainerSize(w)),
      color: Color(0xFF1C1C1C), // Background color
      height: 80.0,
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Image.asset(
              'assets/logos/logod.png', // Your logo image asset
              height: 48.0,
            ),
          ),
          Spacer(),
          _buildFooterLink(context, 'Ana səhifə'),
          SizedBox(width: 16.0),
          _buildFooterLink(context, 'Kataloq'),
          SizedBox(width: 16.0),
          _buildFooterLink(context, 'Haqqımızda'),
          SizedBox(width: 16.0),
        ],
      ),
    );
  }

  Widget _buildFooterLink(BuildContext context, String title) {
    return InkWell(
      onTap: () {
        switch (title) {
          case "Ana səhifə":
            context.pushNamed(APP_PAGE.HOME.toName);
            break;
          case "Kataloq":
            context.pushNamed(APP_PAGE.CATALOG.toName);
            break;
          case "Haqqımızda":
            context.pushNamed(APP_PAGE.ABOUT.toName);
            break;
          default:
        }
      },
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
