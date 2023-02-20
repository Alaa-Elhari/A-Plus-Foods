import 'package:a_plus_foods/Tools/ListProduct.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:openfoodfacts/interface/Parameter.dart';
import 'package:openfoodfacts/model/IngredientsAnalysisTags.dart';
import 'package:openfoodfacts/model/SearchResult.dart';
import 'package:openfoodfacts/model/parameter/IngredientsAnalysisParameter.dart';
import 'package:openfoodfacts/model/parameter/PnnsGroup2Filter.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:openfoodfacts/utils/OpenFoodAPIConfiguration.dart';
import 'package:openfoodfacts/utils/PnnsGroups.dart';
import 'package:openfoodfacts/utils/ProductSearchQueryConfiguration.dart';

class VagenProducts extends StatelessWidget {
  VagenProducts({
    super.key,
    required this.State,
  });
  VeganStatus State;

  late SearchResult result;
  Future<SearchResult> getdata() async {
    ProductSearchQueryConfiguration configuration =
        ProductSearchQueryConfiguration(
      parametersList: <Parameter>[
        IngredientsAnalysisParameter(veganStatus: State),
      ],
    );
    result = await OpenFoodAPIClient.searchProducts(
      OpenFoodAPIConfiguration.globalUser,
      configuration,
    );
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: const CircularProgressIndicator.adaptive(),
            );
          }
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else {
            return Column(
              children: [
                ProductView(
                  result: snapshot.data,
                ),
              ],
            );
          }
        },
        future: getdata(),
      ),
    );
  }
}
