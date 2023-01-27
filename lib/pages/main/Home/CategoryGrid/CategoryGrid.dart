import 'package:async/async.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:endy/Pages/main/Home/CategoryGrid/CategoryGridLayout.dart';
import 'package:endy/Pages/main/Home/CategoryGrid/Category_Cache_Bloc.dart';
import 'package:endy/Pages/main/Home/CategoryGrid/Category_Grid_Bloc.dart';
import 'package:endy/Pages/main/Home/CategoryGrid/Category_Grid_Bar_Bloc.dart';
import 'package:endy/Pages/main/Home/CategoryGrid/ScrollableAllButton.dart';
import 'package:endy/Pages/main/Home/CategoryGrid/TabBar.dart' as tab;
import 'package:endy/Pages/main/Home/FilterPage/Filter_Page_Bloc.dart';
import 'package:endy/Pages/main/Home/SearchPage/Search_Page_Bloc.dart';
import 'package:endy/Pages/main/Home/SearchPage/Search.dart';
import 'package:endy/main.dart';
import 'package:endy/utils/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:typesense/typesense.dart';

class CategoryGrid extends StatefulWidget {
  const CategoryGrid({Key? key}) : super(key: key);

  @override
  State<CategoryGrid> createState() => _CategoryGridState();
}

class _CategoryGridState extends State<CategoryGrid> {
  TextEditingController editingController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final client = Client(typesenseConfig);
  var focusNode = FocusNode();

  @override
  void initState() {
    context.read<FilterPageBloc>().changeFilter(FilterPageState.none);
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        var searchState = context.read<SearchPageBloc>().state;
        var state = context.read<CategoryGridBloc>().state;
        if (searchState.search.isNotEmpty) {
          if (!searchState.isSearching && !searchState.isLastPage) {
            context.read<SearchPageBloc>().setIsSearching(true);
            context.read<SearchPageBloc>().getSearchResult(
                state.category, state.company, state.subcategory, client);
          }
        } else {
          var ctx = context.read<CategoryCacheBloc>();
          var cacheState = ctx.state;
          if (!cacheState.isSearching && !cacheState.isLastPage) {
            var filterState = context.read<FilterPageBloc>().state;
            ctx.setSearching(true);
            var c = CancelableOperation.fromFuture(ctx.getResult(
                state.category, state.company, state.subcategory, client,
                mode: filterState));
            ctx.setCancelableoperation(c);
            c.value.then((value) {
              if (value != null) {
                ctx.setState(value);
              }
            });
          }
        }
      }
    });
  }

  Future<void> filterClick(CategoryGridState state) async {
    await Navigator.pushNamed(context, "/home/filter");

    var filterState = context.read<FilterPageBloc>().state;
    if (state != FilterPageState.none) {
      final ctx = context.read<CategoryCacheBloc>();
      ctx.reset();

      var c = CancelableOperation.fromFuture(ctx.getResult(
          state.category, state.company, state.subcategory, client,
          mode: filterState));
      ctx.setCancelableoperation(c);

      final newState = await c.value;
      if (newState != null) {
        ctx.setState(newState);
      }
    }
  }

  @override
  void dispose() {
    // context.read<CategoryCacheBloc>().setClose();
    editingController.dispose();
    scrollController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return BlocBuilder<SearchPageBloc, SearchPageState>(
      buildWhen: (previous, current) => previous.search != current.search,
      builder: (searchContext, searchState) {
        return BlocBuilder<FilterPageBloc, FilterPageState>(
          builder: (filterContext, filterState) {
            return BlocBuilder<CategoryGridBloc, CategoryGridState>(
              builder: (context, state) {
                return Scaffold(
                  backgroundColor: Colors.white,
                  appBar: AppBar(
                    surfaceTintColor: Colors.white,
                    toolbarHeight: 80,
                    leadingWidth: 56,
                    // titleSpacing: 35,
                    leading: IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                    centerTitle: true,
                    title:
                        BlocBuilder<CategoryGridBarBloc, CategoryGridBarState>(
                      builder: (cacheContext, cacheState) {
                        return cacheState.title
                            ? tab.TabBar(
                                category: state.category,
                                company: state.company,
                                subcategory: state.subcategory,
                                mounted: mounted)
                            : Container();
                      },
                    ),
                    actions: <Widget>[
                      AnimatedSearchBox(
                          focusNode: focusNode,
                          editingController: editingController),
                      if (w > 1024)
                        InkWell(
                          mouseCursor: SystemMouseCursors.click,
                          hoverColor: Colors.transparent,
                          onTap: () {
                            filterClick(state);
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
                  ),
                  body: searchState.search.isNotEmpty
                      ? SearchPage(
                          client: client,
                          category: state.category,
                          company: state.company,
                          subcategory: state.subcategory,
                        )
                      : RefreshIndicator(
                          color: const Color(mainColor),
                          onRefresh: () async {
                            context.read<CategoryGridBloc>().resetAll();
                          },
                          child: ListView(
                            controller: scrollController,
                            children: [
                              Visibility(
                                  visible: state.category != null,
                                  child: ScrollableAllButton(
                                    category: state.category,
                                    subcategory: state.subcategory,
                                    selectedId: state.selectedId,
                                    company: state.company,
                                    client: client,
                                    fnSetState: (String selectedId) {
                                      context
                                          .read<CategoryGridBloc>()
                                          .setSelectedId(selectedId);
                                    },
                                  )),
                              const Padding(padding: EdgeInsets.only(top: 20)),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Container(
                                    margin: const EdgeInsets.only(bottom: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text("100-dən çox məhsul",
                                            style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w400)),
                                        const SizedBox(
                                          width: 40,
                                        ),
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              state.company == null
                                                  ? Container()
                                                  : CachedNetworkImage(
                                                      imageUrl:
                                                          state.company?.logo ??
                                                              "",
                                                      width: 40,
                                                    ),
                                              if (w < 1024)
                                                InkWell(
                                                  mouseCursor:
                                                      SystemMouseCursors.click,
                                                  onTap: () {
                                                    filterClick(state);
                                                  },
                                                  child: Image.asset(
                                                    "assets/icons/filter.png",
                                                    height: 20,
                                                  ),
                                                )
                                            ],
                                          ),
                                        )
                                      ],
                                    )),
                              ),
                              CategoryGridLayout(
                                client: client,
                              )
                            ],
                          ),
                        ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class AnimatedSearchBox extends StatelessWidget {
  const AnimatedSearchBox({
    Key? key,
    required this.focusNode,
    required this.editingController,
  }) : super(key: key);

  final FocusNode focusNode;
  final TextEditingController editingController;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return BlocBuilder<CategoryGridBarBloc, CategoryGridBarState>(
      builder: (context, state) {
        return AnimatedContainer(
          onEnd: () {
            if (!state.isClosing) {
              context.read<CategoryGridBarBloc>().setSuffixMode(true);
            } else {
              if (w < 768) {
                context.read<CategoryGridBarBloc>().changeTitleStatus(true);
              }
            }
          },
          curve: Curves.fastOutSlowIn,
          duration: const Duration(milliseconds: 1000),
          padding: EdgeInsets.only(
              top: 20, left: state.isClosing ? 20 : 0, right: 20, bottom: 20),
          width: w < 768 ? state.searchWidth : 300,
          height: 80,
          color: Colors.white,
          child: SizedBox(
            height: 40,
            child: CupertinoSearchTextField(
              placeholder: "Axtarış",
              focusNode: focusNode,
              onTap: () {
                if (state.isClosing) {
                  context.read<CategoryGridBarBloc>().set(
                      width: MediaQuery.of(context).size.width - 57,
                      isClosing: false);
                  if (w < 768) {
                    context
                        .read<CategoryGridBarBloc>()
                        .changeTitleStatus(false);
                  }
                }
              },
              suffixIcon: const Icon(Icons.close),
              suffixMode: state.suffixMode
                  ? OverlayVisibilityMode.always
                  : OverlayVisibilityMode.never,
              suffixInsets: const EdgeInsets.only(right: 10),
              onSuffixTap: () {
                context
                    .read<CategoryGridBarBloc>()
                    .set(width: 80, suffixMode: false, isClosing: true);
                focusNode.unfocus();
                editingController.text = "";
                context.read<SearchPageBloc>().setSearch('');
              },
              onChanged: (value) {
                context.read<SearchPageBloc>().setSearch(value);
              },
              controller: editingController,
              prefixInsets: const EdgeInsets.only(left: 10),
              borderRadius: const BorderRadius.all(Radius.circular(50)),
            ),
          ),
        );
      },
    );
  }
}
