 
import 'package:endy/MainBloc/GlobalBloc.dart';
import 'package:endy/components/Footer.dart';
import 'package:endy/components/Navbar.dart';
import 'package:endy/utils/index.dart';
import 'package:endy/utils/responsivness/container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:go_router/go_router.dart';

 
class AboutUsRoute extends StatelessWidget {
  const AboutUsRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return BlocBuilder<GlobalBloc, GlobalState>(
      buildWhen: (previous, current) => previous.aboutApp != current.aboutApp,
      builder: (context, state) {
        return ScaffoldWrapper(
          hPadding: 0,
          backgroundColor: Colors.white,
          appBar: AppBar(
            toolbarHeight: 80,
            leading: IconButton(
                onPressed: () {
                  context.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios)),
            title: const Text('Haqqımızda',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500)),
          ),
          body: Column(
            children: [
              if (w >= 1024) const Navbar(),
              Expanded(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: getContainerSize(w), vertical: 75),
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
              ),
              if (w >= 1024) const Footer(),
            ],
          ),
        );
      },
    );
  }
}
