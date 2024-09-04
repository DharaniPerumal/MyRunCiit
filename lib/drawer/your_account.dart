import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myrunciit/bottom_navigationbar/account.dart';
import 'package:myrunciit/bottom_navigationbar/sub_category_2/categories_2.dart';
import 'package:myrunciit/bottom_navigationbar/deals.dart';
import 'package:myrunciit/bottom_navigationbar/favourites.dart';
import 'package:myrunciit/drawer/Address/address_list.dart';
import 'package:myrunciit/drawer/Info/my_info.dart';
import 'package:myrunciit/drawer/about_us.dart';
import 'package:myrunciit/drawer/compare.dart';
import 'package:myrunciit/drawer/contact_us.dart';
import 'package:myrunciit/drawer/my_orders.dart';
import 'package:myrunciit/drawer/privacy_policy.dart';
import 'package:myrunciit/drawer/rewards_log.dart';
import 'package:myrunciit/drawer/terms_and_condition.dart';
import 'package:myrunciit/drawer/transaction.dart';
import 'package:myrunciit/drawer/wallet_money.dart';
import 'package:myrunciit/drawer/wishlist.dart';
import 'package:myrunciit/main_screen/login_screen.dart';
import 'package:myrunciit/product_screen/product_main_screen.dart';
import 'package:myrunciit/roots/roots.dart';
import 'package:myrunciit/widget/cart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import 'frequently_asked_questions.dart';
import 'package:http/http.dart' as http;

var name;
var emailID;
var isd = false;
var phonenumber, user_id, wishlist_count1, user_wallet1;

class YourAccount extends StatefulWidget {
  const YourAccount({super.key});

  @override
  State<YourAccount> createState() => _YourAccountState();
}

class _YourAccountState extends State<YourAccount> {
  int itemCount = 0;
  var myValue;

  void addToCart() {
    setState(() {
      itemCount++;
    });
  }

  Future<void> get_user_id() async {
    SharedPreferences prefs1 = await SharedPreferences.getInstance();
    setState(() {
      user_id = prefs1.getString('user_id') ?? "";
      if(user_id != "")
        {
          isd = true;
        }
    });
    print('wishlish_count_userid===>>> $user_id');
  }

  void wishlist_count() async {
    SharedPreferences prefs1 = await SharedPreferences.getInstance();
    setState(() {
      user_id = prefs1.getString('user_id');
    });
    String url1 = "$root_web/wishlist/count/0/${user_id}";
    print('wishlist_dgdfcount ----> $url1');
    dynamic response = await http.get(Uri.parse(url1));
    if (response.statusCode == 200) {
      print('wishlist_count');
      print(response.body);
      dynamic jsonResponse = jsonDecode(response.body);
      setState(() {
        wishlist_count1 = jsonResponse['Response']['WishlistCount'];
      });

      if (jsonResponse != null && jsonResponse['Response']['WishlistCount'] != null) {
        print('wishlist_count ----> ${jsonResponse['Response']['WishlistCount']}');
      } else {
        print("Invalid response format or missing data");
      }
    } else {
      print("failure");
    }
  }

  @override
  void initState() {
    // setState(() {
      get_user_id();
      wishlist_count();
    // });
    login_details();
    getmyvalue();
    super.initState();
  }

  getmyvalue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      myValue = prefs.getString('first_name');
    });
    print('myvalue ===>>> $myValue');
  }
  Future<void> login_details() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('first_name');
      emailID = prefs.getString('email_id');
      phonenumber = prefs.getString('phone');
      user_wallet1 = prefs.getString('wallet');
    });
  }

  @override
  Widget build(BuildContext context) {
    print('emailID1 ===>>> $emailID');

    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProductScreen()),
        );
        return Future.value(true);
      },

      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff014282),
          leading: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProductScreen()),
              );
            },
            icon: Icon(
              Icons.keyboard_arrow_left,
              size: 35,
              color: Colors.white,
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "Your Account",
                style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold),
              )
            ],
          ),
          actions: [ShoppingCart()],
        ),
        body: Padding(
          padding: const EdgeInsets.all(18.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color:
                            Colors.black.withOpacity(0.3), // Color of the shadow
                        spreadRadius: 2, // Spread radius
                        blurRadius: 4, // Blur radius
                        offset: Offset(0, 2), // Offset of the shadow
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 4),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            ClipOval(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: size.height * 0.08,
                                  width: size.width * 0.2,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                      image: DecorationImage(
                                          image: AssetImage('asset/name.png'),
                                          alignment: Alignment.center),
                                      border: Border.all(
                                          color: Colors.black, width: 2)),
                                  child: Text(""),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: size.width * 0.08,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                isd == true
                                    ? Text(
                                        name,
                                        style: TextStyle(fontSize: 18),
                                      )
                                    : (status == 'SUCCESS')
                                        ? Text(
                                            first_name1,
                                            style: TextStyle(fontSize: 18),
                                          )
                                        : Container(),
                                SizedBox(
                                  height: 5,
                                ),
                                isd == true
                                    ? Text(
                                        emailID,
                                        style: TextStyle(fontSize: 18),
                                      )
                                    : (status == 'SUCCESS')
                                        ? Text(
                                            useremail,
                                            style: TextStyle(fontSize: 18),
                                          )
                                        : Container(),
                                SizedBox(
                                  height: 5,
                                ),
                                isd == true
                                    ? Text(
                                        phonenumber,
                                        style: TextStyle(fontSize: 18),
                                      )
                                    : (status == 'SUCCESS')
                                        ? Text(
                                            usermobilenumber,
                                            style: TextStyle(fontSize: 18),
                                          )
                                        : Container(),
                              ],
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Wallet Balance : ${user_wallet1}",
                                style: TextStyle(fontSize: 20),
                              ),
                              IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => WalletMoney()),
                                    );
                                  },
                                  icon: Icon(Icons.add_circle_outlined))
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color:
                            Colors.black.withOpacity(0.3), // Color of the shadow
                        spreadRadius: 2, // Spread radius
                        blurRadius: 4, // Blur radius
                        offset: Offset(0, 2), // Offset of the shadow
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MyInfo()),
                            );
                          },
                          child: Container(
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
                                            image: AssetImage(
                                                'asset/ICONS2/aQBsKLb.png'),
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
                                      "My Info",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddressList()),
                            );

                            print('Login / Register tapped!');
                          },
                          child: Container(
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
                                            image: AssetImage(
                                                'asset/ICONS2/add.png'),
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
                                      "Address",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Favourites()),
                            );

                            print('Login / Register tapped!');
                          },
                          child: Container(
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
                                                AssetImage('asset/cartclr.png'),
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
                                      "My Cart",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MyOrders()),
                            );

                            print('Login / Register tapped!');
                          },
                          child: Container(
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
                                            image: AssetImage(
                                                'asset/ICONS2/mna6.png'),
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
                                      "My Orders",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => wishList()),
                            );
                          },
                          child: Container(
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
                                        color: Colors.white,),
                                    child: Icon(Icons.favorite_border,color: Colors.green,),
                                  ),
                                ),
                                SizedBox(
                                  width: size.width * 0.05,
                                ),
                                Text(
                                  "WishList",
                                  style: TextStyle(fontSize: 15),
                                ),
                                SizedBox(width : MediaQuery.of(context).size.width * 0.4,),
                                Container(
                                  padding: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  constraints: BoxConstraints(
                                    minWidth: 25,
                                    minHeight: 25,
                                  ),
                                  child: Text(
                                    '${wishlist_count1}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Compare()),
                            );
                          },
                          child: Container(
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
                                        color: Colors.white,),
                                    child: Icon(Icons
                                    .compare_arrows,color: Colors.green,),
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
                                      "Compare",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RewardsLog()),
                            );

                            print('Login / Register tapped!');
                          },
                          child: Container(
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
                                            image: AssetImage(
                                                'asset/ICONS2/mna6.png'),
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
                                      "Rewards Log",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyTransaction()),
                            );
                          },
                          child: Container(
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
                                            image: AssetImage(
                                                'asset/ICONS2/mna6.png'),
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
                                      "My Transaction",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ContactUs()),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withOpacity(0.3), // Color of the shadow
                          spreadRadius: 2, // Spread radius
                          blurRadius: 4, // Blur radius
                          offset: Offset(0, 2), // Offset of the shadow
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                                            image: AssetImage(
                                                'asset/ICONS2/a24dn2W.png'),
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
                                      "Contact Us",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color:
                            Colors.black.withOpacity(0.3), // Color of the shadow
                        spreadRadius: 2, // Spread radius
                        blurRadius: 4, // Blur radius
                        offset: Offset(0, 2), // Offset of the shadow
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Frequently_Asked_questions()),
                            );
                          },
                          child: Container(
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
                                            image: AssetImage(
                                                'asset/ICONS2/abAKB1N.png'),
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
                                      "FAQ",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => About_us()),
                            );
                          },
                          child: Container(
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
                                            image: AssetImage(
                                                'asset/ICONS2/abAKB1N.png'),
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
                                      "About Us",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TermsAndCondition()),
                            );
                          },
                          child: Container(
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
                                            image: AssetImage(
                                                'asset/ICONS2/abAKB1N.png'),
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
                                      "Terms of Service",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PrivacyPolicy()),
                            );
                          },
                          child: Container(
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
                                            image: AssetImage(
                                                'asset/ICONS2/aoIWeuo.png'),
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
                                      "Privacy Policy",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Are you sure want to Logout?',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15.0),),
                                actions: <Widget>[
                                  Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).pop(false);
                                          },
                                          child: Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.1,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.2,
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              // color: Color(0xFF64DD17),
                                              color: Colors.lightGreen,

                                              border:
                                                  Border.all(color: Colors.white),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Center(
                                                child: Text(
                                              'No',
                                              style:
                                                  TextStyle(color: Colors.white),
                                            )),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 2,
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            SharedPreferences preferences =
                                                await SharedPreferences
                                                    .getInstance();
                                            await preferences.clear();
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      LoginScreen()),
                                            ); // This will close the app
                                          },
                                          child: Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.1,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.2,
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              // color: Color(0xFF64DD17),
                                              color: Colors.lightGreen,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Center(
                                              child: Text(
                                                'Yes',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ).then((value) => value ?? false);
                          },
                          child: Container(
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
                                            image: AssetImage(
                                                'asset/ICONS2/awazaYm.png'),
                                            alignment: Alignment.center)),
                                    child: Text(""),
                                  ),
                                ),
                                SizedBox(width: size.width * 0.05),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Logout",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),

        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.grid_view),
              label: 'Categories',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favourites',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.sell),
              label: 'Deals',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_2_rounded),
              label: 'Account',
            ),
          ],
          currentIndex: 4,
          selectedItemColor: Colors.green.shade600,
          unselectedItemColor: Colors.black,
          selectedIconTheme: IconThemeData(color: Colors.green.shade600),
          unselectedIconTheme: IconThemeData(color: Colors.black),
          onTap: (int index) async {
            switch (index) {
              case 0:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProductScreen()),
                );

                print('Tapped on Home');
                break;
              case 1:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Categories2()),
                );
                print('Tapped on Categories');
                break;
              case 2:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Favourites()),
                );
                print('Tapped on Favourites');
                break;
              case 3:
                bool today = false;
                bool recent = false;
                bool most = false;
                bool featured = false;
                bool latest = false;
                final SharedPreferences prefs1 = await SharedPreferences.getInstance();
                await prefs1.setBool('toadys_deals', today);
                await prefs1.setBool('Recent', recent);
                await prefs1.setBool('Featured', featured);
                await prefs1.setBool('Most', most);
                await prefs1.setBool('Latest', latest);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Deals(
                            selectedTabIndex: 0,
                          )),
                );

                // Handle Deals item tap
                print('Tapped on Deals');
                break;
              case 4:
                var sharedPref = await SharedPreferences.getInstance();
                sharedPref.setBool(SplashScreenState.KEYlOGIN, true);
                isLoggedIn = sharedPref.getBool(SplashScreenState.KEYlOGIN);
                print("isLoggedIn: $isLoggedIn");

                if (isLoggedIn == true || status == 'SUCCESS') {
                  print(isLoggedIn);
                  print(status);
                  print(status);
                  print(name);
                  print(first_name1);
                  print(myValue);

                  if (isd)
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => YourAccount()),
                    );
                  else
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Account()),
                    );
                  break;
                }

                break;
            }
            print('Tapped on item $index');
          },
        ),
      ),
    );
  }
}
