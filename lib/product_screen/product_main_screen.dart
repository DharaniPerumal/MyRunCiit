import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:myrunciit/blogs/blogs_detailview.dart';
import 'package:myrunciit/bottom_navigationbar/account.dart';
import 'package:myrunciit/bottom_navigationbar/sub_category_2/categories_2.dart';
import 'package:myrunciit/bottom_navigationbar/favourites.dart';
import 'package:myrunciit/drawer/your_account.dart';
import 'package:myrunciit/main.dart';
import 'package:myrunciit/main_screen/login_screen.dart';
import 'package:myrunciit/product_screen/carousel_slider_1.dart';
import 'package:myrunciit/product_screen/grid/most_viewed_grid.dart';
import 'package:myrunciit/product_screen/grid/recently_viewed_grid.dart';
import 'package:myrunciit/product_screen/grid/todaydeals_grid.dart';
import 'package:myrunciit/roots/roots.dart';
import 'package:myrunciit/widget/cart.dart';
import 'package:myrunciit/widget/drawer.dart';
import 'package:myrunciit/widget/grid_view1.dart';
import 'package:myrunciit/widget/search.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../all_categories/all_cat.dart';
import '../bottom_navigationbar/deals.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'grid/category_banners.dart';
import 'grid/latest_product_grid.dart';

int countAsInt = 0;
var countadded,
    userid1,
    cart2,
    wishlistname,
    wishlistimage,
    wishlistprice,
    wishliststock,
    wishlistdiscount,
    addedname,
    comparename,
    compareimage,
    compareprice,
    comparestock,
    comparediscount,
    invalidCode,
    blogs,
    blogs_img,
    vendorId;
var store_id;
var start = false;

List<Map<String, String>> compareList = [];
Map<String, String> compareData1 = {};
var vendorName = null;

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  int itemCount = 0;
  List subCategories = [];
  List poultry = [];
  List frozen = [];
  List product1 = [];
  List product2 = [];
  var user_id;

  final zipcode_controller = TextEditingController();

  getcartcount()async
  {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      var item_name = prefs.getStringList('product_name') ?? [];
      countAsInt = item_name.length;
    });
  }

  @override
  void initState() {
    setState(() {
      start = false;
    });
    getAreaName();


    super.initState();
  }

  call_all()
  {
    // HorizontalGridView();
    // Todaysdealsgrid();
    getProduct1();
    getBanner();
    getcartcount();
    wishlistdata();

      getProduct1();
      get_blogs_api();
  }

  getAreaName() async {
    print("area_changed_zip_code ---- >>>>${zipcode_controller.text}");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var a = prefs.getString('pin') ?? "59000";
    // zipcode_controller.text == "" ? 2 : zipcode_controller.text;
    // print("area_changed_zip_code ---- >>>>${zipcode_controller.text}");

    String urlw = "$root_web/getNearestVendorName/${a}";
    print("area_changed_url ---- >>>>${urlw}");
    dynamic response = await http.get(Uri.parse(urlw));
    print("area_changed_json ----->${response.body}");
    var jsonencode = jsonDecode(response.body);
    dynamic jsonResponse = jsonDecode(response.body);
    print("area_changed_jsongfd -----> $jsonencode");
    print("area_changed_jsonResponse -----> $jsonResponse");
    var status = jsonencode["status"];
    print("status_area ---->>>> $status");
    if (status == "SUCCESS") {
      await prefs.setString("pin_pre",a.toString());
      await prefs.setString("pin",a.toString());
      var response = jsonencode["Response"];
      print("response_area ---- >>>> $response");
      var page_data = jsonencode["Response"]["page_data"];
      print('page_data ====>>>>> $page_data');
      setState(() {
        vendorName = page_data["vendorDetails"]["name"];
        vendorId = page_data["vendorDetails"]["store_id"];

        setstoreid();
      });
      print('vendorName ====>>>>> $vendorName');
      print('vendorId ====>>>>> $vendorId');
      invalidCode = page_data["vendorDetails"]["zip"];
      print('invalidCode ====>>>>> $invalidCode');
    } else {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("pin",'${prefs.getString('pin_pre').toString()}');
      print("failure");
      Fluttertoast.showToast(
          msg: 'Area Cannot Be Changed, Invalid Zipcode..!',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: Color(0xff014282),
          textColor: Colors.white,
          fontSize: 15,
          webPosition: "center");
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => ProductScreen()));
    }

  }

  setstoreid() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      store_id = vendorId == "" ? 2 : vendorId;
      start = true;
    });

    await prefs.setString('storeid', '${store_id}');
    print('storegfg_id1>>>>$store_id');
    call_all();
  }

  get_blogs_api() async {
    final response = await http.post(
      Uri.parse('$root_web/blogs'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "limit": "all",
      }),
    );
    var jsonResponse = jsonDecode(response.body);
    var status = jsonResponse["status"];
    print('status_blogs_addressess ===>>> ${jsonResponse}');
    if (status == "SUCCESS") {
      setState(() {
        blogs = jsonResponse["response"];
      });

      print('status123_blogs${blogs}');
      print('status123_response${jsonResponse["response"]}');
      print('status123_response${jsonResponse["response"][0]["image_src"]}');
      if (jsonResponse["response"] != null) {
        print('hhelooo12345');
      }
    }
  }

  Future<void> comparelistdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      addedname = prefs.getString('product_name');
      comparename = prefs.getString('compare_name') ?? "";
      compareimage = prefs.getString('compare_image') ?? "";
      compareprice = prefs.getString('compare_price') ?? "";
      comparestock = prefs.getString('compare_stock') ?? "";
      comparediscount = prefs.getString('compare_discount') ?? "";
    });
    print("comparediscount$comparediscount");
    compareData1 = {
      'name': comparename,
      'image': compareimage,
      'price': compareprice,
      'stock': comparestock,
      'discount': comparediscount,
    };
    print('compareData1$compareData1');
    print("compareList ${compareList}");

    // List<Map<String, String>> compareList = [];
    compareList.add(compareData1);
    print(compareData1);

    print("compareList ${compareList}");
    print("First item name: ${compareList[0]['name']}");
  }

  Future<void> wishlistdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      wishlistname = prefs.getString('wishlist_name') ?? "";
      wishlistimage = prefs.getString('wishlist_image') ?? "";
      wishlistprice = prefs.getString('wishlist_price') ?? "";
      wishliststock = prefs.getString('wishlist_stock') ?? "";
      wishlistdiscount = prefs.getString('wishlist_discount') ?? "";
    });
  }

  Future<void> countadding() async {
    print('helloo123');

    var prefs = await SharedPreferences.getInstance();
    userid1 = prefs.getString('user_id');
    print("userid1: $userid1");
    setState(() {
      countadded = prefs.getString('cartcount');
    });
    var item_name = prefs.getStringList('product_name') ?? [];
    setState(() {
      countAsInt = item_name.length;
    });

    print("countadded-----$countadded");
    setState(() {
      cart2 = prefs.getString('cart_items');
    });
    print("cart1$cart2");
  }

  getProduct1() async {
    String url1 = store_id != null
        ? "$root_web/all_category/${store_id}"
        : "$root_web/all_category/2";
    print('get_category_url -------------- $url1');
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
          print("hello20");
          print(product1);
          subCategories = product1[0]['sub_category'];
          poultry = product1[2]['sub_category'];
          frozen = product1[1]['sub_category'];
        });
      } else {
        print("Invalid response format or missing data");
      }
    } else {
      print("failure");
    }
  }

  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const AutoSizeText('Are you sure want to exit?',
            style: TextStyle(color: Colors.black, fontSize: 20.0)),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop(false);
                },
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.045,
                  width: MediaQuery.of(context).size.width * 0.15,
                  decoration: BoxDecoration(
                    color: Colors.lightGreen,
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Center(
                      child: Text(
                    'No',
                    style: TextStyle(color: Colors.white),
                  )),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop(true);
                  SystemNavigator.pop(); // This will close the app
                },
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.045,
                  width: MediaQuery.of(context).size.width * 0.15,
                  decoration: BoxDecoration(
                    color: Colors.lightGreen,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Center(
                    child: Text(
                      'Exit',
                      style: TextStyle(color: Colors.white, fontSize: 15.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ).then((value) => value ?? false);
  }

  getBanner() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      user_id = prefs.getString('user_id') ?? "";
    });
    print('user_id===>>> $user_id');
    String url1 = "$root_web/after_banner";
    dynamic response = await http.get(Uri.parse(url1));
    if (response.statusCode == 200) {
      print('success');
      print(response.body);
      dynamic jsonResponse = jsonDecode(response.body);

      // Check if the response is valid and contains the expected data
      if (jsonResponse != null &&
          jsonResponse['Response'] != null &&
          jsonResponse['Response']["banner_slides"] != null) {
        setState(() {
          product2 = jsonResponse['Response']["banner_slides"];
          print("helooo1");
          print(product2);
        });
      } else {
        print("Invalid response format or missing data");
      }
    } else {
      print("failure");
    }

  }

  _onzipcodemsg() {
    zipcode_controller.text = "";
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState)
        {
          return AlertDialog(
            title: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    "You're Currently Shopping at",
                    style: TextStyle(color: Color(0xffe12c2e), fontSize: 17.0),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.cancel_outlined,
                        color: Color(0xffd2d2d2),
                      )),
                ],
              ),
            ),
            insetPadding: EdgeInsets.zero,
            content: Container(
              height: 180,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      'asset/mricon.png',
                      height: 50.0,
                      width: 60.0,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Please Enter Your PostCode Below',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xffb7b7b7),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'ENTER POSTCODE',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.4,
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.04,
                    child: TextField(
                      // enableInteractiveSelection: false,
                      controller: zipcode_controller,
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.number,
                      cursorHeight: 20,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                            )),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          borderSide: BorderSide(width: 1, color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              InkWell(
                onTap: () async {
                  if (zipcode_controller.text != "") {
                    var a = zipcode_controller.text;
                    String urlw = "$root_web/getNearestVendorName/${a}";
                    print("area_changed_url ---- >>>>${urlw}");
                    dynamic response = await http.get(Uri.parse(urlw));
                    print("area_changed_json ----->${response.body}");
                    var jsonencode = jsonDecode(response.body);
                    dynamic jsonResponse = jsonDecode(response.body);
                    print("area_changed_jsongfd -----> $jsonencode");
                    print("area_changed_jsonResponse -----> $jsonResponse");
                    var status = jsonencode["status"];
                    print("status_area ---->>>> $status");
                    if (status == "SUCCESS") {
                      print('zipcode_controller${zipcode_controller.text}');
                      final SharedPreferences prefs = await SharedPreferences
                          .getInstance();
                      await prefs.setString(
                          "pin", '${zipcode_controller.text}');
                      Navigator.pushReplacement(
                          context, MaterialPageRoute(
                          builder: (context) => ProductScreen()));
                      zipcode_controller.text = "";
                    }
                    else {
                      // setState(() {
                        zipcode_controller.text = "";
                        FocusManager.instance.primaryFocus?.unfocus();
                      // });
                      Fluttertoast.showToast(
                          msg: 'Area Cannot Be Changed, Invalid Zipcode..!',
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 3,
                          backgroundColor: Color(0xff014282),
                          textColor: Colors.white,
                          fontSize: 15,
                          webPosition: "center");
                    }
                  }
                },
                child: SizedBox(
                  height: 60,
                  child: Column(
                    children: [
                      Center(
                        child: Container(
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * 0.04,
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.2,
                          decoration: const BoxDecoration(
                            color: Color(0xffe12c2e),
                            borderRadius: BorderRadius.all(Radius.circular(2)),
                          ),
                          child: const Center(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Check',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        });
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
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff014282),
          leading: Builder(
            builder: (BuildContext context) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.white)),
                  child: IconButton(
                    icon: const Icon(
                      Icons.menu,
                      color: Colors.white,
                      size: 25,
                    ),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  ),
                ),
              );
            },
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Image.asset(
                'asset/unit-1.png',
                fit: BoxFit.contain,
                height: 32,
              ),
            ],
          ),
          actions: [
            ShoppingCart(
              itemCount: countAsInt,
            )
          ],
        ),
        drawer: MyDrawer(),
        body: SafeArea(
          child: start ? ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: const Color(0xff014282),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: CustomSearchBar(),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      final SharedPreferences prefs = await SharedPreferences.getInstance();
                      var a = prefs.getStringList('product_name') ?? [];
                      if (a.length == 0){
                        _onzipcodemsg();
                      }else{
                        Fluttertoast.showToast(
                            msg: 'Area Cannot Be Changed, Because data is existing in Cart..!',
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 3,
                            backgroundColor: Color(0xff014282),
                            textColor: Colors.white,
                            fontSize: 15,
                            webPosition: "center");
                        print('no area change');
                      }
                    },
                    child: vendorName == null
                        ? Container(
                            height: MediaQuery.of(context).size.height * 0.05,
                            width: MediaQuery.of(context).size.width,
                            color: const Color(0xffe12c2e),
                            child:  Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'MYRUNCIIT BANGSAR${countAsInt == 0 ? "(Change area)": ""}',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14.0),
                                )),
                          )
                        : Container(
                            height: MediaQuery.of(context).size.height * 0.05,
                            width: MediaQuery.of(context).size.width,
                            color: const Color(0xffe12c2e),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  '$vendorName ${countAsInt == 0 ? "(Change area)": ""}',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14.0),
                                )),
                          ),
                  ),
                  Container(
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            height: size.height * 0.3,
                            width: size.width,
                            child: Carousel_slider()),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "TODAY'S DEALS",
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          height: size.height * 0.5,
                          width: size.width,
                          child: Todaysdealsgrid(),
                        ),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Deals(
                                        selectedTabIndex: 0,
                                      )),
                                );
                              },
                              child: const Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Explore all",
                                    style: TextStyle(
                                        color: Color(0xFFff7b15),
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Icon(
                                    Icons.chevron_right,
                                    color: Colors.green,
                                  )
                                ],
                              ),
                            )),
                         Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "CATEGORIES",
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                              InkWell(
                                onTap: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => all_cat(
                                        )),
                                  );
                                },
                                child: Text(
                                  "See All",
                                  style: TextStyle(
                                      fontSize: 12, fontWeight: FontWeight.bold,color: Colors.orange),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              color: Colors.white,
                              child: const HorizontalGridView()),
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                "CATEGORY BANNERS",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                        Container(
                          height: 150,
                          width: size.width,
                          child: category_banners(),
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "LATEST PRODUCTS",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                        Container(
                          height: size.height * 0.5,
                          width: size.width,
                          child: latest_product_grid(),
                        ),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Deals(
                                            selectedTabIndex: 4,
                                          )),
                                );
                                },
                              child: const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Explore all",
                                    style: TextStyle(
                                        color: Color(0xFFff7b15),
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Icon(
                                    Icons.chevron_right,
                                    color: Colors.green,
                                  )
                                ],
                              ),
                            )),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "RECENTLY VIEWED",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                        Container(
                          height: size.height * 0.5,
                          width: size.width,
                          child: RecentlyGrid(),
                        ),
                        Padding(
                            padding: const EdgeInsets.fromLTRB(8, 15, 8, 8),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Deals(
                                            selectedTabIndex: 1,
                                          )),
                                );
                              },
                              child: const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Explore all",
                                    style: TextStyle(
                                        color: Color(0xFFff7b15),
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Icon(
                                    Icons.chevron_right,
                                    color: Colors.green,
                                  )
                                ],
                              ),
                            )),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                "MOST VIEWED",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                        Container(
                          height: size.height * 0.5,
                          width: size.width,
                          child: Most_viewedgrid(),
                        ),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Deals(
                                            selectedTabIndex: 3,
                                          )),
                                );
                              },
                              child: const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Explore all",
                                    style: TextStyle(
                                        color: Color(0xFFff7b15),
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Icon(
                                    Icons.chevron_right,
                                    color: Colors.green,
                                  )
                                ],
                              ),
                            )),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Container(
                            width: size.width,
                            height: size.height * 0.5,
                            color: Colors.white,
                            child: blogs != null
                                ? ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: blogs.length,
                              itemBuilder: (context, index) {
                                String summary1 = blogs[index]['summery'];
                                String summary = Bidi.stripHtmlIfNeeded(summary1);
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Stack(
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          print('rangerover');
                                          final SharedPreferences
                                          prefs =
                                          await SharedPreferences
                                              .getInstance();
                                          var blog_title =
                                          blogs[index]
                                          ['title'];
                                          await prefs.setString(
                                              'blogstitle',
                                              '${blog_title}');
                                          print(
                                              'blog_title>>>>$blog_title');

                                          var blog_summary =
                                          blogs[index]
                                          ['summery'];
                                          await prefs.setString(
                                              'blogssummary',
                                              '${blog_summary}');
                                          print(
                                              'blog_summary>>>>$blog_summary');

                                          var blog_author =
                                          blogs[index]
                                          ['author'];
                                          await prefs.setString(
                                              'blogauthor',
                                              '${blog_author}');
                                          print(
                                              'blog_author>>>>$blog_author');

                                          var blog_date =
                                          blogs[index]
                                          ['date'];
                                          await prefs.setString(
                                              'blogdate',
                                              '${blog_date}');
                                          print(
                                              'blog_date>>>>$blog_date');

                                          var blog_desc = blogs[
                                          index]
                                          ['description'];
                                          await prefs.setString(
                                              'blogdesc',
                                              '${blog_desc}');
                                          print(
                                              'blog_desc>>>>$blog_desc');

                                          var blog_category =
                                          blogs[index][
                                          'blog_category_name'];
                                          await prefs.setString(
                                              'blogcategory',
                                              '${blog_category}');
                                          print(
                                              'blog_category>>>>$blog_category');

                                          var blog_image =
                                          blogs[index][
                                          'image_src'];
                                          await prefs.setString(
                                              'blogimage',
                                              '${blog_image}');
                                          print(
                                              'blog_image>>>>$blog_image');

                                          var blog_link =
                                          blogs[index]
                                          ['link'];
                                          await prefs.setString(
                                              'bloglink',
                                              '${blog_link}');
                                          print(
                                              'blog_image>>>>$blog_link');

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Blogs_Detail(
                                                      blogs_link:
                                                      blogs[index]
                                                      ['link'],
                                                    )),
                                          );
                                        },
                                        child: Container(
                                          height: size.height * 0.35,
                                          width: size.width * 0.7,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                  blogs[index]
                                                  ['image_src']),
                                              fit: BoxFit.fill,
                                            ),
                                            color: Colors.grey,
                                            borderRadius:
                                            BorderRadius.all(
                                                Radius.circular(25)),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 110,
                                        left: 10,
                                        child: InkWell(
                                          onTap: () async{
                                            print('rangerover');
                                            final SharedPreferences
                                            prefs =
                                            await SharedPreferences
                                                .getInstance();
                                            var blog_title =
                                            blogs[index]
                                            ['title'];
                                            await prefs.setString(
                                                'blogstitle',
                                                '${blog_title}');
                                            print(
                                                'blog_title>>>>$blog_title');

                                            var blog_summary =
                                            blogs[index]
                                            ['summery'];
                                            await prefs.setString(
                                                'blogssummary',
                                                '${blog_summary}');
                                            print(
                                                'blog_summary>>>>$blog_summary');

                                            var blog_author =
                                            blogs[index]
                                            ['author'];
                                            await prefs.setString(
                                                'blogauthor',
                                                '${blog_author}');
                                            print(
                                                'blog_author>>>>$blog_author');

                                            var blog_date =
                                            blogs[index]
                                            ['date'];
                                            await prefs.setString(
                                                'blogdate',
                                                '${blog_date}');
                                            print(
                                                'blog_date>>>>$blog_date');

                                            var blog_desc = blogs[
                                            index]
                                            ['description'];
                                            await prefs.setString(
                                                'blogdesc',
                                                '${blog_desc}');
                                            print(
                                                'blog_desc>>>>$blog_desc');

                                            var blog_category =
                                            blogs[index][
                                            'blog_category_name'];
                                            await prefs.setString(
                                                'blogcategory',
                                                '${blog_category}');
                                            print(
                                                'blog_category>>>>$blog_category');

                                            var blog_image =
                                            blogs[index][
                                            'image_src'];
                                            await prefs.setString(
                                                'blogimage',
                                                '${blog_image}');
                                            print(
                                                'blog_image>>>>$blog_image');

                                            var blog_link =
                                            blogs[index]
                                            ['link'];
                                            await prefs.setString(
                                                'bloglink',
                                                '${blog_link}');
                                            print(
                                                'blog_image>>>>$blog_link');

                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Blogs_Detail(
                                                        blogs_link:
                                                        blogs[index]
                                                        ['link'],
                                                      )),
                                            );
                                          },
                                          child: Container(
                                            height: size.height * 0.2,
                                            width: size.width * 0.7,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                              BorderRadius.all(
                                                  Radius.circular(
                                                      15)),
                                            ),
                                            child: SingleChildScrollView(
                                              scrollDirection:
                                              Axis.vertical,
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets
                                                        .all(8.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .start,
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                      children: [
                                                        Icon(
                                                          Icons.bookmark,
                                                          color: Colors
                                                              .grey
                                                              .shade700,
                                                          size: 20,
                                                        ),
                                                        Container(
                                                          width: MediaQuery.of(
                                                              context)
                                                              .size
                                                              .width *
                                                              0.6,
                                                          child:
                                                          AutoSizeText(
                                                            '${blogs[index]['title']}',
                                                            style: TextStyle(
                                                                color: Color(
                                                                    0xff1f7036),
                                                                fontSize:
                                                                14),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets
                                                        .all(4.0),
                                                    child: Container(
                                                      width: MediaQuery.of(
                                                          context)
                                                          .size
                                                          .width *
                                                          5,
                                                      child: AutoSizeText(
                                                        '${summary}',
                                                        style: TextStyle(
                                                            color: Colors
                                                                .black,
                                                            fontSize: 14),
                                                      ),
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () async {
                                                      print('rangerover');
                                                      final SharedPreferences
                                                      prefs =
                                                      await SharedPreferences
                                                          .getInstance();
                                                      var blog_title =
                                                      blogs[index]
                                                      ['title'];
                                                      await prefs.setString(
                                                          'blogstitle',
                                                          '${blog_title}');
                                                      print(
                                                          'blog_title>>>>$blog_title');

                                                      var blog_summary =
                                                      blogs[index]
                                                      ['summery'];
                                                      await prefs.setString(
                                                          'blogssummary',
                                                          '${blog_summary}');
                                                      print(
                                                          'blog_summary>>>>$blog_summary');

                                                      var blog_author =
                                                      blogs[index]
                                                      ['author'];
                                                      await prefs.setString(
                                                          'blogauthor',
                                                          '${blog_author}');
                                                      print(
                                                          'blog_author>>>>$blog_author');

                                                      var blog_date =
                                                      blogs[index]
                                                      ['date'];
                                                      await prefs.setString(
                                                          'blogdate',
                                                          '${blog_date}');
                                                      print(
                                                          'blog_date>>>>$blog_date');

                                                      var blog_desc = blogs[
                                                      index]
                                                      ['description'];
                                                      await prefs.setString(
                                                          'blogdesc',
                                                          '${blog_desc}');
                                                      print(
                                                          'blog_desc>>>>$blog_desc');

                                                      var blog_category =
                                                      blogs[index][
                                                      'blog_category_name'];
                                                      await prefs.setString(
                                                          'blogcategory',
                                                          '${blog_category}');
                                                      print(
                                                          'blog_category>>>>$blog_category');

                                                      var blog_image =
                                                      blogs[index][
                                                      'image_src'];
                                                      await prefs.setString(
                                                          'blogimage',
                                                          '${blog_image}');
                                                      print(
                                                          'blog_image>>>>$blog_image');

                                                      var blog_link =
                                                      blogs[index]
                                                      ['link'];
                                                      await prefs.setString(
                                                          'bloglink',
                                                          '${blog_link}');
                                                      print(
                                                          'blog_image>>>>$blog_link');

                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                Blogs_Detail(
                                                                  blogs_link:
                                                                  blogs[index]['link'],
                                                                )),
                                                      );
                                                    },
                                                    child: const Padding(
                                                      padding:
                                                      EdgeInsets.all(
                                                          8.0),
                                                      child: Text(
                                                          'Read More',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .green,
                                                              fontSize:
                                                              14,
                                                              decoration:
                                                              TextDecoration
                                                                  .underline)),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            )
                                : Center(
                              child:
                              CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),), // or any other loading indicator
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ],
          ) : Center(child: CircularProgressIndicator(),),
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
          currentIndex: 0,
          selectedItemColor: Colors.green.shade600,
          unselectedItemColor: Colors.black,
          selectedIconTheme: IconThemeData(color: Colors.green.shade600),
          unselectedIconTheme: const IconThemeData(color: Colors.black),
          onTap: (int index) async {
            switch (index) {
              case 0:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProductScreen()),
                );

                print('Tapped on Home');
                break;
              case 1:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Categories2()),
                );
                print('Tapped on Categories');
                break;
              case 2:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Favourites()),
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

                  if (user_id != "")
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
