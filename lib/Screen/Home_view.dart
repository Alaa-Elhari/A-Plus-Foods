import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:openfoodfacts/model/IngredientsAnalysisTags.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:openfoodfacts/utils/OpenFoodAPIConfiguration.dart';
import 'package:openfoodfacts/utils/PnnsGroups.dart';

import '../Tools/Category.dart';
import '../Tools/ListProduct.dart';
import 'Categorylistproduct_view.dart';
import 'Login_view.dart';
import 'Product_view.dart';
import 'Veganproducts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<String> scanBarcode() async {
    return FlutterBarcodeScanner.scanBarcode(
        "#ff6666", "cancel", true, ScanMode.BARCODE);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:
          BottomNavigationBar(type: BottomNavigationBarType.fixed, items: [
        BottomNavigationBarItem(
          icon: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.home,
              color: Colors.blue,
            ),
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('SearchScreen');
            },
            icon: const Icon(Icons.search, color: Colors.blue),
          ),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: IconButton(
            onPressed: () {
              scanBarcode().then((code) {
                ProductQueryConfiguration config = ProductQueryConfiguration(
                  code,
                  version: ProductQueryVersion.v3,
                );

                OpenFoodAPIClient.getProductV3(config).then((searchResult) {
                  if (searchResult.product == null) {
                    throw Exception("Product was not found!");
                  }
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (builderContext) =>
                              Productdetails(product: searchResult.product!)));
                });
              }).onError((error, trace) {
                var msg = SnackBar(
                  elevation: 0,
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.transparent,
                  content: AwesomeSnackbarContent(
                    title: 'On Snap!',
                    message: '${error.toString()} ${trace.toString()}',
                    contentType: ContentType.failure,
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(msg);
              });
            },
            icon:
                const Icon(Icons.qr_code_scanner_outlined, color: Colors.blue),
          ),
          label: 'Scan',
        ),
        BottomNavigationBarItem(
          icon: IconButton(
            onPressed: () {
              if (OpenFoodAPIConfiguration.globalUser != null) {
                FirebaseAuth.instance.signOut();

                OpenFoodAPIConfiguration.globalUser = null;
              }
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (contex) => const LogininScreen()));
            },
            icon: const Icon(
              Icons.output_sharp,
              color: Colors.blue,
            ),
          ),
          label: 'Log Out',
        ),
      ]),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(
            Icons.fastfood_outlined,
            color: Colors.black,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            'A PLus Foods',
            style: GoogleFonts.roboto(color: Colors.black),
          ),
        ]),
      ),
      body: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Title(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: const [
                    const Text(
                      'Category',
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                    const SizedBox(
                      width: 200,
                    ),
                  ],
                ),
              ),
              Listcategory(),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: const [
                    Text(
                      'Popular Products',
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                    SizedBox(
                      width: 110,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 400, width: 500, child: Listproduct()),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'Vegan Products :',
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ),
                    SizedBox(
                      width: 200,
                    ),
                  ],
                ),
              ),
              SizedBox(
                  height: 400,
                  width: 500,
                  child: VagenProducts(
                    State: VeganStatus.VEGAN,
                  )),
            ]),
      ),
    );
  }
}

class Listcategory extends StatelessWidget {
  Listcategory({
    Key? key,
  }) : super(key: key);
  late List Listcategoryimage = [
    'https://img.freepik.com/free-photo/composition-fruit-juices-black-background_23-2148227598.jpg',
    'https://media.premiumtimesng.com/wp-content/files/2022/01/Mashed-350x250.jpg',
    'https://c8.alamy.com/comp/DH8N1X/bottles-of-hard-liquor-whiskey-rum-vodka-DH8N1X.jpg',
    'https://www.bevindustry.com/ext/resources/2021/News/Spindrift_Unsweetened_Lemonades_900.jpg?1614882186',
    'https://www.nmamilife.com/wp-content/uploads/2020/05/25-blog-1.jpg',
    'https://www.mommyhatescooking.com/wp-content/uploads/2015/12/soda-stream-2.jpg',
    'https://cdn11.bigcommerce.com/s-2xe79qkdap/products/1034/images/1645/NECTARS_TOMATOE_750__59733.1645648526.386.513.jpg?c=1',
    'https://static.toiimg.com/thumb/msid-69385334/69385334.jpg?width=500&resizemode=4',
    'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/best-cereal-brands-1594659454.jpg?crop=0.502xw:1.00xh;0.162xw,0&resize=640:*',
    'https://cdn.pixabay.com/photo/2017/01/11/11/33/cake-1971552__340.jpg',
    'https://simplot-media.azureedge.net/-/media/feature/simplotfoods/components/marketing/product-category-content-images/promoblocks_potatoes.jpg?rev=53c81df03b35406e9d76dfe4f7b4ef28&h=455&w=735&la=en&hash=D42F157FACC9DB5D9534F863D69A5D89',
    'https://media.istockphoto.com/id/182190208/photo/corn-flaked-breakfast-cereal.jpg?s=612x612&w=0&k=20&c=et-XVm9CCYcxIMH2BEAFB0iCYsjtKLTX9jfZ0BdFg2I=',
    'https://www.seriouseats.com/thmb/gBMNe_J1QqbAz_QAXfW7-bRrhnw=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/better-no-knead-bread-recipe-hero-01_1-48d654bfadeb4a5caf9b233b00fc74ca.JPG',
    'https://www.thecookingfoodie.com/Images/Site/Products/240237.jpg',
    'https://www.shutterstock.com/image-photo/four-sandwiches-on-board-260nw-365116274.jpg',
    'https://media.istockphoto.com/id/494154858/photo/hot-homemade-corn-chowder.jpg?s=612x612&w=0&k=20&c=NuwffkneEU9yGgu_SnSZd45wPB_MeJO5YBGfg70x-L0=',
    'https://makeyourmeals.com/wp-content/uploads/2018/02/featured-baked-chicken-bacon-3.jpg.webp',
    'https://www.cafeyumm.com/wp-content/uploads/2021/02/CPG-Full-Line-KitchenWEB.jpg',
    'https://media.self.com/photos/622912847b959736301bfb91/3:2/w_2118,h_1412,c_limit/GettyImages-1301412050.jpg',
    'https://cimg0.ibsrv.net/cimg/www.fitday.com/693x350_85-1/572/23meat-108572.jpg',
    'https://media.istockphoto.com/id/1200498591/photo/various-types-of-fresh-meat-pork-beef-turkey-and-chicken-top-view.jpg?s=612x612&w=0&k=20&c=yseJrNrUK6G5KkxJ9_Ck-NRbMDZOo-9jAt986xG7Lik=',
    'https://media.istockphoto.com/id/1156027693/photo/fresh-salmon-steak-with-a-variety-of-seafood-and-herbs.jpg?s=612x612&w=0&k=20&c=FnY31V37yG5Ip4ejRttubUHBS8PPTaZfHHukDsEDjc0=',
    'https://images.squarespace-cdn.com/content/v1/5afa23cc50a54ff627bbcea9/1593483454668-X7SXW9IMYPZ2MHZ5HZTH/Marrow-IG+%281%29.jpg',
    'https://thumbs.dreamstime.com/b/fruit-2999796.jpg',
    'https://thumbs.dreamstime.com/b/fruit-vegetables-7134858.jpg',
    'https://media.istockphoto.com/id/1218693828/photo/wooden-bowl-with-mixed-nuts-on-rustic-table-top-view-healthy-food-and-snack.jpg?s=612x612&w=0&k=20&c=89-ko7nwlcqM6HPvwaQ3tZus4apArtwHkFAB0IxPQpo=',
    'https://health.clevelandclinic.org/wp-content/uploads/sites/3/2018/03/Nut-Benefits-695071562-770x533-1.jpg',
    'https://st.depositphotos.com/1177973/2443/i/600/depositphotos_24430669-stock-photo-different-kinds-of-beans-in.jpg',
    'https://media.istockphoto.com/id/910881428/photo/dairy-products-shot-on-rustic-wooden-table.jpg?s=612x612&w=0&k=20&c=Xh_dDL7XsV0Rff_aIrLOQJ1ZoapugiatmXUxWdo7q2s=',
    'https://www.godairyfree.org/wp-content/uploads/2007/02/pics-Silken-Chocolate-Dessert-feature.jpg',
    'https://media.gettyimages.com/id/530418574/photo/cheeses-selection.jpg?s=612x612&w=gi&k=20&c=DjlJEQh5CQBXH2svqZd3qmvfT9R43dsmBY9t1cqfJ_0=',
    'https://think.ing.com/uploads/hero/_w1200/260221-image-milk-plant-based-alternatives.jpg',
    'https://alekasgettogether.com/wp-content/uploads/2020/01/cold-appetizer-ideas.jpg',
    'https://health.clevelandclinic.org/wp-content/uploads/sites/3/2017/04/sweetSaltyCravings-1149135424_770x533.jpg',
    'https://thumbs.dreamstime.com/b/assorted-colourful-kids-party-sweets-candy-close-up-assorted-colourful-kids-party-sweets-candy-bright-table-99822962.jpg',
    'https://www.mashed.com/img/gallery/the-most-popular-chocolate-brands-ranked-worst-to-best/l-intro-1619705276.jpg',
    'https://thumbs.dreamstime.com/b/various-varieties-ice-cream-cones-various-varieties-ice-cream-cones-mint-blueberry-strawberry-pistachio-cherry-158155767.jpg',
  ];
  late List<PnnsGroup2> list = PnnsGroup2.values.toList();
  late List listcategorytitle = [
    'FRUIT JUICES', //
    'SWEETENED BEVERAGES', //
    'ALCOHOLIC BEVERAGES', //
    'UNSWEETENED BEVERAGES', //
    'ARTIFICIALLY SWEETENED_BEVERAGES', //
    'WATERS AND FLAVORED_WATERS', //
    'FRUIT NECTARS', //
    'TEAS AND HERBAL TEAS AND COFFEES', //
    'BREAKFAST CEREALS', //
    'PASTRIES', //
    'POTATOES', //
    'CEREALS', //
    'BREAD', //
    'PIZZA PIES AND QUICHE', //
    'SANDWICHES', //
    'SOUPS', //
    'ONE DISH MEALS', //
    'DRESSINGS AND SAUCES', //
    'FATS', //
    'PROCESSED MEAT', //
    'MEAT', //
    'FISH AND SEAFOOD', //
    'OFFALS', //
    'FRUITS', //
    'VEGETABLES', //
    'DRIED FRUITS', //
    'NUTS', //
    'LEGUMES', //
    'MILK AND YOGURT', //
    'DAIRY DESSERTS',
    'CHEESE',
    'PLANT BASED MILK SUBSTITUTES',
    'APPETIZERS',
    'SALTY AND FATTY PRODUCTS',
    'SWEETS',
    'CHOCOLATE PRODUCTS',
    'ICE CREAM'
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: ListView.builder(
          itemCount: Listcategoryimage.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            return SizedBox(
              width: 400,
              child: ListTile(
                title: Categorycard(
                  ImageUrl: '${Listcategoryimage[index]}',
                  title: " ${listcategorytitle[index]}",
                ),
                onTap: () {
                  String NameCategory = listcategorytitle[index];
                  String Imagecategory = Listcategoryimage[index];
                  var category = list[index];
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Listofcategoryproduct(
                        namecategory: NameCategory,
                        imagecategory: Imagecategory,
                        category: category,
                      ),
                    ),
                  );
                },
              ),
            );
          }),
    );
  }
}

class Title extends StatelessWidget {
  const Title({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'We have everthing that you need ',
                        style: GoogleFonts.acme(
                            color: Colors.blueAccent, fontSize: 25),
                      ),
                    ],
                  ),
                )
              ]),
            )),
      ],
    );
  }
}
