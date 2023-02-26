import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:openfoodfacts/model/Nutrient.dart';
import 'package:openfoodfacts/model/NutrientLevels.dart';
import 'package:openfoodfacts/model/PerSize.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

class ProductView extends StatelessWidget {
  final Product? product;

  const ProductView({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return ProductDetails(
      product: product!,
    );
  }
}

class ProductDetails extends StatelessWidget {
  final Product product;

  const ProductDetails({Key? key, required this.product}) : super(key: key);

  List<DataRow> getNutrients(Product? product) {
    Map<String, double> hundredGram = {}, serving = {};
    List<DataRow> rows = [];

    for (var element in Nutrient.values) {
      double? valueHundred =
              product?.nutriments?.getValue(element, PerSize.oneHundredGrams),
          valueServing =
              product?.nutriments?.getValue(element, PerSize.serving);

      if (valueHundred != null) {
        hundredGram[element.offTag] = valueHundred;
      }

      if (valueServing != null) {
        serving[element.offTag] = valueServing;
      }
    }

    var sortedHundred = SplayTreeMap<String, double>.from(
            hundredGram, (k1, k2) => k1.compareTo(k2)),
        sortedServing = SplayTreeMap<String, double>.from(
            serving, (k1, k2) => k1.compareTo(k2));

    sortedHundred.forEach((key, value) {
      rows.add(DataRow(cells: [
        DataCell(Text(key)),
        DataCell(Text('$value')),
        DataCell(Text('${sortedServing[key]}'))
      ]));
    });
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[50],
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Ionicons.chevron_back,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              height: MediaQuery.of(context).size.height * .35,
              padding: const EdgeInsets.only(bottom: 30),
              width: double.infinity,
              child: Image.network('${product.imageFrontUrl}'),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 40, right: 14, left: 14),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Categories',
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${product.categories}',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Product Name',
                              style: GoogleFonts.poppins(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(
                              width: 40,
                            ),
                            SizedBox(
                              width: 160,
                              child: Text(
                                '${product.productName}',
                                style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blueGrey),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Text(
                          '${product.created}',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Information About Product :',
                          style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.blueAccent),
                        ),
                        const SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Details(
                            name: 'Quantity:',
                            data: '${product.quantity}',
                          ),
                        ),
                        Details(
                          name: 'Packaging:',
                          data: '${product.packagings?.join(", ")}',
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Details(
                          name: 'Brands:',
                          data: '${product.brands}',
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Details(
                          name: 'Labels, certifications, awards :',
                          data: '${product.labels}',
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Details(
                          name: 'EMB code:',
                          data: '${product.embCodes}',
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Details(
                          name: 'Brands:',
                          data: '${product.brands}',
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Details(
                          name: 'Stores:',
                          data: '${product.stores}',
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Details(
                          name: 'Countries where sold:',
                          data: '${product.countries}',
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Details(
                          name: 'Barcode :',
                          data: '${product.barcode}',
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Health :',
                          style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.blueAccent),
                        ),
                        const SizedBox(height: 15),
                        const SizedBox(
                          height: 20,
                        ),
                        Details(
                          name: 'Ingredients:',
                          data: '${product.ingredientsText}',
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Details(
                          name: 'Food processing',
                          data: '${product.novaGroup}',
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Details(
                          name: 'Additives',
                          data: '${product.additives!.names}',
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        SizedBox(
                          width: 100,
                          child: Text(
                            'Nutrition :',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ProductQuality(
                          product: product,
                          nutrient: 'sugars',
                        ),
                        Table(),
                        ProductQuality(product: product, nutrient: 'fat'),
                        ProductQuality(product: product, nutrient: 'saturated-fat'),
                        ProductQuality(product: product, nutrient: 'salt'),
                        const SizedBox(
                          height: 30,
                        ),
                        SizedBox(
                          width: 800,
                          child: Center(
                            child: DataTable(
                              columns: [
                                const DataColumn(
                                    label: Text('Nutrition facts	',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold))),
                                const DataColumn(
                                    label: Text('100g/100ml',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold))),
                                DataColumn(
                                    label: SizedBox(
                                  width: 200,
                                  child: Text('Serving(${product.servingSize})',
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold)),
                                )),
                              ],
                              rows: getNutrients(product),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(height: 110, child: Container()),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProductQuality extends StatelessWidget {
  final String nutrient;
  final Product? product;

  const ProductQuality({Key? key, required this.nutrient, required this.product})
      : super(key: key);

  Row createRow(String text, Color givenColor, double boxWidth) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: SizedBox(width: 50, child: Text(nutrient)),
        ),
        const SizedBox(
          width: 10,
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
                color: givenColor,
                borderRadius: const BorderRadius.all(Radius.circular(18))),
          ),
        ),
        SizedBox(
          width: boxWidth,
        ),
        Text(text)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (product?.nutrientLevels?.levels[nutrient]) {
      case Level.HIGH:
        {
          return createRow("$nutrient in High quantity!", Colors.red, 0);
        }
      case Level.MODERATE:
        {
          return createRow("$nutrient in Moderate quantity!", Colors.blue, 10);
        }
      case Level.LOW:
        {
          return createRow("$nutrient in Low quantity!", Colors.green, 20);
        }
      default:
        {
          return Container();
        }
    }
  }
}

class Details extends StatelessWidget {

  final String data;
  final String name;

  const Details({
    Key? key,
    required this.name,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            name,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(
          width: 200,
          child: Text(
            data,
            style: GoogleFonts.poppins(
              fontSize: 15,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
