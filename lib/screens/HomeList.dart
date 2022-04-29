import 'package:flutter/material.dart';
import 'HomeDetails.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'Cart.dart';
import 'package:tiki_project/models/api.dart';
import 'package:tiki_project/models/products.dart';
import 'dart:async';
import 'package:badges/badges.dart';
import 'package:provider/provider.dart';
import 'package:tiki_project/models/CartProvider.dart';

final occ = NumberFormat.simpleCurrency(locale: 'vi-VN');

class TikiProject extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final Color color = Theme.of(context).primaryColor;

    return MultiProvider(
        providers: [
          ChangeNotifierProvider<CartProvider>(create: (_) => CartProvider()),
        ],
        child: MaterialApp(
            title: 'Danh sách sản phẩm',
            initialRoute: '/list',
            routes: {
              '/list': (context) => HomeList(),
              '/details': (context) => HomeDetails(),
              '/cart': (context) => Cart(),
            }));
  }
}

class HomeList extends StatefulWidget {
  const HomeList({Key? key}) : super(key: key);

  @override
  State<HomeList> createState() => _HomeListState();
}

class _HomeListState extends State<HomeList> {
  Timer? _debounce;
  String query = '';

  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  bool _isLoading = false;
  bool _hasMore = true;
  int _itemsperpage = 40;
  int _page = 1;

  List<Product> products = [];
  ScrollController _sc = new ScrollController();
  void initState() {
    super.initState();

    _isLoading = true;
    _hasMore = true;
    this._loadMore(_page);
    _sc.addListener(() {
      if (_sc.position.pixels == _sc.position.maxScrollExtent) {
        _loadMore(_page);
      }
    });
  }

  void _loadMore(int page, {String name = ''}) {
    _isLoading = true;
    Api()
        .getProductsperpage(
      _page,
      _itemsperpage,
      name: name,
    )
        .then((List<Product> fetchedList) {
      if (fetchedList.isEmpty) {
        setState(() {
          _isLoading = false;
          _hasMore = false;
        });
      } else {
        print(_page);
        print(_itemsperpage);
        setState(() {
          _isLoading = true;
          products.addAll(fetchedList);
          // het data roi, khong can load them nua
          if (fetchedList.length < 40) {
            _hasMore = false;
          }
        });
      }
    });
    _itemsperpage = 20; // sau khi load xong thì load thêm 20 sp
    _page++;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    // TODO: implement setState
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shoppingCart = Provider.of<CartProvider>(context);
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
                onPressed: () {}, icon: const Icon(Icons.arrow_back)),
            actions: [
              SizedBox(
                width: 25.0,
                child: IconButton(
                    icon: const Icon(Icons.shopping_bag_outlined),
                    onPressed: () => {
                          // Navigator.push(context,
                          //     MaterialPageRoute(builder: (context) => Cart()));

                          Navigator.pushNamed(context, '/cart')
                        }),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: Center(
                  child: Badge(
                    badgeContent: Text(
                        '${shoppingCart.productList.length == 0 ? '' : shoppingCart.productList.length}'),
                    animationDuration: const Duration(milliseconds: 300),
                  ),
                  
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
            ],
            backgroundColor: Colors.blue,
            title: Center(
                child: Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: SizedBox(
                child: TextField(
                  controller: _searchController,
                  onChanged: (query) {
                    setState(() {
                      if (_debounce?.isActive ?? false) _debounce?.cancel();
                      _debounce = Timer(const Duration(milliseconds: 500), () {
                        products.clear();
                        this.query = query;
                        _isSearching = true;
                        _page = 1;
                        _loadMore(_page, name: query);
                      });
                    });
                  },
                  decoration: InputDecoration(
                    prefixIcon: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.search),
                        color: Colors.grey),
                    suffixIcon: _isSearching == true
                        ? IconButton(
                            onPressed: () {
                              setState(() {
                                _searchController.clear();
                                _isSearching = true;
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const HomeList()));
                              });
                            },
                            icon: const Icon(Icons.clear),
                            color: Colors.grey)
                        : null,
                    hintText: 'Search...',
                    contentPadding: EdgeInsets.all(20),
                  ),
                ),
              ),
            ))),
        body: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, //chia làm 2 cột
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1 / 1.3, // không gian ô
          ),
          padding: const EdgeInsets.all(8.0),
          controller: _sc,
          itemCount: _hasMore ? products.length + 1 : products.length,
          itemBuilder: (context, index) {
            if (!_isLoading) return const CircularProgressIndicator();

            if (products.length == index) {
              return const CircularProgressIndicator(
                backgroundColor: Colors.cyanAccent,
                strokeWidth: 10,
              );
            }
            return ProductItem(product: products[index]);
          },
        ));
  }
}

class ProductItem extends StatelessWidget {
  const ProductItem({Key? key, required this.product}) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/details', arguments: product);
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
                    height: 150,
                    child: Image.network(
                      product.thumbnailUrl,
                    )),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    product.name,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                    // text dài quá thì sẽ xuống dòng
                    maxLines: 2, // chia làm 2 dòng
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0, left: 5.0),
                  child: Row(
                    children: [
                      RatingBar.builder(
                        itemSize: 12,
                        initialRating: product.ratingAverage,
                        minRating: 1,
                        ignoreGestures: true,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {},
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          '(${product.reviewCount}) | ',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      //(' ${} ')
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                            '${product.quantitySold == null ? '' : product.quantitySold!.text}',
                            style: TextStyle(fontSize: 12)),
                      ),
                    ],
                  ),
                ),
                product.discountRate == 0
                    ? Padding(
                        padding: const EdgeInsets.only(left: 8.0, top: 2.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${occ.format(product.price)} ',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            // if(product.discountRate < 0)
                            // {}
                          ],
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0, top: 2.0),
                            child: Text(
                              '${occ.format(product.price)} ',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.red,
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(right: 11.0, top: 2.0),
                            child: Container(
                              width: 40,
                              decoration: BoxDecoration(
                                  color: Colors.pink[100],
                                  border:
                                      Border.all(width: 1, color: Colors.red),
                                  borderRadius: BorderRadius.circular(3)),
                              child: Center(
                                child: Text('-${product.discountRate}%',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.red)),
                              ),
                            ),
                          ),
                        ],
                      ),
              ],
            )));
  }
  
}
