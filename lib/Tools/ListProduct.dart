import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:openfoodfacts/utils/OpenFoodAPIConfiguration.dart';

import '../Screen/Product_view.dart';

class Listproduct extends StatefulWidget {
  const Listproduct({super.key});

  @override
  State<Listproduct> createState() => _ListproductState();
}

class _ListproductState extends State<Listproduct> {
  Future<SearchResult> getdata() async {
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
          return Container(
            width: 50,
            child: const Center(
              child: const CircularProgressIndicator.adaptive(),
            ),
          );
        }
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        } else {
          return ProductView(
            result: snapshot.data,
          );
        }
      },
      future: getdata(),
    );
  }
}

class ProductView extends StatelessWidget {
  SearchResult? result;

  ProductView({Key? key, required this.result}) : super(key: key);

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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InformationProduct(
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
