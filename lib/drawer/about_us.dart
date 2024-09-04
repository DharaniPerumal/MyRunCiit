
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:myrunciit/roots/roots.dart';
import 'package:myrunciit/widget/cart.dart';
import 'package:http/http.dart' as http;

class About_us extends StatefulWidget {
   About_us({super.key});

  @override
  State<About_us> createState() => _About_usState();
}

class _About_usState extends State<About_us> {

  int itemCount = 0;
  List product1 = [];

  void addToCart() {
    setState(() {
      itemCount++;
    });
  }

  getFAQ() async {
    String url1 = "$root_web/about_us";
    dynamic response = await http.get(Uri.parse(url1));
    if (response.statusCode == 200) {
      print('success');
      print(response.body);
      dynamic jsonResponse = jsonDecode(response.body);

      // Check if the response is valid and contains the expected data
      if (jsonResponse != null &&
          jsonResponse['Response'] != null &&
          jsonResponse['Response']["faqs"] != null) {
        setState(() {
          product1 = jsonResponse['Response']["faqs"];
          print("hello20");
          print(product1);
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
    getFAQ();
    super.initState();
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
          leading: IconButton(onPressed: (){Navigator.pop(context);},icon: Icon(Icons.keyboard_arrow_left,size: 35,color: Colors.white,),),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text("About Us",style: TextStyle(color: Colors.white,fontSize: 18.0,fontWeight: FontWeight.bold),)
            ],
          ),
          actions: [
            ShoppingCart()        ],
        ),
        body: ListView.builder(
          itemCount: product1.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Question:', style: TextStyle(fontSize: 18)),
                  Text(product1[index]['question'], style: TextStyle(fontSize: 18)),
                  Text('Ans:', style: TextStyle(fontSize: 18)),
                  Text(product1[index]['answer'], style: TextStyle(fontSize: 18)),
                ],
              ),
            );
          },
        ),


      ),
    );
  }
}
