import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiki_project/models/CartProvider.dart';
import 'package:tiki_project/screens/HomeList.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'Cart.dart';
import 'package:tiki_project/models/products.dart';

final occ = NumberFormat.simpleCurrency(locale: 'vi-VN');

class HomeDetails extends StatefulWidget {
  const HomeDetails({Key? key}) : super(key: key);

  @override
  State<HomeDetails> createState() => _HomeDetailsState();
}

class _HomeDetailsState extends State<HomeDetails> {
  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)!.settings.arguments as Product;
    final shoppingCart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
         title: Padding(
           padding: const EdgeInsets.only(right:20.0),
           child: Center(
               child: Text(
             'Chi tiết sản phẩm',
           )),
         ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back)),
       
        backgroundColor: Colors.blue,
      ),
      body: Container(
        child: Container(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
                width: 250,
                child: Image.network(
                  product.thumbnailUrl,
                )),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                product.name,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Row(
                children: [
                  RatingBar.builder(
                    itemSize: 20,
                    initialRating: product.ratingAverage,
                    ignoreGestures: true,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {},
                  ),
                  Text(
                    '(${product.reviewCount}) | ',
                    style: TextStyle(fontSize: 16),
                  ), //(' ${} ')
                  Text(
                      '${product.quantitySold == null ? '' : product.quantitySold!.text}',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors
                              .pink)), // bằng null thì trả về rỗng, ko thì trả về text
                  IconButton(
                      icon: Icon(Icons.share),
                      color: Colors.grey,
                      onPressed: () => {}),
                  IconButton(
                      icon: Icon(Icons.copy),
                      color: Colors.grey,
                      onPressed: () => {}),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 13.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${occ.format(product.price)} ',
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.red,
                        fontWeight: FontWeight.w500),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right:60.0),
                    child: Text(
                      '${occ.format(product.originalPrice)} ',
                      style: TextStyle(fontSize: 16 ,decoration: TextDecoration.lineThrough),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 18.0),
                    child: Container(
                      width: 60,
                      decoration: BoxDecoration(
                          color: Colors.pink[100],
                          border: Border.all(width: 1, color: Colors.red),
                          borderRadius: BorderRadius.circular(3)),
                      child: Center(
                        child: Text('-${product.discountRate}%',
                            style: TextStyle(fontSize: 21, color: Colors.red)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              child: Center(
                child: FlatButton(
                  child: SizedBox(
                    width: 350,
                    child: Center(
                      child: Text(
                        'Chọn Mua',
                        style: TextStyle(fontSize: 20.0, color: Colors.white),
                      ),
                    ),
                  ),
                  color: Colors.red,
                  onPressed: () {
                    shoppingCart.addItemToCart(product);
                    Navigator.pushNamed(context, '/cart');
                  },
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
