import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:myrunciit/drawer/Address/address_list.dart';
import 'package:myrunciit/product_screen/product_main_screen.dart';
import 'package:myrunciit/roots/roots.dart';
import 'package:myrunciit/widget/cart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';

List<String> item_name1 = [];
List<String> item_qty1 = [];
List<String> item_img1 = [];
List<String> item_price1 = [];
List<String> item_discount1 = [];
bool payment_type = false;
var user_id11, store_id;

var selected_address = "";

class FinalizationOrder extends StatefulWidget {
  // final String categoryName, categoryImage, sale_price, current_stock, description, discount;

  // var categoryName, categoryImage, sale_price, current_stock, description, discount;

  // FinalizationOrder({
  //   required this.categoryName,
  //   required this.categoryImage,
  //   required this.sale_price,
  //   required this.current_stock,
  //   required this.description,
  //   required this.discount,
  // });

  @override
  State<FinalizationOrder> createState() => _FinalizationOrderState();
}

class _FinalizationOrderState extends State<FinalizationOrder> {
  List<String> ordername1 = [];
  List<String> orderqty1 = [];
  List<String> orderimg1 = [];
  List<String> orderprice1 = [];
  List<String> orderdiscount1 = [];
  bool isContainerPressed = false;
  TextEditingController couponController = TextEditingController();
  int itemCount = 0;
  int count = 1;
  List coupon = [];
  String selectedCouponCode = "";
  bool isCouponAvailable = false;
  bool isChecked = false;
  var item_q = 0;
  var tot_price = "0.0";
  var selectedValue = 1;
  List item_name = [];
  List item_qty = [];
  List item_img = [];
  List item_price = [];
  List item_discount = [];
  int counter = 0;
  bool remove = false;
  List shipping_address = [];
  int selectedContainerIndex = 0;

  static int currentTimeInSeconds() {
    var ms = (new DateTime.now()).millisecondsSinceEpoch;
    return (ms / 1000).round();
  }

  make_selected(index)
  {
    setState(() {
      selected_address = index.toString();
      get_lalamove_quotation(index);
    });
  }

  get_lalamove_quotation(index) async
  {
    print("hello ${currentTimeInSeconds()}");
    var timeinsec = currentTimeInSeconds();
    var lalamove_path = "/v3/quotations";
    var url = 'https://rest.lalamove.com${lalamove_path}';
    var store = '{"coordinates": {"lat": "3.128620","lng": "101.677689"},"address": "21, Jalan Bangsar, Bangsar, Kuala Lumpur, Malaysia, 59000"}';
    var stops = '{"coordinates": {"lat": "${shipping_address[index]["latitude"]}","lng": "${shipping_address[index]["longitude"]}"},"address": "${shipping_address[index]["address"]}"}';
    var body = {"data" : {
      "serviceType": "MOTORCYCLE",
      "specialRequests": [],
      "language": "en_MY",
      "stops": [store, stops]
    }};
    print("request body =>> ${body}");
    var time = (timeinsec * 1000);
    var method = 'POST';
    var region = 'MY';
    var hash_string = "${time}\r\n${method}\r\n${lalamove_path}\r\n\r\n${body}";
    var lalamove_secret = 'sk_prod_QjJ0EtPk0xcC8kAhKpbY28we4GPL0p7sBAZtdCAnoL5uBkzCnLgDWKhLPkkMsYwg';
    var lalamove_apiKey = 'pk_prod_7ab9bb93e0b18c42ceafac3e04fcdb59';

    var key = utf8.encode(lalamove_secret);
    var bytes = utf8.encode(hash_string);

    var hmacSha256 = new Hmac(sha512, key); // HMAC-SHA256
    var token = "${lalamove_apiKey}:${time}:${hmacSha256}";
    var head = {
      'Content-type': 'application/json; charset=utf-8',
      'Accept': 'application/json',
      'Authorization': 'hmac ${token}',
      'Market': '${region}'
    };
    // var startTime = microtime(true);
    print("header =>> ${head}");
    print("hmac =>> ${hmacSha256}");

    var response = await http.post(Uri.parse(url),
      headers: {
        'Content-type': 'application/json; charset=utf-8',
        'Accept': 'application/json',
        'Authorization': 'hmac ${token}',
        'Market': '${region}'
      },
      body: json.encode(body),
    );
    print("lalamove response =>> ${response.body}");

    // dynamic response = await http.get(Uri.parse(url1));
    // var jsonResponse = jsonDecode(response.body);
  }

  getProduct() async {
    String url1 = "$root_web/show_coupon/${store_id}";
    dynamic response = await http.get(Uri.parse(url1));
    if (response.statusCode == 200) {
      print('success');
      print(response.body);
      dynamic jsonResponse = jsonDecode(response.body);
      print(jsonResponse);

      // Check if the response is valid and contains the expected data
      if (jsonResponse != null &&
          jsonResponse['Response'] != null &&
          jsonResponse['Response']['available_coupons'] != null &&
          jsonResponse['Response']['available_coupons']['available_coupon'] !=
              null) {
        setState(() {
          // Access the array of categories from the response
          coupon =
          jsonResponse['Response']['available_coupons']['available_coupon'];
          print(coupon);
        });
      } else {
        print("Invalid response format or missing data");
      }
    } else {
      print("failure");
    }
  }

  void setSelectedCouponCode(String code) {
    setState(() {
      selectedCouponCode = code;
      couponController.text = code; // Update the TextEditingController
    });
  }

  getstoreid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      store_id = prefs.getString('storeid');
    });
    print('gridview3store_id===>>> $store_id');
  }

  void initState() {
    getProduct();
    setState(() {
      selected_address = "";
      getstoreid();
    });
    show_cart_items();
    getaddresslist();
    super.initState();
  }

  _select_address() {
    if (isContainerPressed) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              height: 350,
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListView.builder(
                      itemCount: shipping_address.length,
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: GestureDetector(
                            onTap: (){
                              make_selected(index);
                              setState(() {
                                selected_address = index.toString();
                                // selectedValue = value as int;
                              });
                              Navigator.pop(context);
                            },
                            child: Container(
                              color: Colors.grey,
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.1,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Radio(
                                      value: shipping_address[index]["unique_id"],
                                      groupValue: selected_address == index.toString() ? true : false,
                                      activeColor: Colors.cyan,
                                      onChanged: (value) {
                                        make_selected(index);
                                        setState(() {
                                          selected_address = index.toString();
                                          // selectedValue = value as int;
                                        });
                                        Navigator.pop(context);
                                      },
                                    ),
                                    Center(
                                      child: Container(
                                          height:
                                          MediaQuery.of(context).size.height *
                                              0.1,
                                          width:
                                          MediaQuery.of(context).size.width *
                                              0.7,
                                          child: AutoSizeText(
                                            '${shipping_address[index]['name'] + ',' + shipping_address[index]['address'] + ',' + shipping_address[index]['address1'] + ',' + shipping_address[index]['zip_code'] + ',' + shipping_address[index]['country'] + ',' + shipping_address[index]['state'] + ',' + shipping_address[index]['mobile']}',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 13.0),
                                          )),
                                    ),
                                    Divider(
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  getaddresslist() async {
    SharedPreferences prefs1 = await SharedPreferences.getInstance();
    user_id11 = prefs1.getString('store_id');
    String url1 = "$root_web/profile/address_list/0/${user_id11}";
    print('get_address_list$url1');
    dynamic response = await http.get(Uri.parse(url1));
    var jsonResponse = jsonDecode(response.body);
    var status = jsonResponse["status"];
    if (status == "SUCCESS") {
      print('shipping_address ====>>>>');
      shipping_address =
      jsonResponse["response"];
      print('shipping_addressfdhgd====>>>> ${shipping_address.length}');
      print("ship =>> ${shipping_address}");
    } else {
      print("failure${jsonResponse["Message"]}");
    }
  }

  show_cart_items() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      item_name = prefs.getStringList('product_name') ?? [];
      item_qty = prefs.getStringList('qty') ?? [];
      item_img = prefs.getStringList('product_image') ?? [];
      item_price = prefs.getStringList('product_price') ?? [];
      item_discount = prefs.getStringList('product_discount') ?? [];
    });
  }

  void addToCart() {
    setState(() {
      itemCount++;
    });
  }

  void incrementCount() {
    setState(() {
      count++;
    });
  }

  void decrementCount() {
    if (count > 0) {
      setState(() {
        count--;
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

      print('countAsInt$countAsInt');
      counter = item_name.length;
      countAsInt = item_name.length;
      print('countAsInt$countAsInt');
    });
    await prefs.setStringList('qty1', item_qty1);
    await prefs.setStringList('product_name1', item_name1);
    await prefs.setStringList('product_image1', item_img1);
    await prefs.setStringList('product_price1', item_price1);
    await prefs.setStringList('product_discount1', item_discount1);
    print('item_qty1$item_qty');
    print('item_name1$item_name');
    print('item_img1$item_img');
    print('item_price1$item_price');
    print('item_discount1$item_discount');

    item_qty_calc();
  }

  cancelorder() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      item_qty.clear();
      item_name.clear();
      item_img.clear();
      item_price.clear();
      item_discount.clear();

      print('countAsInt$countAsInt');
      counter = item_name.length;
      countAsInt = item_name.length;
      print('countAsInt$countAsInt');
    });
    await prefs.setStringList('qty1', item_qty1);
    await prefs.setStringList('product_name1', item_name1);
    await prefs.setStringList('product_image1', item_img1);
    await prefs.setStringList('product_price1', item_price1);
    await prefs.setStringList('product_discount1', item_discount1);
    print('item_qty1$item_qty');
    print('item_name1$item_name');
    print('item_img1$item_img');
    print('item_price1$item_price');
    print('item_discount1$item_discount');

    item_qty_calc();
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
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
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                "Finalization of the order",
                style: TextStyle(color: Colors.white, fontSize: 15),
              )
            ],
          ),
          actions: [
            ShoppingCart(
              itemCount: itemCount,
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(0.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                        child: Column(children: [
                          Container(
                            height: size.height * 0.05,
                            width: size.width,
                            child: Center(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "1. Orders",
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Quantity($counter)",
                                    style: TextStyle(fontSize: 17),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "RM",
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            decoration: BoxDecoration(
                              border: Border(
                                  bottom:
                                  BorderSide(color: Colors.grey.shade400)),
                              color: Colors.white,
                            ),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Container(
                              height: size.height * 1.5,
                              width: size.width,
                              color: Colors.white,
                              child: Column(
                                children: [
                                  ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: item_name.length,
                                    itemBuilder: (context, index) {
                                      return Row(
                                        children: [
                                          Padding(
                                            padding:
                                            const EdgeInsets.all(8.0),
                                            child: Container(
                                              // height: size.height * 0.2,
                                                width: size.width * 0.2,
                                                child: Image.network(
                                                    item_img[index])),
                                          ),
                                          Padding(
                                            padding:
                                            const EdgeInsets.fromLTRB(
                                                25, 0, 5, 0),
                                            child: Container(
                                              width: size.width * 0.6,
                                              color: Colors.white,
                                              child: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceEvenly,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      Container(
                                                          width: size.width *
                                                              0.4,
                                                          child: Text(
                                                              item_name[
                                                              index])),
                                                      IconButton(
                                                          onPressed: () {
                                                            remove == true;
                                                            remove_item(
                                                                index);
                                                          },
                                                          icon: Icon(
                                                            Icons
                                                                .close_rounded,
                                                            color: Colors.red,
                                                            size: 17,
                                                          ))
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "RM",
                                                        style: TextStyle(
                                                          fontSize: 10,
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                      // Text(
                                                      //   widget.sale_price,
                                                      //   style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.red),
                                                      // ),
                                                      if (int.tryParse(
                                                          item_discount[
                                                          index]) !=
                                                          null &&
                                                          int.parse(
                                                              item_discount[
                                                              index]) >
                                                              0)
                                                        Text.rich(
                                                          TextSpan(
                                                            children: <TextSpan>[
                                                              new TextSpan(
                                                                text:
                                                                item_price[
                                                                index],
                                                                style:
                                                                new TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  decoration:
                                                                  TextDecoration
                                                                      .lineThrough,
                                                                ),
                                                              ),
                                                              new TextSpan(
                                                                text: (double.parse(item_price[
                                                                index]) -
                                                                    (double.parse(item_price[index]) *
                                                                        (double.parse(item_discount[index]) *
                                                                            0.01)))
                                                                    .toStringAsFixed(
                                                                    2),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      else
                                                        Text.rich(
                                                          TextSpan(
                                                            // text: 'This item costs ',
                                                            children: <TextSpan>[
                                                              new TextSpan(
                                                                text:
                                                                item_price[
                                                                index],
                                                                style:
                                                                new TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                  Padding(
                                    padding:
                                    const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                    child: Container(
                                      // height: size.height*0.15,
                                      width: size.width,
                                      decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey.shade400)),
                                        color: Colors.white,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding:
                                            const EdgeInsets.fromLTRB(
                                                8, 0, 8, 0),
                                            child: Container(
                                              // height: size.height*0.15,
                                              width: size.width,
                                              decoration: BoxDecoration(
                                                border: Border(
                                                    bottom: BorderSide(
                                                        color: Colors
                                                            .grey.shade400)),
                                                color: Colors.white,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(0, 8, 0, 0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                      // mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          "Shopping Cart",
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold),
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Padding(
                                                          padding:
                                                          const EdgeInsets
                                                              .only(
                                                              left: 8),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                            children: [
                                                              Text(
                                                                "Subtotal:",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                    13,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                              ),
                                                              Text(
                                                                "RM49.00",
                                                                style:
                                                                TextStyle(
                                                                  fontSize:
                                                                  13,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Padding(
                                                          padding:
                                                          const EdgeInsets
                                                              .only(
                                                              left: 8),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                            children: [
                                                              Text(
                                                                "Tax:",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                    13,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                              ),
                                                              Text(
                                                                "RM0.00",
                                                                style:
                                                                TextStyle(
                                                                  fontSize:
                                                                  13,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Padding(
                                                          padding:
                                                          const EdgeInsets
                                                              .only(
                                                              left: 8),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                            children: [
                                                              Text(
                                                                "Coupon Discount:",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                    13,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                              ),
                                                              Text(
                                                                "RM0.00",
                                                                style:
                                                                TextStyle(
                                                                  fontSize:
                                                                  13,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Padding(
                                                          padding:
                                                          const EdgeInsets
                                                              .only(
                                                              left: 8),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                            children: [
                                                              Text(
                                                                "Delivery Estimate:",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                    13,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                              ),
                                                              Text(
                                                                "RM0.00",
                                                                style:
                                                                TextStyle(
                                                                  fontSize:
                                                                  13,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Container(
                                                          // height: size.height*0.15,
                                                          width: size.width,
                                                          decoration:
                                                          BoxDecoration(
                                                            border: Border(
                                                                bottom: BorderSide(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade400),
                                                                top: BorderSide(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade400)),
                                                            color:
                                                            Colors.white,
                                                          ),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                const EdgeInsets
                                                                    .fromLTRB(
                                                                    0,
                                                                    8,
                                                                    0,
                                                                    0),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                                  // mainAxisAlignment: MainAxisAlignment.start,
                                                                  children: [
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                          8),
                                                                      child:
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                        MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Text(
                                                                            "Grand Total:",
                                                                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                                                          ),
                                                                          Text(
                                                                            "RM49.00",
                                                                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                      5,
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                          8),
                                                                      child:
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                        MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Text(
                                                                            "Available Reward:",
                                                                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              Text("RM1151.77"),
                                                                              SizedBox(
                                                                                width: 5,
                                                                              ),
                                                                              Container(
                                                                                width: size.width * 0.07,
                                                                                child: Checkbox(
                                                                                  value: isChecked,
                                                                                  onChanged: (bool? value) {
                                                                                    setState(() {
                                                                                      isChecked = value!;
                                                                                    });
                                                                                  },
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                "Use Reward",
                                                                                style: TextStyle(color: Colors.grey.shade800),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                      5,
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .all(
                                                                          8.0),
                                                                      child:
                                                                      Column(
                                                                        crossAxisAlignment:
                                                                        CrossAxisAlignment.start,
                                                                        // mainAxisAlignment: MainAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            "Enter Your Coupon Code If You Have One",
                                                                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                                                          ),
                                                                          SizedBox(
                                                                            height: 8,
                                                                          ),
                                                                          Container(
                                                                            height: 30,
                                                                            child: TextFormField(
                                                                              cursorColor: Colors.grey,
                                                                              enabled: !isCouponAvailable,
                                                                              controller: couponController,
                                                                              decoration: const InputDecoration(
                                                                                  contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0), // Adjust the padding as needed

                                                                                  hintText: 'Enter your Coupen Code',
                                                                                  border: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFFeeeeee))),
                                                                                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFFeeeeee)))),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            height: 2,
                                                                          ),
                                                                          Container(
                                                                            width: size.width,
                                                                            child: ElevatedButton(
                                                                              onPressed: () {},
                                                                              child: Text(
                                                                                "APPLY COUPON",
                                                                                style: TextStyle(color: Colors.white),
                                                                              ),
                                                                              style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade900),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            height: 10,
                                                                          ),
                                                                          Text(
                                                                            "Available Coupon Code",
                                                                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                    const EdgeInsets.fromLTRB(4, 0, 4, 0),
                                    child: Container(
                                      // height: size.height*0.15,
                                      width: size.height,
                                      // decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade400))   ,                 color: Colors.white,
                                      // ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.1),
                                                spreadRadius: 2,
                                                blurRadius: 4,
                                                offset: Offset(2, 2),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                const EdgeInsets.all(8.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .start,
                                                  // mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      height: 8,
                                                    ),
                                                    Column(
                                                      children: [
                                                        for (var couponItem
                                                        in coupon)
                                                          for (int i = 0;
                                                          i < 1;
                                                          i++)
                                                            if (couponItem[
                                                            'coupon_id'] ==
                                                                '9')
                                                              Row(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets.all(8.0),
                                                                    child: Container(
                                                                      width: size
                                                                          .width *
                                                                          0.4,
                                                                      height: size
                                                                          .height *
                                                                          0.04,
                                                                      color: Colors
                                                                          .yellow,
                                                                      child: Center(
                                                                          child: Text(
                                                                            couponItem[
                                                                            'code'],
                                                                            textAlign:
                                                                            TextAlign.center,
                                                                          )),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    height: size
                                                                        .height *
                                                                        0.035,
                                                                    width: size
                                                                        .width *
                                                                        0.3,
                                                                    child:
                                                                    ElevatedButton(
                                                                      onPressed:
                                                                          () {
                                                                        setSelectedCouponCode(
                                                                            couponItem['code']);
                                                                        setState(
                                                                                () {
                                                                              isCouponAvailable =
                                                                              true; // Set the flag to true
                                                                            });
                                                                      },
                                                                      child: Text(
                                                                          "Available"),
                                                                      style: ElevatedButton.styleFrom(
                                                                          backgroundColor:
                                                                          Colors.red),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                        SizedBox(
                                                          width: size.width *
                                                              0.15,
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 8,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "Minimum order ",
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold,
                                                              color: Colors
                                                                  .green),
                                                        ),
                                                        Text(
                                                          "RM",
                                                          style: TextStyle(
                                                              fontSize: 7,
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold,
                                                              color: Colors
                                                                  .green),
                                                        ),
                                                        Text(
                                                          "20",
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold,
                                                              color: Colors
                                                                  .green),
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
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                            Colors.black.withOpacity(0.1),
                                            spreadRadius: 2,
                                            blurRadius: 4,
                                            offset: Offset(2, 2),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding:
                                            const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              // mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                    width: size.width,
                                                    decoration: BoxDecoration(
                                                        border: Border(
                                                            bottom: BorderSide(
                                                                color: Colors
                                                                    .grey
                                                                    .shade400))),
                                                    child: const Padding(
                                                      padding:
                                                      EdgeInsets.only(
                                                          bottom: 5),
                                                      child: Text(
                                                        "2. Place Of Delivery",
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                            FontWeight
                                                                .bold),
                                                      ),
                                                    )),
                                                SizedBox(
                                                  height: 18,
                                                ),
                                                Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                    ),
                                                    width: size.width,
                                                    child: Text(
                                                      "Select Address:",
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                          FontWeight
                                                              .bold),
                                                    )),
                                                InkWell(
                                                  onTap: () {
                                                    print(
                                                        'place_delivery_address_clicked');
                                                    setState(() {
                                                      print(
                                                          'place_delivery_selected');
                                                      isContainerPressed =
                                                      !isContainerPressed;
                                                    });
                                                    _select_address();
                                                  },
                                                  child: Container(
                                                    height: size.height * 0.1,
                                                    decoration: BoxDecoration(
                                                      // color: Colors.red,
                                                        border: Border(
                                                            bottom: BorderSide(
                                                                color: Colors
                                                                    .grey
                                                                    .shade400))),
                                                    width: size.width,
                                                    child: selected_address != "" ? AutoSizeText(
                                                      '${shipping_address[int.parse(selected_address.toString())]['name'] + ',' + shipping_address[int.parse(selected_address.toString())]['address'] + ',' + shipping_address[int.parse(selected_address.toString())]['address1'] + ',' + shipping_address[int.parse(selected_address.toString())]['zip_code'] + ',' + shipping_address[int.parse(selected_address.toString())]['country'] + ',' + shipping_address[int.parse(selected_address.toString())]['state'] + ',' + shipping_address[int.parse(selected_address.toString())]['mobile']}',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 13.0),
                                                    ) : SizedBox(),
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                  AddressList()),
                                                        );
                                                      },
                                                      child: Text(
                                                          "+ Add Address:",
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold,
                                                              color: Colors
                                                                  .blueAccent)),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.only(
                                                      left: 10),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        payment_type =
                                                        !payment_type;
                                                      });
                                                    },
                                                    child: Container(
                                                      color:
                                                      Colors.red.shade800,
                                                      child: const Padding(
                                                        padding: EdgeInsets
                                                            .fromLTRB(
                                                            30, 7, 30, 7),
                                                        child: Text(
                                                          "Next",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          if (payment_type)
                                            Padding(
                                              padding:
                                              const EdgeInsets.all(2.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets.all(
                                                        8.0),
                                                    child: Text(
                                                      'Payment Type :',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 12.0,
                                                          fontWeight:
                                                          FontWeight
                                                              .bold),
                                                    ),
                                                  ),
                                                  Container(
                                                    color: Colors.white,
                                                    width:
                                                    MediaQuery.of(context)
                                                        .size
                                                        .width,
                                                    height:
                                                    MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                        0.15,
                                                    child:
                                                    SingleChildScrollView(
                                                        scrollDirection:
                                                        Axis.horizontal,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () {
                                                                setState(
                                                                        () {
                                                                      selectedContainerIndex =
                                                                      0;
                                                                    });
                                                              },
                                                              child:
                                                              Center(
                                                                child:
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                      .all(
                                                                      8.0),
                                                                  child:
                                                                  Container(
                                                                    width:
                                                                    MediaQuery.of(context).size.width * 0.18,
                                                                    height:
                                                                    MediaQuery.of(context).size.height * 0.07,
                                                                    decoration:
                                                                    BoxDecoration(
                                                                      border:
                                                                      Border.all(
                                                                        color: selectedContainerIndex == 0 ? Colors.blue : Colors.transparent,
                                                                        width: 2.0,
                                                                      ),
                                                                    ),
                                                                    child:
                                                                    Padding(
                                                                      padding:
                                                                      const EdgeInsets.all(8.0),
                                                                      child:
                                                                      Image.asset('asset/ipay88.png', fit: BoxFit.fitWidth),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            GestureDetector(
                                                              onTap: () {
                                                                setState(
                                                                        () {
                                                                      selectedContainerIndex =
                                                                      1;
                                                                    });
                                                              },
                                                              child:
                                                              Center(
                                                                child:
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                      .all(
                                                                      8.0),
                                                                  child:
                                                                  Container(
                                                                    width:
                                                                    MediaQuery.of(context).size.width * 0.18,
                                                                    height:
                                                                    MediaQuery.of(context).size.height * 0.07,
                                                                    decoration:
                                                                    BoxDecoration(
                                                                      border:
                                                                      Border.all(
                                                                        color: selectedContainerIndex == 1 ? Colors.blue : Colors.transparent,
                                                                        width: 2.0,
                                                                      ),
                                                                    ),
                                                                    child:
                                                                    Padding(
                                                                      padding:
                                                                      const EdgeInsets.all(8.0),
                                                                      child:
                                                                      Image.asset('asset/wallet.png', fit: BoxFit.fitWidth),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            GestureDetector(
                                                              onTap: () {
                                                                setState(
                                                                        () {
                                                                      selectedContainerIndex =
                                                                      2;
                                                                    });
                                                              },
                                                              child:
                                                              Center(
                                                                child:
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                      .all(
                                                                      8.0),
                                                                  child:
                                                                  Container(
                                                                    width:
                                                                    MediaQuery.of(context).size.width * 0.18,
                                                                    height:
                                                                    MediaQuery.of(context).size.height * 0.07,
                                                                    decoration:
                                                                    BoxDecoration(
                                                                      border:
                                                                      Border.all(
                                                                        color: selectedContainerIndex == 2 ? Colors.blue : Colors.transparent,
                                                                        width: 2.0,
                                                                      ),
                                                                    ),
                                                                    child:
                                                                    Padding(
                                                                      padding:
                                                                      const EdgeInsets.all(8.0),
                                                                      child:
                                                                      Image.asset('asset/cash.png', fit: BoxFit.fitWidth),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        )),
                                                  ),
                                                ],
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ]),
                      ),
                    ],
                  ),
                ),
                // SizedBox(height: 15,),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Row(
          children: [
            Container(
              color: Colors.grey.shade200,
              height: 60, // Set the desired height
              width: size.width * 0.5,
              child: InkWell(
                onTap: () {
                  cancelorder();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProductScreen()),
                  );
                },
                child: Center(
                  child: Text(
                    "Cancel Order",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              color: Colors.green,
              height: 60, // Set the desired height
              width: size.width * 0.5,
              child: InkWell(
                onTap: () {
                  // Handle checkout action here
                },
                child: Center(
                  child: Text(
                    "Place Order",
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
      ),
    );
  }
}
