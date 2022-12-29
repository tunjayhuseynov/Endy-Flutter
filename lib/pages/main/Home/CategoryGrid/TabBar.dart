import 'package:endy/MainBloc/GlobalBloc.dart';
import 'package:endy/types/category.dart';
import 'package:endy/types/company.dart';
import 'package:endy/types/user.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class TabBar extends StatelessWidget {
  const TabBar({
    Key? key,
    required this.category,
    required this.company,
    required this.subcategory,
    required this.user,
    required this.mounted,
  }) : super(key: key);

  final Category? category;
  final Company? company;
  final Subcategory? subcategory;
  final UserData user;
  final bool mounted;

  @override
  Widget build(BuildContext context) {
    return Flex(direction: Axis.horizontal, children: [
      Flexible(
          flex: 4,
          child: Text(
              category?.name ?? company?.name ?? subcategory?.name ?? "",
              style:
                  const TextStyle(fontSize: 25, fontWeight: FontWeight.w500))),
      const SizedBox(width: 10),
      company != null
          ? Flexible(
              flex: 1,
              child: IconButton(
                  onPressed: () async {
                    final state = Overlay.of(context);
                    if (!user.subscribedCompanies.contains(company!.id)) {
                      await FirebaseMessaging.instance
                          .subscribeToTopic(company!.id);
                      if (!mounted || state == null) return;
                      context.read<GlobalBloc>().addSubscription(company!.id);
                      showTopSnackBar(
                        state,
                        const CustomSnackBar.success(
                          message: "Uğurla abonə oldunuz.",
                        ),
                      );
                    } else {
                      await FirebaseMessaging.instance
                          .unsubscribeFromTopic(company!.id);
                      if (!mounted || state == null) return;
                      context
                          .read<GlobalBloc>()
                          .removeSubscription(company!.id);
                      showTopSnackBar(
                        state,
                        const CustomSnackBar.success(
                          message: "Uğurla abonəlikdən çıxdınız.",
                        ),
                      );
                    }
                  },
                  icon: Icon(context
                          .read<GlobalBloc>()
                          .state
                          .userData!
                          .subscribedCompanies
                          .contains(company!.id)
                      ? Icons.notifications_active_rounded
                      : Icons.notifications_none_rounded)))
          : Container(),
    ]);
  }
}
