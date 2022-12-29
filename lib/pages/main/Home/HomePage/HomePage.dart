import 'package:endy/MainBloc/GlobalBloc.dart';
import 'package:endy/components/AdSlider.dart';
import 'package:endy/pages/main/Home/HomePage/Home_Page_Bloc.dart';
import 'package:endy/pages/main/Home/SearchPage/Search_Page_Bloc.dart';
import 'package:endy/pages/main/Home/HomePage/ScrollableCategoriesHome.dart';
import 'package:endy/pages/main/Home/HomePage/HomePageGridProducts.dart';
import 'package:endy/pages/main/Home/SearchPage/Search.dart';
import 'package:endy/utils/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController editingController = TextEditingController();

  @override
  void dispose() {
    editingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocProvider<SearchPageBloc>(
      lazy: false,
      create: (context) => SearchPageBloc(),
      child: BlocBuilder<SearchPageBloc, SearchPageState>(
        buildWhen: (previous, current) => previous.search != current.search,
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: RefreshIndicator(
              color: const Color(mainColor),
              triggerMode: RefreshIndicatorTriggerMode.anywhere,
              onRefresh: () async =>
                  {context.read<HomePageCacheBloc>().deleteCache()},
              child: ListView(
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                        top: 20, left: 20, right: 20, bottom: 20),
                    width: size.width,
                    height: 80,
                    // color: Colors.white,
                    child: SizedBox(
                      height: 40,
                      child: CupertinoSearchTextField(
                        placeholder: "Axtarış",
                        onChanged: (value) =>
                            context.read<SearchPageBloc>().setSearch(value),
                        controller: editingController,
                        prefixInsets: const EdgeInsets.only(left: 10),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(50)),
                      ),
                    ),
                  ),
                  state.search.isNotEmpty
                      ? SearchPage()
                      : Column(
                          children: [
                            const Padding(padding: EdgeInsets.only(top: 5)),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: const AdSlider(),
                            ),
                            const Padding(padding: EdgeInsets.only(top: 20)),
                            Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 0),
                                child: ScrollableCategoriesHome(
                                    list: context
                                        .read<GlobalBloc>()
                                        .state
                                        .categories)),
                            const Padding(padding: EdgeInsets.only(top: 15)),
                            const HomePageGridProducts()
                          ],
                        )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
