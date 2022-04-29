import 'package:flutter/material.dart';

class QuantitySold {
   String text;
   int value;

  QuantitySold({
    required this.text,
    required this.value,
  });

  factory QuantitySold.fromJson(Map<String, dynamic> json) {
    // print('parse QuantitySold from $json');
    return QuantitySold(
      text: json['text'] ?? '',
      value: json['value'],
    );
  }
}

class Product {
   int id;
   String name;
   String thumbnailUrl;
   int price;
   int originalPrice;
   int discountRate;
   double ratingAverage;
   int reviewCount;
   QuantitySold? quantitySold;

  Product({
    required this.id,
    required this.name,
    required this.thumbnailUrl,
    required this.price,
    required this.originalPrice,
    required this.discountRate,
    required this.ratingAverage,
    required this.reviewCount,
    this.quantitySold,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    // print('Mapping $json');
    try {
      return Product(
        id: json['id'],
        name: json['name'] ?? '',
        thumbnailUrl: json['thumbnail_url'] ?? '',
        price: int.parse('${json['price'] ?? '0'}'),
        originalPrice: int.parse('${json['original_price'] ?? '0'}'),
        discountRate: int.parse('${json['discount_rate'] ?? '0'}'),
        ratingAverage: double.parse('${json['rating_average'] ?? '0'}'),
        reviewCount: int.parse('${json['review_count'] ?? '0'}'),
        quantitySold: json['quantity_sold'] == null
            ? null
            : QuantitySold.fromJson(json['quantity_sold']),
      );
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  @override
  String toString() {
    return 'Product {id: $id, name: $name, price: $price, discountRate: $discountRate}';
  }
}

class CartProduct {
  Product product;
  int quantity;
  bool isChecked;


  CartProduct({
    required this.product,
    required this.quantity,
    required this.isChecked,
    
  });

}
