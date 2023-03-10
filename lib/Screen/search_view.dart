import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:openfoodfacts/model/parameter/SearchTerms.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:openfoodfacts/utils/OpenFoodAPIConfiguration.dart';

import 'product_view.dart';

class SearchView extends StatefulWidget {

  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _searchController = TextEditingController();
  SearchResult? _searchResults;

  Future<SearchResult> searchProductsByName(String name) async {
    ProductSearchQueryConfiguration configuration =
        ProductSearchQueryConfiguration(
      parametersList: <Parameter>[
        SearchTerms(terms: [name]),
      ],
    );

    return OpenFoodAPIClient.searchProducts(
      OpenFoodAPIConfiguration.globalUser,
      configuration,
    );
  }

  Future<void> _searchProduct(String productName) async {
    SearchResult searchResults = await searchProductsByName(productName);
    setState(() {
      _searchResults = searchResults;
    });
  }

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextButton.icon(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('HomeScreen');
                },
                icon: const Icon(Icons.arrow_back),
                label: Text(
                  "Back",
                  style: GoogleFonts.roboto(color: Colors.black, fontSize: 20),
                )),
            const SizedBox(
              width: 50,
            ),
            Text('Product Search',
                style: GoogleFonts.roboto(color: Colors.black))
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Enter product name',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              String productName = _searchController.text;
              _searchProduct(productName);
            },
            child: const Text('Search'),
          ),
          const SizedBox(
            height: 30,
          ),
          FutureBuilder(
              future: searchProductsByName(_searchController.text.trim()),
              builder: ((context, snapshot) {
                if (!(snapshot.connectionState == ConnectionState.waiting)) {
                  if (_searchResults != null) {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: _searchResults?.products!.length,
                        itemBuilder: (context, index) {
                          Product product = _searchResults!.products![index];
                          return ListTile(
                            title: Text(product.productName ?? ''),
                            subtitle: Text(product.brands ?? ''),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductView(
                                    product: product,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    );
                  }
                  return Container();
                } else if (_searchResults == null) {
                  return Container();
                } else {
                  return const Center(
                      child: CircularProgressIndicator.adaptive());
                }
              }))
        ],
      ),
    );
  }
}
