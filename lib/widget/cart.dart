import 'package:flutter/material.dart';
import 'package:myrunciit/add_to_cart/add_to_cart.dart';
import 'package:myrunciit/add_to_cart/cart_available.dart';
import 'package:myrunciit/main.dart';
import 'package:myrunciit/product_screen/product_main_screen.dart';
import 'package:myrunciit/shopping_cart/cart_no_page.dart';
import 'package:myrunciit/widget/drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

var categoryname;
var categoryimage;
var categoryprice;
var categorystock;
var categorydesc;
var categorydiscount;
var added;
var cart1;

GlobalKey<_ShoppingCartState> shoppingCartKey = GlobalKey<_ShoppingCartState>();

class ShoppingCart extends StatefulWidget {
  final int itemCount;

  ShoppingCart({this.itemCount = 0});

  @override
  _ShoppingCartState createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  @override
  void initState() {
    getadded();
    super.initState();
  }

  Future<void> getadded() async {
    SharedPreferences prefsadded = await SharedPreferences.getInstance();
    setState(() {
      added = (prefsadded.getStringList('product_id') ?? "-") == "-"
          ? "false"
          : "true";
    });
    print("categoryadded$added");
  }

  @override
  Widget build(BuildContext context) {
    print(added);
    return Stack(
      children: [
        GestureDetector(
          onTap: () async {
             SharedPreferences prefsadded = await SharedPreferences.getInstance();
              setState(() {
                countAsInt =
                (prefsadded.getStringList('product_name') ?? "-") == "-"
                    ? 0
                    : prefsadded.getStringList('product_name')!.length;
              });
            if (countAsInt != 0) {
              print('if is working');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InCart(),
                ),
              );
            } else {
              print('else is working');
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => NoItemCart()));
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Image.asset(
              'asset/cartwhite.png',
              width: 30,
              height: 30,
            ),
          ),
        ),
        countAsInt > 0
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
                    // '${widget.itemCount}',
                    countAsInt.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            : Positioned(
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
                    '0',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
      ],
    );
  }
}
