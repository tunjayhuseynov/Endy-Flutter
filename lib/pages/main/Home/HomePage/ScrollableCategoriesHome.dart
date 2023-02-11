import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:endy/MainBloc/GlobalBloc.dart';
import 'package:endy/Pages/main/Home/CategoryGrid/Category_Grid_Bloc.dart';
import 'package:endy/Pages/main/Home/CategorySelectionList/Category_List_Bloc.dart';
import 'package:endy/Pages/main/Home/CategorySelectionList/Category_Selection_List_Bloc.dart';
import 'package:endy/types/category.dart';
import 'package:endy/types/company.dart';
import 'package:endy/utils/responsivness/container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:provider/provider.dart';
import 'package:tap_canvas/tap_canvas.dart';

class ScrollableCategoriesHome extends StatelessWidget {
  final ScrollController controller = ScrollController();

  late final List<Category> list;
  final Category allcategory = Category(
      id: "100",
      name: "Kateqoriya",
      subcategory: [],
      logo: "assets/icons/category.png",
      productCount: 0,
      isAllCategories: true,
      isAllBrands: false,
      createdAt: 0);

  final Category brands = Category(
      id: "200",
      name: "Brendlər",
      subcategory: [],
      logo: "assets/icons/brand.png",
      productCount: 0,
      isAllCategories: false,
      isAllBrands: true,
      createdAt: 0);
  ScrollableCategoriesHome(
      {Key? key,
      required List<Category> list,
      required List<Company> allBrands})
      : super(key: key) {
    this.list = [allcategory, brands, ...list];
    allcategory.subcategory = list;
    brands.subcategory = allBrands;
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final count = w >= 1024 ? list.length - 1 : list.length;
    return Container(
      height: 100,
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: w >= 1024 ? 50 : 0),
            child: ListView.builder(
              shrinkWrap: true,
              controller: controller,
              itemCount: count,
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, index) {
                return CategoryCard(
                    category:
                        w >= 1024 ? list.skip(1).toList()[index] : list[index]);
              },
            ),
          ),
          if (w >= 1024 && count * 100 > w - (getContainerSize(w) * 2))
            Positioned(
                left: 0,
                top: 20,
                child: IconButton(
                    mouseCursor: SystemMouseCursors.click,
                    onPressed: () {
                      controller.animateTo(controller.offset - 100,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.linear);
                    },
                    icon: Icon(
                      CupertinoIcons.back,
                      color: Colors.black,
                    ))),
          if (w >= 1024 && count * 100 > w - (getContainerSize(w) * 2))
            Positioned(
                right: 0,
                top: 20,
                child: IconButton(
                    mouseCursor: SystemMouseCursors.click,
                    onPressed: () {
                      controller.animateTo(controller.offset + 100,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.linear);
                    },
                    icon: Icon(
                      CupertinoIcons.forward,
                      color: Colors.black,
                    )))
        ],
      ),
    );
  }
}

class CategoryCard extends StatefulWidget {
  const CategoryCard({
    super.key,
    required this.category,
  });

  final Category category;

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  bool visible = false;
  bool subVisible = false;

  onSubVisible(bool value) => setState(() => subVisible = value);

  onClickMobileV(double w) {
    if (w < 1024) {
      if (widget.category.id == "100") {
        context.read<CategoryListBloc>().setTypeAndList(widget.category);

        Navigator.pushNamed(context, "/home/category/all");
      } else {
        context.read<CategorySelectionListBloc>().setTypeAndList(
            widget.category,
            widget.category.isAllCategories,
            widget.category.isAllBrands,
            (!widget.category.isAllBrands && !widget.category.isAllCategories),
            context.read<GlobalBloc>().state.categories,
            context.read<GlobalBloc>().state.companies,
            widget.category.subcategory);

        Navigator.pushNamed(context, "/home/category");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return Container(
        height: 100,
        width: 100,
        child: PortalTarget(
          visible: (visible || subVisible) && w >= 1024,
          anchor: const Aligned(
            follower: Alignment.topCenter,
            target: Alignment.bottomRight,
          ),
          portalFollower:
              WebSubmenu(category: widget.category, onSubVisible: onSubVisible),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            // onEnter: (event) => setState(() => visible = true),
            // onExit: (event) => setState(() => visible = false),
            child: GestureDetector(
              behavior: w < 1024 ? null : HitTestBehavior.opaque,
              onTap: () => w < 1024
                  ? onClickMobileV(w)
                  : setState(() => subVisible = !subVisible),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  widget.category.logo.contains("https://")
                      ? SizedBox(
                          height: 40,
                          width: 40,
                          child: CachedNetworkImage(
                              imageUrl: widget.category.logo,
                              fit: BoxFit.cover),
                        )
                      : SizedBox(
                          height: 40,
                          width: 40,
                          child: Image.asset(
                            widget.category.logo,
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
                      widget.category.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 12),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

class WebSubmenu extends StatefulWidget {
  final Category category;
  final Function(bool visible) onSubVisible;

  WebSubmenu({
    super.key,
    required this.category,
    required this.onSubVisible,
  });

  @override
  State<WebSubmenu> createState() => _WebSubmenuState();
}

class _WebSubmenuState extends State<WebSubmenu> {
  @override
  Widget build(BuildContext context) {
    return TapOutsideDetectorWidget(
      onTappedOutside: () => widget.onSubVisible(false),
      child: MouseRegion(
        // cursor: SystemMouseCursors.click,
        onEnter: (event) => widget.onSubVisible(true),
        onExit: (event) => widget.onSubVisible(false),
        child: Container(
            clipBehavior: Clip.hardEdge,
            width: 300,
            constraints: BoxConstraints(
              maxHeight: 375,
            ),
            // Card style
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: ListView.builder(
                shrinkWrap: true,
                physics: widget.category.subcategory.length > 7
                    ? ScrollPhysics()
                    : NeverScrollableScrollPhysics(),
                itemCount: widget.category.subcategory.length,
                itemBuilder: (b, c) {
                  return WebMenuItem(
                    isBrand: widget.category.id == "200",
                    category: widget.category,
                    widget: widget.category.subcategory[c],
                    isLast: widget.category.subcategory.length - 1 == c,
                  );
                })),
      ),
    );
  }
}

class WebMenuItem extends StatefulWidget {
  final bool isLast;
  final bool isBrand;
  WebMenuItem(
      {super.key,
      required this.widget,
      required this.isLast,
      required this.category,
      required this.isBrand});

  final dynamic widget;
  final Category category;

  @override
  State<WebMenuItem> createState() => _WebMenuItemState();
}

class _WebMenuItemState extends State<WebMenuItem> {
  bool onHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onExit: (event) {
        setState(() {
          onHovered = false;
        });
      },
      onEnter: (event) {
        setState(() {
          onHovered = true;
        });
      },
      child: GestureDetector(
        onTap: () {
          if (widget.isBrand) {
            context.read<CategoryGridBloc>().set(
                company: widget.widget,
                category: null,
                subcategory: null,
                id: "");
          } else {
            context.read<CategoryGridBloc>().set(
                id: widget.widget.id,
                company: null,
                category: widget.category,
                subcategory: widget.widget);
          }
          Navigator.pushNamed(context, '/home/main/all');
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
              color: onHovered ? Colors.grey.withOpacity(0.1) : Colors.white,
              border: Border(
                  bottom: BorderSide(
                      color: !widget.isLast
                          ? Colors.grey.withOpacity(0.5)
                          : Colors.white))),
          height: 50,
          child: Row(
            children: [
              if (widget.widget.logo != null && widget.widget.logo != "")
                CachedNetworkImage(
                  imageUrl: widget.widget.logo!,
                  height: 30,
                  width: 50,
                ),
              if (widget.widget.logo != null && widget.widget.logo != "")
                const SizedBox(
                  width: 10,
                ),
              Text(widget.widget.name),
            ],
          ),
        ),
      ),
    );
  }
}
