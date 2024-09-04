import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:myrunciit/add_to_cart/add_to_cart.dart';
import 'package:myrunciit/bottom_navigationbar/deals_page/deals_sub_category/today_sub_category.dart';
import 'package:myrunciit/product_screen/product_main_screen.dart';
import 'package:myrunciit/roots/roots.dart';
import 'package:myrunciit/widget/cart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchGrid extends StatefulWidget {
  List product1 = [];
  SearchGrid({Key? key, required this.product1}) : super(key: key);
  @override
  _SearchGridState createState() => _SearchGridState();
}

class _SearchGridState extends State<SearchGrid> {
  List product2 = [];
  var store_id;
  getProduct() async {
    print('vendorIdddd$vendorId');
    print('store_idIdddd$vendorId');

    String url1 = store_id != null ? "$root_web/all_category?vendor_id=${store_id}" : "$root_web/all_category?vendor_id=2";
    dynamic response = await http.get(Uri.parse(url1));
    if (response.statusCode == 200) {
      print('success');
      print(response.body);
      dynamic jsonResponse = jsonDecode(response.body);

      // Check if the response is valid and contains the expected data
      if (jsonResponse != null &&
          jsonResponse['Response'] != null &&
          jsonResponse['Response']['category'] != null) {
        setState(() {
          // Access the array of categories from the response
          product2 = jsonResponse['Response']['category'];
        });
      } else {
        print("Invalid response format or missing data");
      }
    } else {
      print("failure");
    }
  }

  void initState() {
    getProduct();
    super.initState();
  }
  getstoreid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      store_id = prefs.getString('storeid');
    });
    print('gridview3store_id===>>> $store_id');
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    print(widget.product1);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.count(
        scrollDirection: Axis.vertical,
        crossAxisCount: 2,
        childAspectRatio: (1/1.2),
        crossAxisSpacing: 0.0,
        mainAxisSpacing: 0.0,
        children: List.generate(widget.product1.length, (index) {
          var optionsJson = jsonDecode(widget.product1[index]["options"]);

          List<String> optionValues = [];

          // if (optionsJson is List) {
          for (var option in optionsJson) {
            if (option['option'] is List) {
              for (var value in option['option']) {
                for (int i = 0; i < 1; i++) {
                  if (optionsJson[0]["title"] == 'KG') {
                    optionValues;
                    print("helooo====20");
                    print(optionValues);
                    print(value);
                  }
                }
              }
            }
          }
          return GestureDetector(
            onTap: () {
              if (added == 'true') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddToCart(
                        sub_category: widget.product1[index]["sub_category_name"],
                          categoryName:
                          widget.product1[index]["title"].toString(),
                          categoryImage: widget.product1[index]["product_image"]
                              .toString(),
                          sale_price:
                          widget.product1[index]["sale_price"].toString(),
                          current_stock: widget.product1[index]["current_stock"]
                              .toString(),
                          description:
                          widget.product1[index]["description"].toString(),
                          discount: widget.product1[index]["discount"].toString(),
                          product_id: widget.product1[index]["product_id"].toString(),
                          options: widget.product1[index]['options'].toString(),
                          multi_price: widget.product1[index]['multiple_price'].toString(),
                          product_muti_images: widget.product1[index]['product_image'],
                          tax: widget.product1[index]['tax'].toString(),
                          tax_type: widget.product1[index]['tax_type'].toString(),
                          brand_name: widget.product1[index]['brand_name'].toString(),
                          cod_status: widget.product1[index]['cod_status'].toString(),
                      )),
                );

              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CategoryDetailScreen(
                          categoryName:
                          widget.product1[index]["title"].toString(),
                          categoryImage: widget.product1[index]["product_image"]
                              .toString(),
                          sale_price:
                          widget.product1[index]["sale_price"].toString(),
                          current_stock: widget.product1[index]["current_stock"]
                              .toString(),
                          description:
                          widget.product1[index]["description"].toString(),
                          discount:
                          widget.product1[index]["discount"].toString(),
                          product_id: widget.product1[index]["product_id"].toString(),
                          brand_name:
                          widget.product1[index]["brand"].toString(),
                          options: widget.product1[index]['options'].toString(),
                          tax: widget.product1[index]['tax'].toString(),
                          tax_type: widget.product1[index]['tax_type'].toString(),
                          cod_status: widget.product1[index]['cod_status'].toString(),
                        multi_price: widget.product1[index]['multiple_price'].toString(),
                        product_images: widget.product1[index]['product_image'],
                        sub_category: widget.product1[index]['sub_category_name'].toString(),

                      )),
                );

              }
            },
            behavior: HitTestBehavior.translucent,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              margin: EdgeInsets.fromLTRB(18.0, 15.0, 18.0, 15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.product1[index]["discount"] != null &&
                      int.tryParse(widget.product1[index]["discount"].toString()) != null &&
                      int.parse(widget.product1[index]["discount"].toString()) > 0)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                          8, 8, 0, 0),
                      child: Container(
                        height: size.height * 0.02,
                        width: size.width * 0.15,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(244, 194, 37, 1),

                          borderRadius: BorderRadius.all(
                              Radius.circular(10)),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets
                                  .fromLTRB(6, 2, 0, 2),
                              child: Text(
                                widget.product1[index]
                                ["discount"]
                                    .toString(),
                                style: TextStyle(
                                    fontSize: 10),
                                textAlign:
                                TextAlign.center,
                              ),
                            ),
                            Text(
                              "% offer",
                              style:
                              TextStyle(fontSize: 10),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                          8, 8, 0, 0),
                      child: Container(
                        height: size.height * 0.02,
                        width: size.width * 0.15,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                              Radius.circular(10)),
                        ),
                      ),
                    ),

                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Center(
                      child: Container(
                        height: 60,
                        width: 80,
                        // color: Colors.cyan,
                        child: widget.product1[index]['product_image']
                                    .toString() !=
                                null
                            ? Image.network(
                                widget.product1[index]['product_image']
                                    .toString(),
                                errorBuilder: (BuildContext context,
                                    Object error, StackTrace? stackTrace) {
                                  return Image.asset(
                                      'asset/dummy.jpg');
                                },
                              )
                            : Image.asset(
                                'asset/dummy.jpg'),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.005,
                  ),
                  Center(
                    child: Text(
                      widget.product1[index]["title"].toString(),
                      style:
                          TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 8,),
                  Center(
                    child:  widget.product1[index]["discount"] != null &&
                        int.tryParse(widget.product1[index]["discount"].toString()) != null &&
                        int.parse(widget.product1[index]["discount"].toString()) > 0
                        ? Container(
                      // Your original code with some modifications
                      decoration: const BoxDecoration(
                        color: Color(0xffc40001),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      height: size.height * 0.02,
                      width: size.width * 0.35,
                      child: Center(
                        child: Text.rich(
                          TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: widget.product1[index]["sale_price"].toString(),
                                style: TextStyle(
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              TextSpan(
                                text: "RM "+(double.parse(widget.product1[index]["sale_price"]) -
                                    (double.parse(widget.product1[index]["sale_price"]) *
                                        (double.parse(widget.product1[index]["discount"]) *
                                            0.01)))
                                    .toStringAsFixed(2),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                        : Container(
                      // Your original code with some modifications
                      decoration: BoxDecoration(
                        color: Color(0xffc40001),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      height: size.height * 0.02,
                      width: size.width * 0.30,
                      child: Center(
                        child: Text(
                          "RM "+widget.product1[index]["sale_price"].toString() ,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
