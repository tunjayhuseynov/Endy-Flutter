import 'package:endy/MainBloc/GlobalBloc.dart';
import 'package:endy/components/AdSlider.dart';
import 'package:endy/Pages/main/Home/HomePage/Home_Page_Bloc.dart';
import 'package:endy/Pages/main/Home/SearchPage/Search_Page_Bloc.dart';
import 'package:endy/Pages/main/Home/HomePage/ScrollableCategoriesHome.dart';
import 'package:endy/Pages/main/Home/HomePage/HomePageGridProducts.dart';
import 'package:endy/Pages/main/Home/SearchPage/Search.dart';
import 'package:endy/main.dart';
import 'package:endy/utils/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:typesense/typesense.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final client = Client(typesenseConfig);
  TextEditingController editingController = TextEditingController();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        var state = context.read<SearchPageBloc>().state;
        if (state.search.isNotEmpty &&
            !state.isLastPage &&
            !state.isSearching) {
          context.read<SearchPageBloc>().setIsSearching(true);
          context
              .read<SearchPageBloc>()
              .getSearchResult(null, null, null, client);
        }
      }
    });
  }

  @override
  void dispose() {
    editingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocConsumer<SearchPageBloc, SearchPageState>(
      listener: (context, state) {
        if (state.search.isEmpty) {
          editingController.clear();
        }
      },
      buildWhen: (previous, current) => previous.search != current.search,
      builder: (context, state) {
        var categories = context.read<GlobalBloc>().state.categories;
        categories.sort((a, b) => a.iconOrder.compareTo(b.iconOrder));
        return Scaffold(
          backgroundColor: Colors.white,
          body: RefreshIndicator(
            color: const Color(mainColor),
            triggerMode: RefreshIndicatorTriggerMode.anywhere,
            onRefresh: () async =>
                {context.read<HomePageCacheBloc>().deleteCache()},
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                children: [
                  SizedBox(height: 30),
                  TopBar(size: size, editingController: editingController),
                  state.search.isNotEmpty
                      ? SearchPage(client: client)
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
                                child:
                                    ScrollableCategoriesHome(list: categories)),
                            // const Padding(padding: EdgeInsets.only(top: 15)),
                            HomePageGridProducts()
                          ],
                        )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class TopBar extends StatelessWidget {
  const TopBar({
    Key? key,
    required this.size,
    required this.editingController,
  }) : super(key: key);

  final Size size;
  final TextEditingController editingController;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
      width: size.width,
      height: 80,
      // color: Colors.white,
      child: SizedBox(
        height: 40,
        child: CupertinoSearchTextField(
          placeholder: "Axtarış",
          onSuffixTap: () => context.read<SearchPageBloc>().setSearch(''),
          onSubmitted: (value) =>
              context.read<SearchPageBloc>().setSearch(value),
          controller: editingController,
          prefixInsets: const EdgeInsets.only(left: 10),
          borderRadius: const BorderRadius.all(Radius.circular(50)),
        ),
      ),
    );
  }
}
