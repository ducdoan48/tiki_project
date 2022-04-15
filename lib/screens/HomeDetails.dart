import 'package:flutter/material.dart';
import 'package:tiki_project/screens/HomeList.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class HomeDetails extends StatefulWidget {
  const HomeDetails({Key? key}) : super(key: key);

  @override
  State<HomeDetails> createState() => _HomeDetailsState();
}

class _HomeDetailsState extends State<HomeDetails> {

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)!.settings.arguments as Product;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back)),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.shopping_cart), onPressed: () => {}),
        ],
        backgroundColor: Colors.blue,
      ),
      body: Container(
        child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                    width: 1, color: Color.fromARGB(255, 218, 218, 218)),
                borderRadius: BorderRadius.circular(12)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                    width: 200,
                    child: Image.network(
                      product.thumbnailUrl,
                    )),
                Text(
                  product.name,
                  style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),
                ),
                Row(

                  children: [
                    RatingBar.builder(
                      itemSize: 20,
                      initialRating: product.ratingAverage,
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
                            fontSize:
                                16)), // bằng null thì trả về rỗng, ko thì trả về text
                    IconButton(icon: Icon(Icons.share), onPressed: () => {}),
                    IconButton(icon: Icon(Icons.copy), onPressed: () => {}),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      '${product.price.toString()} đ',
                      style: TextStyle(fontSize: 19, color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 216, 105, 105),
                          borderRadius: BorderRadius.circular(10)),
                      child: Text('-${product.discountRate}%',
                          style: TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
                SizedBox(
                  child: Center(
                    child: FlatButton(
                      child: Text(
                        'Chọn',
                        style: TextStyle(fontSize: 20.0, color: Colors.white),

                      ),
                      color: Colors.red,
                      onPressed: () {},
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
