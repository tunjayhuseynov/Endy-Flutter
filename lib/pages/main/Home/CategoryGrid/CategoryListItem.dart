import 'package:endy/types/category.dart';
import 'package:endy/utils/index.dart';
import 'package:flutter/material.dart';

class CategoryFilterItem extends StatelessWidget {
  final Subcategory subcategory;
  final bool isSelected;
  final void Function(Subcategory category) fn;
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
          onPressed: () {
            fn(subcategory);
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
