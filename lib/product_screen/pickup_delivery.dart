import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:myrunciit/add_to_cart/add_to_cart.dart';
import 'package:myrunciit/add_to_cart/delivery.dart';
import 'package:myrunciit/add_to_cart/pickup.dart';
import 'package:myrunciit/product_screen/product_main_screen.dart';
import 'package:myrunciit/roots/roots.dart';
import 'package:myrunciit/widget/cart.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

var store_id;

class pickup_delivery extends StatefulWidget {
  final String categoryName, categoryImage, sale_price, subcat, current_stock, description, discount,multi_price,options,brand_name, cod_status, tax, tax_type;
  List product_images=[];
  pickup_delivery({
    required this.categoryName,
    required this.categoryImage,
    required this.sale_price,
    required this.current_stock,
    required this.multi_price,
    required this.product_images,
    required this.subcat,
    required this.description, required this.discount, required this.options, required this.brand_name, required this.cod_status, required this.tax, required this.tax_type,
  });

  @override
  State<pickup_delivery> createState() => _pickup_deliveryState();
}

class _pickup_deliveryState extends State<pickup_delivery> {
  StreamController<List> _dealsStreamController = StreamController<List>();

  List todaydeals = [];

  getstoreid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      store_id = prefs.getString('storeid');
    });
    print('gridview3store_id===>>> $store_id');
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
    String url1 = "$root_web/getLatestProducts/${store_id}";
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
          // Access the array of categories from the response
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
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);        return Future.value(true);
      },

      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff014282),
          leading: IconButton(onPressed: (){
            Navigator.pop(context);
            },icon: Icon(Icons.keyboard_arrow_left,size: 35,color: Colors.white,),),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text("Item Details",style: TextStyle(color: Colors.white,fontSize: 18.0,fontWeight: FontWeight.bold),)
            ],
          ),
          actions: [ShoppingCart()],
        ),
        body: StreamBuilder<List>(
          stream: _dealsStreamController.stream,
          builder: (context, snapshot) {
            if ((snapshot.hasData)) {
              List todaydeals = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: size.height,
                  color: Colors.white,

                  child: Container(
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,

                      children: [
                        IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.close_rounded,color: Colors.red,)),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: (){
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Pickup(
                                          subcategory: widget.subcat,
                                          multi_price: widget.multi_price,
                                          product_images: widget.product_images,
                                          categoryName: widget.categoryName,
                                          categoryImage: widget.categoryImage,
                                          sale_price: widget.sale_price,
                                          current_stock: widget.current_stock,
                                          description: widget.description,
                                          discount: widget.discount,
                                          options: widget.options,
                                          brand_name: widget.options, cod_status: widget.cod_status, tax: widget.tax, tax_type: widget.tax_type,
                                        )));
                              },
                              child: Container(
                                // height: size.height*0.2,
                                color: Colors.white,
                                child: Column(
                                  children: [
                                    Container(
                                      height: size.height*0.11,
                                      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade400),borderRadius: BorderRadius.only(topRight: Radius.circular(5),topLeft: Radius.circular(5))),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          height: size.height*0.13,
                                          width: size.width*0.4,
                                          color: Colors.white,
                                          child: Image.network('https://myrunciit.my/template/front/img/pickup.png'),

                                        ),
                                      ),
                                    ),
                                    Container(
                                        height: size.height*0.04,
                                        width: size.width*0.45,
                                        decoration: BoxDecoration(                              color: Colors.grey.shade300,
                                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5))),
                                        child: Center(child: Text("Pickup",style: TextStyle(fontSize: 15),)))
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 15,),
                            InkWell(
                              onTap: (){
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => AddToCart(
                                //           categoryName: widget.categoryName,
                                //           categoryImage: widget.categoryImage,
                                //           sale_price: widget.sale_price,
                                //           current_stock: widget.current_stock,
                                //           description: widget.description,
                                //           weight: widget.weight,)));
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Delivery(
                                          subcategory: widget.subcat,
                                          multi_price: widget.multi_price,
                                          product_images: widget.product_images,
                                            categoryName: widget.categoryName,
                                            categoryImage: widget.categoryImage,
                                            sale_price: widget.sale_price,
                                            current_stock: widget.current_stock,
                                            description: widget.description,
                                            discount: widget.discount,
                                            options: widget.options,
                                          brand_name: widget.options, cod_status: widget.cod_status, tax: widget.tax, tax_type: widget.tax_type,
                                        )));
                              },
                              child: Container(
                                // height: size.height*0.2,
                                color: Colors.white,
                                child: Column(
                                  children: [
                                    Container(
                                      height: size.height*0.11,
                                      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade400),borderRadius: BorderRadius.only(topRight: Radius.circular(5),topLeft: Radius.circular(5))),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          height: size.height*0.15,
                                          width: size.width*0.4,
                                          color: Colors.white,
                                          child: Image.network('https://myrunciit.my/template/front/img/delivery.png'),

                                        ),
                                      ),
                                    ),
                                    Container(
                                        height: size.height*0.04,
                                        width: size.width*0.45,
                                        decoration: BoxDecoration(                              color: Colors.grey.shade300,
                                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5))),
                                        child: Center(child: Text("Deivery",style: TextStyle(fontSize: 15),)))
                                  ],
                                ),
                              ),
                            ),


                            // ElevatedButton(onPressed: () {
                            //   // Navigator.push(
                            //   //     context,
                            //   //     MaterialPageRoute(
                            //   //         builder: (context) => Delivery()));
                            //
                            // }, child: Text("Pickup")),
                            // ElevatedButton(
                            //     onPressed: () {
                            //       // Navigator.push(
                            //       //     context,
                            //       //     MaterialPageRoute(
                            //       //         builder: (context) => AddToCart(
                            //       //           categoryName: widget.categoryName,
                            //       //           categoryImage: widget.categoryImage,
                            //       //           sale_price: widget.sale_price,
                            //       //           current_stock: widget.current_stock,
                            //       //           description: widget.description,
                            //       //           weight: widget.weight,)));
                            //         Navigator.push(
                            //             context,
                            //             MaterialPageRoute(
                            //                 builder: (context) => Delivery(
                            //                             categoryName: widget.categoryName,
                            //                             categoryImage: widget.categoryImage,
                            //                             sale_price: widget.sale_price,
                            //                             current_stock: widget.current_stock,
                            //                             description: widget.description,
                            //
                            //                 )));
                            //
                            //     },
                            //     child: Text("Delivery"))
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}

