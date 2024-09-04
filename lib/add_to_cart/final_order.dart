import 'dart:convert';
import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myrunciit/add_to_cart/cart_available.dart';
import 'package:myrunciit/drawer/Address/address_list.dart';
import 'package:myrunciit/product_screen/product_main_screen.dart';
import 'package:myrunciit/roots/roots.dart';
import 'package:myrunciit/webview/ipay88/ipay88_integration.dart';
import 'package:myrunciit/widget/cart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';

List<String> item_name1 = [];
List<String> item_qty1 = [];
List<String> item_img1 = [];
List<String> item_price1 = [];
List<String> item_discount1 = [];
List<String> coupon_list = [];
List<String> coupon_value = [];
var selected_address_index = "";
var grand_tot = "0.0";
var chec = false;
var av_reward = "0.0";
var response_url;
var coupon_amount, coupon_disc = 0;
bool payment_type = false;
var delivery_estimate = "0.0";
var user_id11, discount_amount, discount_type, store_id;
var tot_tax = "0.0";
var selected_address;
var use_reward = 0;

class FinalizationOrder extends StatefulWidget {

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
  TextEditingController minamountController = TextEditingController();
  int itemCount = 0;
  int count = 1;
  List coupon = [];
  String selectedCouponCode = "";
  var lala_response = "";
  bool isCouponAvailable = false;
  bool isChecked = false;
  var item_q = 0;
  var tot_price = "0.0";
  var selectedValue = 1;
  List<String> item_name = [];
  List<String> item_qty = [];
  List<String> item_img = [];
  List<String> item_price = [];
  List<String> item_discount = [];
  List<String> item_cod = [];
  List<String> item_tax = [];
  List<String> item_tax_type = [];
  List<String> item_options = [];
  int counter = 0;
  bool remove = false;
  var shipping_address, shipping_address_name, shipping_address_address1, shipping_address_address2, shipping_address_zip_code, shipping_address_phone, shipping_address_email, shipping_address_country, shipping_address_unique_id, shipping_address_state, shipping_address_city = [];
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


  place_cod_order()async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user_id11 = prefs.getString('store_id');
    var p_d = await prefs.getString('pickup_delivery') ?? "delivery";
    var pc_date = await prefs.getString('pc_date') ?? DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
    var cartList = []; // Create an empty list to store cart items

    for (var g = 0; g < item_name.length; g++) {
      var rng = new Random();
      var code = rng.nextInt(900000) + 100000;
      var random_data = "${code}${getRandomString(10)}";
      var f = {
        "id": item_product_id[g],
        "qty": item_qty[g],
        "option": item_options[g][0],
        "price": item_price[g],
        "name": item_price[g],
        "shipping": 0,
        "tax": item_tax[g],
        "image": item_img[g],
        "coupon": "",
        "subscribamt": 0,
        "rowid": "${random_data}",
        "subtotal": (double.parse(item_price[g]) * double.parse(item_qty[g])) +
            double.parse(item_tax[g] != "" && item_tax[g].toString() != null
                ? item_tax[g]
                : "0"),
      };
      cartList.add({"${random_data}": f});
    }

    var map_data = {
      "cart": cartList,
      "user_id": user_id11, // login user_id
      "cart_total": grand_tot, // grand_total
      "langlat": null, // nul
      "shipping_cost": delivery_estimate, // delivery_estimate
      "payment_type": "cash_on_delivery",
      "shipping_address": {
        "firstname": "${shipping_address_name}",
        "address1": "${shipping_address_address1}",
        "address2": "${shipping_address_address2}",
        "zip": "${shipping_address_zip_code}",
        "phone": "${shipping_address_phone}",
        "email": "${shipping_address_email}",
        "country": "${shipping_address_country}",
        "state": "${shipping_address_state}",
        "cities": "${shipping_address_city}",
        "short_country": "" // ?
      },
      "shipping_unique_id": "${shipping_address_unique_id}",
      "vat_per": null, // ?
      "rewards": 0, // rewards ( how much you use )
      "payment_option_dis": 1, // ?
      "total_dis": coupon_amount, // coupon_dis != 0
      "lalamove_res":{lala_response},
      "order_type": p_d.toString(),
      "pickup_date" : p_d.toString() == "delivery" ? "" : pc_date.toString(),
      "order_notes" : ""
    };
    var url = "https://myrunciit.my/webservice/cart_finish/go";
    var response = await http.post(Uri.parse(url),
      body: jsonEncode(map_data),
    );
    print("cod_response =>> ${response.body}");
    if(response.body.toString().contains("SUCCESS"))
    {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('qty', []);
      await prefs.setStringList('product_name', []);
      await prefs.setStringList('product_image', []);
      await prefs.setStringList('product_price', []);
      await prefs.setStringList('product_discount', []);
      await prefs.setStringList('cod_status', []);
      await prefs.setStringList('tax', []);
      await prefs.setStringList('tax_type', []);
      await prefs.setStringList('product_id', []);
      Fluttertoast.showToast(
          msg: 'Order Placed Successfully...!',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: Color(0xff014282),
          textColor: Colors.white,
          fontSize: 15,
          webPosition: "center");
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => ProductScreen()));
    }
    else
    {
      Fluttertoast.showToast(
          msg: 'Something went Wrong..!',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: Color(0xff014282),
          textColor: Colors.white,
          fontSize: 15,
          webPosition: "center");
    }
  }

  place_wallet_order()async {

    var cartList = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var p_d = await prefs.getString('pickup_delivery') ?? "delivery";
    var pc_date = await prefs.getString('pc_date') ?? DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
    for (var g = 0; g < item_name.length; g++) {
      var rng = new Random();
      var code = rng.nextInt(900000) + 100000;
      var random_data = "${code}${getRandomString(10)}";
      var f = {
        "id": item_product_id[g],
        "qty": item_qty[g],
        "option": item_options[g][0],
        "price": item_price[g],
        "name": item_price[g],
        "shipping": 0,
        "tax": item_tax[g],
        "image": item_img[g],
        "coupon": "",
        "subscribamt": 0,
        "rowid": "${random_data}",
        "subtotal": (double.parse(item_price[g]) * double.parse(item_qty[g])) +
            double.parse(item_tax[g] != "" && item_tax[g].toString() != null
                ? item_tax[g]
                : "0"),
      };
      cartList.add({"${random_data}": f});
    }

    var map_data = {
      "cart": cartList,
      "user_id": user_id11,
      "cart_total": grand_tot,
      "langlat": null,
      "shipping_cost": delivery_estimate,
      "payment_type": "wallet",
      "shipping_address": {
        "firstname": "${shipping_address_name}",
        "address1": "${shipping_address_address1}",
        "address2": "${shipping_address_address2}",
        "zip": "${shipping_address_zip_code}",
        "phone": "${shipping_address_phone}",
        "email": "${shipping_address_email}",
        "country": "${shipping_address_country}",
        "state": null,
        "cities": "${shipping_address_city}",
        "short_country": ""
      },
      "shipping_unique_id": "${shipping_address_unique_id}",
      "vat_per": null,
      "rewards": coupon_amount,
      "payment_option_dis": 1,
      "total_dis": 10,
      "lalamove_res":lala_response.toString(),
      "order_type": p_d.toString(),
      "pickup_date" : p_d.toString() == "delivery" ? "" : pc_date.toString(),
      "order_notes" : ""
    };
    var url = "https://myrunciit.my/webservice/cart_finish/go";
    print("map_data =>> ${map_data}");
    var response = await http.post(Uri.parse(url),
      body: jsonEncode(map_data),
    );
    print("cod_response =>> ${response.body}");
    if(response.body.toString().contains("SUCCESS"))
    {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('qty', []);
      await prefs.setStringList('product_name', []);
      await prefs.setStringList('product_image', []);
      await prefs.setStringList('product_price', []);
      await prefs.setStringList('product_discount', []);
      await prefs.setStringList('cod_status', []);
      await prefs.setStringList('tax', []);
      await prefs.setStringList('tax_type', []);
      await prefs.setStringList('product_id', []);
      await prefs.setStringList('options', []);
      Fluttertoast.showToast(
          msg: 'Order Placed Successfully...!',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: Color(0xff014282),
          textColor: Colors.white,
          fontSize: 15,
          webPosition: "center");
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => ProductScreen()));
    }
    else
    {
      Fluttertoast.showToast(
          msg: 'Something went Wrong..!',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: Color(0xff014282),
          textColor: Colors.white,
          fontSize: 15,
          webPosition: "center");
    }
  }

  var _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  get_lalamove_quotation(index) async
  {
    setState(() {
      selected_address_index = index.toString();
    });
    print("hello ${currentTimeInSeconds()}");
    var timeinsec = currentTimeInSeconds();
    var lalamove_path = "/v3/quotations"; // taken from map : 3.128892771515703, 101.67896099904704
    var url = 'https://rest.lalamove.com${lalamove_path}';
    var store = {"coordinates": {"lat": "3.128620","lng": "101.677689"},"address": "21, Jalan Bangsar, Bangsar, Kuala Lumpur, Malaysia, 59000"};
    // var stops = {"coordinates": {"lat": "3.128892","lng": "101.678960"},"address": "Lorong Lengkok Abdullah, Jalan Bangsar, 59000 Kuala Lumpur, Wilayah Persekutuan Kuala Lumpur, Malaysia, 59000"};
    var stops = {"coordinates": {"lat": "${shipping_address[index]["latitude"]}","lng": "${shipping_address[index]["longitude"]}"},"address": "${shipping_address[index]["address"]}"};
    var body = jsonEncode({"data" : {
      "serviceType": "MOTORCYCLE",
      "specialRequests": [],
      "language": "en_MY",
      "stops": [store, stops]
    }});
    print("request body =>> ${body}");
    var time = (timeinsec * 1000);
    var method = 'POST';
    var region = 'MY';
    var hash_string = "${time}\r\n${method}\r\n${lalamove_path}\r\n\r\n${body}";
    var lalamove_secret = 'sk_prod_QjJ0EtPk0xcC8kAhKpbY28we4GPL0p7sBAZtdCAnoL5uBkzCnLgDWKhLPkkMsYwg';
    var lalamove_apiKey = 'pk_prod_7ab9bb93e0b18c42ceafac3e04fcdb59';

    var key1 = utf8.encode(lalamove_secret);
    var bytes1 = utf8.encode(hash_string);

    var hmacSha2561 = Hmac(sha256, key1); // HMAC-SHA256
    var digest1 = hmacSha2561.convert(bytes1);

    print("digest1: ${digest1}");
    var token = "${lalamove_apiKey}:${time}:${digest1}";
    var head = {
      'Content-type': 'application/json; charset=utf-8',
      'Accept': 'application/json',
      'Authorization': 'hmac ${token}',
      'Market': '${region}'
    };
    print("header =>> ${head}");

    var response = await http.post(Uri.parse(url),
      headers: {
        'Content-type': 'application/json; charset=utf-8',
        'Accept': 'application/json',
        'Authorization': 'hmac ${token}',
        'Market': '${region}'
      },
      body: body,
    );
    print("lalamove response =>> ${response.body}");
    setState(() {
      lala_response = response.body.toString();
    });
    var parsed_data = json.decode(response.body);
    print("heheehee ${parsed_data["data"]["priceBreakdown"]["total"].toString()}");
    if(response.body.toString().contains("message"))
    {
      print("i am in");
    }
    else
    {
      print("i ama out");
      setState(() {
        delivery_estimate = parsed_data["data"]["priceBreakdown"]["total"].toString();
        item_qty_calc();
        print("i ama out ${delivery_estimate}");
      });

    }
  }

  // get_place_order() async{
  //     String url = "$root_web/cart_finish/go";
  //     print('get_place_order$url');
  //     Map data = {
  //       "cart":   {
  //         "0fcbc61acd0479dc77e3cccc0f5ffca7": {
  //           "id": 531,
  //           "qty": 2,
  //           "option": "{\"color\":{\"title\":\"Color\",\"value\":\"rgba(204,204,204,1)\"}}",
  //           "price": 17.5,
  //           "name": "Eggs Grade A 10pcs",
  //           "shipping": 0,
  //           "tax": 0,
  //           "image": "https://myrunciit.my/uploads/product_image/product_531_1_thumb.jpg",
  //           "coupon": "",
  //           "subscribamt": 1,
  //           "rowid": "0fcbc61acd0479dc77e3cccc0f5ffca7",
  //           "subtotal": 35
  //         },
  //         "b9228e0962a78b84f3d5d92f4faa000b": {
  //           "id": 412,
  //           "qty": 2,
  //           "option": "{\"color\":{\"title\":\"Color\",\"value\":\"rgba(228,72,72,1)\"}}",
  //           "price": 17,
  //           "name": "DORY FILLET",
  //           "shipping": 0,
  //           "tax": 0,
  //           "image": "https://myrunciit.my/uploads/product_image/product_412_1_thumb.jpg",
  //           "coupon": "",
  //           "subscribamt": 1,
  //           "rowid": "b9228e0962a78b84f3d5d92f4faa000b",
  //           "subtotal": 34
  //         }
  //       },
  //       "user_id": 23,
  //       "cart_total": 1180,
  //       "langlat": null,
  //       "shipping_cost": 20.00,
  //       "payment_type": "ipay88",
  //       "shipping_address": {
  //         "firstname": "prs",
  //         "address1": "Lot 1, Kompleks MBPP, 61, Lebuh Pantai",
  //         "address2": "61",
  //         "zip": "10200",
  //         "phone": "9629839594",
  //         "email": "vprasath5@gmail.com",
  //         "country": "Malaysia",
  //         "state": null,
  //         "cities": "Lebuh Pantai",
  //         "short_country": ""
  //       },
  //       "shipping_unique_id": "SHIP487648780979",
  //       "vat_per": null,
  //       "rewards": 2444.22,
  //       "payment_option_dis": 1,
  //       "total_dis": 10,
  //       "lalamove_res":{"2":"{\"data\":{\"quotationId\":\"2847024211698963016\",\"scheduleAt\":\"2023-12-02T03:31:19.00Z\",\"expiresAt\":\"2023-12-02T03:36:19.00Z\",\"serviceType\":\"MOTORCYCLE\",\"language\":\"EN_MY\",\"stops\":[{\"stopId\":\"2847025439589847102\",\"coordinates\":{\"lat\":\"3.1286200\",\"lng\":\"101.6776890\"},\"address\":\"21, Jalan Bangsar,Bangsar,Kuala Lumpur, Malaysia,59000\"},{\"stopId\":\"2847025439589847103\",\"coordinates\":{\"lat\":\"3.1490000\",\"lng\":\"101.6970000\"},\"address\":\"2145,  fdl Street,Johore,Johore, Malaysia-,50400\"}],\"isRouteOptimized\":false,\"priceBreakdown\":{\"base\":\"5.00\",\"totalBeforeOptimization\":\"5.00\",\"totalExcludePriorityFee\":\"5.00\",\"total\":\"5.00\",\"currency\":\"MYR\"},\"distance\":{\"value\":\"4501\",\"unit\":\"m\"}}}\n"},
  //       "order_type": "delivery/pickup",
  //       "pickup_date" : "",
  //       "order_notes" : "vklnsdv"
  //     };
  //     http.Response response =
  //     await http.post(Uri.parse(url), body: jsonEncode(data));
  //     print("database connectivity ->>>>>>>>>>>>>>>>>> ${response.body}");
  //     print(response.statusCode);
  // }

  get_place_order() async{

    var cartList = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var p_d = await prefs.getString('pickup_delivery') ?? "delivery";
    var pc_date = await prefs.getString('pc_date') ?? DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
    for (var g = 0; g < item_name.length; g++) {
      var rng = new Random();
      var code = rng.nextInt(900000) + 100000;
      var random_data = "${code}${getRandomString(10)}";
      var f = {
        "id": item_product_id[g],
        "qty": item_qty[g],
        "option": item_options[g][0],
        "price": item_price[g],
        "name": item_price[g],
        "shipping": 0,
        "tax": item_tax[g],
        "image": item_img[g],
        "coupon": "",
        "subscribamt": 0,
        "rowid": "${random_data}",
        "subtotal": (double.parse(item_price[g]) * double.parse(item_qty[g])) +
            double.parse(item_tax[g] != "" && item_tax[g].toString() != null
                ? item_tax[g]
                : "0"),
      };
      cartList.add({"${random_data}": f});
    }

    String url = "$root_web/user_checkoutApi";
    print('get_place_order -------> $url----------------$user_id11----------------------$store_id-----------${use_reward}---------');
    Map data = {
      "langlat":"",
      "firstname":"${shipping_address_name}",
      "lastname":"",
      "address1":"${shipping_address_address1}",
      "address2":"${shipping_address_address2}",
      "zip":"${shipping_address_zip_code}",
      "email":"${shipping_address_email}",
      "phone":"${shipping_address_phone}",
      "cities":"${shipping_address_city}",
      "state":"${shipping_address_state}",
      "country":"${shipping_address_country}",
      "address_unicid":"${shipping_address_unique_id}",
      "rewards_using":"0",// 0 - not used , 1 - pending , 2 - used
      "payment_type":"ipay88",
      "userID":"${user_id11}",
      "store_id":"${store_id}",
      "order_type":p_d.toString(),
      "pickup_date" : p_d.toString() == "delivery" ? "" : pc_date.toString(),
      "reward_using_amt":"",// use rewards
      "mode":"user",
      "cart":cartList
    };
    http.Response response = await http.post(Uri.parse(url), body: jsonEncode(data));
    print("database connectivity ->>>>>>>>>>>>>>>>>> ${response.body}");
    print(response.statusCode);
    var jsonResponse = jsonDecode(response.body);
    var status = jsonResponse['status'];
    if(status == 'SUCCESS'){
      var message = jsonResponse['Message'];
      response_url = jsonResponse['Response']['url'];
      print('ipay888_message -----> ${message}');
      print('ipay888_url -----> ${response_url}');
      Navigator.push(context, MaterialPageRoute(builder: (context) => ipay88(response_url: response_url))).then((value) {

        print("response from the ip88 is =>> $value");
      });
    }
  }

  getProduct() async {
    String url1 = "$root_web/show_coupon/${store_id}";
    dynamic response = await http.get(Uri.parse(url1));
    if (response.statusCode == 200) {
      print('success--------------------------');
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
          for(var y=0;y<jsonResponse['Response']['available_coupons']['available_coupon'].length;y++)
          {
            coupon_list.add(jsonResponse['Response']['available_coupons']['available_coupon'][y]["code"]);
            coupon_value.add(jsonResponse['Response']['available_coupons']['available_coupon'][y]["min_order_amount"]); // put value here
          }
          coupon =
          jsonResponse['Response']['available_coupons']['available_coupon'];
          print("coupon -- - - - - - - ${coupon_value}");
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
    getProduct();
    get_available_rewards();
    show_cart_items();
    getaddresslist();
  }

  void get_available_rewards() async {
    String url1 = "$root_web/individual_user_rewards/${user_id}";
    print('rewards------------$user_id-------------$url1');
    dynamic response = await http.get(Uri.parse(url1));
    var jsonResponse = jsonDecode(response.body);
    var status = jsonResponse["Status"];
    var Response = jsonResponse["Response"];
    if (status == 'SUCCESS') {
      av_reward = Response;
      print('rewards-----------Response--$Response----------$av_reward');
    } else {
      print("Invalid response format or missing data");
    }
  }
  void initState() {

    setState(() {
      getstoreid();
      coupon_list = [];
      coupon_value = [];
      delivery_estimate = "0.0";
      selected_address = "";
      shipping_address = [];
      tot_price = "0.0";
      tot_tax ="0.0";
      grand_tot = "0.0";
      chec = false;

      coupon_amount =0;
    });

    super.initState();
  }

  _select_address() {
    if (true) {
      // if (isContainerPressed) {
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
                              if(shipping_address[index]["delivery_status"] == "delivery_available") {
                                make_selected(index);
                                setState(() {
                                  selected_address = index.toString();
                                });
                                Navigator.pop(context);
                              }
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
                                      onChanged:  (value) {
                                        if(shipping_address[index]["delivery_status"] == "delivery_available") {
                                          make_selected(index);
                                          setState(() {
                                            selected_address = index.toString();
                                          });
                                          Navigator.pop(context);
                                        }
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
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              AutoSizeText(
                                                '${shipping_address[index]['name'] + ',' + shipping_address[index]['address'] + ',' + shipping_address[index]['address1'] + ',' + shipping_address[index]['zip_code'] + ',' + shipping_address[index]['country'] + ',' + shipping_address[index]['state'] + ',' + shipping_address[index]['mobile']}',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 13.0),
                                              ),
                                              AutoSizeText(
                                                'Note: ${shipping_address[index]["delivery_status"] == "delivery_available" ? "Delivery Available" : "Delivery Not Available"}',
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 13.0,fontWeight: FontWeight.bold),
                                              ),
                                            ],
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
    setState(() {
      shipping_address = [];
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user_id11 = prefs.getString('store_id');
    var j = prefs.getStringList('cod_status') ?? [];
    var i = prefs.getStringList('product_name') ?? [];
    print('jcod_status ====> $j l,djfo ====> $i');
    String url1 = "$root_web/profile/address_list/${user_id11}/${store_id}";
    print('get_address_list$url1');
    dynamic response = await http.get(Uri.parse(url1));
    var jsonResponse = jsonDecode(response.body);
    var status = jsonResponse["status"];
    if (status == "SUCCESS") {
      print('shipping_address ====>>>> ${jsonResponse}');
      shipping_address = jsonResponse["Response"]["user_address"]["shipping_address"];
      if(selected_address_index != "")
      {
        shipping_address_name = jsonResponse["Response"]["user_address"]["shipping_address"][int.parse(selected_address_index)]["name"];
        shipping_address_address1 = jsonResponse["Response"]["user_address"]["shipping_address"][int.parse(selected_address_index)]["address"];
        shipping_address_address2 = jsonResponse["Response"]["user_address"]["shipping_address"][int.parse(selected_address_index)]["address1"];
        shipping_address_zip_code = jsonResponse["Response"]["user_address"]["shipping_address"][int.parse(selected_address_index)]["zip_code"];
        shipping_address_phone = jsonResponse["Response"]["user_address"]["shipping_address"][int.parse(selected_address_index)]["mobile"];
        shipping_address_email = jsonResponse["Response"]["user_address"]["shipping_address"][int.parse(selected_address_index)]["email"];
        shipping_address_country = jsonResponse["Response"]["user_address"]["shipping_address"][int.parse(selected_address_index)]["country"];
        shipping_address_state = jsonResponse["Response"]["user_address"]["shipping_address"][int.parse(selected_address_index)]["state"];
        shipping_address_city = jsonResponse["Response"]["user_address"]["shipping_address"][int.parse(selected_address_index)]["city"];
        shipping_address_unique_id = jsonResponse["Response"]["user_address"]["shipping_address"][int.parse(selected_address_index)]["unique_id"];

      }
     print('shipping_addressfdhgd====>>>> ${shipping_address.length}');
      print("ship =>> ${shipping_address}");
    } else {
      print("failure${jsonResponse["Message"]}");
    }
  }

  get_coupon_discount(couponController) async {
    String url1 = "$root_web/coupon_check/${couponController.text}/${grand_tot}";
    print('get_coupon_discount$url1');
    dynamic response = await http.get(Uri.parse(url1));
    var jsonResponse = jsonDecode(response.body);
    var status = jsonResponse["status"];
    if (status == "SUCCESS") {
      print('get_coupon_discount_Success ->> ${jsonResponse}');
      setState(() {
        coupon_amount = jsonResponse["Response"]["discount_amount"];
        discount_type = jsonResponse["Response"]["discount_type"];
      });

      print('discount_amount ---->> $discount_amount');
      print('discount_type ----->> $discount_type');
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
      item_cod = prefs.getStringList('cod_status') ?? [];
      item_tax = prefs.getStringList('tax') ?? [];
      item_tax_type = prefs.getStringList('tax_type') ?? [];
      item_options = prefs.getStringList('options') ?? [];
      print('item_cod --->> $item_cod');
    });
    item_qty_calc();
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
      item_cod.removeAt(index);
      item_product_id.removeAt(index);
      item_tax.removeAt(index);
      item_tax_type.removeAt(index);
      item_options.removeAt(index);

      print('countAsInt$countAsInt');
      counter = item_name.length;
      countAsInt = item_name.length;
      print('countAsInt$countAsInt');
    });
    await prefs.setStringList('qty', item_qty);
    await prefs.setStringList('product_name', item_name);
    await prefs.setStringList('product_image', item_img);
    await prefs.setStringList('product_price', item_price);
    await prefs.setStringList('product_discount', item_discount);
    await prefs.setStringList('cod_status', item_cod);
    await prefs.setStringList('product_id', item_product_id);
    await prefs.setStringList('tax', item_tax);
    await prefs.setStringList('tax_type', item_tax_type);
    await prefs.setStringList('options', item_options);
    print('item_qty1$item_qty');
    print('item_name1$item_name');
    print('item_img1$item_img');
    print('item_price1$item_price');
    print('item_discount1$item_discount');
    print('cod_status $item_cod');

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
      item_cod.clear();
      item_tax_type.clear();
      item_tax.clear();
      item_options.clear();
      item_product_id.clear();

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
    await prefs.setStringList('cod_status', item_cod);
    await prefs.setStringList('tax', item_tax);
    await prefs.setStringList('tax_type', item_tax_type);
    await prefs.setStringList('product_id', item_product_id);
    await prefs.setStringList('options', item_options);
    print('item_qty1$item_qty');
    print('item_name1$item_name');
    print('item_img1$item_img');
    print('item_price1$item_price');
    print('item_discount1$item_discount');

    item_qty_calc();
  }

  item_qty_calc() {
    if(item_name.length == 0)
    {
      Navigator.pop(context);
    }
    setState(() {
      item_q = 0;
      tot_price = "0.0";
      tot_tax = "0";
    });
    for (var k = 0; k < item_qty.length; k++) {
      setState(() {
        item_q += int.parse(item_qty[k].toString());
        if(item_tax[k] != "" && item_tax[k].toString() != "0") {
          if (item_tax_type[k] == "percent") {
            tot_tax = ((((int.parse(item_tax[k].toString()) / int.parse(item_price[k].toString())) * 100) * int.parse(item_qty[k].toString())) + int.parse(tot_tax.toString())).toString();
          }
          else {
            print("item_tax[k] ->> ${item_tax[k]}");
            tot_tax =
                ((int.parse(item_qty[k].toString()) * int.parse(item_tax[k])) + int.parse(tot_tax))
                    .toString();
          }
        }
        tot_price = ((double.tryParse(item_price[k].toString())! *
            int.parse(item_qty[k].toString())) +
            double.tryParse(tot_price.toString())!)
            .toString();
        var rew = "0.0";
        double total_amount = double.parse((((((double.tryParse(tot_price.toString())! + int.parse(tot_tax.toString()))) - coupon_amount) + double.parse(delivery_estimate.toString())).toString()));
        double rew1 = double.parse(av_reward.toString());
        if(total_amount < rew1){
          total_amount;
          print('total_amount -------------> $total_amount');
        }else{
          print('rewardssssssss ------------> $rew1');
          rew1;
        }
        if(chec)
        {
          rew = av_reward.toString();
        }
        grand_tot = (double.parse((((((double.tryParse(tot_price.toString())! + int.parse(tot_tax.toString()))) - coupon_amount) + double.parse(delivery_estimate.toString())).toString()))-double.parse(rew.toString())).toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    InCart()),
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
                  MaterialPageRoute(
                      builder: (context) =>
                          InCart()),

                );
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
                  style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold),
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
                                "Quantity($item_q)",
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
                                  Text(
                                    "${tot_price.toString()}",
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red),
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
                                                          0.45,
                                                      child: AutoSizeText(
                                                        item_name[
                                                        index],style: TextStyle(color: Colors.black,fontSize: 13.0),)),
                                                  IconButton(
                                                      onPressed: () {
                                                        remove == true;
                                                        remove_item(
                                                            index);
                                                      },
                                                      icon: Icon(
                                                        Icons
                                                            .cancel_outlined,
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
                                              SizedBox(height: 3,),
                                              Text(
                                                "* ${item_cod[index] == "cash_on_delivery_not_available" ? "COD not Available..!" : "COD Available"}",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: item_cod[index] == "cash_on_delivery_not_available" ? Colors.red : Colors.green),
                                              )
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
                                                            style: TextStyle(//hi hi
                                                                fontSize:
                                                                13,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                          ),
                                                          Text(
                                                            "RM${double.tryParse(tot_price)!.toStringAsFixed(2)}",
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
                                                            "RM${tot_tax != '0'? double.tryParse(tot_tax)!.toStringAsFixed(2) : "0.00"}",
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
                                                            "RM${double.tryParse(coupon_amount.toString())!.toStringAsFixed(2)}",
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
                                                            "RM${delivery_estimate != "0.0" ? double.tryParse(delivery_estimate.toString())!.toStringAsFixed(2) : "0.00"}",
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
                                                                        "RM${double.tryParse(grand_tot.toString())!.toStringAsFixed(2)}",
                                                                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height:
                                                                  5,
                                                                ),
                                                                Divider(),
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
                                                                      Text("RM${double.parse(av_reward.toString())}"),
                                                                      SizedBox(
                                                                        width: 5,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height:
                                                                  5,
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Container(
                                                                      width: size.width * 0.07,
                                                                      child: Checkbox(
                                                                        value: isChecked,
                                                                        onChanged: (bool? value) {
                                                                          setState(() {
                                                                            use_reward = 2;
                                                                            isChecked = value!;
                                                                            chec = value!;
                                                                            item_qty_calc();
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
                                                                SizedBox(
                                                                  height:
                                                                  5,
                                                                ),
                                                                Divider(),
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
                                                                      Padding(
                                                                        padding: const EdgeInsets.all(8.0),
                                                                        child: Text(
                                                                          "Enter Your Coupon Code If You Have One",
                                                                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height: 8,
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets.all(8.0),
                                                                        child: Container(
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
                                                                        ),),
                                                                      SizedBox(
                                                                        height: 2,
                                                                      ),
                                                                      Container(
                                                                        width: size.width,
                                                                        child: ElevatedButton(
                                                                          onPressed: () {
                                                                            setState(() {
                                                                              if(couponController.text.toString() != "" && coupon_list.contains(couponController.text))
                                                                              {
                                                                                coupon_amount = int.parse(coupon_value[coupon_list.indexOf(couponController.text)]);
                                                                                get_coupon_discount(couponController);
                                                                                item_qty_calc();
                                                                              }
                                                                              else
                                                                              {
                                                                                Fluttertoast.showToast(
                                                                                    msg: 'Invalid Coupon...!',
                                                                                    toastLength: Toast.LENGTH_LONG,
                                                                                    gravity: ToastGravity.CENTER,
                                                                                    timeInSecForIosWeb: 3,
                                                                                    backgroundColor: Color(0xff014282),
                                                                                    textColor: Colors.white,
                                                                                    fontSize: 15,
                                                                                    webPosition: "center");
                                                                              }
                                                                            });
                                                                          },
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
                                  width: size.height,
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
                                                        Padding(
                                                          padding: const EdgeInsets.only(top:10.0),
                                                          child: Row(
                                                            children: [
                                                              Container(
                                                                width: size
                                                                    .width *
                                                                    0.4,
                                                                height: size
                                                                    .height *
                                                                    0.03,
                                                                color: Colors
                                                                    .yellow,
                                                                child: Center(
                                                                    child: Text(
                                                                      couponItem['code'],
                                                                      textAlign: TextAlign.center,
                                                                    )),
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
                                                                    "Available",style: TextStyle(color:Colors.white,),),
                                                                  style: ElevatedButton.styleFrom(
                                                                      backgroundColor:
                                                                      Colors.red),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
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
                                                height: size.height * 0.05,
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
                                                ) : Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Text('Select address here...',style: (TextStyle(color: Colors.black,fontSize: 15.0))),
                                                ),
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
                                                    ).then((value) {
                                                      getaddresslist();
                                                    });
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
                                                  if(selected_address != ""){
                                                    setState(() {
                                                      payment_type =
                                                      !payment_type;
                                                    });
                                                  }else{
                                                    Fluttertoast.showToast(
                                                        msg: 'Please select address...!',
                                                        toastLength: Toast.LENGTH_LONG,
                                                        gravity: ToastGravity.CENTER,
                                                        timeInSecForIosWeb: 3,
                                                        backgroundColor: Color(0xff014282),
                                                        textColor: Colors.white,
                                                        fontSize: 15,
                                                        webPosition: "center");
                                                  }
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
                                                        item_cod.contains("cash_on_delivery_not_available") ? SizedBox() : GestureDetector(
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
            height: 60,
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
                if(selected_address != "")
                {
                  if(selectedContainerIndex == 0)
                  {
                    get_place_order();
                  }
                  else if(selectedContainerIndex == 1)
                  {
                    place_wallet_order();
                  }
                  else
                  {
                    place_cod_order();
                  }
                }
                else
                {
                  Fluttertoast.showToast(
                      msg: 'Please Select Address..!',
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 3,
                      backgroundColor: Color(0xff014282),
                      textColor: Colors.white,
                      fontSize: 15,
                      webPosition: "center");
                }
                // get_place_order();
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
    ),
    );
  }
}

