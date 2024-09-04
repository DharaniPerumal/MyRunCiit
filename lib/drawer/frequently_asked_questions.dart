import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myrunciit/roots/roots.dart';
import 'package:myrunciit/widget/cart.dart';
import 'package:http/http.dart' as http;

class Frequently_Asked_questions extends StatefulWidget {
  const Frequently_Asked_questions({super.key});

  @override
  State<Frequently_Asked_questions> createState() => _Frequently_Asked_questionsState();
}

class _Frequently_Asked_questionsState extends State<Frequently_Asked_questions> {

  int itemCount = 0;
  List product1 = [];
  bool showContent = false;
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
              Text("FAQ",style: TextStyle(color: Colors.white,fontSize: 18.0,fontWeight: FontWeight.bold),)
            ],
          ),
          actions: [
            ShoppingCart()        ],
        ),
        body: ListView.builder(
          itemCount: product1.length,
          itemBuilder: (context, index) {
            String html = product1[index]['answer'];

            String parsedstring3 = Bidi.stripHtmlIfNeeded(html);
            print('parsedstring3$parsedstring3');
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            showContent = !showContent;
                          });
                        },
                        icon: Icon(showContent ? Icons.remove : Icons.add),
                      ),
                      Text(
                        product1[index]['question'],
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  if (showContent)
                    Padding(
                      padding: const EdgeInsets.only(left: 40),
                      child: Text(parsedstring3, style: TextStyle(fontSize: 18)),
                    ),
                ],
              ),
            );
          },
        ),


      ),
    );
  }
}
