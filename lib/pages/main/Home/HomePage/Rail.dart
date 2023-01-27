import 'package:endy/Pages/main/Home/HomePage/Home_Page_Bloc.dart';
import 'package:endy/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget NavRail(int index, BuildContext context) {
  final currentIndex = context.read<HomePageNavBloc>();
  return NavigationRail(
    indicatorColor: Color(mainColor),
    leading: Container(
      width: 50,
      height: 30,
      child: FittedBox(
        fit: BoxFit.contain,
        child: Image(
          image: AssetImage("assets/logos/logod.png"),
          // width: 40,
        ),
      ),
    ),
    selectedIndex: index,
    onDestinationSelected: (value) => currentIndex.setIndex(value),
    minWidth: 60,
    destinations: [
      NavigationRailDestination(
          icon: FittedBox(
            child: ImageIcon(
              const AssetImage("assets/icons/navbar/home.png"),
              color: index == 0 ? Colors.white : Colors.grey.shade400,
            ),
          ),
          label: Text('Ana Səhifə')),
      NavigationRailDestination(
          icon: FittedBox(
            fit: BoxFit.contain,
            child: ImageIcon(
              const AssetImage("assets/icons/navbar/card.png"),
              color: index == 1 ? Colors.white : Colors.grey.shade400,
            ),
          ),
          label: Text('Bonus Kart')),
      NavigationRailDestination(
          icon: ImageIcon(
            const AssetImage("assets/icons/navbar/catalog.png"),
            color: index == 2 ? Colors.white : Colors.grey.shade400,
          ),
          label: Text('Kataloq')),
      NavigationRailDestination(
          icon: ImageIcon(
            const AssetImage("assets/icons/navbar/dots.png"),
            color: index == 3 ? Colors.white : Colors.grey.shade400,
          ),
          label: Text('Daha çox')),
    ],
  );
}
