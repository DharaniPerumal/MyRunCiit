import 'dart:async';
import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myrunciit/bottom_navigationbar/account.dart';
// import 'package:myrunciit/bottom_navigationbar/categories.dart';
import 'package:myrunciit/bottom_navigationbar/sub_category_2/categories_2.dart';
import 'package:myrunciit/bottom_navigationbar/deals.dart';
import 'package:myrunciit/bottom_navigationbar/favourites.dart';
import 'package:myrunciit/drawer/invoice.dart';
import 'package:myrunciit/drawer/review.dart';
// import 'package:myrunciit/drawer/Address/address_list_grid.dart';
import 'package:myrunciit/drawer/your_account.dart';
import 'package:myrunciit/main.dart';
import 'package:myrunciit/main_screen/login_screen.dart';
import 'package:myrunciit/product_screen/product_main_screen.dart';
import 'package:myrunciit/roots/roots.dart';
import 'package:myrunciit/widget/cart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widget/drawer.dart';

var orderstoreid;
var order_id;
var review_status;


class MyOrders extends StatefulWidget {
  const MyOrders({super.key});

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  StreamController<List> _orderStreamController = StreamController<List>();

  var sale_code, created_datetime, price, product_name, qty;

  // List qty = [];

  Future<void> my_orders_api() async {
    print(orderstoreid);
    String url = "$root_web/profile/order_history/$orderstoreid";
    dynamic response = await http.get(Uri.parse(url));
    print('my_orders_api${response.body}');
    print(response.statusCode);
    print(response);

    var jsonResponse = jsonDecode(response.body);
    var status = jsonResponse["status"];

    if (status == "SUCCESS") {
      var orders = jsonResponse["Response"] as List<dynamic>;

    } else {
      print('API request failed with status: $status');
    }
  }

  Future<void> getProduct1() async {
    try {
      // Initialize the product list
      List<dynamic> product = [];

      print(orderstoreid);
      String url1 = "$root_web/profile/order_history/${orderstoreid}";
      final response = await http.get(Uri.parse(url1));

      if (response.statusCode == 200) {
        print('success');
        print(response.body);
        final recommendedResponse = jsonDecode(response.body);

        debugPrint('recommended_response$recommendedResponse');

        if (recommendedResponse != null && recommendedResponse['Response'] != null) {
          // Assign the product list
          product = recommendedResponse['Response'];

          _orderStreamController.add(product);
          print("product1$recommendedResponse");
        } else {
          print("Invalid response format or missing data");
        }
      } else {
        print("Failure - ${response.statusCode}");
      }
    } catch (error) {
      print("Error: $error");
    }
  }


  void initState() {
    setState(() {
      initData();
    });
    super.initState();
  }

  Future<void> initData() async {
    await orderstoreid1();
    getProduct1();
    my_orders_api();
  }

  Future<void> orderstoreid1() async {
    SharedPreferences prefs1 = await SharedPreferences.getInstance();
    setState(() {
      orderstoreid = prefs1.getString('store_id');
      review_status = prefs1.getString('review_status');
    });
    print('orderstoreid1 ===>>> $orderstoreid');
    print('review_status ===>>> $review_status');

  }

  @override
  void dispose() {
    _orderStreamController.close();
    super.dispose();
  }

  int itemCount = 0;

  void addToCart() {
    setState(() {
      itemCount++;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);        return Future.value(true);
      },

      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff014282),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.keyboard_arrow_left,
              size: 35,color: Colors.white,
            ),
          ),
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[Text("My orders",style: TextStyle(fontSize: 18.0,color: Colors.white,fontWeight: FontWeight.bold))],
          ),
          actions: [ShoppingCart()],
        ),
        body: StreamBuilder<List>(
          stream: _orderStreamController.stream,
          builder: (context, snapshot) {
            if ((snapshot.hasData)) {
              List<dynamic> product = snapshot.data!;
              return ListView.builder(
                itemCount: product.length,
                itemBuilder: (context, index) {
                  String saleCode = product[index]['sale_id'];
                  String orderid1 = product[index]['order_id'];
                  var productdetails = product[index]['product_details'];
                  print("productdetails$productdetails");
                  print("productdetails${productdetails.length}");
                  List<String> itemNames = [];
                  List<String> itemImage = [];
                  List<String> productid1 = [];
                  List<String> review1 = [];
                  for(int i =0 ; i<productdetails.length ;) {
                    String review = productdetails[i]["review"];
                    print("productdetails${productdetails[i]["review"]}");
                    i++;
                    review1.add(review);
                    print("review1review1${review1}");
                  }
                  for(int i =0 ; i<productdetails.length ;) {
                    String itemname =productdetails[i]["name"];
                    print("productdetails${productdetails[i]["name"]}");
                    i++;
                    itemNames.add(itemname);
                  }
                  for(int i =0 ; i<productdetails.length ;) {
                    String itemimage =productdetails[i]["image"];
                    print("itemimage${productdetails[i]["image"]}");
                    i++;
                    itemImage.add(itemimage);
                  }
                  for(int i =0 ; i<productdetails.length ;) {
                    String productid =productdetails[i]["id"];
                    print("productdetails${productdetails[i]["id"]}");
                    i++;
                    productid1.add(productid);
                  }




                  return GestureDetector(
                      onTap: () {},
                      behavior: HitTestBehavior.translucent,
                      child: Container(
                          color: Colors.white,
                          child: Column(children: [
                            Padding(
                              padding: const EdgeInsets.all(1.0),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 1, 0, 1),
                                child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5)),
                                      border:
                                      Border.all(color: Colors.grey.shade500),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          spreadRadius: 2,
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    margin: const EdgeInsets.all(8.0),
                                    width: size.width,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  "Sale Code:",
                                                  style: TextStyle(
                                                      color: Colors.grey.shade700,
                                                      fontSize: 13),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      right: 8),
                                                  child: Text(
                                                    saleCode,
                                                    style: TextStyle(
                                                        color:
                                                        Colors.grey.shade700,
                                                        fontSize: 13),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 5),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text("Time:",
                                                    style: TextStyle(
                                                        color:
                                                        Colors.grey.shade700,
                                                        fontSize: 13)),
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      right: 8),
                                                  child: Text(
                                                      created_datetime.toString(),
                                                      style: TextStyle(
                                                          color: Colors
                                                              .grey.shade700,
                                                          fontSize: 13)),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(
                                                  2, 5, 0, 4),
                                              child: Container(
                                                height: size.height * 0.035,
                                                width: size.width,
                                                decoration: BoxDecoration(
                                                    border: Border(
                                                        top: BorderSide(
                                                            color: Colors
                                                                .grey.shade400),
                                                        bottom: BorderSide(
                                                            color: Colors
                                                                .grey.shade400))),
                                                child: Align(
                                                  alignment: Alignment
                                                      .centerLeft, // Aligns the text to the left
                                                  child: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      const Text(
                                                        'Grand Total:',
                                                        style: TextStyle(
                                                            fontWeight:
                                                            FontWeight.bold),
                                                      ),
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets.only(
                                                            right: 8),
                                                        child: Text(
                                                          'RM' +
                                                              product[index]
                                                              ["grandtotal"],
                                                          style: TextStyle(
                                                              fontWeight:
                                                              FontWeight.bold,
                                                              color: Colors.green
                                                                  .shade600),
                                                        ),
                                                      ),
                                                    ],
                                                  ),

                                                ),
                                              ),
                                            ),
                                            ListView.builder(
                                              shrinkWrap: true,
                                              physics: NeverScrollableScrollPhysics(),
                                              itemCount: itemNames.length,
                                              itemBuilder: (context, index) {

                                                return Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    width: size.width,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(color: Colors.grey.shade400),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: Container(
                                                            height: size.height * 0.12,
                                                            width: size.width * 0.22,
                                                            child: Image.network(
                                                              itemImage[index].toString(),
                                                              fit: BoxFit.fitHeight,
                                                            ),
                                                          ),
                                                        ),
                                                        Column(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                                                              child: Container(
                                                                color: Colors.white,
                                                                width: size.width * 0.45,
                                                                child: Column(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    AutoSizeText(
                                                                      itemNames[index],
                                                                      style: TextStyle(
                                                                        fontWeight: FontWeight.bold,
                                                                        color: Colors.black,
                                                                        fontSize: 15,
                                                                      ),
                                                                      maxLines: 4,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets.fromLTRB(8, 0, 8, 4),
                                                              child: Container(
                                                                width: size.width * 0.4,
                                                                child: Text(
                                                                  'Seller: MyRunciit',
                                                                  style: TextStyle(
                                                                    fontWeight: FontWeight.bold,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            // if (review_status == "FAILED")
                                                            //   Container()
                                                            //  else
                                                            review1[index] == "User already reviewed this product" ?
                                                            TextButton(
                                                              onPressed: () {
                                                              },

                                                              child:

                                                              Text(
                                                                "Already Reviewed by you",
                                                                style: TextStyle(
                                                                  color: Colors.green,
                                                                  fontWeight: FontWeight.bold,
                                                                ),
                                                              ),
                                                            ) :
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.push(
                                                                  context,

                                                                  MaterialPageRoute(
                                                                    builder: (context) => Review(
                                                                        order_id: orderid1,
                                                                        productname:itemNames[index],
                                                                        product_id:productid1[index],
                                                                        user_id: orderstoreid,
                                                                        sale_id: saleCode


                                                                    ),
                                                                  ),
                                                                );
                                                              },

                                                              child:

                                                              Text(
                                                                "Rate & Review",
                                                                style: TextStyle(
                                                                  color: Colors.green,
                                                                  fontWeight: FontWeight.bold,
                                                                ),
                                                              ),
                                                            )                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );

                                              },
                                            ),

                                            InkWell(
                                              onTap: (){
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => Invoice(
                                                          order_id: product[index]['order_id'],
                                                        )));
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Container(
                                                    decoration: const BoxDecoration(
                                                        color: Colors
                                                            .green,
                                                        borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10))),
                                                    child: Center(
                                                      child:
                                                      const Text(
                                                        "Invoice",
                                                        style: TextStyle(
                                                            color: Colors
                                                                .white,
                                                            fontWeight:
                                                            FontWeight.bold,fontSize: 18.0),
                                                      ),
                                                    )),
                                              ),
                                            )
                                          ]),
                                    )),
                              ),
                            )
                          ])));
                },
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.grid_view),
              label: 'Categories',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favourites',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.sell),
              label: 'Deals',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_2_rounded),
              label: 'Account',
            ),
          ],
          currentIndex: 0,
          selectedItemColor: Colors.green.shade600,
          unselectedItemColor: Colors.black,
          selectedIconTheme: IconThemeData(color: Colors.green.shade600),
          unselectedIconTheme: const IconThemeData(color: Colors.black),
          onTap: (int index) async {
            switch (index) {
              case 0:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProductScreen()),
                );
                print('Tapped on Home');
                break;
              case 1:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Categories2()),
                );
                print('Tapped on Categories');
                break;
              case 2:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Favourites()),
                );
                print('Tapped on Favourites');
                break;
              case 3:
                bool today = false;
                bool recent = false;
                bool most = false;
                bool featured = false;
                bool latest = false;
                final SharedPreferences prefs1 = await SharedPreferences.getInstance();
                await prefs1.setBool('toadys_deals', today);
                await prefs1.setBool('Recent', recent);
                await prefs1.setBool('Featured', featured);
                await prefs1.setBool('Most', most);
                await prefs1.setBool('Latest', latest);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Deals(
                      selectedTabIndex: 0,
                    ),
                  ),
                );
                print('Tapped on Deals');
                break;
              case 4:
                var sharedPref = await SharedPreferences.getInstance();
                sharedPref.setBool(SplashScreenState.KEYlOGIN, true);
                isLoggedIn = sharedPref.getBool(SplashScreenState.KEYlOGIN);
                print("isLoggedIn: $isLoggedIn");

                if (isLoggedIn == true || status == 'SUCCESS') {
                  print(isLoggedIn);
                  print(status);
                  print(status);
                  print(name);
                  print(first_name1);
                  print(myValue);

                  if (myValue != null && isLoggedIn == true)
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => YourAccount()),
                    );
                  else
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Account()),
                    );
                  break;
                }

                break;
            }
            print('Tapped on item $index');
          },
        ),
      ),
    );
  }
}
