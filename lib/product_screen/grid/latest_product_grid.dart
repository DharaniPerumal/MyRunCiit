import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:myrunciit/add_to_cart/add_to_cart.dart';
import 'package:myrunciit/bottom_navigationbar/deals_page/deals_sub_category/today_sub_category.dart';
import 'package:myrunciit/roots/roots.dart';
import 'package:myrunciit/widget/cart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

var store_id;

class latest_product_grid extends StatefulWidget {
  const latest_product_grid({super.key});

  @override
  State<latest_product_grid> createState() => _latest_product_gridState();
}

class _latest_product_gridState extends State<latest_product_grid> {
  StreamController<List> _dealsStreamController = StreamController<List>();

  List todaydeals = [];
  late double discountedPrice;

  // List subcategories = [];

  getstoreid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.getString('storeid');
    await prefs.reload();
    print('get_today_deals ===>>> $store_id');
    gettoadydeals();
  }

  @override
  void initState() {
    setState(() {
      getstoreid();
    });
    super.initState();
  }

  @override
  void dispose() {
    _dealsStreamController.close();
    super.dispose();
  }

  gettoadydeals() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    store_id = prefs.getString('storeid');
    String url1 = "$root_web/getLatestProducts/${prefs.getString('storeid')}";
    print('getLatestProducts --------- $url1');
    dynamic response = await http.get(Uri.parse(url1));
    if (response.statusCode == 200) {
      print('success');
      print(response.body);
      dynamic jsonResponse = jsonDecode(response.body);

      // Check if the response is valid and contains the expected data
      if (jsonResponse != null &&
          jsonResponse['Response'] != null &&
          jsonResponse['Response']["latestProducts"] != null) {
        setState(() {
          todaydeals = jsonResponse['Response']["latestProducts"];
          _dealsStreamController.add(todaydeals);
          print(todaydeals);
        });
      } else {
        print("Invalid response format or missing data");
      }
    } else {
      print("failure");
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: StreamBuilder<List>(
          stream: _dealsStreamController.stream,
          builder: (context, snapshot) {
            if ((snapshot.hasData)) {
              List<dynamic> todaydeals = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.only(left: 0),
                child: Container(
                  width: size.width,
                  color: Colors.white,
                  child: GridView.count(
                    physics: NeverScrollableScrollPhysics(), // Disable vertical scroll
                    scrollDirection: Axis.vertical,
                    crossAxisCount: 2,
                    childAspectRatio: (1/1.18),
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 0.0,
                    children: List.generate(todaydeals.length>4?4:todaydeals.length, (index) {
                      print("hello12345l");
                      return GestureDetector(
                        onTap: () {
                          if (added == 'true') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddToCart(
                                  sub_category: todaydeals[index]["sub_category_name"],
                                  tax:todaydeals[index]["tax"],
                                  tax_type:todaydeals[index]["tax_type"],
                                  multi_price: todaydeals[index]["multiple_price"],
                                  product_muti_images: todaydeals[index]["product_image"],
                                  categoryName: todaydeals[index]["title"].toString(),
                                  categoryImage:
                                  todaydeals[index]["banner"].toString(),
                                  sale_price:
                                  todaydeals[index]["sale_price"].toString(),
                                  current_stock:
                                  todaydeals[index]["current_stock"].toString(),
                                  description:
                                  todaydeals[index]["description"].toString(),
                                  discount: todaydeals[index]["discount"].toString(),
                                  product_id: todaydeals[index]["product_id"].toString(),
                                  options: todaydeals[index]['options'],
                                  brand_name: todaydeals[index]['brand_name'],
                                  cod_status: todaydeals[index]['cod_status'].toString(),
                                ),
                              ),
                            );

                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CategoryDetailScreen(
                                  tax: todaydeals[index]["tax"],
                                  tax_type: todaydeals[index]["tax_type"],
                                  multi_price: todaydeals[index]["multiple_price"],
                                  product_images: todaydeals[index]["product_image"],
                                  categoryName: todaydeals[index]["title"].toString(),
                                  categoryImage:
                                  todaydeals[index]["banner"].toString(),
                                  sale_price:
                                  todaydeals[index]["sale_price"].toString(),
                                  current_stock:
                                  todaydeals[index]["current_stock"].toString(),
                                  description:
                                  todaydeals[index]["description"].toString(),
                                  product_id: todaydeals[index]["product_id"].toString(),

                                  discount: todaydeals[index]["discount"].toString(),
                                  // weight: todaydeals[index]["option"].toString(),
                                  brand_name:
                                  todaydeals[index]["brand_name"].toString(),
                                  options: todaydeals[index]['options'],
                                  cod_status: todaydeals[index]['cod_status'],
                                  sub_category: todaydeals[index]['sub_category_name'].toString(),

                                ),
                              ),
                            );

                          }
                        },
                        behavior: HitTestBehavior.translucent,
                        child: Column(
                          children: [
                            SafeArea(
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border:
                                    Border.all(color: Colors.grey.shade100)),
                                width: size.width * 0.55,
                                height: size.height * 0.25,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (int.tryParse(
                                        todaydeals[index]["discount"]) !=
                                        null &&
                                        int.parse(todaydeals[index]["discount"]) >
                                            0)
                                      Padding(
                                        padding:
                                        const EdgeInsets.fromLTRB(4, 8, 0, 0),
                                        child: Container(
                                          height: size.height * 0.02,
                                          width: size.width * 0.15,
                                          decoration: BoxDecoration(
                                            color: Color.fromRGBO(244, 194, 37, 1),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                          ),
                                          child: Center(
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.fromLTRB(
                                                      4, 2, 0, 2),
                                                  child: Text(
                                                    todaydeals[index]["discount"]
                                                        .toString() +
                                                        "% offer",
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                        FontWeight.bold),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    else
                                      Padding(
                                        padding:
                                        const EdgeInsets.fromLTRB(4, 8, 0, 0),
                                        child: Container(
                                          height: size.height * 0.02,
                                          width: size.width * 0.15,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                          ),
                                          // child: Center(
                                          //   child: Row(
                                          //     children: [
                                          //       Padding(
                                          //         padding: const EdgeInsets.fromLTRB(6, 2, 0, 2),
                                          //         child: Text(
                                          //           todaydeals[index]["discount"].toString(),
                                          //           style: TextStyle(fontSize: 10),
                                          //           textAlign: TextAlign.center,
                                          //         ),
                                          //       ),
                                          //       Text(
                                          //         "% offer",
                                          //         style: TextStyle(fontSize: 10),
                                          //       )
                                          //     ],
                                          //   ),
                                          // ),
                                        ),
                                      ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Container(
                                            height: 80,
                                            width: 100,
                                            child: todaydeals[index]["banner"] !=
                                                null
                                                ? Image.network(
                                              todaydeals[index]["banner"]
                                                  .toString(),
                                              errorBuilder: (BuildContext
                                              context,
                                                  Object error,
                                                  StackTrace? stackTrace) {
                                                return Image.asset(
                                                    'asset/dummy.jpg');
                                              },
                                            )
                                                : Image.asset('asset/dummy.jpg'),
                                          ),
                                        ),
                                        SizedBox(
                                          height: size.height * 0.002,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 8, right: 8),
                                          child: Text(
                                            todaydeals[index]["title"].toString(),
                                            style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        SizedBox(
                                            height: size.height * 0.02
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 7, 0, 0),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              Center(
                                                child: Text(
                                                  "RM ",
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 9,
                                                      fontWeight: FontWeight.bold),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),

                                              if (int.tryParse(
                                                  todaydeals[index]["discount"]) !=
                                                  null &&
                                                  int.parse(todaydeals[index]["discount"]) >
                                                      0)
                                                Text.rich(TextSpan(
                                                  // text: 'This item costs ',
                                                  children: <TextSpan>[
                                                    new TextSpan(
                                                      text:  todaydeals[index]["sale_price"]
                                                          .toString(),
                                                      style: new TextStyle(
                                                        color: Colors.grey,
                                                        decoration: TextDecoration.lineThrough,
                                                      ),
                                                    ),

                                                    new TextSpan(
                                                      text:(double.parse(todaydeals[index]["sale_price"]) -
                                                          (double.parse(todaydeals[index]["sale_price"])

                                                              * (double.parse(todaydeals[index]["discount"])
                                                                  *0.01)
                                                          )
                                                      ).toStringAsFixed(2),

                                                    ),
                                                  ],
                                                ),

                                                )
                                              else
                                                Text.rich(TextSpan(
                                                  // text: 'This item costs ',
                                                  children: <TextSpan>[
                                                    new TextSpan(
                                                      text:  todaydeals[index]["sale_price"]
                                                          .toString(),
                                                      style: new TextStyle(
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),

                                                )

                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ));
  }
}
