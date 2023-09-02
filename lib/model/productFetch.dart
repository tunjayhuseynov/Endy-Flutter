import 'package:endy/model/product.dart';

class ProductFetch{
  List<Product> products;
  bool isLastPage;

  ProductFetch({required this.products, required this.isLastPage});
}