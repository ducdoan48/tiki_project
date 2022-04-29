import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tiki_project/models/products.dart';
import 'package:tiki_project/screens/HomeList.dart';
import '../models/CartProvider.dart';

final occ = NumberFormat.simpleCurrency(locale: 'vi-VN');

class Cart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final shoppingCart = Provider.of<CartProvider>(context);

    return Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: EdgeInsets.only(left: 95),
            child: (Text(
              'Giỏ hàng',
            )),
          ),
          leading: IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeList()));
              },
              icon: Icon(Icons.arrow_back)),
          actions: [
            SizedBox(
              width: 100,
              child: Row(
                children: [
                  RaisedButton(
                    onPressed: () => {},
                    color: Colors.blue,
                    child: Text(
                      'TikiNgon',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 24,
                            left: 20,
                          ),
                          child: Text('Tổng cộng',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5, left: 20),
                          child: Text(
                              '${occ.format(shoppingCart.getTotalPrice())}',
                              style: const TextStyle(
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
                                'Mua Hàng (${shoppingCart.productList.where((p) => p.isChecked == true).length})',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ),
                          color: Colors.red,
                          onPressed: () {},
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
 
  

  @override
  Widget build(BuildContext context) {
    // final cart = context.watch<CartModel>();
    final shoppingCart = Provider.of<CartProvider>(context);

    return Column(children: [
      Row(
        children: [
          Checkbox(
            checkColor: Colors.white,
            value: shoppingCart.checkall,
            onChanged: (bool? value) {
              shoppingCart.checkall = value!;
                shoppingCart.checkAll(shoppingCart.productList, shoppingCart.checkall) ;
                
            },
          ),
          Spacer(),
          Text('Tất cả( ${shoppingCart.productList.where((p) => p.isChecked == true).length} sản phẩm) '),// độ dài của những sản phẩm được chọn
          Spacer(flex: 50),
          IconButton(
              onPressed: () {
                if (shoppingCart.productList.isNotEmpty) {
                  return openMyAlertDialog(context, shoppingCart);
                } else {}
              },
              icon: Icon(Icons.delete)),
        ],
      ),
      Expanded(
          child: ListView.separated(
        itemCount: shoppingCart.productList.length,
        separatorBuilder: (BuildContext context, int index) => const Divider(),
        itemBuilder: (BuildContext context, int index) {
          final cartproduct = shoppingCart.productList[index];

          return Container(
            child: Row(children: [
              Checkbox(
                checkColor: Colors.white,
                value: shoppingCart.productList[index].isChecked,
                onChanged: (bool? value) {
                  shoppingCart.checked(shoppingCart.productList[index], value!);
                },
              ),
              SizedBox(
                width: 110,
                height: 130,
                child: Image.network(cartproduct.product.thumbnailUrl),
                //(hà cc.mảng có gtri index).
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Text(
                        cartproduct.product.name,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 4,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Text(
                        occ.format(cartproduct.product.price),
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 4,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              border: Border.all(
                                  width: 1,
                                  color: Color.fromARGB(200, 200, 200, 200)),
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    shoppingCart.sub(cartproduct);
                                  },
                                  icon: const Icon(Icons.remove)),
                              Text('${cartproduct.quantity}'),
                              IconButton(
                                  onPressed: () {
                                    shoppingCart.plus(cartproduct);
                                  },
                                  icon: const Icon(Icons.add)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: TextButton(
                              onPressed: () {
                                shoppingCart.remove(cartproduct);
                              },
                              child: Text('Xóa')),
                        )
                      ],
                    )
                  ],
                ),
              )
            ]),
          );
        },
      )),
    ]);
  }
}

void openMyAlertDialog(BuildContext context, CartProvider shoppingCart) {
  //shoppingCart nằm trong hàm build(private), dùng ở ngoài thì p kbao
  // Create a AlertDialog.
  AlertDialog dialog = AlertDialog(
    title: Text("Xác nhận"),
    content: Text("Bạn có thực sự muốn xóa hay không?"),
    shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.green, width: 3),
        borderRadius: BorderRadius.all(Radius.circular(15))),
    actions: [
      ElevatedButton(
          child: Text("Có"),
          onPressed: () {
            shoppingCart.clearlist();
            Navigator.of(context).pop(true); // Return true
          }),
      ElevatedButton(
          child: Text("Không"),
          onPressed: () {
            Navigator.of(context).pop(false); // Return false
          }),
    ],
  );

  // Call showDialog function.
  Future futureValue = showDialog(
      context: context,
      builder: (BuildContext context) {
        return dialog;
      });
  futureValue.then((value) {
    print("Return value: " + value.toString()); // true/false
  });
}
