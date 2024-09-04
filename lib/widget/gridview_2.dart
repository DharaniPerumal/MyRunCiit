import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:myrunciit/main_screen/sub_categories/sub_category_1.dart';
import 'package:myrunciit/roots/roots.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HorizontalListView extends StatefulWidget {
  const HorizontalListView({Key? key}) : super(key: key);

  @override
  _HorizontalListViewState createState() => _HorizontalListViewState();
}

class _HorizontalListViewState extends State<HorizontalListView> {
  List product = [];
  var store_id;

  getProduct() async {
    String url1 = store_id != null
        ? "$root_web/all_category/${store_id}"
        : "$root_web/all_category/2";

    dynamic response = await http.get(Uri.parse(url1));
    if (response.statusCode == 200) {
      print('success');
      print(response.body);
      dynamic jsonResponse = jsonDecode(response.body);

      if (jsonResponse != null &&
          jsonResponse['Response'] != null &&
          jsonResponse['Response']['category'] != null) {
        setState(() {
          product = jsonResponse['Response']['category'];
        });
      } else {
        print("Invalid response format or missing data");
      }
    } else {
      print("failure");
    }
  }

  @override
  void initState() {
    getstoreid();
    getdefaul_storeid();

    getProduct();
    super.initState();
  }
  var store_data = 0;

  getdefaul_storeid() async {
    String url1 = "$root_web/defaul_store";
    dynamic response = await http.get(Uri.parse(url1));
    var jsonResponse = jsonDecode(response.body);
    var status = jsonResponse["status"];
    if (status == "SUCCESS") {
      var default_store = jsonResponse["Response"]["default_store"];
      print('default_store${default_store}');
      setState(() {
        store_data = int.parse(default_store[0]["store_id"].toString());
      });
      getProduct();
      print('store_id ====>>>> ${store_data}');
    } else {
      print("failure");
    }
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

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: product.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              if (product[index]['sub_category'] != null &&
                  product[index]['sub_category'].isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Subcategory(
                      subcategories: product[index]['sub_category'],
                      store_data: store_data,
                    ),
                  ),
                );
              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Text("No Sub Category Products"),
                      actions: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.lightGreen),
                          child: Center(child: Text("OK")),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              }
            },
            behavior: HitTestBehavior.translucent,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(5, 4, 5, 12),
              child: Container(
                color: Colors.white60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Image(image: AssetImage(product[index]["category_banner"].toString())),
                        Container(
                          height: size.height * 0.05,
                          width: size.width * 0.15,
                          child: product[index]["banner"] != null
                              ? Image.network(
                                  product[index]["banner"].toString(),
                                  errorBuilder: (BuildContext context,
                                      Object error, StackTrace? stackTrace) {
                                    return Image.asset('asset/dummy.jpg');
                                  },
                                )
                              : Image.asset('asset/dummy.jpg'),
                        ),

                        SizedBox(
                          width: size.width * 0.03,
                        ),
                        Text(
                          product[index]["category_name"].toString(),
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                    Icon(Icons.chevron_right)
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
