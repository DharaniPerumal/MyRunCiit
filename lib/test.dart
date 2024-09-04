
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:myrunciit/add_to_cart/add_to_cart.dart';
import 'package:myrunciit/bottom_navigationbar/account.dart';
import 'package:myrunciit/bottom_navigationbar/categories.dart';
import 'package:myrunciit/bottom_navigationbar/deals_page/deals_sub_category/today_sub_category.dart';
import 'package:myrunciit/bottom_navigationbar/sub_category_2/categories_2.dart';
import 'package:myrunciit/bottom_navigationbar/deals.dart';
import 'package:myrunciit/bottom_navigationbar/favourites.dart';
import 'package:myrunciit/drawer/your_account.dart';
import 'package:myrunciit/main.dart';
import 'package:myrunciit/main_screen/login_screen.dart';
import 'package:myrunciit/product_screen/product_main_screen.dart';
import 'package:myrunciit/roots/roots.dart';
import 'package:myrunciit/widget/bottom_navigation_bar.dart';
import 'package:myrunciit/widget/cart.dart';
import 'package:myrunciit/widget/drawer.dart';
import 'package:myrunciit/widget/grid_view1.dart';
import 'package:myrunciit/widget/search.dart';
import 'package:shared_preferences/shared_preferences.dart';


var product1 = [];
class Product_specific extends StatefulWidget {
  var store_data = "";
  var product_id = "";
  var sub_cat = [];
  Product_specific({super.key,required this.store_data,required this.product_id,required this.sub_cat});

  @override
  State<Product_specific> createState() => _Product_specificState();
}

class _Product_specificState extends State<Product_specific> {
  int itemCount = 0;

  void addToCart() {
    setState(() {
      itemCount++;
    });
  }

  getProduct1() async {
    product1 = [];
    String url1 = "$root_web/category/${widget.sub_cat[int.parse(widget.product_id)]["category_id"]}/${widget.sub_cat[int.parse(widget.product_id)]["sub_category_id"]}/${widget.store_data}";
    print('get_sub_categoriesfgghvfghg ====>>> $url1');
    dynamic response = await http.get(Uri.parse(url1));
    if (response.statusCode == 200) {
      dynamic recommended_response = jsonDecode(response.body);
      debugPrint('recommended_response$recommended_response');
      if (recommended_response != null &&
          recommended_response['Response'] != null) {
        setState(() {
          for(var k=0;k<recommended_response['Response'].length;k++)
          {
            product1.add(recommended_response["Response"][k]);
          }

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
    // TODO: implement initState
    super.initState();
    getProduct1();
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
              Text("Products",style: TextStyle(fontSize: 18,color: Colors.white),)
            ],
          ),
          actions: [
            ShoppingCart(itemCount: itemCount,)
          ],
        ),
        body: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                width: size.width * 0.95, // Set a fixed width
                child: GridView.count(
                  scrollDirection: Axis.vertical,
                  crossAxisCount: 2,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5,
                  childAspectRatio: (1 / 1.4),
                  // Disable vertical scroll
                  shrinkWrap:
                  true, // Allow GridView to be in a SingleChildScrollView
                  children:
                  List.generate(product1.length ?? 0, (index) {
                    return GestureDetector(
                      onTap: () {
                        if (added == 'true') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddToCart(
                                  sub_category: product1[index]["sub_category_name"],
                                  tax:product1[index]["tax"],
                                  tax_type:product1[index]["tax_type"],
                                  multi_price: product1[index]["multiple_price"],
                                  product_muti_images: product1[index]["product_image"],
                                    categoryName:
                                    product1[index]["title"].toString(),
                                    categoryImage: product1[index]["product_image"]
                                        .toString(),
                                    sale_price:
                                 product1[index]["sale_price"].toString(),
                                    current_stock:product1[index]["current_stock"]
                                        .toString(),
                                    description:
                                    product1[index]["description"].toString(),
                                    discount:product1[index]["discount"].toString(),
                                    product_id: product1[index]["product_id"].toString(),
                                    options: product1[index]['options'].toString(),
                                  brand_name: product1[index]['brand_name'],
                                  cod_status: product1[index]['cod_status'].toString(),
                                )),
                          );
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CategoryDetailScreen(
                                      tax: product1[index]["tax"],
                                      tax_type: product1[index]["tax_type"],
                                      multi_price: product1[index]["multiple_price"],
                                      product_images: product1[index]["product_image"],
                                      categoryName: product1[index]["title"].toString(),
                                      categoryImage: product1[index]["banner"].toString(),
                                      sale_price: product1[index]["sale_price"].toString(),
                                      current_stock: product1[index]["current_stock"].toString(),
                                      description: product1[index]["description"].toString(),
                                      discount: product1[index]["discount"].toString(),
                                      brand_name: product1[index]["brand_name"].toString(),
                                      options: product1[index]['options'],
                                      product_id:product1[index]["product_id"].toString(),
                                      cod_status:product1[index]["cod_status"].toString(),
                                      sub_category: product1[index]['sub_category_name'].toString(),

                                    ),
                              ));
                        }
                      },
                      behavior: HitTestBehavior.translucent,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border:
                          Border.all(color: Colors.grey.shade100),
                        ),
                        margin: EdgeInsets.all(0.0),
                        child: Center(
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment.start,
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                if (product1[index]["discount"] != null &&
                                    int.tryParse(product1[index]["discount"].toString()) != null &&
                                    int.parse(product1[index]["discount"].toString()) > 0)
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        8, 8, 0, 0),
                                    child: Container(
                                      height: size.height * 0.02,
                                      width: size.width * 0.15,
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(244, 194, 37, 1),

                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets
                                                .fromLTRB(6, 2, 0, 2),
                                            child: Text(
                                              product1[index]
                                              ["discount"]
                                                  .toString(),
                                              style: TextStyle(
                                                  fontSize: 10),
                                              textAlign:
                                              TextAlign.center,
                                            ),
                                          ),
                                          Text(
                                            "% offer",
                                            style:
                                            TextStyle(fontSize: 10),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                else
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        8, 8, 0, 0),
                                    child: Container(
                                      height: size.height * 0.02,
                                      width: size.width * 0.15,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                    ),
                                  ),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      height: 80,
                                      width: 80,
                                      child: product1[index]
                                      ["banner"] !=
                                          null
                                          ? Image.network(
                                        product1[index]["banner"]
                                            .toString(),
                                        errorBuilder:
                                            (BuildContext context,
                                            Object error,
                                            StackTrace?
                                            stackTrace) {
                                          return Image.asset(
                                            'asset/dummy.jpg',
                                          );
                                        },
                                      )
                                          : Image.asset(
                                        'asset/dummy.jpg',
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: size.height * 0.002,
                                ),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      product1[index]['title']
                                          .toString(),
                                      style: TextStyle(fontSize: 11),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                Center(
                                  child:  product1[index]["discount"] != null &&
                                      int.tryParse(product1[index]["discount"].toString()) != null &&
                                      int.parse(product1[index]["discount"].toString()) > 0
                                      ? Container(
                                    // Your original code with some modifications
                                    decoration: const BoxDecoration(
                                      color: Color(0xffc40001),
                                      borderRadius: BorderRadius.all(Radius.circular(5)),
                                    ),
                                    height: size.height * 0.02,
                                    width: size.width * 0.35,
                                    child: Center(
                                      child: Text.rich(
                                        TextSpan(
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: product1[index]["sale_price"].toString(),
                                              style: TextStyle(
                                                color: Colors.grey,
                                                decoration: TextDecoration.lineThrough,
                                              ),
                                            ),
                                            TextSpan(
                                              text: "RM "+(double.parse(product1[index]["sale_price"]) -
                                                  (double.parse(product1[index]["sale_price"]) *
                                                      (double.parse(product1[index]["discount"]) *
                                                          0.01)))
                                                  .toStringAsFixed(2),
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 10.5,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                      : Container(
                                    // Your original code with some modifications
                                    decoration: BoxDecoration(
                                      color: Color(0xffc40001),
                                      borderRadius: BorderRadius.all(Radius.circular(5)),
                                    ),
                                    height: size.height * 0.02,
                                    width: size.width * 0.30,
                                    child: Center(
                                      child: Text("RM "+
                                        product1[index]["sale_price"].toString() ,
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      // color: Colors.red,
                                      height: size.height * 0.025,
                                      width: size.width * 0.3,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.all(
                                              Radius.circular(5)),
                                          color: product1[index][
                                          'current_stock']
                                              .toString() ==
                                              "null" ||
                                              product1[index][
                                              'current_stock']
                                                  .toString() ==
                                                  "0"
                                              ? Colors.red
                                              : Colors.green),
                                      child: Center(
                                        child: Padding(
                                          padding:
                                          const EdgeInsets.fromLTRB(
                                              4, 0, 4, 0),
                                          child: Text(
                                            '${product1[index]['current_stock'].toString() == "null" || product1[index]['current_stock'].toString() == "0" ? "OUT OF STOCK" : 'IN CART'}',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight:
                                                FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            )
        ),
        // Padding(
        //   padding: const EdgeInsets.all(18.0),
        //   // child: Container(
        //   //   height: size.height*0.1,
        //   //   width: size.width*0.9,
        //   //   decoration: BoxDecoration(
        //   //     color: Colors.white,
        //   //     boxShadow: [
        //   //       BoxShadow(
        //   //         color: Colors.black.withOpacity(0.5), // Color of the shadow
        //   //         spreadRadius: 2, // Spread radius
        //   //         blurRadius: 4, // Blur radius
        //   //         offset: Offset(0, 2), // Offset of the shadow
        //   //       ),
        //   //
        //   //     ],
        //   //   ),
        //   //
        //   //   child: Padding(
        //   //     padding: const EdgeInsets.all(8.0),
        //   //     child: Center(
        //   //       child: InkWell(
        //   //         onTap: () {
        //   //           Navigator.push(
        //   //             context,
        //   //             MaterialPageRoute(builder: (context) => LoginScreen()),
        //   //           );
        //   //
        //   //           print('Login / Register tapped!');
        //   //         },
        //   //
        //   //         child: Container(
        //   //           height: size.height*0.05,
        //   //           color: Colors.deepOrange,
        //   //           child: Center(child: Text("Login / Register", style: TextStyle(color: Colors.white,),textAlign: TextAlign.center,)),
        //   //         ),
        //   //
        //   //       ),
        //   //     ),
        //   //   ),
        //   // ) ,
        // ),

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
            switch(index) {
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
                  MaterialPageRoute(builder: (context) => Deals(selectedTabIndex: 0,)),
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
