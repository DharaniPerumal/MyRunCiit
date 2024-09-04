
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

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({super.key});

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
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
            leading: IconButton(onPressed: (){Navigator.pop(context);},icon: Icon(Icons.keyboard_arrow_left,size: 35,),),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text("Privacy Policy")
              ],
            ),
            actions: [
              ShoppingCart()        ],
          ),
          body:
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Privacy Policy',style: TextStyle(fontSize: 18),),
          )


      ),
    );
  }
}
