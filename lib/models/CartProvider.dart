import 'package:flutter/foundation.dart';
import 'package:tiki_project/models/products.dart';
import 'dart:convert';

class CartProvider extends ChangeNotifier {
  List<CartProduct> productList = [];
   bool checkall = true;

  void addItemToCart(Product productItem) {
    CartProduct item = CartProduct(product: productItem, quantity: 1, isChecked: true);
    if (productList.where((p) => p.product.id == productItem.id).isNotEmpty) {
      productList.firstWhere((p) => p.product.id == productItem.id).quantity +=
          1;
    } else {
      productList.add(item);
    }
    notifyListeners();
  }

  void remove(CartProduct item) {
    productList = productList
        .where((element) => element.product.id != item.product.id)
        .toList();
    notifyListeners();
  }

  double getTotalPrice() {
    double total = 0;
    for (CartProduct cartproduct in productList.where((p) => p.isChecked == true)) {// những cái đc tích thì có tổng+=...
      total += cartproduct.product.price * cartproduct.quantity;
    }
    return total;
  }

  void clearlist() {
    productList.clear();
    notifyListeners();
  }

  void sub(CartProduct item) {
    item.quantity--;
    if (item.quantity < 1) {
      item.quantity = 1;
    }
    notifyListeners();
  }

  void plus(CartProduct item) {
    item.quantity++;

    notifyListeners();
  }
  void checked( CartProduct item, bool value) {
    
              item.isChecked = value;
              notifyListeners();
  }

  void checkAll( List<CartProduct> productListss, bool value){

        for (CartProduct cartproduct in productListss) {
                  cartproduct.isChecked = value;
                }
      
                notifyListeners();
    }
    
  }


