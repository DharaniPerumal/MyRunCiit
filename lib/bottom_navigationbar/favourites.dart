import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myrunciit/product_screen/product_main_screen.dart';
import 'package:myrunciit/roots/roots.dart';
import 'package:myrunciit/widget/drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../main_screen/login_screen.dart';

var user_id;
var transactionstoreid;
var wishlist_list_data;
List wishlist_list_details = [];
class Favourites extends StatefulWidget {
  const Favourites({super.key});

  @override
  State<Favourites> createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  int itemCount = 0;

  void addToCart() {
    setState(() {
      itemCount++;
    });
  }

  Future<void> getMyValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      myValue = prefs.getString('first_name') == null ? 'Guest' : prefs.getString('first_name');
    });
    print('myvalue_fav ===>>> $myValue');
  }

  Future<void> get_user_id() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      user_id = prefs.getString('user_id');
    });
    print('wishlist_list_userid===>>> $user_id');
  }
  void wishlist_list_for_list() async {
    print('user_id_wishlist -----> $user_id');
    String url1 = "$root_web/wishlist/list/0/${user_id == null ? 12 : user_id}";
    print('wishlist_list ----> $root_web/wishlist/list/0/${user_id}');
    print('wishlist_list ----> $url1');
    dynamic response = await http.get(Uri.parse(url1));
    if (response.statusCode == 200) {
      print('success1');
      print(response.body);
      dynamic jsonResponse = jsonDecode(response.body);
      // wishlist_list_data = jsonResponse["Response"]["wishlistProducts"];
      print('wishlist_list_response ----> ${jsonResponse['Response']}');
      if ( jsonResponse != null && jsonResponse['Response'] != null && jsonResponse['Response']['wishlistProducts'] != null ) {
        setState(() {
          wishlist_list_details = [];
          wishlist_list_details = jsonResponse['Response']['wishlistProducts'];
        });
        // var check_wish_list = wishlist_list_details[0]['product_id'];
        print('wishlist_list $wishlist_list_details');
        // print('check_wish_list $check_wish_list');
      } else {
        setState(() {
          wishlist_list_details = [];
        });
        print("Invalid response format or missing data");
        Fluttertoast.showToast(
            msg: 'No data...!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 3,
            backgroundColor: Color(0xff014282),
            textColor: Colors.white,
            fontSize: 15,
            webPosition: "center");
      }
    } else {
      print("failure");
    }
  }
  wishlist_list_delete(index) async {
    String url1 = "$root_web/wishlist/remove/${wishlist_list_details[index]['product_id']}/${user_id}";
    print('wishlist_remove ----> $url1');
    dynamic response = await http.get(Uri.parse(url1));
    dynamic jsonResponse = jsonDecode(response.body);
    var status = jsonResponse['status'];
    if (status == 'SUCCESS') {
      print('wishlist_remove');
      Fluttertoast.showToast(
          msg: 'Deleted Successfully...!',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: Color(0xff014282),
          textColor: Colors.white,
          fontSize: 15,
          webPosition: "center");
      wishlist_list_for_list();
    } else {
      print("failure -------> wishlist_removed");
    }
  }

  @override
  void initState() {
    setState(() {
      getMyValue();
      wishlist_list_details = [];
      get_user_id();
      wishlist_list_for_list();
    });
  senddata();
  super.initState();
  }

  senddata() async {
    print('Sending data...');

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
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff014282),
        leading: IconButton(onPressed: () async {
           await senddata();
          Navigator.pop(context);
          },icon: Icon(Icons.keyboard_arrow_left,size: 35,color: Colors.white,),),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("Wishlist",style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      body:
      myValue == 'Guest' ?
      Center(
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
                Text("You have not added any product to your",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                Text("Wishlist as yet",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
              ],
            ),
            InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: MediaQuery.of(context).size.height * 0.2,
                      child: AlertDialog(
                        title: Text(
                          "sign in",
                          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        insetPadding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.37),
                        content: Center(
                            child: Text(
                              "Do you want to sign in ?",
                              style: TextStyle(fontSize: 16),
                            )),
                        actions: [
                          Row(
                            mainAxisAlignment : MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap:(){
                                  Navigator.pop(context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      'Cancel',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.green, fontSize: 15.0),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 7,),
                              InkWell(
                                onTap: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => LoginScreen()),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      'Sign in',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.green, fontSize: 15.0),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Container(
                height: size.height*0.05,
                width: size.width*0.6,
                color: Colors.deepOrange,
                child: Center(child: Text("Login to start your wishlist", style: TextStyle(color: Colors.white,),textAlign: TextAlign.center,)),
              ),
            ),
          ],
        ),
      ) : SingleChildScrollView(
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  color: Color(0xff014282),
                  child: Center(child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.favorite,color: Colors.red),
                        SizedBox(width: MediaQuery.of(context).size.width * 0.001,),
                        Text("Your Wishlist",style: TextStyle(color: Colors.white, fontSize: 18.0,fontWeight: FontWeight.bold),),
                      ],
                    ),
                  )),
                )
            ),
            wishlist_list_details.length != 0 ? ListView.builder(
                itemCount: wishlist_list_details.length,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        width: size.width,
                        // height: size.height*0.2,
                        decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade400)),
                        child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(height: size.height*0.1,
                                  width: size.width*0.25,
                                  child: Image.network(wishlist_list_details[index]['product_image'],fit: BoxFit.fitHeight,),),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 4),
                                    child: Container(
                                        width: size.width*0.5,
                                        child: Text(wishlist_list_details[index]['title'],style: TextStyle(fontWeight: FontWeight.bold),)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(8, 8, 4, 4),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "RM ",
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontSize:12,fontWeight: FontWeight.bold),
                                        ),
                                        if (int.tryParse(
                                            wishlist_list_details[index]['discount_price']) !=
                                            null &&
                                            int.parse(wishlist_list_details[index]['discount_price']) >
                                                0)
                                          Text.rich(TextSpan(
                                            style: TextStyle(fontSize: 12),
                                            text: '${wishlist_list_details[index]['sale_price']}',
                                            children: <TextSpan>[
                                              new TextSpan(
                                                  text:(double.parse(wishlist_list_details[index]['sale_price']) -
                                                      (double.parse(wishlist_list_details[index]['sale_price'])
                                                          * (double.parse(wishlist_list_details[index]['discount_price'])
                                                              *0.01)
                                                      )
                                                  ).toStringAsFixed(2),
                                                  style: TextStyle(fontSize: 15)),
                                            ],
                                          ),
                                          )
                                        else
                                          Text.rich(TextSpan(
                                            children: <TextSpan>[
                                              new TextSpan(
                                                text:  wishlist_list_details[index]['sale_price'],
                                                style: new TextStyle(
                                                    color: Colors.black,fontSize: 15
                                                ),
                                              ),
                                            ],
                                          ),
                                          ),

                                      ],
                                    ),
                                  ),
                                  Center(child: wishlist_list_details[index]['current_stock'].toString() ==
                                      "null"
                                      ? Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: Container(
                                      decoration: BoxDecoration(color: Colors.green,borderRadius: BorderRadius.all(Radius.circular(5))),
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Text(
                                          "In stock",
                                          style: TextStyle(
                                              color: Colors.white, fontSize: 13),
                                          textAlign: TextAlign.end,
                                        ),
                                      ),
                                    ),
                                  )
                                      : Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: Container(
                                      decoration: BoxDecoration(color: Colors.red,borderRadius: BorderRadius.all(Radius.circular(5))),

                                      // color: Colors.red,
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Text("Out of stock",
                                            style:
                                            TextStyle(color: Colors.white,fontSize: 13,)),
                                      ),
                                    ),
                                  ),),
                                  SizedBox(height: 0,),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: Container(

                                          width: size.width*0.3,
                                          decoration: BoxDecoration(color: Colors.orangeAccent,borderRadius: BorderRadius.all(Radius.circular(5))),
                                          // color: Colors.green,
                                          child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Row(
                                              children: [
                                                Text(
                                                  "Add To Cart",
                                                  style: TextStyle(fontSize: 13,
                                                      color: Colors.white),
                                                  textAlign: TextAlign.end,
                                                ),
                                                SizedBox(width: 5,),
                                                Icon(Icons.shopping_cart,color: Colors.white,size: 20,)
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: MediaQuery.of(context).size.width * 0.185,),
                                      IconButton(onPressed: () {wishlist_list_delete(index);}, icon: Icon(Icons.delete_rounded,color: Colors.red,))
                                    ],
                                  ),
                                ],
                              ),
                            ])
                    ),
                  ); } ):SizedBox(),
          ],
        ),
      ),
    );
  }
}
