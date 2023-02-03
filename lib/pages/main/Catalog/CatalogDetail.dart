import 'package:endy/MainBloc/GlobalBloc.dart';
import 'package:endy/Pages/main/Catalog/CatalogCard.dart';
import 'package:endy/types/company.dart';
import 'package:endy/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CatalogDetail extends StatelessWidget {
  final Company company;
  const CatalogDetail({super.key, required this.company});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    var catalogs = company.catalogs;

    return ScaffoldWrapper(
      appBar: AppBar(
        title: Text("${company.name} kataloqları"),
      ),
      body: BlocBuilder<GlobalBloc, GlobalState>(
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            children: [
              SizedBox(height: 20),
              GridView.builder(
                  shrinkWrap: true,
                  itemCount: catalogs.length,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: getCatalogMainGrid(w),
                      childAspectRatio: 250 / 350, //(250 / 430),
                      mainAxisSpacing: 15,
                      crossAxisSpacing: 15),
                  itemBuilder: ((context, index) {
                    return CatalogCard(
                      catalog: catalogs[index],
                    );
                  })),
              const SizedBox(height: 50),
            ],
          );
        },
      ),
    );
  }
}
