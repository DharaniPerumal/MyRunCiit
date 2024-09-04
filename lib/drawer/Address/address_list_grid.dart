import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myrunciit/bottom_navigationbar/deals_page/deals_sub_category/today_sub_category.dart';
import 'package:myrunciit/drawer/Address/edit_address.dart';
import 'package:myrunciit/main_screen/login_screen.dart';
import 'package:myrunciit/roots/roots.dart';
import 'package:shared_preferences/shared_preferences.dart';

var user_id;

class AddressListGrid extends StatefulWidget {
  @override
  _AddressListGridState createState() => _AddressListGridState();
}

var edit_name;
var edit_phone;
var edit_email;
var edit_address;
var edit_address1;
var edit_country;
var edit_state;
var edit_city;
var edit_zipcode;
var ship_uni_id;

class _AddressListGridState extends State<AddressListGrid> {
  StreamController<List> _dealsStreamController = StreamController<List>();

  List shipping_address = [];
  var user_id;
  var store_id;

  @override
  void initState() {
    setState(() {
      getstoreid();
      initData();
    });
    super.initState();
  }

  Future<void> initData() async {
    await getstoreid();
    await getaddresslist();
  }

  Future<void> getstoreid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      user_id = prefs.getString('user_id');
      store_id = prefs.getString('storeid');
    });
    print('address_list_grid_userid===>>> $user_id');
    print('address_list_grid_userid===>>> $store_id');
  }

  @override
  void dispose() {
    _dealsStreamController.close();
    super.dispose();
  }

  getaddresslist() async {
    print('storeId3>>>>>$user_id');

    String url1 = "$root_web/profile/address_list/${user_id}/${store_id}";
    dynamic response = await http.get(Uri.parse(url1));
    var jsonResponse = jsonDecode(response.body);
    var status = jsonResponse["status"];
    if (status == "SUCCESS") {
      var shipping_address = jsonResponse['Response']['user_address']['shipping_address'];
      _dealsStreamController.add(shipping_address);
      print('shipping_addressdfg ====>>>> ${shipping_address}');
      print('shipping_addressdfg ====>>>> ${shipping_address[0]["name"]}');
    } else {
      print("failure${jsonResponse["Message"]}");
    }
  }

  get_delete(unique_id) async {
    String url1 = "$root_web/profile/delete_address/${unique_id}";
    print('delete_address$url1');
    dynamic response = await http.get(Uri.parse(url1));
    var jsonResponse = jsonDecode(response.body);
    var status = jsonResponse["status"];
    message = jsonResponse["message"];
    print('status_delete_data ===>>> ${status}');
    if (status == "SUCCESS") {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Center(child: Text("${message}")),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Center(
                    child: Container(
                      width: 100,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        // color: Color(0xFF64DD17),
                        color: Colors.lightGreen,

                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                          child: Text(
                        'Ok',
                        style: TextStyle(color: Colors.white),
                      )),
                    ),
                  ),
                ),
                SizedBox(
                  width: 7,
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      print("failure${jsonResponse["Message"]}");
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Center(child: Text("${message}")),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Center(
                    child: Container(
                      width: 100,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        // color: Color(0xFF64DD17),
                        color: Colors.lightGreen,

                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                          child: Text(
                        'Ok',
                        style: TextStyle(color: Colors.white),
                      )),
                    ),
                  ),
                ),
                SizedBox(
                  width: 7,
                ),
              ],
            ),
          ],
        ),
      );
    }
  }

  // gettoadydeals() async {
  //   String url1 = "https://myrunciit.my/webservice/getLatestProducts/2";
  //   dynamic response = await http.get(Uri.parse(url1));
  //   if (response.statusCode == 200) {
  //     dynamic jsonResponse = jsonDecode(response.body);
  //
  //     if (jsonResponse != null &&
  //         jsonResponse['Response'] != null &&
  //         jsonResponse['Response']["latestProducts"] != null) {
  //       setState(() {
  //         todaydeals = jsonResponse['Response']["latestProducts"];
  //         _dealsStreamController.add(todaydeals);
  //       });
  //     } else {
  //       print("Invalid response format or missing data");
  //     }
  //   } else {
  //     print("failure");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: StreamBuilder<List>(
        stream: _dealsStreamController.stream,
        builder: (context, snapshot) {
          if ((snapshot.hasData)) {
            List<dynamic> shipping_address = snapshot.data!;
            return ListView.builder(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemCount: shipping_address.length,
              itemBuilder: (context, index) {
                print('object');
                return GestureDetector(
                  onTap: () {
                    //       Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //           builder: (context) => CategoryDetailScreen(
                    //             categoryName: todaydeals[index]["title"].toString(),
                    //             categoryImage: todaydeals[index]["banner"].toString(),
                    //             sale_price: todaydeals[index]["sale_price"].toString(),
                    //             current_stock: todaydeals[index]["current_stock"].toString(),
                    //             description: todaydeals[index]["description"].toString(),
                    //             discount : todaydeals[index]["discount"].toString()
                    // weight:  todaydeals[index]["option"].toString(),

                    //     ),
                    //   ),
                    // );
                  },
                  behavior: HitTestBehavior.translucent,
                  child: Container(
                    // height: size.height * 0.22,
                    color: Colors.white,
                    child: Column(
                      children: [
                        Container(
                          // height : MediaQuery.of(context).size.height * 0.2,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 2,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          margin: EdgeInsets.all(6.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Text(
                                  shipping_address[index]["name"].toString(),
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Text(
                                shipping_address[index]["address"].toString(),
                                style: TextStyle(
                                  fontSize: 13.5,
                                  color: Colors.grey,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Text(
                                  "${shipping_address[index]["city"].toString()}" +
                                      "," +
                                      "${shipping_address[index]["country"].toString()}",
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    color: Colors.grey,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Text(
                                  "${shipping_address[index]["zip_code"].toString()}",
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    color: Colors.grey,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Text(
                                  "Phone Number : ${shipping_address[index]["mobile"].toString()}",
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    color: Colors.grey,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Text(
                                  "Email : ${shipping_address[index]["email"].toString()}",
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    color: Colors.grey,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditAddress(
                                                        edit_name:
                                                            shipping_address[
                                                                        index]
                                                                    ["name"]
                                                                .toString(),
                                                        edit_phone:
                                                            shipping_address[
                                                                        index]
                                                                    ["mobile"]
                                                                .toString(),
                                                        edit_email:
                                                            shipping_address[
                                                                        index]
                                                                    ["email"]
                                                                .toString(),
                                                        edit_address:
                                                            shipping_address[
                                                                        index]
                                                                    ["address"]
                                                                .toString(),
                                                        edit_address1:
                                                            shipping_address[
                                                                        index]
                                                                    ["address1"]
                                                                .toString(),
                                                        edit_country:
                                                            shipping_address[
                                                                        index]
                                                                    ["country"]
                                                                .toString(),
                                                        edit_state:
                                                            shipping_address[
                                                                        index]
                                                                    ["state"]
                                                                .toString(),
                                                        edit_city:
                                                            shipping_address[
                                                                        index]
                                                                    ["city"]
                                                                .toString(),
                                                        edit_zipcode:
                                                            shipping_address[
                                                                        index]
                                                                    ["zip_code"]
                                                                .toString(),
                                                        edit_unique_id:
                                                            shipping_address[
                                                                        index][
                                                                    "unique_id"]
                                                                .toString(),
                                                      )));
                                        },
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                color: Colors.grey.shade100),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: const Center(
                                            child: Text(
                                              'Edit',
                                              style: TextStyle(
                                                fontSize: 12.0,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text("DELETE"),
                                                content: Text(
                                                    "Are you sure you want to delete this item?"),
                                                actions: <Widget>[
                                                  SingleChildScrollView(
                                                    scrollDirection: Axis.horizontal,
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: InkWell(
                                                            onTap: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: Container(
                                                              color: Colors
                                                                  .lightGreen,
                                                              height:
                                                                  size.height *
                                                                      0.04,
                                                              width: size.width *
                                                                  0.3,
                                                              child: Center(
                                                                  child: Text(
                                                                "Cancel",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              )),
                                                            ),
                                                          ),
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            print(
                                                                'delete_clicked ====>>> ');
                                                            get_delete(
                                                                shipping_address[
                                                                        index][
                                                                    'unique_id']);
                                                            Navigator.of(context)
                                                                .pop();
                                                          },
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Container(
                                                              color: Colors
                                                                  .lightGreen,
                                                              height:
                                                                  size.height *
                                                                      0.04,
                                                              width: size.width *
                                                                  0.3,
                                                              // child: TextButto(
                                                              child: Center(
                                                                  child: Text(
                                                                "Delete",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              )),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                color: Colors.grey.shade100),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: const Center(
                                            child: Text(
                                              'Delete',
                                              style: TextStyle(
                                                fontSize: 12.0,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
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
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
