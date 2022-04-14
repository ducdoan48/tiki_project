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
     return Scaffold(
       
        appBar: AppBar(
            leading: IconButton(onPressed: () {}, 
            icon: Icon(Icons.arrow_back)),
            actions: <Widget>[
              IconButton(icon: Icon(Icons.shopping_cart), onPressed: () => {}),
            ],
            backgroundColor: Colors.blue,
            ),
        body: FutureBuilder<List<Product>>(
          future: fetchPhotos(http.Client()),
          builder: (context, snapshot) {
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
          },
        )
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
        crossAxisCount: 1, //chia là 2 cột

      ),
      padding: const EdgeInsets.all(8.0),
      itemCount: photos.length,
      itemBuilder: (context, index) {
        return Container(
     
            child: Column(
              children: [

                SizedBox(
                    width: 120,
                    child: Image.network(
                      photos[index].thumbnailUrl,
                    )),
                Text(photos[index].name, style: TextStyle(fontSize: 20),),
                Row(
                  children: [
                     RatingBar.builder(
                      itemSize: 15,
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
                   
                    Text('(${photos[index].reviewCount}) | ', style: TextStyle(fontSize: 15),), //(' ${} ')
                    Text('${photos[index].quantitySold == null ? '' : photos[index].quantitySold!.text }' ,style: TextStyle(fontSize: 15)), // bằng null thì trả về rỗng, ko thì trả về text
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${photos[index].price.toString()} đ', style: TextStyle(fontSize: 15),),
                    Container(
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 216, 105, 105),
                          borderRadius: BorderRadius.circular(10)),
                      child: Text('-${photos[index].discountRate}%',
                          style: TextStyle(fontSize: 15)),
                    ),
                   
                  ],
                ),
                
                //Text(photos[index].id.toString()),// id đang là số ng-> toString vì text nhận string
              ],
            ));
        
      },
    );
  }
}