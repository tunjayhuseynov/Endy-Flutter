import 'package:auto_route/auto_route.dart';
import 'package:endy/MainBloc/GlobalBloc.dart';
import 'package:endy/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';

class AboutUsRoute extends StatelessWidget {
  const AboutUsRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GlobalBloc, GlobalState>(
      buildWhen: (previous, current) => previous.aboutApp != current.aboutApp,
      builder: (context, state) {
        return ScaffoldWrapper(
          backgroundColor: Colors.white,
          appBar: AppBar(
            toolbarHeight: 80,
            leading: IconButton(
                onPressed: () {
                  context.router.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios)),
            title: const Text('Haqqımızda',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500)),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 75),
            child: Html(
              shrinkWrap: true,
              data: state.aboutApp,
              style: {
                "p": Style(
                  margin: Margins.only(bottom: 10),
                )
              },
            ),
          ),
        );
      },
    );
  }
}
