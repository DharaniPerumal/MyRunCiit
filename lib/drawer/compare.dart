
import 'dart:convert';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../roots/roots.dart';


var user_id;
var f_d = false;
var store_id = "";
var product_category = [];
var product_id = [];
var product_name = [];
var product_image = [];
var product_price = [];
var product_brand = [];
var product_sub = [];
var product_des = [];
var product_cat_id = [];
var product_sub_id = [];
class Compare extends StatefulWidget {
  const Compare({Key? key}) : super(key: key);

  @override
  State<Compare> createState() => _CompareState();
}

class _CompareState extends State<Compare> {


  void compare_remove(id) async {
    String url1 = "$root_web/compare/remove/${id}/${user_id}";
    print('compare ----> $url1');
    dynamic response = await http.get(Uri.parse(url1));
    if (response.statusCode == 200) {
      print('success1 compare');
      print(response.body);
      dynamic jsonResponse = jsonDecode(response.body);
      if (jsonResponse != null && jsonResponse['message'] != null) {
        Fluttertoast.showToast(
            msg: 'Product removed from Compare List...!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 3,
            backgroundColor: Color(0xff014282),
            textColor: Colors.white,
            fontSize: 15,
            webPosition: "center");
      } else {
        print("Invalid response format or missing data");
      }
    } else {
      print("failure");
    }
    get_compare_data();
  }

  void get_compare_clear() async {
    String url1 = "$root_web/compare/clear/${user_id}";
    print('compare ----> $url1');
    dynamic response = await http.get(Uri.parse(url1));
    var jsonResponse = jsonDecode(response.body);
    var status = jsonResponse["status"];
    var Response = jsonResponse["Response"];
    if (status == 'SUCCESS') {
      print('success1 compare');
      print(response.body);
      dynamic jsonResponse = jsonDecode(response.body);
      if (jsonResponse != null && jsonResponse['message'] != null) {
        get_compare_data();
        Fluttertoast.showToast(
            msg: '$Response',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 3,
            backgroundColor: Color(0xff014282),
            textColor: Colors.white,
            fontSize: 15,
            webPosition: "center");
      } else {
        print("Invalid response format or missing data");
      }
    } else {
      print("failure");
    }
  }



  get_compare_data()async
  {
    SharedPreferences prefs1 = await SharedPreferences.getInstance();
    setState(() {
      store_id = prefs1.getString('storeid')!;
      user_id = prefs1.getString('user_id');
    });
    String url1 = "$root_web/compare/${user_id}";
    print('compare ----> $url1');
    dynamic response = await http.get(Uri.parse(url1));
    if (response.statusCode == 200) {
      print('success1 compare data');
      print(response.body);
      dynamic jsonResponse = jsonDecode(response.body);
      setState(() {
        product_category = [];
        product_name = [];
        product_des = [];
        product_sub = [];
        product_brand = [];
        product_image = [];
        product_price = [];
        product_cat_id = [];
        product_sub_id = [];
        product_id = [];
      });
      if (jsonResponse != null && jsonResponse['Response'] != null && jsonResponse['Response'] !="Compare List is Empty") {
        setState(() {

         for(var gg=0;gg<jsonResponse['Response'].length;gg++)
         {
           var data = jsonResponse['Response'][gg];
           var data1 = jsonResponse['Response'][gg]["product"];
           if(product_category.contains(data["category_name"]))
           {
             var index = product_category.indexOf(data["category_name"]);
             product_name[index] = product_name[index] + "-" + data1["title"];
             product_id[index] = product_id[index] + "-" + data1["product_id"];
             product_image[index] = product_image[index] + "-" + data["img_src"];
             product_price[index] = product_price[index] + "-" + data1["sale_price"];
             product_des[index] = product_des[index] + "-" + data1["description"];
             product_sub[index] = product_sub[index] + "-" + data["sub_category_name"];
             product_brand[index] = product_brand[index] + "-____________" + data["brand_detail"];
             // product_sub_id[index] = product_sub_id[index] + "-" + data["sub_category"];
             // product_cat_id[index] = product_cat_id[index] + "-" + data["category"];

           }
           else
           {
             product_id.add(data1["product_id"]);
             product_category.add(data["category_name"]);
             product_name.add(data1["title"]);
             product_price.add(data1["sale_price"]);
             product_des.add(data1["description"]);
             product_sub.add(data["sub_category_name"]);
             product_brand.add(data["brand_detail"]);
             product_image.add(data["img_src"]);
             product_cat_id.add(data1["category"]);
             product_sub_id.add(data1["sub_category"]);
           }
         }
         print("product_name =>> ${product_name}");
         print("product_cat =>> ${product_category}");
         print("product_des =>> ${product_des}");

        });
      }
      else
       {
         Fluttertoast.showToast(
             msg: 'No Data in Compare List..!',
             toastLength: Toast.LENGTH_LONG,
             gravity: ToastGravity.CENTER,
             timeInSecForIosWeb: 3,
             backgroundColor: Color(0xff014282),
             textColor: Colors.white,
             fontSize: 15,
             webPosition: "center");
       }
    }
  }


  @override
  void initState() {
    setState(() {
      product_category = [];
      product_name = [];
      product_des = [];
      product_sub = [];
      product_brand = [];
      product_image = [];
      product_price = [];
      product_sub_id = [];
      product_cat_id = [];
      product_id = [];
    });
    // TODO: implement initState
    get_compare_data();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff014282),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: IconButton(
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) =>
              //           Deals(selectedTabIndex: selectedTabIndex)),
              // );
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.keyboard_arrow_left,
              size: 35,
              color: Colors.white,
            ),
          ),
        ),
        title: const Center(
            child: Text(
              "Compare",
              style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold),
            )),
        // actions: [
        //   ShoppingCart(
        //     itemCount: countAsInt,
        //   )
        // ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            InkWell(
                onTap: (){
                  get_compare_clear();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Clear All Data', style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18.0),),
                )),
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    for(var c=0;c<product_category.length;c++)
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("${product_category[c]}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                              IconButton(onPressed: ()async{
                              if(product_name[c].toString().split("-").length >= 3)
                              {
                              Fluttertoast.showToast(
                              msg: 'Remove Any Data to add in this Category...!',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 3,
                              backgroundColor: Color(0xff014282),
                              textColor: Colors.white,
                              fontSize: 15,
                              webPosition: "center");
                              }
                              else {
                                List<String> _list = [];
                                List<String> product_id = [];
                                var selec = "";
                                String url1 = "$root_web/category/${product_cat_id[c]}/${product_sub_id[c]}/${store_id}";
                                print('compare ----> $url1');
                                dynamic response = await http.get(
                                    Uri.parse(url1));
                                if (response.statusCode == 200) {
                                  print('success1 compare');
                                  print(response.body);
                                  dynamic jsonResponse = jsonDecode(
                                      response.body);
                                  if (jsonResponse != null &&
                                      jsonResponse['Response'] != null) {
                                    for (var b = 0; b <
                                        jsonResponse['Response'].length; b++) {
                                      setState(() {
                                        _list.add(
                                            "${jsonResponse['Response'][b]['title']}");
                                        product_id.add(
                                            "${jsonResponse['Response'][b]['product_id']}");
                                      });
                                    }
                                    selec = _list[0];
                                    if (f_d == false) {
                                      setState(() {
                                        f_d = true;
                                      });
                                      showModalBottomSheet<void>(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Container(
                                              height: 600,
                                              child: Center(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment
                                                      .center,
                                                  mainAxisSize: MainAxisSize
                                                      .min,
                                                  children: [
                                                    CustomDropdown<String>(
                                                      hintText: 'Select job role',
                                                      items: _list,
                                                      initialItem: _list[0],
                                                      onChanged: (value) {
                                                        selec = value;
                                                        print(
                                                            'changing value to: $value');
                                                      },
                                                    ),
                                                    ElevatedButton(
                                                      child: const Text(
                                                          'Add to Compare'),
                                                      onPressed: () async {
                                                        var inde = _list
                                                            .indexOf(selec);
                                                        var pro_id = product_id[inde];
                                                        String url1 = "$root_web/compare/add/${pro_id}/${user_id}";
                                                        print(
                                                            'compare adddddddd----> $url1');
                                                        dynamic response = await http
                                                            .get(
                                                            Uri.parse(url1));
                                                        if (response
                                                            .statusCode ==
                                                            200) {
                                                          print(
                                                              'success1 compare');
                                                          print(response.body);
                                                          dynamic jsonResponse = jsonDecode(
                                                              response.body);
                                                          get_compare_data();
                                                          if (jsonResponse !=
                                                              null &&
                                                              jsonResponse['message'] !=
                                                                  null) {
                                                            Fluttertoast
                                                                .showToast(
                                                                msg: 'Product Added to Compare List...!',
                                                                toastLength: Toast
                                                                    .LENGTH_LONG,
                                                                gravity: ToastGravity
                                                                    .CENTER,
                                                                timeInSecForIosWeb: 3,
                                                                backgroundColor: Color(
                                                                    0xff014282),
                                                                textColor: Colors
                                                                    .white,
                                                                fontSize: 15,
                                                                webPosition: "center");
                                                          } else {
                                                            print(
                                                                "Invalid response format or missing data");
                                                          }
                                                        } else {
                                                          print("failure");
                                                        }
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }).then((value) {
                                        setState(() {
                                          f_d = false;
                                        });
                                      });
                                    }
                                  }
                                }
                              }
                            }, icon: Icon(Icons.add))
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Table(
                              border: TableBorder.all(), // Allows to add a border decoration around your table
                              children: [
        
                                TableRow(children :[
                                  for(var f=0;f<product_name[c].toString().split("-").length;f++)
                                  Text('${product_name[c].toString().split("-")[f]}'),
                                ]),
        
                                TableRow(children :[
        
                                  for(var r=0;r<product_image[c].toString().split("-").length;r++)
                                    Image.network("${product_image[c].toString().split("-")[r]}"),
                                ]),
        
                                TableRow(children :[
        
                                  for(var h=0;h<product_price[c].toString().split("-").length;h++)
                                    Text('${product_price[c].toString().split("-")[h]}'),
        
                                ]),
        
                                TableRow(children :[
                                  for(var t=0;t<product_brand[c].toString().split("-").length;t++)
                                    Text('${product_brand[c].toString().split("-")[t]}'),
                                ]),
        
                                TableRow(children :[
                                  for(var y=0;y<product_sub[c].toString().split("-").length;y++)
                                    Text('${product_sub[c].toString().split("-")[y]}'),
                                ]),
        
                                TableRow(children :[
                                  for(var z=0;z<product_id[c].toString().split("-").length;z++)
                                    ElevatedButton(onPressed: (){
                                      compare_remove(product_id[c].toString().split("-")[z]);
                                    }, child: Text("Remove"))
                                ]),
                                //
                                // TableRow(children :[
                                //
                                //   for(var x=0;x<product_des[c].toString().split("-____________").length;x++)
                                //     Text('${product_des[c].toString().split("-____________")[x]}'),
                                // ]),
        
                              ]
                          ),
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
    );
  }
}





// import 'dart:convert';
//
// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:flutter/material.dart';
// import 'package:myrunciit/add_to_cart/cart_available.dart';
// import 'package:myrunciit/bottom_navigationbar/deals_page/deals_sub_category/today_sub_category.dart';
// import 'package:myrunciit/drawer/Address/address_list_grid.dart';
// import 'package:myrunciit/product_screen/product_main_screen.dart';
// import 'package:myrunciit/widget/cart.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
//
// var transactionstoreid;
// List<String> compareitem_name = [];
// List<String> compareitem_qty = [];
// List<String> compareitem_img = [];
// List<String> compareitem_price = [];
// List<String> compareitem_discount = [];
// List<String> comparebrand = [];
// List<String> comparesubcategory = [];
//
// var item_qty = 0;
// bool remove1 = false;
//
// class Compare extends StatefulWidget {
//   @override
//   _CompareState createState() => _CompareState();
// }
//
// class _CompareState extends State<Compare> {
//   @override
//   void initState() {
//     show_cart_items();
//     super.initState();
//   }
//
//   show_cart_items() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       compareitem_name = prefs.getStringList('compare_name') ?? [];
//       compareitem_qty = prefs.getStringList('qty') ?? [];
//       compareitem_img = prefs.getStringList('compare_image') ?? [];
//       compareitem_price = prefs.getStringList('compare_price') ?? [];
//       compareitem_discount = prefs.getStringList('compare_discount') ?? [];
//       comparebrand = prefs.getStringList('compare_brand') ?? [];
//       comparesubcategory = prefs.getStringList('compare_sub_category') ?? [];
//
//       var item_quantity = prefs.setInt('quantity', item_qty);
//       print('compareitem_name$compareitem_name');
//       print('compareitem_qty$compareitem_qty');
//       print('compareitem_img$compareitem_img');
//       print('compareitem_price$compareitem_price');
//       print('compareitem_discount$compareitem_discount');
//       print('comparebrand$comparebrand');
//       print('comparesubcategory$comparesubcategory');
//     });
//   }
//
//   cancelorder() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       compareitem_name.clear();
//       compareitem_qty.clear();
//       compareitem_img.clear();
//       compareitem_price.clear();
//       comparesubcategory.clear();
//     });
//     await prefs.remove('compare_name');
//     await prefs.remove('qty');
//     await prefs.remove('compare_image');
//     await prefs.remove('compare_price');
//     await prefs.remove('compare_discount');
//     await prefs.remove('compare_brand');
//     await prefs.remove('compare_sub_category');
//   }
//
//   remove_item(index) async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       compareitem_qty.removeAt(index);
//       compareitem_name.removeAt(index);
//       compareitem_img.removeAt(index);
//       compareitem_price.removeAt(index);
//       compareitem_discount.removeAt(index);
//
//       print('countAsInt$countAsInt');
//
//       countAsInt = compareitem_name.length;
//       print('countAsInt$countAsInt');
//     });
//     await prefs.setStringList('qty', compareitem_qty);
//     await prefs.setStringList('compare_name', compareitem_name);
//     await prefs.setStringList('compare_image', compareitem_img);
//     await prefs.setStringList('compare_price', compareitem_price);
//     await prefs.setStringList('compare_discount', compareitem_discount);
//
//     // item_qty_calc();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Color(0xff014282),
//         leading: IconButton(
//           onPressed: () {
//             // cancelorder();
//             Navigator.pop(context);
//           },
//           icon: Icon(
//             Icons.keyboard_arrow_left,
//             size: 35,
//             color: Colors.white,
//           ),
//         ),
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: <Widget>[
//             Center(
//               child: Text(
//                 "Compare",
//                 style: TextStyle(color: Colors.white, fontSize: 15),
//               ),
//             ),
//           ],
//         ),
//         actions: [ShoppingCart()],
//       ),
//       body: Container(
//         height: MediaQuery.of(context).size.height,
//         width: MediaQuery.of(context).size.width * 1.5,
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               Container(
//                 height: size.height,
//                 width: size.width * 1.5,
//                 decoration: const BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(top: 10),
//                       child: Container(
//                         height: size.height * 0.05,
//                         width: size.width,
//                         decoration: BoxDecoration(
//                             border: Border(
//                                 top: BorderSide(color: Colors.grey.shade400),
//                                 bottom:
//                                 BorderSide(color: Colors.grey.shade400))),
//                         child: Center(
//                           child: Text(
//                             'Category:',
//                             style: TextStyle(
//                                 fontSize: 17,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.black),
//                           ),
//                         ),
//                       ),
//                     ),
//                     Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             if (compareitem_name[0] != null &&
//                                 compareitem_name[0].isNotEmpty)
//                               Container(
//                                 // height: size.height * 0.3,
//                                 width: size.width * 0.5,
//                                 color: Colors.white,
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Column(
//                                     children: [
//                                       Container(
//                                         height: size.height * 0.05,
//                                         width: size.width,
//                                         decoration: BoxDecoration(
//                                             border: Border(
//                                                 top: BorderSide(
//                                                     color:
//                                                     Colors.grey.shade400),
//                                                 bottom: BorderSide(
//                                                     color:
//                                                     Colors.grey.shade400))),
//                                         child: Center(
//                                           child: Text(
//                                             'Name',
//                                             style: TextStyle(
//                                                 fontSize: 17,
//                                                 fontWeight: FontWeight.bold,
//                                                 color: Colors.black),
//                                           ),
//                                         ),
//                                       ),
//                                       Container(
//                                         height: size.height * 0.05,
//                                         width: size.width,
//                                         child: Center(
//                                             child: Text(compareitem_name[0]
//                                                 .toString())),
//                                       ),
//                                       Container(
//                                         height: size.height * 0.05,
//                                         width: size.width,
//                                         decoration: BoxDecoration(
//                                             border: Border(
//                                                 top: BorderSide(
//                                                     color:
//                                                     Colors.grey.shade400),
//                                                 bottom: BorderSide(
//                                                     color:
//                                                     Colors.grey.shade400))),
//                                         child: Center(
//                                           child: Text(
//                                             'Image',
//                                             style: TextStyle(
//                                                 fontSize: 17,
//                                                 fontWeight: FontWeight.bold,
//                                                 color: Colors.black),
//                                           ),
//                                         ),
//                                       ),
//                                       Container(
//                                         // height: size.height * 0.3,
//                                         width: size.width * 0.5,
//                                         color: Colors.white,
//                                         child: Padding(
//                                           padding: const EdgeInsets.all(8.0),
//                                           child: Column(
//                                             children: [
//                                               Container(
//                                                 height: size.height * 0.2,
//                                                 width: size.width,
//                                                 child: Image.network(
//                                                     compareitem_img[0]
//                                                         .toString()),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                       Container(
//                                         height: size.height * 0.05,
//                                         width: size.width,
//                                         decoration: BoxDecoration(
//                                             border: Border(
//                                                 top: BorderSide(
//                                                     color:
//                                                     Colors.grey.shade400),
//                                                 bottom: BorderSide(
//                                                     color:
//                                                     Colors.grey.shade400))),
//                                         child: Center(
//                                           child: Text(
//                                             'Price',
//                                             style: TextStyle(
//                                                 fontSize: 17,
//                                                 fontWeight: FontWeight.bold,
//                                                 color: Colors.black),
//                                           ),
//                                         ),
//                                       ),
//                                       Container(
//                                         height: size.height * 0.05,
//                                         width: size.width,
//                                         child: Center(
//                                             child: Row(
//                                               mainAxisAlignment:
//                                               MainAxisAlignment.center,
//                                               children: [
//                                                 Text("RM"),
//                                                 Text(compareitem_price[0]
//                                                     .toString()),
//                                               ],
//                                             )),
//                                       ),
//                                       Container(
//                                         height: size.height * 0.05,
//                                         width: size.width,
//                                         decoration: BoxDecoration(
//                                             border: Border(
//                                                 top: BorderSide(
//                                                     color:
//                                                     Colors.grey.shade400),
//                                                 bottom: BorderSide(
//                                                     color:
//                                                     Colors.grey.shade400))),
//                                         child: Center(
//                                           child: Text(
//                                             'Brand',
//                                             style: TextStyle(
//                                                 fontSize: 17,
//                                                 fontWeight: FontWeight.bold,
//                                                 color: Colors.black),
//                                           ),
//                                         ),
//                                       ),
//                                       Container(
//                                         height: size.height * 0.05,
//                                         width: size.width,
//                                         child: Center(
//                                             child: Text(
//                                                 comparebrand[0].toString())),
//                                       ),
//                                       Container(
//                                         height: size.height * 0.05,
//                                         width: size.width,
//                                         decoration: BoxDecoration(
//                                             border: Border(
//                                                 top: BorderSide(
//                                                     color:
//                                                     Colors.grey.shade400),
//                                                 bottom: BorderSide(
//                                                     color:
//                                                     Colors.grey.shade400))),
//                                         child: Center(
//                                           child: Text(
//                                             'Sub Category',
//                                             style: TextStyle(
//                                                 fontSize: 17,
//                                                 fontWeight: FontWeight.bold,
//                                                 color: Colors.black),
//                                           ),
//                                         ),
//                                       ),
//                                       Container(
//                                         height: size.height * 0.05,
//                                         width: size.width,
//                                         child: Center(
//                                             child: Text(comparesubcategory[0]
//                                                 .toString())),
//                                       ),
//                                       Container(
//                                         height: size.height * 0.05,
//                                         width: size.width,
//                                         decoration: BoxDecoration(
//                                             border: Border(
//                                                 top: BorderSide(
//                                                     color:
//                                                     Colors.grey.shade400),
//                                                 bottom: BorderSide(
//                                                     color:
//                                                     Colors.grey.shade400))),
//                                         child: Center(
//                                           child: Text(
//                                             'Description',
//                                             style: TextStyle(
//                                                 fontSize: 17,
//                                                 fontWeight: FontWeight.bold,
//                                                 color: Colors.black),
//                                           ),
//                                         ),
//                                       ),
//                                       // Container(
//                                       //   height: size.height * 0.05,
//                                       //   width: size.width,
//                                       //   child: Center(
//                                       //       child: Text(
//                                       //           compare_desc[0].toString())),
//                                       // ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             Row(
//                               children: [
//                                 SizedBox(
//                                   height: size.height * 0.8,
//                                   width: size.width * 0.5,
//                                   child: ListView(
//                                     scrollDirection: Axis.horizontal,
//                                     children: [
//                                       if (compareitem_name[1] != null &&
//                                           compareitem_name[1].isNotEmpty)
//                                         Container(
//                                           width: size.width * 0.5,
//                                           color: Colors.white,
//                                           child: Padding(
//                                             padding: const EdgeInsets.all(8.0),
//                                             child: Column(
//                                               children: [
//                                                 Container(
//                                                   height: size.height * 0.05,
//                                                   width: size.width,
//                                                   decoration: BoxDecoration(
//                                                       border: Border(
//                                                           top: BorderSide(
//                                                               color: Colors.grey
//                                                                   .shade400),
//                                                           bottom: BorderSide(
//                                                               color: Colors.grey
//                                                                   .shade400))),
//                                                   child: Center(
//                                                     child: Text(
//                                                       '',
//                                                       style: TextStyle(
//                                                           fontSize: 17,
//                                                           fontWeight:
//                                                           FontWeight.bold,
//                                                           color: Colors.black),
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 Container(
//                                                   height: size.height * 0.05,
//                                                   width: size.width,
//                                                   child: Center(
//                                                       child: Text(
//                                                           compareitem_name[1]
//                                                               .toString())),
//                                                 ),
//                                                 Container(
//                                                   height: size.height * 0.05,
//                                                   width: size.width,
//                                                   decoration: BoxDecoration(
//                                                       border: Border(
//                                                           top: BorderSide(
//                                                               color: Colors.grey
//                                                                   .shade400),
//                                                           bottom: BorderSide(
//                                                               color: Colors.grey
//                                                                   .shade400))),
//                                                   child: Center(
//                                                     child: Text(
//                                                       '',
//                                                       style: TextStyle(
//                                                           fontSize: 17,
//                                                           fontWeight:
//                                                           FontWeight.bold,
//                                                           color: Colors.black),
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 Container(
//                                                   // height: size.height * 0.3,
//                                                   width: size.width * 0.5,
//                                                   color: Colors.white,
//                                                   child: Padding(
//                                                     padding:
//                                                     const EdgeInsets.all(
//                                                         8.0),
//                                                     child: Column(
//                                                       children: [
//                                                         Container(
//                                                           height:
//                                                           size.height * 0.2,
//                                                           width: size.width,
//                                                           child: Image.network(
//                                                               compareitem_img[1]
//                                                                   .toString()),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 Container(
//                                                   height: size.height * 0.05,
//                                                   width: size.width,
//                                                   decoration: BoxDecoration(
//                                                       border: Border(
//                                                           top: BorderSide(
//                                                               color: Colors.grey
//                                                                   .shade400),
//                                                           bottom: BorderSide(
//                                                               color: Colors.grey
//                                                                   .shade400))),
//                                                   child: Center(
//                                                     child: Text(
//                                                       '',
//                                                       style: TextStyle(
//                                                           fontSize: 17,
//                                                           fontWeight:
//                                                           FontWeight.bold,
//                                                           color: Colors.black),
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 Container(
//                                                   height: size.height * 0.05,
//                                                   width: size.width,
//                                                   child: Center(
//                                                       child: Row(
//                                                         mainAxisAlignment:
//                                                         MainAxisAlignment
//                                                             .center,
//                                                         children: [
//                                                           Text("RM"),
//                                                           Text(compareitem_price[1]
//                                                               .toString()),
//                                                         ],
//                                                       )),
//                                                 ),
//                                                 Container(
//                                                   height: size.height * 0.05,
//                                                   width: size.width,
//                                                   decoration: BoxDecoration(
//                                                       border: Border(
//                                                           top: BorderSide(
//                                                               color: Colors.grey
//                                                                   .shade400),
//                                                           bottom: BorderSide(
//                                                               color: Colors.grey
//                                                                   .shade400))),
//                                                   child: Center(
//                                                     child: Text(
//                                                       '',
//                                                       style: TextStyle(
//                                                           fontSize: 17,
//                                                           fontWeight:
//                                                           FontWeight.bold,
//                                                           color: Colors.black),
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 Container(
//                                                   height: size.height * 0.05,
//                                                   width: size.width,
//                                                   child: Center(
//                                                       child: Text(
//                                                           comparebrand[1]
//                                                               .toString())),
//                                                 ),
//                                                 Container(
//                                                   height: size.height * 0.05,
//                                                   width: size.width,
//                                                   decoration: BoxDecoration(
//                                                       border: Border(
//                                                           top: BorderSide(
//                                                               color: Colors.grey
//                                                                   .shade400),
//                                                           bottom: BorderSide(
//                                                               color: Colors.grey
//                                                                   .shade400))),
//                                                   child: Center(
//                                                     child: Text(
//                                                       '',
//                                                       style: TextStyle(
//                                                           fontSize: 17,
//                                                           fontWeight:
//                                                           FontWeight.bold,
//                                                           color: Colors.black),
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 Container(
//                                                   height: size.height * 0.05,
//                                                   width: size.width,
//                                                   child: Center(
//                                                       child: Text(
//                                                           comparesubcategory[1]
//                                                               .toString())),
//                                                 ),
//                                                 Container(
//                                                   height: size.height * 0.05,
//                                                   width: size.width,
//                                                   decoration: BoxDecoration(
//                                                       border: Border(
//                                                           top: BorderSide(
//                                                               color: Colors.grey
//                                                                   .shade400),
//                                                           bottom: BorderSide(
//                                                               color: Colors.grey
//                                                                   .shade400))),
//                                                   child: Center(
//                                                     child: Text(
//                                                       '',
//                                                       style: TextStyle(
//                                                           fontSize: 17,
//                                                           fontWeight:
//                                                           FontWeight.bold,
//                                                           color: Colors.black),
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 // Container(
//                                                 //   height: size.height * 0.05,
//                                                 //   width: size.width,
//                                                 //   child: Center(
//                                                 //       child: Text(
//                                                 //           compare_desc[1]
//                                                 //               .toString())),
//                                                 // ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       if (compareitem_name[2] != null &&
//                                           compareitem_name[2].isNotEmpty)
//                                         Container(
//                                           // height: size.height * 0.3,
//                                           width: size.width * 0.5,
//                                           color: Colors.white,
//                                           child: Padding(
//                                             padding: const EdgeInsets.all(8.0),
//                                             child: Column(
//                                               children: [
//                                                 Container(
//                                                   height: size.height * 0.05,
//                                                   width: size.width,
//                                                   decoration: BoxDecoration(
//                                                       border: Border(
//                                                           top: BorderSide(
//                                                               color: Colors.grey
//                                                                   .shade400),
//                                                           bottom: BorderSide(
//                                                               color: Colors.grey
//                                                                   .shade400))),
//                                                   child: Center(
//                                                     child: Text(
//                                                       '',
//                                                       style: TextStyle(
//                                                           fontSize: 17,
//                                                           fontWeight:
//                                                           FontWeight.bold,
//                                                           color: Colors.black),
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 Container(
//                                                   height: size.height * 0.05,
//                                                   width: size.width,
//                                                   child: Center(
//                                                       child: Text(
//                                                           compareitem_name[2]
//                                                               .toString())),
//                                                 ),
//                                                 Container(
//                                                   height: size.height * 0.05,
//                                                   width: size.width,
//                                                   decoration: BoxDecoration(
//                                                       border: Border(
//                                                           top: BorderSide(
//                                                               color: Colors.grey
//                                                                   .shade400),
//                                                           bottom: BorderSide(
//                                                               color: Colors.grey
//                                                                   .shade400))),
//                                                   child: Center(
//                                                     child: Text(
//                                                       '',
//                                                       style: TextStyle(
//                                                           fontSize: 17,
//                                                           fontWeight:
//                                                           FontWeight.bold,
//                                                           color: Colors.black),
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 Container(
//                                                   // height: size.height * 0.3,
//                                                   width: size.width * 0.5,
//                                                   color: Colors.white,
//                                                   child: Padding(
//                                                     padding:
//                                                     const EdgeInsets.all(
//                                                         8.0),
//                                                     child: Column(
//                                                       children: [
//                                                         Container(
//                                                           height:
//                                                           size.height * 0.2,
//                                                           width: size.width,
//                                                           child: Image.network(
//                                                               compareitem_img[2]
//                                                                   .toString()),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 Container(
//                                                   height: size.height * 0.05,
//                                                   width: size.width,
//                                                   decoration: BoxDecoration(
//                                                       border: Border(
//                                                           top: BorderSide(
//                                                               color: Colors.grey
//                                                                   .shade400),
//                                                           bottom: BorderSide(
//                                                               color: Colors.grey
//                                                                   .shade400))),
//                                                   child: Center(
//                                                     child: Text(
//                                                       '',
//                                                       style: TextStyle(
//                                                           fontSize: 17,
//                                                           fontWeight:
//                                                           FontWeight.bold,
//                                                           color: Colors.black),
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 Container(
//                                                   height: size.height * 0.05,
//                                                   width: size.width,
//                                                   child: Center(
//                                                       child: Row(
//                                                         mainAxisAlignment:
//                                                         MainAxisAlignment
//                                                             .center,
//                                                         children: [
//                                                           Text("RM"),
//                                                           Text(compareitem_price[2]
//                                                               .toString()),
//                                                         ],
//                                                       )),
//                                                 ),
//                                                 Container(
//                                                   height: size.height * 0.05,
//                                                   width: size.width,
//                                                   decoration: BoxDecoration(
//                                                       border: Border(
//                                                           top: BorderSide(
//                                                               color: Colors.grey
//                                                                   .shade400),
//                                                           bottom: BorderSide(
//                                                               color: Colors.grey
//                                                                   .shade400))),
//                                                   child: Center(
//                                                     child: Text(
//                                                       '',
//                                                       style: TextStyle(
//                                                           fontSize: 17,
//                                                           fontWeight:
//                                                           FontWeight.bold,
//                                                           color: Colors.black),
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 Container(
//                                                   height: size.height * 0.05,
//                                                   width: size.width,
//                                                   child: Center(
//                                                       child: Text(
//                                                           comparebrand[2]
//                                                               .toString())),
//                                                 ),
//                                                 Container(
//                                                   height: size.height * 0.05,
//                                                   width: size.width,
//                                                   decoration: BoxDecoration(
//                                                       border: Border(
//                                                           top: BorderSide(
//                                                               color: Colors.grey
//                                                                   .shade400),
//                                                           bottom: BorderSide(
//                                                               color: Colors.grey
//                                                                   .shade400))),
//                                                   child: Center(
//                                                     child: Text(
//                                                       '',
//                                                       style: TextStyle(
//                                                           fontSize: 17,
//                                                           fontWeight:
//                                                           FontWeight.bold,
//                                                           color: Colors.black),
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 Container(
//                                                   height: size.height * 0.05,
//                                                   width: size.width,
//                                                   child: Center(
//                                                       child: Text(
//                                                           comparesubcategory[2]
//                                                               .toString())),
//                                                 ),
//                                                 Container(
//                                                   height: size.height * 0.05,
//                                                   width: size.width,
//                                                   decoration: BoxDecoration(
//                                                       border: Border(
//                                                           top: BorderSide(
//                                                               color: Colors.grey
//                                                                   .shade400),
//                                                           bottom: BorderSide(
//                                                               color: Colors.grey
//                                                                   .shade400))),
//                                                   child: Center(
//                                                     child: Text(
//                                                       '',
//                                                       style: TextStyle(
//                                                           fontSize: 17,
//                                                           fontWeight:
//                                                           FontWeight.bold,
//                                                           color: Colors.black),
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 Container(
//                                                   height: size.height * 0.05,
//                                                   width: size.width,
//                                                   child: Center(
//                                                       child: Text(
//                                                           compare_desc[2]
//                                                               .toString())),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ],
//                     )
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
