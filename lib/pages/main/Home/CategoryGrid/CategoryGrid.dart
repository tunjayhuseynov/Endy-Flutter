import 'package:cached_network_image/cached_network_image.dart';
import 'package:endy/MainBloc/GlobalBloc.dart';
import 'package:endy/Pages/main/Home/CategoryGrid/CategoryGridLayout.dart';
import 'package:endy/Pages/main/Home/CategoryGrid/Category_Grid_Bloc.dart';
import 'package:endy/Pages/main/Home/CategoryGrid/Category_Grid_Cache_Bar_Bloc.dart';
import 'package:endy/Pages/main/Home/CategoryGrid/ScrollableAllButton.dart';
import 'package:endy/Pages/main/Home/CategoryGrid/ScrollableCategoryBar.dart';
import 'package:endy/Pages/main/Home/CategoryGrid/TabBar.dart' as tab;
import 'package:endy/Pages/main/Home/SearchPage/Search_Page_Bloc.dart';
import 'package:endy/Pages/main/Home/SearchPage/Search.dart';
import 'package:endy/utils/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryGrid extends StatefulWidget {
  const CategoryGrid({Key? key}) : super(key: key);

  @override
  State<CategoryGrid> createState() => _CategoryGridState();
}

class _CategoryGridState extends State<CategoryGrid> {
  TextEditingController editingController = TextEditingController();

  var focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SearchPageBloc>(
          create: (context) => SearchPageBloc(),
        ),
        BlocProvider<CategoryGridCacheBloc>(
          create: (context) => CategoryGridCacheBloc(),
        ),
      ],
      child: BlocBuilder<SearchPageBloc, SearchPageState>(
        builder: (searchContext, searchState) {
          return BlocBuilder<CategoryGridBloc, CategoryGridState>(
            builder: (context, state) {
              return Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  surfaceTintColor: Colors.white,
                  toolbarHeight: 80,
                  titleSpacing: 1,
                  leading: IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  title: BlocBuilder<CategoryGridCacheBloc,
                      CategoryGridCacheAndBarState>(
                    builder: (cacheContext, cacheState) {
                      return cacheState.isClosing
                          ? tab.TabBar(
                              category: state.category,
                              company: state.company,
                              subcategory: state.subcategory,
                              user: context.read<GlobalBloc>().state.userData!,
                              mounted: mounted)
                          : Container();
                    },
                  ),
                  actions: <Widget>[
                    AnimatedSearchBox(
                        focusNode: focusNode,
                        editingController: editingController)
                  ],
                ),
                body: searchState.search.isNotEmpty
                    ? SearchPage()
                    : RefreshIndicator(
                        color: const Color(mainColor),
                        onRefresh: () async {
                          context.read<CategoryGridBloc>().resetAll();
                        },
                        child: ListView(
                          children: [
                            Visibility(
                                visible: state.category != null,
                                child: ScrollableAllButton(
                                  category: state.category,
                                  subcategory: state.subcategory,
                                  selectedId: state.selectedId,
                                  company: state.company,
                                  fnSetState: (String selectedId) {
                                    context
                                        .read<CategoryGridBloc>()
                                        .setSelectedId(selectedId);
                                  },
                                )),
                            Visibility(
                                visible: state.company != null,
                                child: ScrollableCategory(
                                  company: state.company,
                                  subcategory: state.subcategory,
                                  selectedId: state.selectedId,
                                  category: state.category,
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
                                                        state.company!.logo,
                                                    width: 40,
                                                  ),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.pushNamed(
                                                    context, "/home/filter");
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
                            const CategoryGridLayout()
                          ],
                        ),
                      ),
              );
            },
          );
        },
      ),
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
    return BlocBuilder<CategoryGridCacheBloc, CategoryGridCacheAndBarState>(
      builder: (context, state) {
        return AnimatedContainer(
          onEnd: () {
            if (!state.isClosing) {
              context.read<CategoryGridCacheBloc>().setSuffixMode(true);
            }
          },
          curve: Curves.fastOutSlowIn,
          duration: const Duration(milliseconds: 1000),
          padding:
              const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
          width: state.searchWidth,
          height: 80,
          color: Colors.white,
          child: SizedBox(
            height: 40,
            child: CupertinoSearchTextField(
              placeholder: "Axtarış",
              focusNode: focusNode,
              onTap: () {
                context
                    .read<CategoryGridCacheBloc>()
                    .setSearchWidth(MediaQuery.of(context).size.width - 30);
              },
              suffixIcon: const Icon(Icons.close),
              suffixMode: state.suffixMode
                  ? OverlayVisibilityMode.always
                  : OverlayVisibilityMode.never,
              suffixInsets: const EdgeInsets.only(right: 10),
              onSuffixTap: () {
                context
                    .read<CategoryGridCacheBloc>()
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
