import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:myrunciit/product_screen/product_main_screen.dart';
import 'package:myrunciit/widget/cart.dart';

class NoItemCart extends StatefulWidget {
  const NoItemCart({super.key});

  @override
  State<NoItemCart> createState() => _NoItemCartState();
}

class _NoItemCartState extends State<NoItemCart> {
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
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => ProductScreen()));
          return false;
        },
        child: Scaffold(
      
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => ProductScreen()));
            },
            icon: const Icon(
                Icons.keyboard_arrow_left,
                size: 35,
                color: Colors.white,
              ),
      
          ),
          backgroundColor: Color(0xff014282),
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text("Shopping Cart",style: TextStyle(color: Colors.white,fontSize: 18.0,fontWeight: FontWeight.bold),)
            ],
          ),
          actions: [
            ShoppingCart(itemCount: itemCount,)        ],
        ),
        //
        body:Center(
          child: Column(
            children: [
              Container(
                height: size.height*0.2,
                width: size.width*0.35,
                decoration: BoxDecoration(image: DecorationImage(image: AssetImage('asset/Cart.png'))),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(child: AutoSizeText("you have not added any product to your cart \n as yet",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),)),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProductScreen()),
                    );
                    },
      
                  child: Container(
                    height: size.height*0.05,
                    width: size.width*0.6,
                    color: Colors.deepOrange,
                    child: Center(child: Text("START SHOPPING", style: TextStyle(color: Colors.white,),textAlign: TextAlign.center,)),
                  ),
      
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
