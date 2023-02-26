import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:foods/Tools/product.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:openfoodfacts/utils/OpenFoodAPIConfiguration.dart';

import '../Screen/product_view.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {

  Future<SearchResult> fetchData() async {
    ProductSearchQueryConfiguration configuration =
        ProductSearchQueryConfiguration(
      parametersList: <Parameter>[
        const SortBy(option: SortOption.POPULARITY),
      ],
    );

    return OpenFoodAPIClient.searchProducts(
      OpenFoodAPIConfiguration.globalUser,
      configuration,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            width: 50,
            child: Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          );
        }
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        } else {
          return ProductsView(
            result: snapshot.data,
          );
        }
      },
      future: fetchData(),
    );
  }
}

class ProductsView extends StatelessWidget {
  final SearchResult? result;

  const ProductsView({Key? key, required this.result}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StaggeredGridView.countBuilder(
          itemCount: (result?.products?.length),
          crossAxisCount: 4,
          itemBuilder: (context, index) {
            String? name = result?.products?[index].productName;

            if (name == null || name.isEmpty) {
              return Container();
            }

            return Padding(
              padding: const EdgeInsets.all(10),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: SizedBox(
                  width: 400,
                  height: 200,
                  child: ListTile(
                    title: Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.6),
                            offset: const Offset(
                              0.0,
                              10.0,
                            ),
                            blurRadius: 10.0,
                            spreadRadius: -6.0,
                          ),
                        ],
                        image: DecorationImage(
                          colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.10),
                            BlendMode.multiply,
                          ),
                          image: NetworkImage(
                              '${result?.products?[index].imageFrontUrl}'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              '${result?.products?[index].productName} ',
                              style: GoogleFonts.robotoFlex(
                                  color: Colors.grey[200],
                                  //backgroundColor: Colors.grey,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                    ),
                    onTap: () {
                      var product = result?.products?[index];

                      ProductData(OpenFoodAPIConfiguration.globalUser?.userId)
                          .saveProduct(product)
                          .loadProducts();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductView(
                            product: product,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
          staggeredTileBuilder: (index) => const StaggeredTile.fit(2)),
    );
  }
}
