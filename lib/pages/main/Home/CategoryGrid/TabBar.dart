import 'package:endy/MainBloc/GlobalBloc.dart';
import 'package:endy/types/category.dart';
import 'package:endy/types/company.dart';
import 'package:endy/utils/index.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' as io;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TabBar extends StatelessWidget {
  const TabBar({
    Key? key,
    required this.category,
    required this.company,
    required this.subcategory,
    required this.mounted,
  }) : super(key: key);

  final Category? category;
  final Company? company;
  final Subcategory? subcategory;
  final bool mounted;

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
          if (company != null && !io.kIsWeb && globalState.userData != null)
            Flexible(
                flex: 1,
                child: IconButton(
                    onPressed: () async {
                      if (!globalState.userData!.subscribedCompanies
                          .contains(company!.id)) {
                        await FirebaseMessaging.instance
                            .subscribeToTopic(company!.id);
                        if (!mounted) return;
                        context.read<GlobalBloc>().addSubscription(company!.id);
                        ShowTopSnackBar(context, "Uğurla abonə oldunuz.",
                            success: true);
                      } else {
                        await FirebaseMessaging.instance
                            .unsubscribeFromTopic(company!.id);
                        if (!mounted) return;
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
