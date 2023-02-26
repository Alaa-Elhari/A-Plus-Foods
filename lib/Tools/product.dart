import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:openfoodfacts/model/Product.dart';

class ProductData {

  final String? username;
  final FirebaseDatabase database = FirebaseDatabase.instance;

  ProductData(this.username);

  ProductData saveProduct(Product? product) {
    final DatabaseReference ref = database.ref("server/saving-data/users").child(username!);
    final DatabaseReference products = ref.child("products");
    products.push().set(product);
    return this;
  }

  List<ProductData> loadProducts() {
    final DatabaseReference ref = database.ref("server/saving-data/users").child(username!);
    final DatabaseReference products = ref.child("products");
    products.onValue.listen((event) {
      print(event.snapshot.value);
    });
    return [];
  }
}