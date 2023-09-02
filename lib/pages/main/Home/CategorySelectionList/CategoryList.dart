import 'package:cached_network_image/cached_network_image.dart';
import 'package:endy/MainBloc/GlobalBloc.dart';
import 'package:endy/Pages/main/Home/CategorySelectionList/Category_List_Bloc.dart';
import 'package:endy/route/router_names.dart';
import 'package:endy/model/category.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CategoryListRoute extends StatefulWidget {
  const CategoryListRoute({Key? key}) : super(key: key);

  @override
  State<CategoryListRoute> createState() => _CategoryListRouteState();
}

class _CategoryListRouteState extends State<CategoryListRoute> {
  TextEditingController editingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<CategoryListBloc>().search("");
  }

  @override
  void dispose() {
    editingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return BlocSelector<CategoryListBloc, CategoryListState, CategoryListState>(
      selector: (state) {
        return state.copyWith(
          categories: context
              .read<GlobalBloc>()
              .state
              .categories
              .where((element) => state.searchValue != ""
                  ? element.name
                      .toLowerCase()
                      .contains(state.searchValue.toLowerCase())
                  : true)
              .toList(),
        );
      },
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () async {
            return true;
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              surfaceTintColor: Colors.white,
              toolbarHeight: 80,
              leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    context.pop(context);
                  }),
              title: Text(state.selectedCategory?.name ?? "",
                  style: const TextStyle(
                      fontSize: 25, fontWeight: FontWeight.w500)),
            ),
            body: Column(
              children: [
                Container(
                  width: w < 768 ? null : 300,
                  padding: const EdgeInsets.all(8.0),
                  child: CupertinoSearchTextField(
                    placeholder: "Axtarış",
                    onChanged: (value) {
                      context.read<CategoryListBloc>().search(value);
                    },
                    controller: editingController,
                    prefixInsets: const EdgeInsets.only(left: 20),
                    borderRadius: const BorderRadius.all(Radius.circular(50)),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.categories.length,
                      itemBuilder: (BuildContext context, int index) {
                        return CategoryItem(
                          category: state.categories[index],
                        );
                      }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class CategoryItem extends StatelessWidget {
  final Category category;
  const CategoryItem({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final productAmount = category.subcategory.map((e) => e.products.length);
    final amountOfSub = productAmount.isNotEmpty
        ? productAmount.reduce((value, element) => value + element)
        : 0;

    return Container(
      padding: w < 768 ? null : EdgeInsets.symmetric(horizontal: (w - 768) / 2),
      child: InkWell(
        mouseCursor: SystemMouseCursors.click,
        onTap: () {
          context.pushNamed(APP_PAGE.SUBCATEGORY_LIST.toName,
              pathParameters: {"id": category.id});
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: const EdgeInsets.only(right: 15),
                width: 45,
                height: 45,
                child: CachedNetworkImage(imageUrl: category.logo),
              ),
              Expanded(flex: 2, child: Text(category.name)),
              Text(amountOfSub.toString(),
                  style: const TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }
}
