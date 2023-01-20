import 'package:endy/MainBloc/GlobalBloc.dart';
import 'package:endy/Pages/main/Catalog/CatalogCard.dart';
import 'package:endy/types/company.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CatalogDetail extends StatelessWidget {
  final Company company;
  const CatalogDetail({super.key, required this.company});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              LayoutBuilder(builder: (context, constraints) {
                var catalogs = company.catalogs;
                return GridView.builder(
                    shrinkWrap: true,
                    itemCount: catalogs.length,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio:
                            constraints.maxWidth * 0.66 / 350, //(250 / 430),
                        mainAxisSpacing: 15,
                        crossAxisSpacing: 15),
                    itemBuilder: ((context, index) {
                      return CatalogCard(
                        catalog: catalogs[index],
                      );
                    }));
              }),
              const SizedBox(height: 50),
            ],
          );
        },
      ),
    );
  }
}
