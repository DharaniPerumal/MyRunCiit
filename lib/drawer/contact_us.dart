
import 'package:flutter/material.dart';
import 'package:myrunciit/bottom_navigationbar/categories.dart';
import 'package:myrunciit/bottom_navigationbar/sub_category_2/categories_2.dart';
import 'package:myrunciit/bottom_navigationbar/deals.dart';
import 'package:myrunciit/bottom_navigationbar/favourites.dart';
import 'package:myrunciit/main_screen/login_screen.dart';
import 'package:myrunciit/product_screen/product_main_screen.dart';
import 'package:myrunciit/widget/bottom_navigation_bar.dart';
import 'package:myrunciit/widget/cart.dart';
import 'package:myrunciit/widget/drawer.dart';
import 'package:myrunciit/widget/grid_view1.dart';
import 'package:myrunciit/widget/search.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({super.key});

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
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
          backgroundColor: Color(0xff014282),
          leading: IconButton(onPressed: (){Navigator.pop(context);},icon: Icon(Icons.keyboard_arrow_left,size: 35,color: Colors.white,),),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text("Account",style: TextStyle(fontSize: 18.0,color: Colors.white,fontWeight: FontWeight.bold)),
            ],
          ),
          actions: [
      ShoppingCart()        ],
        ),
        body:
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: Container(
            height: size.height*0.25,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5), // Color of the shadow
                  spreadRadius: 2, // Spread radius
                  blurRadius: 4, // Blur radius
                  offset: Offset(0, 2), // Offset of the shadow
                ),

              ],
            ),

            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child:  Column(
                children: [
                  Container(
                    height: size.height * 0.05,
                    color: Colors.white,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 4),
                          child: Container(
                            height: size.height * 0.08,
                            width: size.width * 0.05,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                image: DecorationImage(
                                    image:
                                    AssetImage('asset/ICONS2/abAKB1N.png'),
                                    alignment: Alignment.center)),
                            child: Text(""),
                          ),
                        ),
                        SizedBox(
                          width: size.width * 0.05,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "No 21, Ground Floor, Jalan Bangsar",
                              style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: size.height * 0.05,
                    color: Colors.white,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 4),
                          child: Container(
                            height: size.height * 0.08,
                            width: size.width * 0.05,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                image: DecorationImage(
                                    image:
                                    AssetImage('asset/ICONS2/a24dn2W.png'),
                                    alignment: Alignment.center)),
                            child: Text(""),
                          ),
                        ),
                        SizedBox(
                          width: size.width * 0.05,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "+60-0000000000",
                              style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: size.height * 0.05,
                    color: Colors.white,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 4),
                          child: Container(
                            height: size.height * 0.08,
                            width: size.width * 0.05,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                image: DecorationImage(
                                    image:
                                    AssetImage('asset/ICONS2/aQBsKLb.png'),
                                    alignment: Alignment.center)),
                            child: Text(""),
                          ),
                        ),
                        SizedBox(
                          width: size.width * 0.05,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "https://www.myrunciit.com",
                              style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: size.height * 0.05,
                    color: Colors.white,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 4),
                          child: Container(
                            height: size.height * 0.08,
                            width: size.width * 0.05,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                image: DecorationImage(
                                    image:
                                    AssetImage('asset/ICONS2/loginmail.png'),
                                    alignment: Alignment.center)),
                            child: Text(""),
                          ),
                        ),
                        SizedBox(
                          width: size.width * 0.05,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "support@myrunciit.com",
                              style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

            ),
          ) ,),


      ),
    );
  }
}
