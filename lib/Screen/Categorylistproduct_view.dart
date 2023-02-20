import 'package:a_plus_foods/Tools/ListProduct.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:openfoodfacts/interface/Parameter.dart';
import 'package:openfoodfacts/model/SearchResult.dart';
import 'package:openfoodfacts/model/parameter/PnnsGroup2Filter.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:openfoodfacts/utils/OpenFoodAPIConfiguration.dart';
import 'package:openfoodfacts/utils/PnnsGroups.dart';
import 'package:openfoodfacts/utils/ProductSearchQueryConfiguration.dart';

class Listofcategoryproduct extends StatelessWidget {
  Listofcategoryproduct(
      {super.key,
      required this.namecategory,
      required this.imagecategory,
      required this.category});
  String namecategory;
  String imagecategory;
  PnnsGroup2 category;

  @override
  Widget build(BuildContext context) {
    return categorydetails(category: category);
  }
}

class categorydetails extends StatelessWidget {
  categorydetails({
    super.key,
    required this.category,
  });
  PnnsGroup2 category;

  late SearchResult result;
  Future<SearchResult> getdata() async {
    ProductSearchQueryConfiguration configuration =
        ProductSearchQueryConfiguration(
      parametersList: <Parameter>[
        PnnsGroup2Filter(pnnsGroup2: category),
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
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).backgroundColor,
        title: Row(
          children: [
            const Text('back'),
            SizedBox(
              height: 200,
              child: Text('name'),
            )
          ],
        ),
      ),
      body: Container(
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
      ),
    );
  }
}
