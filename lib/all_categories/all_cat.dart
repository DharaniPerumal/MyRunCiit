
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:myrunciit/main_screen/sub_categories/sub_category_1.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../roots/roots.dart';
import '../test.dart';

var store_id;
var img = [];
var name_dat = [];
var id = [];
var cat_id = [];
var sub_cat = [];
var pro_ind = [];
class all_cat extends StatefulWidget {
  const all_cat({Key? key}) : super(key: key);

  @override
  _all_catState createState() => _all_catState();
}

class _all_catState extends State<all_cat> {
  List product = [];

  getProduct() async {

    String url1 = "$root_web/all_category/${store_id}";
    print('getproduct -------------------> $url1');
    dynamic response = await http.get(Uri.parse(url1));
    if (response.statusCode == 200) {
      print('success of categories');
      print(response.body);
      dynamic jsonResponse = jsonDecode(response.body);
      if (jsonResponse != null &&
          jsonResponse['Response'] != null &&
          jsonResponse['Response']['category'] != null) {
        setState(() {
          product = jsonResponse['Response']['category'];
          img = [];
          cat_id = [];
          name_dat = [];
          id = [];
          pro_ind = [];
          for(var k=0;k<product.length;k++)
          {
            sub_cat.add("main");
            cat_id.add(product[k]["category_id"]);
            img.add(product[k]["banner"]);
            name_dat.add(product[k]["category_name"]);
            id.add(product[k]["category_id"]);
            pro_ind.add(0);
            if(product[k]["sub_category"]!=null)
              for(var f=0;f<product[k]["sub_category"].length;f++)
              {
                pro_ind.add(f);
                sub_cat.add("sub");
                img.add(product[k]["sub_category"][f]["banner"]);
                name_dat.add(product[k]["sub_category"][f]["sub_category_name"]);
                id.add(product[k]["sub_category"][f]["category_id"]);
              }
          }
        });
      } else {
        print("Invalid response format or missing data");
      }
    } else {
      print("failure");
    }
  }

  setstoreid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      store_id = prefs.getString('storeid');
    });

    print('store_id ---------- $store_id');
    getProduct();
  }

  @override
  void initState() {
    setState(() {
      setstoreid();

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("All Categories"),
      ),
      body: Container(
        width: size.width * 0.95,
        height: size.height,// Set a fixed width
        child: GridView.count(
          scrollDirection: Axis.vertical,
          crossAxisCount: 3,
          mainAxisSpacing: 5,
          crossAxisSpacing: 5,
          // physics: NeverScrollableScrollPhysics(), // Disable vertical scroll
          shrinkWrap: true, // Allow GridView to be in a SingleChildScrollView
          children: List.generate(name_dat.length , (index) {
            return GestureDetector(
              onTap: () {
                var ind = cat_id.indexOf(id[index]);
                if (product[ind]['sub_category'] != null &&
                    product[ind]['sub_category'].isNotEmpty) {
                  if(sub_cat[index]=="sub")
                  {
                    print("i am clicked 1");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Product_specific(
                                  store_data: store_id
                                      .toString(),
                                  product_id: pro_ind[index].toString(),
                                  sub_cat: product[ind]['sub_category'],
                                )));
                  }
                  else
                  {
                    print("i am clicked 2");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Subcategory(
                          subcategories: product[ind]['sub_category'],
                          store_data: store_id,
                        ),
                      ),
                    );
                  }

                } else {
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
              },
              behavior: HitTestBehavior.translucent,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade100),
                ),
                margin: EdgeInsets.all(0.0),
                child: Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 60,
                          width: 80,
                          child: img[index] != null
                              ? Image.network(
                            img[index].toString(),
                            errorBuilder: (BuildContext context,
                                Object error, StackTrace? stackTrace) {
                              return Image.asset('asset/dummy.jpg');
                            },
                          )
                              : Image.asset('asset/dummy.jpg'),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.002,
                      ),
                      Text(
                        name_dat[index].toString(),
                        style: TextStyle(fontSize: 10),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}



// ----------------------------------------------------------------------------------
// import 'dart:convert';
// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:myrunciit/main_screen/sub_categories/sub_category_1.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../roots/roots.dart';
//
// var store_id;
//
// class HorizontalGridView extends StatefulWidget {
//   const HorizontalGridView({Key? key}) : super(key: key);
//
//   @override
//   _HorizontalGridViewState createState() => _HorizontalGridViewState();
// }
//
// class _HorizontalGridViewState extends State<HorizontalGridView> {
//   List product = [];
//
//   getProduct() async {
//
//     String url1 = "$root_web/all_category/${store_id}";
//     print('getproduct -------------------> $url1');
//     dynamic response = await http.get(Uri.parse(url1));
//     if (response.statusCode == 200) {
//       print('success of categories');
//       print(response.body);
//       dynamic jsonResponse = jsonDecode(response.body);
//       if (jsonResponse != null &&
//           jsonResponse['Response'] != null &&
//           jsonResponse['Response']['category'] != null) {
//         setState(() {
//           product = jsonResponse['Response']['category'];
//         });
//       } else {
//         print("Invalid response format or missing data");
//       }
//     } else {
//       print("failure");
//     }
//   }
//
//   setstoreid() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       store_id = prefs.getString('storeid');
//     });
//
//     print('store_id ---------- $store_id');
//     getProduct();
//   }
//
//   @override
//   void initState() {
//     setState(() {
//       setstoreid();
//
//     });
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: Container(
//         width: size.width * 0.95, // Set a fixed width
//         child: GridView.count(
//           scrollDirection: Axis.vertical,
//           crossAxisCount: 3,
//           mainAxisSpacing: 5,
//           crossAxisSpacing: 5,
//           physics: NeverScrollableScrollPhysics(), // Disable vertical scroll
//           shrinkWrap: true, // Allow GridView to be in a SingleChildScrollView
//           children: List.generate(product.length ?? 0, (index) {
//             return GestureDetector(
//               onTap: () {
//                 if (product[index]['sub_category'] != null &&
//                     product[index]['sub_category'].isNotEmpty) {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => Subcategory(
//                         subcategories: product[index]['sub_category'],
//                         store_data: store_id,
//                       ),
//                     ),
//                   );
//                 } else {
//                   showDialog(
//                     context: context,
//                     builder: (BuildContext context) {
//                       return AlertDialog(
//                         content: Text("No Sub Category Products"),
//                         actions: [
//                           ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.lightGreen,
//                             ),
//                             child: Center(child: Text("OK")),
//                             onPressed: () {
//                               Navigator.of(context).pop();
//                             },
//                           ),
//                         ],
//                       );
//                     },
//                   );
//                 }
//               },
//               behavior: HitTestBehavior.translucent,
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   border: Border.all(color: Colors.grey.shade100),
//                 ),
//                 margin: EdgeInsets.all(0.0),
//                 child: Center(
//                   child: Column(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Container(
//                           height: 60,
//                           width: 80,
//                           child: product[index]["banner"] != null
//                               ? Image.network(
//                             product[index]["banner"].toString(),
//                             errorBuilder: (BuildContext context,
//                                 Object error, StackTrace? stackTrace) {
//                               return Image.asset('asset/dummy.jpg');
//                             },
//                           )
//                               : Image.asset('asset/dummy.jpg'),
//                         ),
//                       ),
//                       SizedBox(
//                         height: size.height * 0.002,
//                       ),
//                       Text(
//                         product[index]["category_name"].toString(),
//                         style: TextStyle(fontSize: 10),
//                         textAlign: TextAlign.center,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           }),
//         ),
//       ),
//     );
//   }
// }