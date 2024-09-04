import 'package:flutter/material.dart';
import 'package:myrunciit/bottom_navigationbar/account.dart';
import 'package:myrunciit/bottom_navigationbar/categories.dart';
import 'package:myrunciit/bottom_navigationbar/sub_category_2/categories_2.dart';
import 'package:myrunciit/bottom_navigationbar/deals.dart';
import 'package:myrunciit/bottom_navigationbar/favourites.dart';
import 'package:myrunciit/main_screen/sub_categories/products.dart';
import 'package:myrunciit/product_screen/product_main_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myrunciit/widget/cart.dart';

class Poultry_grid extends StatefulWidget {
  final List poultry;

  const Poultry_grid({Key? key, required this.poultry}) : super(key: key);

  @override
  State<Poultry_grid> createState() => _Poultry_gridState();
}

class _Poultry_gridState extends State<Poultry_grid> {
  int itemCount = 0;

  @override
  void initState() {
    // getProduct1();
    super.initState();
  }

  void addToCart() {
    setState(() {
      itemCount++;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Product()));
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Container(
                  color: Colors.white,
                  height: size.height * 0.42,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: GridView.count(
                      scrollDirection: Axis.horizontal,
                      crossAxisCount:
                          2, // Adjust the number of columns as needed
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                      children: List.generate(widget.poultry.length, (index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Product()),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                // boxShadow: [
                                //   BoxShadow(
                                //     color: Colors.black.withOpacity(0.1),
                                //     spreadRadius: 2,
                                //     blurRadius: 4,
                                //     offset: Offset(2, 2),
                                //   ),
                                // ],
                                border:
                                    Border.all(color: Colors.grey.shade100)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 80,
                                    width: 100,
                                    child: widget.poultry[index]['banner'] !=
                                            null
                                        ? Image.network(
                                            widget.poultry[index]['banner']
                                                .toString(),
                                            errorBuilder: (BuildContext context,
                                                Object error,
                                                StackTrace? stackTrace) {
                                              return Image.asset(
                                                  'asset/dummy.jpg');
                                            },
                                            fit: BoxFit.cover,
                                            height: 50,
                                            width: 50,
                                          )
                                        : Image.asset('asset/dummy.jpg'),
                                  ),
                                ),
                                Text(
                                  widget.poultry[index]['sub_category_name']
                                      .toString(),
                                  style: TextStyle(fontSize: 10),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
