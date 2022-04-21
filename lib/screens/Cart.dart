import 'package:flutter/material.dart';
import 'package:tiki_project/screens/HomeList.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

final occ = new NumberFormat("#,##0", "EN_US");

class Cart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text('Giỏ hàng')),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back)),
          backgroundColor: Colors.blue,
        ),
        body: CartDetails(),
        bottomNavigationBar: BottomAppBar(
            color: Colors.white,
            child: Container(
                height: 100,
                child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 24,
                          ),
                          child: Text('Tổng cộng',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5,left: 20),
                          child: Text('285.0000 đ',
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red)),
                        ),
                      ],
                    ),
                    Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: FlatButton(
                          child: SizedBox(
                            width: 100,
                            height: 50,
                            child: Center(
                              child: Text(
                                'Mua Hàng (2)',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ),
                          color: Colors.red,
                          onPressed: () {
                           
                          },
                        )),
                  ],
                ))));
  }
}

class CartDetails extends StatefulWidget {
  @override
  State<CartDetails> createState() => _CartDetailsState();
}

class _CartDetailsState extends State<CartDetails> {
  late int i = 1;
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        children: [
          Checkbox(
            checkColor: Colors.white,
            value: isChecked,
            onChanged: (bool? value) {
              setState(() {
                isChecked = value!;
              });
            },
          ),
          Text('Tất cả( sản phẩm)'),
          Padding(
            padding: const EdgeInsets.only(left: 200),
            child: IconButton(onPressed: () {}, icon: Icon(Icons.delete)),
          ),
        ],
      ),
      Expanded(
          child: ListView.separated(
        itemCount: 25,
        separatorBuilder: (BuildContext context, int index) => const Divider(),
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Row(children: [
              SizedBox(
                width: 100,
                height: 100,
                child: Expanded(
                  child: Image.network(
                      'https://salt.tikicdn.com/cache/280x280/ts/product/19/5e/21/e9545516e51437aa3266c8a684c83f1d.jpg'),
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Text(
                      'Điện thoại Samsung S20 FE',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(0),
                    child: Text(
                      '10.000đ',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      
                        color: Colors.grey.shade100,
                        border: Border.all(
                        width: 1, color: Color.fromARGB(200, 200, 200, 200)),
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      children: [
                        FlatButton(
                          minWidth: 10.0,
  height: 5.0,
                          child: Text('-'),
                          onPressed: () {
                            setState(() {
                              i--;
                              if (i < 0) {
                                i = 0;
                              }
                              ;
                            });
                          },
                        ),
                        Text('$i'),
                        FlatButton(
                          minWidth: 10.0,
  height: 5.0,
                            child: Text('+'),
                            onPressed: () {
                              setState(() {
                                i++;
                              });
                            }),
                      ],
                    ),
                  )
                ],
              ),
            ]),
            leading: Checkbox(
              checkColor: Colors.white,
              value: isChecked,
              onChanged: (bool? value) {
                setState(() {
                  isChecked = value!;
                });
              },
            ),
          );
        },
      )),
    ]);
  }
}
