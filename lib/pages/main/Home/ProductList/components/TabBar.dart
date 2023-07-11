import 'package:endy/MainBloc/GlobalBloc.dart';
import 'package:endy/Pages/main/Home/ProductList/Category_Grid_Bar_Bloc.dart';
import 'package:endy/Pages/main/Home/ProductList/Category_Grid_Bloc.dart';
import 'package:endy/Pages/main/Home/ProductList/components/AnimatedSearchBox.dart';
import 'package:endy/route/router_names.dart';
import 'package:endy/types/category.dart';
import 'package:endy/types/company.dart';
import 'package:endy/utils/index.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' as io;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AppBarCategoryList extends StatelessWidget
    implements PreferredSizeWidget {
  const AppBarCategoryList({
    super.key,
    required this.focusNode,
    required this.editingController,
    required this.w,
    this.category,
    this.subcategory,
    this.company,
  });

  final FocusNode focusNode;
  final TextEditingController editingController;
  final double w;
  final Category? category;
  final Subcategory? subcategory;
  final Company? company;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      surfaceTintColor: Colors.white,
      backgroundColor: Colors.white,
      toolbarHeight: 80,
      leadingWidth: 56,
      // titleSpacing: 35,
      leading: BlocBuilder<CategoryGridBloc, CategoryGridState>(
          builder: (context, state) {
        return IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              context.pop(context);
            });
      }),
      centerTitle: true,
      title: BlocBuilder<CategoryGridBarBloc, CategoryGridBarState>(
        builder: (cacheContext, cacheState) {
          return cacheState.title
              ? TabBar(
                  category: category,
                  company: company,
                  subcategory: subcategory,
                )
              : Container();
        },
      ),
      actions: <Widget>[
        AnimatedSearchBox(
            focusNode: focusNode, editingController: editingController),
        if (w > 1024)
          InkWell(
            mouseCursor: SystemMouseCursors.click,
            hoverColor: Colors.transparent,
            onTap: () {
              context.pushNamed(APP_PAGE.FILTER.toName);
            },
            child: Image.asset(
              "assets/icons/filter.png",
              height: 20,
              width: 20,
            ),
          ),
        if (w > 1024)
          SizedBox(
            width: w / 2 - 150,
          )
      ],
    );
  }

  @override
  Size get preferredSize => Size(w, 80);
}


class TabBar extends StatelessWidget {
  const TabBar({
    Key? key,
    required this.category,
    required this.company,
    required this.subcategory,
  }) : super(key: key);

  final Category? category;
  final Company? company;
  final Subcategory? subcategory;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GlobalBloc, GlobalState>(
      builder: (context, globalState) {
        return Flex(direction: Axis.horizontal, children: [
          Flexible(
              flex: 4,
              child: Text(
                  category?.name ?? company?.name ?? subcategory?.name ?? "",
                  style: const TextStyle(
                      fontSize: 25, fontWeight: FontWeight.w500))),
          const SizedBox(width: 10),
          if (company != null && !io.kIsWeb && globalState.userData != null && !globalState.isAnonymous)
            Flexible(
                flex: 1,
                child: IconButton(
                    onPressed: () async {
                      if (!globalState.userData!.subscribedCompanies
                          .contains(company!.id)) {
                        await FirebaseMessaging.instance
                            .subscribeToTopic(company!.id);
                        context.read<GlobalBloc>().addSubscription(company!.id);
                        ShowTopSnackBar(context, "Uğurla abonə oldunuz.",
                            success: true);
                      } else {
                        await FirebaseMessaging.instance
                            .unsubscribeFromTopic(company!.id);
                        context
                            .read<GlobalBloc>()
                            .removeSubscription(company!.id);
                        ShowTopSnackBar(context, "Abonəliyinizi ləğv etdiniz.",
                            error: true);
                      }
                    },
                    icon: Icon(globalState.userData!.subscribedCompanies
                            .contains(company!.id)
                        ? Icons.notifications_active_rounded
                        : Icons.notifications_none_rounded))),
        ]);
      },
    );
  }
}
