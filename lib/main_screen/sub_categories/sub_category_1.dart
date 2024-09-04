import 'package:flutter/material.dart';
import 'package:myrunciit/add_to_cart/add_to_cart.dart';
import 'package:myrunciit/bottom_navigationbar/account.dart';
import 'package:myrunciit/bottom_navigationbar/deals.dart';
import 'package:myrunciit/bottom_navigationbar/favourites.dart';
import 'package:myrunciit/bottom_navigationbar/sub_category_2/categories_2.dart';
import 'package:myrunciit/drawer/your_account.dart';
import 'package:myrunciit/main_screen/sub_categories/products.dart';
import 'package:myrunciit/product_screen/product_main_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myrunciit/roots/roots.dart';
import 'package:myrunciit/widget/cart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../bottom_navigationbar/deals_page/deals_sub_category/today_sub_category.dart';
import '../../main.dart';
import '../../test.dart';

class Subcategory extends StatefulWidget {
  final List subcategories;
  var store_data;


  Subcategory({Key? key, required this.subcategories, required this.store_data})
      : super(key: key);

  @override
  State<Subcategory> createState() => _SubcategoryState();
}

var store_id;
var all_data;
var all_price;

class _SubcategoryState extends State<Subcategory> {
  int itemCount = 0;
  List product1 = [];

  // List subcategories = [];



  @override
  void initState() {

    // getallcategory();
    setState(() {
      setstoreid();

      all_data = [];
      all_price = [];
      product1 = [];
    });
    super.initState();
  }

  // getdefaul_storeid() async {
  //   String url1 = "$root_web/defaul_store";
  //   dynamic response = await http.get(Uri.parse(url1));
  //   var jsonResponse = jsonDecode(response.body);
  //   var status = jsonResponse["status"];
  //   if (status == "SUCCESS") {
  //     var default_store = jsonResponse["Response"]["default_store"];
  //     print('default_store${default_store}');
  //     store_id = default_store[0]["store_id"];
  //     print('store_id ====>>>> ${store_id}');
  //   } else {
  //     print("failure");
  //   }
  // }

  setstoreid() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      store_id = prefs.getString('storeid');
    });
    // getallcategory();
    getProduct1();
    print('store_id_sub_category ---------- $store_id');
  }

  // getallcategory() async {
  //   String url1 = "$root_web/all_category/${store_id}";
  //   dynamic response = await http.get(Uri.parse(url1));
  //   var jsonResponse = jsonDecode(response.body);
  //   var status = jsonResponse["status"];
  //   if (status == "SUCCESS") {
  //     var default_store = jsonResponse["Response"]["default_store"];
  //     print('default_store${default_store}');
  //     store_id = default_store[0]["store_id"];
  //     print('store_id ====>>>> ${store_id}');
  //   } else {
  //     print("failure");
  //   }
  // }

  getProduct1() async {
    setState(() {
      product1 = [];
    });
    if(widget.subcategories.isNotEmpty && widget.subcategories.length != null){
      for (var j = 0; j < widget.subcategories.length; j++) {
        String url1 =
            "$root_web/category/${widget.subcategories[j]["category_id"]}/${widget.subcategories[j]["sub_category_id"]}/${store_id}";
        print('get_sub_categories ====>>> $url1');
        dynamic response = await http.get(Uri.parse(url1));
        if (response.statusCode == 200) {
          dynamic recommended_response = jsonDecode(response.body);
          debugPrint('recommended_response$recommended_response');
          if (recommended_response != null &&
              recommended_response['Response'] != null) {
            setState(() {
              for (var k = 0; k < recommended_response['Response'].length; k++) {
                all_data.add(recommended_response["Response"][k]);
                var ob_data = jsonDecode(recommended_response["Response"][k]["multiple_price"]);
                if(ob_data.length != 0){
                  var low = 0;
                  for(var f=0;f<ob_data.length;f++)
                  {
                    if(f==0)
                    {
                      low = int.parse(ob_data[f]["amount"].toString());
                    }
                    var current = int.parse(ob_data[f]["amount"].toString());
                    if(current < low){
                      low = current;
                    }
                  }
                  setState(() {
                    all_price.add(low.toString());
                  });
                }
                else
                {
                  setState(() {
                    all_price.add(recommended_response["Response"][k]["sale_price"].toString());
                  });
                }

              }
            });
          } else {
            show_dialog();
            print("Invalid response format or missing data");
          }
        } else {
          show_dialog();
          print("failure");
        }
      }
      setState(() {
        product1 = all_data;
        print("product1$product1");
      });
    }else{
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text("No Sub Category Products"),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreen,
                ),
                child: Center(child: Text("OK")),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  show_dialog()
  {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text("No Sub Category Products"),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightGreen,
              ),
              child: Center(child: Text("OK")),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
        Navigator.pop(context);        return Future.value(true);
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
            children: <Widget>[
              Text(
                "Sub Categories",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: [ShoppingCart()],
        ),
        body: product1.length != 0 ? ListView(
          children: [
            SingleChildScrollView(
              child: Container(
                // height: size.height * 1.6,
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Product()));
                      },
                      child: Container(
                        height: size.height * 0.14,
                        width: size.width * 0.78,
                        // color: Colors.amberamber,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GridView.count(
                            scrollDirection: Axis.vertical,
                            crossAxisCount: 3,
                            crossAxisSpacing: 0.0,
                            mainAxisSpacing: 0.0,
                            physics:
                            NeverScrollableScrollPhysics(), // Disable vertical scroll
                            shrinkWrap: true,
                            children: List.generate(
                                widget.subcategories.length ?? 0, (index) {
                              return Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Product_specific(
                                                    store_data: widget.store_data
                                                        .toString(),
                                                    product_id: index.toString(),
                                                    sub_cat: widget.subcategories,
                                                  )));
                                    },
                                    child: Container(
                                      height: size.height * 0.065,
                                      decoration: BoxDecoration(
                                        color: Color(0xfff8f9fd),
                                        shape: BoxShape.circle,
                                      ),
                                      child: widget.subcategories[index]
                                      ['banner'] !=
                                          null
                                          ? Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Image.network(
                                          widget.subcategories[index]
                                          ['banner']
                                              .toString(),
                                          errorBuilder:
                                              (BuildContext context,
                                              Object error,
                                              StackTrace? stackTrace) {
                                            return Image.asset(
                                                'asset/dummy.jpg');
                                          },
                                          fit: BoxFit.contain,
                                        ),
                                      )
                                          : Padding(
                                        padding: const EdgeInsets.all(1.0),
                                        child:
                                        Image.asset('asset/dummy.jpg'),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 1),
                                    child: Text(
                                      widget.subcategories[index]
                                      ['sub_category_name']
                                          .toString(),
                                      style: TextStyle(fontSize: 10.5),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ),
                        ),
                      ),
                    ),
                    Column(children: [
                      Container(
                          width: size.width,
                          color: Color(0xfff8f9fd),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              'PRODUCT LIST',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.black),
                            ),
                          )),
                      Padding(
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
                                physics:
                                NeverScrollableScrollPhysics(), // Disable vertical scroll
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
                                                categoryName: product1[index]["title"]
                                                    .toString(),
                                                categoryImage: product1[index]
                                                ["banner"]
                                                    .toString(),
                                                sale_price: product1[index]
                                                ["sale_price"]
                                                    .toString(),
                                                current_stock: product1[index]
                                                ["current_stock"]
                                                    .toString(),
                                                description: product1[index]
                                                ["description"]
                                                    .toString(),
                                                discount: product1[index]["discount"]
                                                    .toString(),
                                                product_id: product1[index]
                                                ["product_id"]
                                                    .toString(),
                                                options: product1[index]['options'],
                                                brand_name: product1[index]['brand_name'],
                                                cod_status: product1[index]['cod_status'].toString()),
                                          ),
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
                                                    product_images: product1[index]
                                                    ["product_image"],
                                                    categoryName: product1[index]
                                                    ["title"]
                                                        .toString(),
                                                    categoryImage: product1[index]
                                                    ["banner"]
                                                        .toString(),
                                                    sale_price: product1[index]
                                                    ["sale_price"]
                                                        .toString(),
                                                    current_stock: product1[index]
                                                    ["current_stock"]
                                                        .toString(),
                                                    description: product1[index]
                                                    ["description"]
                                                        .toString(),
                                                    discount: product1[index]
                                                    ["discount"]
                                                        .toString(),
                                                    product_id: product1[index]
                                                    ["product_id"]
                                                        .toString(),
                                                    brand_name: product1[index]
                                                    ["brand_name"]
                                                        .toString(),
                                                    options: product1[index]['options'],
                                                    cod_status: product1[index]['cod_status'],
                                                    sub_category: product1[index]['sub_category_name'].toString(),

                                                  ),
                                            ));
                                      }
                                    },
                                    behavior: HitTestBehavior.translucent,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            color: Colors.grey.shade100),
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
                                              if (product1[index]["discount"] !=
                                                  null &&
                                                  int.tryParse(product1[index]
                                                  ["discount"]
                                                      .toString()) !=
                                                      null &&
                                                  int.parse(product1[index]
                                                  ["discount"]
                                                      .toString()) >
                                                      0)
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.fromLTRB(
                                                      8, 8, 0, 0),
                                                  child: Container(
                                                    height: size.height * 0.02,
                                                    width: size.width * 0.15,
                                                    decoration: BoxDecoration(
                                                      color: Color.fromRGBO(
                                                          244, 194, 37, 0.1),
                                                      borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              10)),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                          const EdgeInsets
                                                              .fromLTRB(
                                                              6, 2, 0, 2),
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
                                                          style: TextStyle(
                                                              fontSize: 10),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              else
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.fromLTRB(
                                                      8, 8, 0, 0),
                                                  child: Container(
                                                    height: size.height * 0.02,
                                                    width: size.width * 0.15,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              10)),
                                                    ),
                                                  ),
                                                ),
                                              Center(
                                                child: Padding(
                                                  padding:
                                                  const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    height: 80,
                                                    width: 80,
                                                    child: product1[index]
                                                    ["banner"] !=
                                                        null
                                                        ? Image.network(
                                                      product1[index]
                                                      ["banner"]
                                                          .toString(),
                                                      errorBuilder:
                                                          (BuildContext
                                                      context,
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
                                                  padding:
                                                  const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    product1[index]['title']
                                                        .toString(),
                                                    style:
                                                    TextStyle(fontSize: 11),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                              Center(
                                                child: product1[index]
                                                ["discount"] !=
                                                    null &&
                                                    int.tryParse(product1[
                                                    index]
                                                    ["discount"]
                                                        .toString()) !=
                                                        null &&
                                                    int.parse(product1[index]
                                                    ["discount"]
                                                        .toString()) >
                                                        0
                                                    ? Container(
                                                  // Your original code with some modifications
                                                  decoration:
                                                  const BoxDecoration(
                                                    color:
                                                    Color(0xffc40001),
                                                    borderRadius:
                                                    BorderRadius.all(
                                                        Radius.circular(
                                                            5)),
                                                  ),
                                                  height:
                                                  size.height * 0.02,
                                                  width: size.width * 0.35,
                                                  child: Center(
                                                    child: Text.rich(
                                                      TextSpan(
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                            text: all_price[
                                                            index]
                                                                .toString(),
                                                            style:
                                                            TextStyle(
                                                              color: Colors
                                                                  .grey,
                                                              decoration:
                                                              TextDecoration
                                                                  .lineThrough,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: "RM " +(double.parse(all_price[index]) -
                                                                (double.parse(all_price[index]) *
                                                                    (double.parse(product1[index]["discount"]) *
                                                                        0.01)))
                                                                .toStringAsFixed(
                                                                2),
                                                            style:
                                                            TextStyle(
                                                              color: Colors
                                                                  .white,
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold,
                                                              fontSize:
                                                              10.5,
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
                                                    color:
                                                    Color(0xffc40001),
                                                    borderRadius:
                                                    BorderRadius.all(
                                                        Radius.circular(
                                                            5)),
                                                  ),
                                                  height:
                                                  size.height * 0.02,
                                                  width: size.width * 0.30,
                                                  child: Center(
                                                    child: Text(
                                                      "RM " +all_price[index]
                                                          .toString(),
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Center(
                                                child: Padding(
                                                  padding:
                                                  const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    // color: Colors.red,
                                                    height: size.height * 0.025,
                                                    width: size.width * 0.3,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                5)),
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
                                                        padding: const EdgeInsets
                                                            .fromLTRB(4, 0, 4, 0),
                                                        child: Text(
                                                          '${product1[index]['current_stock'].toString() == "null" || product1[index]['current_stock'].toString() == "0" ? "OUT OF STOCK" : 'IN CART'}',
                                                          style: TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 12,
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold),
                                                          textAlign:
                                                          TextAlign.center,
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
                          )),
                    ]),
                  ],
                ),
              ),
            ),
          ],
        ) : Center(child: CircularProgressIndicator(color: Colors.blue,)),
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

                if (isLoggedIn == true) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => YourAccount()),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Account()),
                  );
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