import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myrunciit/add_to_cart/add_to_cart.dart';
import 'package:myrunciit/bottom_navigationbar/deals_page/deals_sub_category/today_sub_category.dart';
import 'package:myrunciit/roots/roots.dart';
import 'package:myrunciit/widget/cart.dart';
import 'package:shared_preferences/shared_preferences.dart';

var store_id;

class Most_viewedgrid extends StatefulWidget {
  @override
  _Most_viewedgridState createState() => _Most_viewedgridState();
}

class _Most_viewedgridState extends State<Most_viewedgrid> {
  StreamController<List> _most_viewedController = StreamController<List>();

  List most = [];
  var all_price = [];

  getstoreid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      store_id = prefs.getString('storeid');
    });
    print('gridview3store_id===>>> $store_id');
    getrencent();
  }

  @override
  void initState() {
    setState(() {
      getstoreid();
    });

    super.initState();
  }

  @override
  void dispose() {
    _most_viewedController.close();
    super.dispose();
  }

  getrencent() async {
    String url1 = "$root_web/getMostViewedProducts/${store_id}";
    print("url data =>> ${url1}");
    dynamic response = await http.get(Uri.parse(url1));
    var jsonResponse = jsonDecode(response.body);
    var status = jsonResponse["status"];
    if (status == "SUCCESS") {
      print('success_getmostview-----------------------');
      print(response.body);
      dynamic jsonResponse = jsonDecode(response.body);
      if (jsonResponse != null &&
          jsonResponse['Response'] != null &&
          jsonResponse['Response']["mostViewedProducts"] != null) {
        setState(() {
          most = jsonResponse['Response']["mostViewedProducts"];
          _most_viewedController.add(most);
          for (var k = 0; k < most.length; k++) {
            // all_data.add(recommended_response["Response"][k]);
            var ob_data = jsonDecode(most[k]["multiple_price"]);
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
                all_price.add(most[k]["sale_price"].toString());
              });
            }

          }
          print(most);
        });
      } else {
        print("Invalid response format or missing data");
      }
    } else {
      print("failure");
    }
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
          body: StreamBuilder<List>(
            stream: _most_viewedController.stream,
            builder: (context, snapshot) {
              if ((snapshot.hasData)) {
                List<dynamic> most = snapshot.data!;
                return Padding(
                  padding: const EdgeInsets.only(left: 0),
                  child: Container(
                    width: size.width,
                    color: Colors.white,
                    child: GridView.count(
                      physics: NeverScrollableScrollPhysics(), // Disable vertical scroll

                      scrollDirection: Axis.vertical,
                      crossAxisCount: 2,
                      childAspectRatio: (1/1.18),
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 0.0,

                      children: List.generate(most.length > 4 ? 4 : most.length, (index) {

                        print("hello12345o");
                        // print(discountedPrice);
                        return GestureDetector(
                          onTap: () {
                            if (added == 'true') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddToCart(
                                    sub_category: most[index]["sub_category_name"],
                                    tax:most[index]["tax"],
                                    tax_type:most[index]["tax_type"],
                                    multi_price: most[index]["multiple_price"],
                                    product_muti_images: most[index]["product_image"],
                                      categoryName: most[index]["title"].toString(),
                                      categoryImage:
                                      most[index]["banner"].toString(),
                                      sale_price:
                                      most[index]["sale_price"].toString(),
                                      current_stock:
                                      most[index]["current_stock"].toString(),
                                      description:
                                      most[index]["description"].toString(),
                                      discount: most[index]["discount"].toString(),
                                      product_id: most[index]["product_id"].toString(),
                                      options: most[index]['options'],
                                    brand_name: most[index]['brand_name'],
                                    cod_status: most[index]['cod_status'].toString(),
                                  ),
                                ),
                              );

                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CategoryDetailScreen(
                                    tax: most[index]["tax"],
                                    tax_type: most[index]["tax_type"],
                                    multi_price: most[index]["multiple_price"],
                                    product_images: most[index]["product_image"],
                                      categoryName: most[index]["title"].toString(),
                                      categoryImage:
                                      most[index]["banner"].toString(),
                                      sale_price:
                                      most[index]["sale_price"].toString(),
                                      current_stock:
                                      most[index]["current_stock"].toString(),
                                      description:
                                      most[index]["description"].toString(),
                                      discount: most[index]["discount"].toString(),
                                      brand_name:
                                      most[index]["brand_name"].toString(),
                                      product_id: most[index]["product_id"].toString(),
                                      options: most[index]['options'],
                                    cod_status: most[index]['cod_status'].toString(),
                                    sub_category: most[index]['sub_category_name'].toString(),

                                  ),
                                ),
                              );

                            }
                          },
                          behavior: HitTestBehavior.translucent,
                          child: Column(
                            children: [
                              SafeArea(
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border:
                                      Border.all(color: Colors.grey.shade100)),
                                  width: size.width * 0.55,
                                  height: size.height * 0.25,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (int.tryParse(
                                          most[index]["discount"]) !=
                                          null &&
                                          int.parse(most[index]["discount"]) >
                                              0)
                                        Padding(
                                          padding:
                                          const EdgeInsets.fromLTRB(4, 8, 0, 0),
                                          child: Container(
                                            height: size.height * 0.02,
                                            width: size.width * 0.15,
                                            decoration: const BoxDecoration(
                                              color: Color.fromRGBO(244, 194, 37, 1),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                            ),
                                            child: Center(
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets.fromLTRB(
                                                        4, 2, 0, 2),
                                                    child: Text(
                                                      most[index]["discount"]
                                                          .toString() +
                                                          "% offer",
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          fontWeight:
                                                          FontWeight.bold),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      else
                                        Padding(
                                          padding:
                                          const EdgeInsets.fromLTRB(4, 8, 0, 0),
                                          child: Container(
                                            height: size.height * 0.02,
                                            width: size.width * 0.15,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                            ),
                                            // child: Center(
                                            //   child: Row(
                                            //     children: [
                                            //       Padding(
                                            //         padding: const EdgeInsets.fromLTRB(6, 2, 0, 2),
                                            //         child: Text(
                                            //           most[index]["discount"].toString(),
                                            //           style: TextStyle(fontSize: 10),
                                            //           textAlign: TextAlign.center,
                                            //         ),
                                            //       ),
                                            //       Text(
                                            //         "% offer",
                                            //         style: TextStyle(fontSize: 10),
                                            //       )
                                            //     ],
                                            //   ),
                                            // ),
                                          ),
                                        ),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Container(
                                              height: 80,
                                              width: 100,
                                              child: most[index]["banner"] !=
                                                  null
                                                  ? Image.network(
                                                most[index]["banner"]
                                                    .toString(),
                                                errorBuilder: (BuildContext
                                                context,
                                                    Object error,
                                                    StackTrace? stackTrace) {
                                                  return Image.asset(
                                                      'asset/dummy.jpg');
                                                },
                                              )
                                                  : Image.asset('asset/dummy.jpg'),
                                            ),
                                          ),
                                          SizedBox(
                                            height: size.height * 0.002,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 8, right: 8),
                                            child: Text(
                                              most[index]["title"].toString(),
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          SizedBox(
                                              height: size.height * 0.02
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 7, 0, 0),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: [
                                                Center(
                                                  child: Text(
                                                    "RM ",
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 9,
                                                        fontWeight: FontWeight.bold),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),

                                                if (int.tryParse(
                                                    most[index]["discount"]) !=
                                                    null &&
                                                    int.parse(most[index]["discount"]) >
                                                        0)
                                                  Text.rich(TextSpan(
                                                    // text: 'This item costs ',
                                                    children: <TextSpan>[
                                                      new TextSpan(
                                                        text:  all_price[index]
                                                            .toString(),
                                                        style: new TextStyle(
                                                          color: Colors.grey,
                                                          decoration: TextDecoration.lineThrough,
                                                        ),
                                                      ),

                                                      new TextSpan(
                                                        text:(double.parse(all_price[index]) -
                                                            (double.parse(all_price[index])

                                                                * (double.parse(most[index]["discount"])
                                                                    *0.01)
                                                            )
                                                        ).toStringAsFixed(2),

                                                      ),
                                                    ],
                                                  ),

                                                  )
                                                else
                                                  Text.rich(TextSpan(
                                                    // text: 'This item costs ',
                                                    children: <TextSpan>[
                                                      new TextSpan(
                                                        text:  all_price[index]
                                                            .toString(),
                                                        style: new TextStyle(
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ],
                                                  ),

                                                  )

                                              ],
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
                        );
                      }),
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          )),
    );
  }
}
