import 'dart:convert';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:myrunciit/bottom_navigationbar/sub_category_2/sub_category_2.dart';
import 'package:myrunciit/main_screen/sub_categories/sub_category_1.dart';
import 'package:myrunciit/roots/roots.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HorizontalGridView_3 extends StatefulWidget {
  const HorizontalGridView_3({Key? key}) : super(key: key);
  @override
  _HorizontalGridView_3State createState() => _HorizontalGridView_3State();
}

class _HorizontalGridView_3State extends State<HorizontalGridView_3> {
  List product2 = [];
  var store_id;

  getProduct() async {
    setState(() {
      product2 = [];
    });
    String url1 = store_id != null
        ? "$root_web/all_category/${store_id}"
        : "$root_web/all_category/2";
    // https://myrunciit.my/webservice/all_category
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
    getstoreid();


    super.initState();
  }

  getstoreid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      store_id = prefs.getString('storeid');
    });
    getProduct();
    print('gridview3store_id===>>> $store_id');
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Expanded(
        child: product2.length != 0 ? GridView.count(
          scrollDirection: Axis.vertical,
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          childAspectRatio: (1 / 0.95),
          mainAxisSpacing: 10.0,
          children: List.generate(product2.length, (index) {
            return GestureDetector(
              onTap: () {
                print('category_sub ------------------> $store_id');
                if(product2[index]['sub_category'] != null)
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Subcategory(
                          subcategories: product2[index]['sub_category'], store_data: store_id,
                        )),
                  );
                }
                else
                {
                  Fluttertoast.showToast(
                      msg: 'No Sub Category Available...!',
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 3,
                      backgroundColor: Color(0xff014282),
                      textColor: Colors.white,
                      fontSize: 15,
                      webPosition: "center");
                }

              },
              behavior: HitTestBehavior.translucent,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: Colors.black.withOpacity(0.1),
                      //     spreadRadius: 2,
                      //     blurRadius: 4,
                      //     offset: Offset(0, 2),
                      //   ),
                      // ],
                      border: Border.all(color: Colors.grey.shade300)),
                  // margin: EdgeInsets.fromLTRB(18.0, 15.0, 18.0, 15.0),
                  child: Center(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 60,
                            width: 80,
                            // color: Colors.cyan,
                            child: product2[index]["banner"] != null
                                ? Image.network(
                              product2[index]["banner"].toString(),
                              errorBuilder: (BuildContext context,
                                  Object error, StackTrace? stackTrace) {
                                return Image.asset('asset/dummy.jpg');
                              },
                            )
                                : Image.asset('asset/dummy.jpg'),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        Text(
                          product2[index]["category_name"].toString(),
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    // Text(product[index]),
                  ),
                ),
              ),
            );
          }),
        ) : Center(child: CircularProgressIndicator()),
      ),
    );
  }
}