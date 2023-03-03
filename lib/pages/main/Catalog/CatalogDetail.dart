import 'package:auto_route/annotations.dart';
import 'package:endy/MainBloc/GlobalBloc.dart';
import 'package:endy/Pages/main/Catalog/CatalogCard.dart';
import 'package:endy/components/Navbar.dart';
import 'package:endy/types/company.dart';
import 'package:endy/utils/index.dart';
import 'package:endy/utils/responsivness/container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../components/Footer.dart';

class CatalogDetailRoute extends StatefulWidget {
  final String? companyId;

  CatalogDetailRoute({super.key, @pathParam this.companyId});

  @override
  State<CatalogDetailRoute> createState() => _CatalogDetailRouteState();
}

class _CatalogDetailRouteState extends State<CatalogDetailRoute> {
  Company? company;

  @override
  void initState() {
    super.initState();
    try {
      company = context.read<GlobalBloc>().state.companies.firstWhere(
            (element) => element.id == widget.companyId,
          );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return ScaffoldWrapper(
      hPadding: 0,
      appBar: AppBar(
        title: company != null ? Text("${company?.name} kataloqları") : null,
      ),
      body: BlocBuilder<GlobalBloc, GlobalState>(
        builder: (context, state) {
          var catalogs = company?.catalogs;
          return ListView(
            // padding: const EdgeInsets.symmetric(horizontal: 20),
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            children: [
              if (w >= 1024) const Navbar(),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.symmetric(horizontal: getContainerSize(w)),
                constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height - 75),
                child: GridView.builder(
                    shrinkWrap: true,
                    itemCount: catalogs?.length,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: getCatalogMainGrid(w),
                        childAspectRatio: 250 / 350, //(250 / 430),
                        mainAxisSpacing: 15,
                        crossAxisSpacing: 15),
                    itemBuilder: ((context, index) {
                      return CatalogCard(
                        catalog: catalogs?[index],
                      );
                    })),
              ),
              const SizedBox(height: 50),
              if (w >= 1024) const Footer(),
            ],
          );
        },
      ),
    );
  }
}
