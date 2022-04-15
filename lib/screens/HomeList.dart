import 'package:flutter/material.dart';

import 'dart:convert';
import 'HomeDetails.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class AppSearch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).primaryColor;

    // TODO: implement build
    return MaterialApp(
        title: 'Danh sách sản phẩm',
        initialRoute: '/list',
        routes: {
          '/list': (context) => HomeList(),
          '/details': (context) => HomeDetails(),
        });
  }
}

class HomeList extends StatefulWidget {
  const HomeList({Key? key}) : super(key: key);

  @override
  State<HomeList> createState() => _HomeListState();
}

// Adapted from search demo in offical flutter gallery:
// https://github.com/flutter/flutter/blob/master/examples/flutter_gallery/lib/demo/material/search_demo.dart

class _HomeListState extends State<HomeList> {
  // final List<String> Words;
  // _HomeListState()
  //     : Words = List.from(Set.from(all))
  //   ..sort(
  //         (w1, w2) => w1.toLowerCase().compareTo(w2.toLowerCase()),
  //   ),
  //       super();
  String query = '';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_back)),
            actions: <Widget>[
              IconButton(icon: const Icon(Icons.shopping_cart), onPressed: () => {}),
            ],
            backgroundColor: Colors.blue,
            title: Center(
                child: Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: SizedBox(
                child: TextField(
                  onChanged: (query) {
                    setState(() {
                      this.query = query;
                    });
                  },
                  decoration: InputDecoration(
                    prefixIcon: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.search),
                        color: Colors.grey),
                    suffixIcon: IconButton(
                        onPressed: () {
                          query = '';
                        },
                        icon: const Icon(Icons.clear),
                        color: Colors.grey),
                    hintText: 'Search...',
                    contentPadding: EdgeInsets.all(20),
                  ),
                ),
              ),
            ))),
        body: FutureBuilder<List<Product>>(
          future: fetchPhotos(http.Client()),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('An error has occurred!'),
              );
            } else if (snapshot.hasData) {
              return PhotosList(
                  photos: snapshot.data!
                      .where((photos) => photos.name.contains(query)) // nhập vào -> contain: ktra xem có name ko, có thì list ra
                      .toList());
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }
}

class PhotosList extends StatelessWidget {
  const PhotosList({Key? key, required this.photos}) : super(key: key);

  final List<Product> photos;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, //chia làm 2 cột
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      padding: const EdgeInsets.all(8.0),
      itemCount: photos.length,
      itemBuilder: (context, index) {
        return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/details',
                  arguments: photos[index]);
            },
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        width: 1, color: Color.fromARGB(200, 200, 200, 200)),
                    borderRadius: BorderRadius.circular(12)),
                child: Column(
                  children: [
                    SizedBox(
                        width: 120,
                        child: Image.network(
                          photos[index].thumbnailUrl,
                        )),
                    Text(
                      photos[index].name,
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                      // text dài quá thì sẽ xuống dòng
                      maxLines: 2, // chia làm 2 dòng
                    ),
                    Row(
                      children: [
                        RatingBar.builder(
                          itemSize: 10,
                          initialRating: photos[index].ratingAverage,
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
                          '(${photos[index].reviewCount}) | ',
                          style: TextStyle(fontSize: 10),
                        ),
                        //(' ${} ')
                        Text(
                            '${photos[index].quantitySold == null ? '' : photos[index].quantitySold!.text}',
                            style: TextStyle(fontSize: 10)),
                        // bằng null thì trả về rỗng, ko thì trả về text
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${photos[index].price.toString()} đ',
                          style: TextStyle(fontSize: 11),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 216, 105, 105),
                              borderRadius: BorderRadius.circular(10)),
                          child: Text('-${photos[index].discountRate}%',
                              style: TextStyle(fontSize: 11)),
                        ),
                      ],
                    ),

                    //Text(photos[index].id.toString()),// id đang là số ng-> toString vì text nhận string
                  ],
                )));
      },
    );
  }
}

class QuantitySold {
  final String text;
  final int value;

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
  final int id;
  final String name;
  final String thumbnailUrl;
  final int price;
  final int originalPrice;
  final int discountRate;
  final double ratingAverage;
  final int reviewCount;
  final QuantitySold? quantitySold;

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

List<Product> parsePhotos(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Product>((json) => Product.fromJson(json)).toList();
}

Future<List<Product>> fetchPhotos(http.Client client) async {
  final response =
      await client.get(Uri.parse('http://172.29.4.126:30000/products'));
  return compute(parsePhotos, response.body);
}
