import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:endy/MainBloc/GlobalBloc.dart';
import 'package:endy/components/AdSlider.dart';
import 'package:endy/Pages/main/Home/HomePage/Home_Page_Bloc.dart';
import 'package:endy/Pages/main/Home/SearchPage/Search_Page_Bloc.dart';
import 'package:endy/Pages/main/Home/HomePage/ScrollableCategoriesHome.dart';
import 'package:endy/Pages/main/Home/HomePage/HomePageGridProducts.dart';
import 'package:endy/Pages/main/Home/SearchPage/Search.dart';
import 'package:endy/components/Footer.dart';
import 'package:endy/components/Navbar.dart';
import 'package:endy/main.dart';
import 'package:endy/utils/index.dart';
import 'package:endy/utils/responsivness/container.dart';
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
  void dispose() {
    editingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocBuilder<GlobalBloc, GlobalState>(
      builder: (gContext, gState) {
        return BlocConsumer<SearchPageBloc, SearchPageState>(
          listener: (context, state) {
            if (state.search.isEmpty) {
              editingController.clear();
            }
          },
          buildWhen: (previous, current) => previous.search != current.search,
          builder: (context, state) {
            return RefreshIndicator(
              color: const Color(mainColor),
              triggerMode: RefreshIndicatorTriggerMode.anywhere,
              onRefresh: () async =>
                  {context.read<HomePageCacheBloc>().deleteCache()},
              child: Column(
                children: [
                  if (size.width >= 1024) const Navbar(),
                  SizedBox(height: 30),
                  if (size.width < 1024)
                    TopBar(editingController: editingController),
                  state.search.isNotEmpty && size.width < 1024
                      ? SearchPageRoute()
                      : Container(
                          constraints: BoxConstraints(minHeight: size.height),
                          padding: EdgeInsets.symmetric(
                              horizontal: getContainerSize(size.width)),
                          child: Column(
                            children: [
                              const Padding(padding: EdgeInsets.only(top: 5)),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: const AdSlider(),
                              ),
                              const Padding(padding: EdgeInsets.only(top: 20)),
                              ScrollableCategoriesHome(
                                  list: gState.categories,
                                  allBrands: gState.companies),
                              // const Padding(padding: EdgeInsets.only(top: 15)),
                              const HomePageGridProducts()
                            ],
                          ),
                        ),
                  if (size.width >= 1024) const Footer(),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class TopBar extends StatefulWidget {
  const TopBar({
    Key? key,
    required this.editingController,
  }) : super(key: key);

  final TextEditingController? editingController;

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: size.width < 1024
          ? const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20)
          : null,
      width: size.width < 1024 ? size.width : null,
      height: 80,
      alignment: size.width >= 1024 ? Alignment.bottomCenter : null,
      child: Container(
        height: 40,
        alignment: size.width >= 1024 ? Alignment.bottomCenter : null,
        child: CupertinoSearchTextField(
          placeholder: "Axtarış",
          onSuffixTap: () {
            context.read<SearchPageBloc>().setSearch('');
            var path = context.router.stackData
                .firstWhere((element) => element.name == "SearchPage",
                    orElse: () => context.router.stackData.last)
                .path;
            context.router
                .pushNamed(context.routeData.path == path ? "/" : path);
            widget.editingController?.clear();
          },
          onChanged: (value) {
            if (_debounce != null || _debounce?.isActive == true) {
              _debounce?.cancel();
            }
            if (value.isNotEmpty) {
              _debounce = Timer(const Duration(milliseconds: 800), () {
                context.read<SearchPageBloc>().setSearch(value);
                context.router.pushNamed("/search?params=" + value);
              });
            } else {
              context.read<SearchPageBloc>().setSearch(value);
              var path = context.router.stackData
                  .firstWhere((element) => element.name == "SearchPage",
                      orElse: () => context.router.stackData.last)
                  .path;
              context.router
                  .pushNamed(context.routeData.path == path ? "/" : path);
            }
          },
          controller: widget.editingController,
          prefixInsets: const EdgeInsets.only(left: 10),
          borderRadius: const BorderRadius.all(Radius.circular(50)),
        ),
      ),
    );
  }
}
