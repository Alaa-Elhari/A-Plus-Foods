import 'package:flutter/material.dart';
import 'package:openfoodfacts/model/IngredientsAnalysisTags.dart';
import 'package:openfoodfacts/model/parameter/IngredientsAnalysisParameter.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:openfoodfacts/utils/OpenFoodAPIConfiguration.dart';

import '../Tools/product_list.dart';

class VeganProductsView extends StatelessWidget {
  final VeganStatus state;

  const VeganProductsView({
    super.key,
    required this.state,
  });

  Future<SearchResult> fetchData() async {
    ProductSearchQueryConfiguration configuration =
        ProductSearchQueryConfiguration(
      parametersList: <Parameter>[
        IngredientsAnalysisParameter(veganStatus: state),
      ],
    );

    return await OpenFoodAPIClient.searchProducts(
      OpenFoodAPIConfiguration.globalUser,
      configuration,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        } else {
          return Column(
            children: [
              ProductsView(
                result: snapshot.data,
              ),
            ],
          );
        }
      },
      future: fetchData(),
    );
  }
}
