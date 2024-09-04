import 'package:flutter/material.dart';
import 'package:myrunciit/bottom_navigationbar/account.dart';
import 'package:myrunciit/bottom_navigationbar/categories.dart';
import 'package:myrunciit/bottom_navigationbar/sub_category_2/categories_2.dart';
import 'package:myrunciit/bottom_navigationbar/deals.dart';
import 'package:myrunciit/bottom_navigationbar/favourites.dart';
import 'package:myrunciit/drawer/your_account.dart';
import 'package:myrunciit/main.dart';
import 'package:myrunciit/main_screen/login_screen.dart';
import 'package:myrunciit/main_screen/sub_categories/products.dart';
import 'package:myrunciit/product_screen/product_main_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myrunciit/widget/cart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../roots/roots.dart';
import '../../widget/drawer.dart';

var store_id;

class Subcategory_2 extends StatefulWidget {
  final List subcategories;

  const Subcategory_2({Key? key, required this.subcategories})
      : super(key: key);

  @override
  State<Subcategory_2> createState() => _Subcategory_2State();
}

class _Subcategory_2State extends State<Subcategory_2> {
  int itemCount = 0;
  List product1 = [];

  // List subcategories = [];

  getstoreid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      store_id = prefs.getString('storeid');
    });
    print('gridview3store_id===>>> $store_id');
  }

  @override
  void initState() {
    setState(() {
      getstoreid();
    });
    getProduct1();
    super.initState();
  }

  getProduct1() async {
    String url1 = "$root_web/all_category/${store_id}";
    // https://myrunciit.my/webservice/all_category
    dynamic response = await http.get(Uri.parse(url1));
    if (response.statusCode == 200) {
      print('success');
      print(response.body);
      dynamic jsonResponse = jsonDecode(response.body);

      // Check if the response is valid and contains the expected data
      if (jsonResponse != null &&
          jsonResponse['Response'] != null &&
          jsonResponse['Response']["category"] != null) {
        setState(() {
          // Access the array of categories from the response
          product1 = jsonResponse['Response']["category"];
          print(product1);
        });
      } else {
        print("Invalid response format or missing data");
      }
    } else {
      print("failure");
    }
  }

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
        Navigator.pop(context);
        return Future.value(true);
      },

      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff014282),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
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
            children: <Widget>[Text("Sub Categories",style: TextStyle(color: Colors.white,fontSize: 18.0,fontWeight: FontWeight.bold),)],
          ),
          // actions: [ShoppingCart()],
        ),
        // ElevatedButton(
        //   onPressed: addToCart,
        //   child: Text('Add to Cart'),
        // ),
        body: Container(
          color: Colors.white,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Product()));
                  },
                  child: Container(
                    height: size.height * 0.8,
                    width: size.width,
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Adjust the number of columns as needed
                        crossAxisSpacing: 10.0,
                        childAspectRatio: (1.1/1),
                        mainAxisSpacing: 10.0,
                      ),
                      itemCount: widget.subcategories.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey.shade200)
                            // boxShadow: [
                            //   BoxShadow(
                            //     color: Colors.black.withOpacity(0.1),
                            //     spreadRadius: 2,
                            //     blurRadius: 4,
                            //     offset: Offset(2, 2),
                            //   ),
                            // ],
                          ),
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height:80,
                                width: 80,
                                child: widget.subcategories[index]['banner'] != null
                                    ? Image.network(
                                        widget.subcategories[index]['banner']
                                            .toString(),
                                        errorBuilder: (BuildContext context,
                                            Object error, StackTrace? stackTrace) {
                                          return Image.asset('asset/dummy.jpg');
                                        },
                                        fit: BoxFit.cover,
                                        height: 50,
                                        width: 50,
                                      )
                                    : Image.asset('asset/dummy.jpg'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  widget.subcategories[index]['sub_category_name']
                                      .toString(),
                                  style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),

                          // Container(
                          //
                          // ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
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
          currentIndex: 1,
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



                  if (myValue != null  && isLoggedIn == true)
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
