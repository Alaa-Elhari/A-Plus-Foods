import 'package:a_plus_foods/Tools/product_list.dart';
import 'package:flutter/material.dart';
import 'package:openfoodfacts/model/parameter/PnnsGroup2Filter.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:openfoodfacts/utils/OpenFoodAPIConfiguration.dart';
import 'package:openfoodfacts/utils/PnnsGroups.dart';

class CategoryView extends StatelessWidget {

  final String name;
  final String image;
  final PnnsGroup2 category;
  
  const CategoryView(
      {super.key,
      required this.name,
      required this.image,
      required this.category});

  @override
  Widget build(BuildContext context) {
    return CategoryDetails(category: category);
  }
}

class CategoryDetails extends StatelessWidget {

  final PnnsGroup2 category;

  const CategoryDetails({
    super.key,
    required this.category,
  });

  Future<SearchResult> fetchData() async {
    ProductSearchQueryConfiguration configuration =
        ProductSearchQueryConfiguration(
      parametersList: <Parameter>[
        PnnsGroup2Filter(pnnsGroup2: category),
      ],
    );
    return OpenFoodAPIClient.searchProducts(
      OpenFoodAPIConfiguration.globalUser,
      configuration,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Row(
          children: const [
            Text('back'),
            SizedBox(
              height: 200,
              child: Text('name'),
            )
          ],
        ),
      ),
      body: FutureBuilder(
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
      ),
    );
  }
}
