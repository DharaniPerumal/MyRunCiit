import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myrunciit/roots/roots.dart';
import 'package:myrunciit/widget/searched_products.dart';

class CustomSearchBar extends StatefulWidget {
  @override
  _CustomSearchBarState createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  TextEditingController _searchController = TextEditingController();
  List product1 = [];
  var search;

  @override
  void initState() {
    _searchController.addListener(_onSearchChanged);

    super.initState();
  }

  getProduct1() async {
    String url1 = "$root_web/product_search/$search";
    dynamic response = await http.get(Uri.parse(url1));
    if (response.statusCode == 200) {
      print('success');
      print(response.body);
      dynamic jsonResponse = jsonDecode(response.body);

      if (jsonResponse != null &&
          jsonResponse['Response'] != null &&
          jsonResponse['Response']["product"] != null) {
        setState(() {
          product1 = jsonResponse['Response']["product"];
          print("hello205");
          print(product1);
        });
      } else {
        print("Invalid response format or missing data");
      }
    } else {
      print("failure");
    }
  }

  void _onSearchChanged() {
    setState(() {
      search = _searchController.text;
      getProduct1();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        // Container(
        //   width: size.width,
        //   decoration: BoxDecoration(
        //     color: Colors.white,
        //     borderRadius: BorderRadius.all(
        //       Radius.circular(10),
        //     ),
        //   ),
        //   child: Column(
        //     children: [
        //       Container(
        //         height: size.height * 0.035,
        //         width: size.width,
        //         decoration: BoxDecoration(
        //           color: Colors.transparent,
        //           borderRadius: BorderRadius.all(
        //             Radius.circular(10),
        //           ),
        //         ),
        //         child: TextField(
        //           controller: _searchController,
        //           style: TextStyle(color: Colors.black, fontSize: 20),
        //           autofocus: false,
        //           onChanged: (value) {
        //             setState(() {
        //               // Do something with the search value
        //             });
        //           },
        //           decoration: InputDecoration(
        //             hintText: "Search products, Brand and more",
        //             hintStyle: TextStyle(fontSize: 15),
        //             labelStyle: TextStyle(color: Colors.black, fontSize: 15),
        //             border: OutlineInputBorder(
        //               borderSide: BorderSide(color: Colors.white),
        //             ),
        //             contentPadding:
        //                 EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        Container(
          height: 30,
          width: size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _searchController,
                  style: TextStyle(color: Colors.black, fontSize: 20),

                  autofocus: false,
                  onChanged: (value) {
                    setState(() {
                      // Do something with the search value
                    });
                  },

                  decoration: InputDecoration(

                    focusColor: Colors.grey.shade300,
                    hintText: "Search products, Brand and more",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent), // Set border color to transparent
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent), // Set border color to transparent
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent), // Set border color to transparent
                    ),

                    // focusedBorder: UnderlineInputBorder(
                    //   borderSide: BorderSide(color: Colors.grey.shade300),
                    // ),
                    // enabledBorder: UnderlineInputBorder(
                    //   borderSide: BorderSide(color: Colors.grey.shade300),
                    // ),

                    hintStyle: TextStyle(fontSize: 15,),
                    labelStyle: TextStyle(color: Colors.black, fontSize: 15),
                    // border: OutlineInputBorder(
                    //   borderSide: BorderSide(color: Colors.white),
                    // ),

                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                  ),
                ),
              ),
              Container(
                width: size.width * 0.09,
                height: size.height * 0.04,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(5),
                    bottomRight: Radius.circular(5),
                  ),
                ),
                child: GestureDetector(
                  onTap: (){
                  if (product1.isNotEmpty) {
                  Navigator.push(
                  context,
                  MaterialPageRoute(
                  builder: (context) =>
                  SearchedProducts(product: product1),
                  ),
                  );
                  _searchController.clear();
                  }
                  },
                  child: Icon(
                      Icons.search,
                      color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
