import 'package:auto_route/auto_route.dart';
import 'package:endy/Pages/main/Home/CategoryGrid/Category_Fetch_Bloc.dart';
import 'package:endy/Pages/main/Home/CategoryGrid/Category_Grid_Bloc.dart';
import 'package:endy/Pages/main/Home/CategoryGrid/Category_Grid_Bar_Bloc.dart';
import 'package:endy/Pages/main/Home/FilterPage/Filter_Page_Bloc.dart';
import 'package:endy/types/category.dart';
import 'package:endy/types/company.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:typesense/typesense.dart';
import 'package:endy/utils/index.dart';
import 'package:flutter/material.dart';

class ScrollableCategoryList extends StatefulWidget {
  ScrollableCategoryList({
    Key? key,
    required this.category,
    required this.subcategory,
    required this.company,
    required this.selectedId,
    required this.client,
  }) : super(key: key);

  final Category? category;
  final Subcategory? subcategory;
  final Company? company;
  final String selectedId;
  final Client client;

  @override
  State<ScrollableCategoryList> createState() => _ScrollableCategoryListState();
}

class _ScrollableCategoryListState extends State<ScrollableCategoryList> {
  List<dynamic> subcategories = [];
  @override
  void initState() {
    var allCat = Subcategory(
        id: "",
        createdAt: DateTime.now().millisecondsSinceEpoch,
        products: [],
        name: "Hamısı",
        category: widget.category!.id);
    subcategories = widget.category?.subcategory != null
        ? [allCat, ...widget.category!.subcategory]
        : [allCat];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, size) {
        return BlocBuilder<FilterPageBloc, FilterPageState>(
          builder: (filterContext, filterState) {
            return SizedBox(
              width: size.maxWidth,
              height: 35,
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: subcategories.length,
                  itemBuilder: (context, index) {
                    final curr = subcategories[index] as Subcategory;
                    return CategoryFilterItem(
                        isSelected: widget.selectedId == curr.id,
                        subcategory: curr,
                        fn: (Subcategory subcategory) async {
                          try {
                            final state =
                                context.read<CategoryFetchBloc>().state;
                            if (state.cancellableOperation != null) {
                              state.cancellableOperation?.cancel();
                            }
                            context.read<CategoryGridBarBloc>().deleteCache();
                            context.router.pushNamed(
                                '/${widget.category != null ? "category" : "company"}/products/${widget.category?.id ?? widget.company?.id}/${curr.id == "" ? "all" : curr.id}');
                            // CategoryFetchBloc.fetch(
                            //     context,
                            //     widget.client,
                            //     widget.category?.id,
                            //     widget.company?.id,
                            //     widget.subcategory?.id,
                            //     resetProduct: true);
                          } catch (e) {
                            print(e);
                          }
                        });
                  }),
            );
          },
        );
      },
    );
  }
}

class CategoryFilterItem extends StatelessWidget {
  final Subcategory subcategory;
  final bool isSelected;
  final Future<void> Function(Subcategory category) fn;
  const CategoryFilterItem(
      {Key? key,
      required this.subcategory,
      required this.isSelected,
      required this.fn})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 5, left: 5),
      child: ElevatedButton(
          onPressed: () async {
            await fn(subcategory);
          },
          style: ButtonStyle(
            surfaceTintColor: MaterialStateProperty.all<Color>(Colors.white),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100.0),
                side: BorderSide(
                  color: isSelected ? const Color(mainColor) : Colors.black,
                  width: 1.0,
                ),
              ),
            ),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
            foregroundColor: MaterialStateProperty.all<Color>(
                isSelected ? const Color(mainColor) : Colors.black),
          ),
          child: Text(
            subcategory.name,
            style: const TextStyle(fontSize: 15),
          )),
    );
  }
}
