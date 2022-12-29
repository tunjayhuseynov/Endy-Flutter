import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:endy/MainBloc/GlobalBloc.dart';
import 'package:endy/pages/main/Home/CategorySelectionList/Category_List_Bloc.dart';
import 'package:endy/pages/main/Home/CategorySelectionList/Category_Selection_List_Bloc.dart';
import 'package:endy/types/category.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScrollableCategoriesHome extends StatelessWidget {
  late final List<Category> list;
  final Category allcategory = Category(
      id: "100",
      name: "Kateqoriya",
      logo: "assets/icons/category.png",
      productCount: 0,
      isAllCategories: true,
      isAllBrands: false,
      createdAt: 0);

  final Category brands = Category(
      id: "200",
      name: "Brendlər",
      logo: "assets/icons/brand.png",
      productCount: 0,
      isAllCategories: false,
      isAllBrands: true,
      createdAt: 0);
  ScrollableCategoriesHome({Key? key, required List<Category> list})
      : super(key: key) {
    this.list = [allcategory, brands, ...list];
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        itemCount: list.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, index) =>
            _buildBox(category: list[index], context: context),
      ),
    );
  }

  Widget _buildBox(
          {required Category category, required BuildContext context}) =>
      GestureDetector(
        onTap: () {
          if (category.id == "100") {
            context.read<CategoryListBloc>().setTypeAndList(category);

            Navigator.pushNamed(context, "/home/category/all");
          } else {
            context.read<CategorySelectionListBloc>().setTypeAndList(
                category,
                category.isAllCategories,
                category.isAllBrands,
                (!category.isAllBrands && !category.isAllCategories),
                context.read<GlobalBloc>().state.categories,
                context.read<GlobalBloc>().state.companies,
                category.subcategory);

            Navigator.pushNamed(context, "/home/category");
          }
        },
        child: SizedBox(
            height: 100,
            width: 100,
            child: Column(
              children: [
                category.logo.contains("https://")
                    ? SizedBox(
                        height: 40,
                        width: 40,
                        child: CachedNetworkImage(
                            imageUrl: category.logo, fit: BoxFit.cover),
                      )
                    : SizedBox(
                        height: 40,
                        width: 40,
                        child: Image.asset(
                          category.logo,
                          fit: BoxFit.cover,
                        ),
                      ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 40,
                  width: 80,
                  child: AutoSizeText(
                    wrapWords: true,
                    softWrap: true,
                    category.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 12),
                  ),
                )
              ],
            )),
      );
}
