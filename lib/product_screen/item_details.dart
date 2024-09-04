
import 'package:flutter/material.dart';
import 'package:myrunciit/bottom_navigationbar/categories.dart';
import 'package:myrunciit/bottom_navigationbar/deals.dart';
import 'package:myrunciit/bottom_navigationbar/favourites.dart';
import 'package:myrunciit/main_screen/login_screen.dart';
import 'package:myrunciit/product_screen/product_main_screen.dart';
import 'package:myrunciit/widget/bottom_navigation_bar.dart';
import 'package:myrunciit/widget/drawer.dart';
import 'package:myrunciit/widget/grid_view1.dart';
import 'package:myrunciit/widget/search.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  int itemCount = 0;

  void addToCart() {
    setState(() {
      itemCount++;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Color(0xff014282),
        leading: IconButton(onPressed: (){Navigator.pop(context);},icon: Icon(Icons.keyboard_arrow_left,size: 35,color: Colors.white,),),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("Item Details",style: TextStyle(color: Colors.white,fontSize: 18.0,fontWeight: FontWeight.bold),)
          ],
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  // Navigate to cart screen or show cart details
                },
              ),
              itemCount > 0
                  ? Positioned(
                right: 6,
                top: 6,
                child: Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    '$itemCount',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
                  : Container()
            ],
          ),
        ],
      ),
      // ElevatedButton(
      //   onPressed: addToCart,
      //   child: Text('Add to Cart'),
      // ),
      body:Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Container(
              height: size.height*0.4,
              width: size.width,
              color: Colors.white,
              decoration: BoxDecoration(image: DecorationImage(image: AssetImage('asset/bg.jpg'))),
            ),
          )
        ],
      )


    );
  }
}
