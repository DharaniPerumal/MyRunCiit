import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:myrunciit/add_to_cart/final_order.dart';
import 'package:myrunciit/bottom_navigationbar/deals.dart';
import 'package:myrunciit/main_screen/login_screen.dart';
import 'package:myrunciit/product_screen/product_main_screen.dart';
import 'package:myrunciit/widget/cart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../shopping_cart/cart_no_page.dart';

List<String> item_name = [];
List<String> item_qty = [];
List<String> item_img = [];
List<String> item_price = [];
List<String> item_discount = [];
List<String> item_cod = [];
List<String> item_tax = [];
List<String> item_product_id = [];
List<String> item_tax_type = [];

var item_q = 0;
var tot_price = "0.0";
var selectedValue = 1;
bool remove = false;

class InCart extends StatefulWidget {
  // final String categoryName, categoryImage, sale_price, current_stock, description, discount;
  // final cart;

  // InCart({
  //   required this.categoryName,
  //   required this.categoryImage,
  //   required this.sale_price,
  //   required this.current_stock,
  //   required this.description, required this.discount, required this.cart,
  // });

  @override
  State<InCart> createState() => _InCartState();
}

class _InCartState extends State<InCart> {
  int itemCount = item_name.length;
  int count = 1;
  var myValue;

  List<Map<String, dynamic>> cartItems = [];

  // List<Map<String, dynamic>> cartItems1 = cartItems + cartItems;

  show_cart_items() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      item_name = prefs.getStringList('product_name') ?? [];
      item_qty = prefs.getStringList('qty') ?? [];
      item_img = prefs.getStringList('product_image') ?? [];
      item_price = prefs.getStringList('product_price') ?? [];
      item_discount = prefs.getStringList('product_discount') ?? [];
      item_product_id = prefs.getStringList('product_id') ?? [];
      item_tax = prefs.getStringList('tax') ?? [];
      item_tax_type = prefs.getStringList('tax_type') ?? [];
      item_cod = prefs.getStringList('cod_status') ?? [];
      var item_quantity = prefs.setInt('quantity', item_q);
      item_qty_calc();
      if(item_name.length == 0)
        {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => NoItemCart()));
        }
    });
  }

  @override
  void initState() {
    // addToCart();
    getMyValue();

    item_q = 0;
    tot_price = "0.0";
    show_cart_items();
    senddata();
    super.initState();
    sendqty();
    // print('incart---$cart1');
  }

  Future<void> getMyValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      myValue = prefs.getString('first_name');
    });
    print('myvalue ===>>> $myValue');
  }

  senddata() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setStringList('order_name', item_name);
      prefs.setStringList('order_qty', item_qty);
      prefs.setStringList('order_img', item_img);
      prefs.setStringList('order_price', item_price);
      prefs.setStringList('order_discount', item_discount);
      print('item_name$item_name');
      print('item_qty$item_qty');
      print('item_img$item_img');
      print('item_price$item_price');
      print('item_discount$item_discount');
    });
  }

  // void addToCart() {
  //   setState(() {
  //     // Check if the item is already in the cart
  //     int existingIndex = cartItems.indexWhere((item) =>
  //     item['categoryName'] == widget.categoryName &&
  //         item['categoryImage'] == widget.categoryImage &&
  //         item['sale_price'] == widget.sale_price &&
  //         item['current_stock'] == widget.current_stock &&
  //         item['description'] == widget.description &&
  //         item['discount'] == widget.discount);
  //
  //     if (existingIndex != -1) {
  //       print("cartitems not added");
  //       cartItems[existingIndex]['count'] += 1;
  //     } else {
  //       print("cartitems  added");
  //
  //       cartItems.add({
  //
  //       'categoryName': widget.categoryName,
  //         'categoryImage': widget.categoryImage,
  //         'sale_price': widget.sale_price,
  //         'current_stock': widget.current_stock,
  //         'description': widget.description,
  //         'discount': widget.discount,
  //         'count': 1,
  //       });
  //       print(cartItems);
  //     }
  //
  //     itemCount = cartItems.length;
  //   });
  //   print('cartItems>>>>>$cartItems');
  // }

  incrementCount(index) async {
    // WidgetsBinding.instance.addPostFrameCallback((_){
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      item_qty[index] = (int.parse(item_qty[index].toString()) + 1).toString();
      // count++;
    });
    await prefs.setStringList('qty', item_qty);
    item_qty_calc();
    // });
  }

  decrementCount(index) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (int.parse(item_qty[index].toString()) > 1) {
      setState(() {
        item_qty[index] =
            (int.parse(item_qty[index].toString()) - 1).toString();
        // count++;
      });
      await prefs.setStringList('qty', item_qty);
      item_qty_calc();
    }

    // if (count > 0) {
    //   setState(() {
    //     count--;
    //   });
    // }
  }

  item_qty_calc() {
    setState(() {
      item_q = 0;
      tot_price = "0.0";
    });
    for (var k = 0; k < item_qty.length; k++) {
      setState(() {
        item_q += int.parse(item_qty[k].toString());
        tot_price = ((double.tryParse(item_price[k].toString())! *
                    int.parse(item_qty[k].toString())) +
                double.tryParse(tot_price.toString())!)
            .toString();
      });
    }
  }

  remove_item(index) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      item_qty.removeAt(index);
      item_name.removeAt(index);
      item_img.removeAt(index);
      item_price.removeAt(index);
      item_discount.removeAt(index);
      item_tax_type.removeAt(index);
      item_tax.removeAt(index);
      item_product_id.removeAt(index);
      item_cod.removeAt(index);

      print('countAsInt$countAsInt');

      countAsInt = item_name.length;
      print('countAsInt$countAsInt');
    });
    await prefs.setStringList('qty', item_qty);
    await prefs.setStringList('product_name', item_name);
    await prefs.setStringList('product_image', item_img);
    await prefs.setStringList('product_price', item_price);
    await prefs.setStringList('product_discount', item_discount);
    await prefs.setStringList('cod_status', item_cod);
    await prefs.setStringList('tax', item_tax);
    await prefs.setStringList('tax_type', item_tax_type);
    await prefs.setStringList('product_id', item_product_id);

    item_qty_calc();
  }

  sendqty() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('item_quantity', item_q);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        // Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  Deals(selectedTabIndex: 0)),

        );
        return Future.value(true);
      },

      child: Scaffold(
        backgroundColor: Color(0xfff6f6f6),
        appBar: AppBar(
          backgroundColor: Color(0xff014282),
          leading: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Deals(selectedTabIndex: 0)),
              );
            },
            icon: const Icon(
              Icons.keyboard_arrow_left,
              size: 35,
              color: Colors.white,
            ),
          ),
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                "Shopping Cart",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
          actions: [
            ShoppingCart(
              itemCount: countAsInt,
            ),
          ],
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: size.height * 0.05,
                  width: size.width,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: AutoSizeText(
                          "Cart",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AutoSizeText(
                          "Quantity (${item_q}) ",
                          style: TextStyle(fontSize: 13.0, color: Colors.black),
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: AutoSizeText(
                              "RM",
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Color(0xffc26928),
                              ),
                            ),
                          ),
                          // if (int.tryParse(item_price['discount']) != null &&
                          //     int.parse(item['discount']) > 0)
                          Text(
                            "${tot_price.toString()}",
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.red),
                          )
                          //   else
                          //   Text(
                          //     (count* double.parse(item['sale_price'])).toStringAsFixed(2),
                          //     style: TextStyle(fontSize: 13,
                          //         fontWeight: FontWeight.bold,
                          //         color: Colors.red),
                          //   )
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 2.0,
                ),
                ListView.builder(
                  itemCount: item_name.length,
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Container(
                            height: size.height * 0.15,
                            width: size.width,
                            color: Colors.white,
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                      height: size.height * 0.25,
                                      width: size.width * 0.2,
                                      child: Image.network(item_img[index])),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                            color: Colors.white,
                                            width: size.width * 0.4,
                                            child: AutoSizeText(
                                              item_name[index],
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 10.0,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                        // child: Text(item['categoryName'])),
                                        const Row(
                                          children: [
                                            Text(
                                              "RM",
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xffc26928),
                                              ),
                                            ),
                                          ],
                                        ),
                                        //     if (int.tryParse(item['discount']) != null &&
                                        //         int.parse(item['discount']) > 0)
                                        Text.rich(
                                          TextSpan(
                                            children: <TextSpan>[
                                              new TextSpan(
                                                text: item_price[index],
                                                style: new TextStyle(
                                                  color: Colors.black,
                                                  // decoration: TextDecoration.lineThrough,
                                                ),
                                              ),
                                              // new TextSpan(
                                              //   text: (double.parse(item['sale_price']) -
                                              //       (double.parse(item['sale_price']) *
                                              //           (double.parse(item['discount']) * 0.01))
                                              //   ).toStringAsFixed(2),
                                              // ),
                                            ],
                                          ),
                                        ),
                                        //     else
                                        //       Text.rich(TextSpan(
                                        //         children: <TextSpan>[
                                        //           new TextSpan(
                                        //             text: item['sale_price'],
                                        //             style: new TextStyle(
                                        //               color: Colors.black,
                                        //             ),
                                        //           ),
                                        //         ],
                                        //       ),
                                        //       )
                                        //   ],
                                        // ),
                                        int.parse(item_qty[index].toString()) <= 1
                                            ? Row(
                                                children: [
                                                  Text(
                                                      item_qty[index].toString()),
                                                  IconButton(
                                                    icon: const Icon(
                                                      Icons.add_circle_outlined,
                                                      color: Colors.green,
                                                    ),
                                                    onPressed: () {
                                                      incrementCount(index);
                                                    },
                                                  ),
                                                ],
                                              )
                                            : Row(
                                                children: [
                                                  IconButton(
                                                    icon: const Icon(
                                                      Icons.remove_circle_rounded,
                                                      color: Colors.green,
                                                    ),
                                                    onPressed: () {
                                                      decrementCount(index);
                                                    },
                                                  ),
                                                  Text(
                                                      item_qty[index].toString()),
                                                  IconButton(
                                                    icon: const Icon(
                                                      Icons.add_circle_outlined,
                                                      color: Colors.green,
                                                    ),
                                                    onPressed: () {
                                                      incrementCount(index);
                                                    },
                                                  ),
                                                ],
                                              ),
                                      ],
                                    ),
                                  ),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      onPressed: () async {
                                        if (item_q != null) {
                                          remove == true;
                                          await remove_item(index);

                                          if (item_q == 0) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProductScreen()),
                                            );
                                          }
                                        }
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.only(
                                            top: 45.0, left: 17.0),
                                        child: Center(
                                          child: Text(
                                            'Remove',
                                            style: TextStyle(
                                                color: Color(0xffaa1e20),
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Row(
          children: [
            Container(
              color: Color(0xffc40001),
              height: 60,
              width: size.width * 0.5,
              child: InkWell(
                onTap: () {
                  if (item_q == 0) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProductScreen()),
                    );
                  } else if (myValue == null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              FinalizationOrder()),//price: tot_price
                    ).then((value) {
                      show_cart_items();
                    });
                  }

                  //   if (myValue != null) {
                  //   }  else {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(builder: (context) => FinalizationOrder( price: tot_price)),
                  //     );
                  //
                  //   }
                  // } else {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(builder: (context) => LoginScreen()),
                  //   );
                  //
                  // }

                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => FinalizationOrder( price: tot_price)),
                  // );

                  // Handle checkout action here
                },
                child: Center(
                  child: Text(
                    "Checkout",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              // decoration: BoxDecoration(color: Color(0xff014282),border: Border.all(color: Colors.grey.shade400)),
              color: Color(0xff014282),
              height: 60,
              width: size.width * 0.5,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProductScreen()),
                  );

                  // Handle checkout action here
                },
                child: Center(
                  child: Text(
                    "Continue Shopping",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        // bottomNavigationBar: Container(
        //   color: Color(0xffc40001),
        //   height: 60, // Set the desired height
        //   width: size.width,
        //   child: InkWell(
        //     onTap: () {
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(builder: (context) =>
        //             FinalizationOrder(categoryName: widget.categoryName,
        //               categoryImage: widget.categoryImage,
        //               sale_price: widget.sale_price,
        //               current_stock: widget.current_stock,
        //               description: widget.description,
        //               discount: widget.discount,
        //             )),
        //       );
        //
        //       // Handle checkout action here
        //     },
        //     child: Center(
        //       child: Text(
        //         "Checkout",
        //         style: TextStyle(
        //           fontSize: 17,
        //           fontWeight: FontWeight.bold,
        //           color: Colors.white,
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
      ),
    );
  }
}
