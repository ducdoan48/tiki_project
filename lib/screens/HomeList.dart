import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart' as english_words;
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// Adapted from search demo in offical flutter gallery:
// https://github.com/flutter/flutter/blob/master/examples/flutter_gallery/lib/demo/material/search_demo.dart
List<Product> parsePhotos(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Product>((json) => Product.fromJson(json)).toList();
}

Future<List<Product>> fetchPhotos(http.Client client) async {
  final response = await client.get(Uri.parse('http://172.29.4.126:30000/products'));
  return compute(parsePhotos,response.body) ;
}
class SearchBar extends StatefulWidget {
  const SearchBar({ Key? key }) : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
         leading: IconButton(onPressed:(){}, icon:Icon(Icons.arrow_back)),
          actions: <Widget>[  
          
          IconButton(icon: Icon(Icons.shopping_cart), onPressed: () => {}),  
         
        ],  
            backgroundColor: Colors.blue,
            title: Center(
              child: Container(decoration: BoxDecoration(
                  
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)),
                  
              
                
                child: SizedBox(
                  width:340,
                
                  child: TextField(
                    
                   
                      decoration: InputDecoration(
                      
                        prefixIcon: IconButton(onPressed:(){}, icon:Icon(Icons.search), color: Colors.grey),
                        suffixIcon: IconButton(onPressed:(){}, icon:Icon(Icons.clear),color: Colors.grey),
                        hintText: 'Search...',
                        contentPadding: EdgeInsets.all(20),
                        ),
                        
                        
                         
                  ),
                  
                ),
                
              ))
             
              
            
              
            ),
        body : 
        FutureBuilder <List<Product>>(future: fetchPhotos(http.Client()), builder: (context, snapshot){
         if (snapshot.hasError) {
            return const Center(
              child: Text('An error has occurred!'),
            );
          } else if (snapshot.hasData) {
            return PhotosList(photos: snapshot.data!);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
      },)

//         GridView.builder(
          
//   itemCount: 100,
//   itemBuilder: (context, index) => ItemTile(index),
//   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//     crossAxisCount: 2,
//     childAspectRatio: 1, //điều chỉnh chiều cao của các mục
    
//   ),
  
  
// )


        
    );
    
  }
}
// class ItemTile extends StatelessWidget {
//   final int itemNo;

//   const ItemTile(
//     this.itemNo,
//   );

//   @override
//   Widget build(BuildContext context) {
//     final Color color = Colors.primaries[itemNo % Colors.primaries.length];
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: ListTile(
//         tileColor: color.withOpacity(0.3),
//         onTap: () {},
//         leading: Container(
//           width: 50,
//           height: 30,
//           color: color.withOpacity(0.5),
//           child: Placeholder(
//             color: color,
//           ),
//         ),
//         title: Text(
//           'Product $itemNo',
//           key: Key('text_$itemNo'),
//         ),
//       ),
//     );
//   }
// }
class AppSearch extends StatelessWidget{
  Column _buildButtonColumn(Color color, IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
    
        Icon(icon , 
        color: color,),
        Container(
          margin: const EdgeInsets.only(top: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: color,
              
              
            ),
          ),
        ),
      ],
    );
  }
@override

  Widget build(BuildContext context) {
    Color color = Theme.of(context).primaryColor;

Widget buttonSection = Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: [
    _buildButtonColumn(color, Icons.call, 'CALL'),
    _buildButtonColumn(color, Icons.near_me, 'ROUTE'),
    _buildButtonColumn(color, Icons.share, 'SHARE'),
  ],
);
    // TODO: implement build
    return MaterialApp(
      title: 'Danh sách sản phẩm',
      home: SearchBar(),

      
    );
  }
}
class PhotosList extends StatelessWidget {
  const PhotosList({Key? key, required this.photos}) : super(key: key);

  final List<Product> photos;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,  
         crossAxisSpacing: 10,  
        
        
      ),
      padding: const EdgeInsets.all(8.0),
      itemCount: photos.length,
      itemBuilder: (context, index) {
        
        return Image.network(photos[index].thumbnailUrl);
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