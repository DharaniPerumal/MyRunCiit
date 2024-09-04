import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myrunciit/add_to_cart/add_to_cart.dart';
import 'package:myrunciit/bottom_navigationbar/deals_page/advance_search.dart';
import 'package:myrunciit/bottom_navigationbar/deals_page/deals_sub_category/today_sub_category.dart';
import 'package:myrunciit/roots/roots.dart';
import 'package:myrunciit/widget/cart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Recently_viewed extends StatefulWidget {
  @override
  _Recently_viewedState createState() => _Recently_viewedState();
}

class _Recently_viewedState extends State<Recently_viewed> {
  StreamController<List> _dealsStreamController = StreamController<List>();
  bool recently_viewed = false;

  List product2 = [];
  var store_id;

  void initState() {
    getstoreid();
    super.initState();
  }

  getstoreid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      store_id = prefs.getString('storeid');
      adv_status = prefs.getString('advstatus');
      print("adv_status$adv_status");
      recently_viewed = prefs.getBool('Recent')!;
      print("recently_viewed$recently_viewed");
    });
    print('gridview3store_id===>>> $store_id');

    adv_title = prefs.getStringList('advtitle') ?? [];
    adv_tax = prefs.getStringList('advtax') ?? [];
    adv_taxtype = prefs.getStringList('advtax_type') ?? [];
    adv_multipleprice = prefs.getStringList('advmultiple_price') ?? [];
    adv_saleprice = prefs.getStringList('advsale_price') ?? [];
    adv_currentstock = prefs.getStringList('advcurrent_stock') ?? [];
    adv_description = prefs.getStringList('advdescription') ?? [];
    adv_discount = prefs.getStringList('advdiscount') ?? [];
    adv_productid = prefs.getStringList('advproduct_id') ?? [];
    adv_options = prefs.getStringList('advoptions') ?? [];
    adv_image = prefs.getStringList('advimage') ?? [];
    adv_banner = prefs.getStringList('advbanner') ?? [];
    adv_codstatus = prefs.getStringList('advcod_status') ?? [];
    adv_brandname = prefs.getStringList('advbrand_name') ?? [];
    setState(() {
      adv_image = adv_image.map((url) {
        return url.replaceAll('[', '').replaceAll(']', '');
      }).toList();
    });

    print("adv_title$adv_title");
    print("adv_tax$adv_tax");
    print("adv_taxtype$adv_taxtype");
    print("adv_multipleprice$adv_multipleprice");
    print("adv_saleprice$adv_saleprice");
    print("adv_currentstock$adv_currentstock");
    print("adv_description$adv_description");
    print("adv_discount$adv_discount");
    print("adv_productid$adv_productid");
    print("adv_options$adv_options");
    print("adv_image$adv_image");
    print("adv_banner$adv_banner");

    print("adv_codstatus$adv_codstatus");
    print("adv_brandname$adv_brandname");
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // print(widget.product1);
    // print('object1111111111');
    // print(widget.product1);

    return Padding(
        padding: const EdgeInsets.all(8.0),
        child:
        recently_viewed == true ?
        adv_status == "SUCCESS" ?
        GridView.count(
          scrollDirection: Axis.vertical,
          crossAxisCount: 2,
          childAspectRatio: (1 / 1.2),
          crossAxisSpacing: 0.0,
          mainAxisSpacing: 0.0,
          children: List.generate(adv_productid.length, (index) {
            // var optionsJson = jsonDecode(adv_options[index]);

            // List<String> optionValues = [];

            // if (optionsJson is List) {
            // for (var option in optionsJson) {
            //   if (option['option'] is List) {
            //     for (var value in option['option']) {
            //       for (int i = 0; i < 1; i++) {
            //         if (optionsJson[0]["title"] == 'KG') {
            //           optionValues;
            //           print("helooo====20");
            //           print(optionValues);
            //           print(value);
            //         }
            //       }
            //     }
            //   }
            // }

            return GestureDetector(
              onTap: () {
                print("its an image" + adv_image[index]);
                if (added == 'true') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddToCart(
                        sub_category: adv_sub[index],
                        tax: adv_tax[index],
                        tax_type: adv_taxtype[index],
                        multi_price: adv_multipleprice[index],
                        product_muti_images: [adv_image[index]],
                        categoryName: adv_title[index].toString(),
                        categoryImage: adv_banner[index].toString(),
                        sale_price: adv_saleprice[index].toString(),
                        current_stock: adv_currentstock[index].toString(),
                        description: adv_description[index].toString(),
                        discount: adv_discount[index].toString(),
                        product_id: adv_productid[index].toString(),
                        options: adv_options[index],
                        brand_name: adv_brandname[index],
                        cod_status: adv_codstatus[index].toString(),
                      ),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategoryDetailScreen(
                        tax: adv_tax[index],
                        tax_type: adv_taxtype[index],
                        multi_price: adv_multipleprice[index],
                        // product_muti_images: adv_image[index],
                        categoryName: adv_title[index].toString(),
                        categoryImage: adv_banner[index].toString(),
                        sale_price: adv_saleprice[index].toString(),
                        current_stock: adv_currentstock[index].toString(),
                        description: adv_description[index].toString(),
                        discount: adv_discount[index].toString(),
                        product_id: adv_productid[index].toString(),
                        options: adv_options[index],
                        brand_name: adv_brandname[index],
                        cod_status: adv_codstatus[index].toString(),
                        product_images: [adv_image[index]],
                        sub_category: adv_productid[index],
                      ),
                    ),
                  );
                }
              },
              behavior: HitTestBehavior.translucent,
              child: Container(
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
                margin: EdgeInsets.fromLTRB(18.0, 15.0, 18.0, 15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (adv_discount[index] != null &&
                        int.tryParse(adv_discount[index].toString()) != null &&
                        int.parse(adv_discount[index].toString()) > 0)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 8, 0, 0),
                        child: Container(
                          height: size.height * 0.02,
                          width: size.width * 0.15,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(244, 194, 37, 1),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(6, 2, 0, 2),
                                child: Text(
                                  adv_discount[index].toString(),
                                  style: TextStyle(fontSize: 10),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Text(
                                "% offer",
                                style: TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 8, 0, 0),
                        child: Container(
                          height: size.height * 0.02,
                          width: size.width * 0.15,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Center(
                        child: Container(
                          height: 60,
                          width: 80,
                          // color: Colors.cyan,
                          child: adv_image[index].toString() != null
                              ? Image.network(
                            adv_banner[index].toString(),
                            errorBuilder: (BuildContext context,
                                Object error, StackTrace? stackTrace) {
                              return Image.asset('asset/dummy.jpg');
                            },
                          )
                              : Image.asset('asset/dummy.jpg'),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.005,
                    ),
                    Container(
                      height: size.height * 0.05,
                      width: size.width * 0.5,
                      child: Center(
                        child: Text(
                          adv_title[index].toString(),
                          style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Center(
                      child: adv_discount[index] != null &&
                          int.tryParse(adv_discount[index].toString()) !=
                              null &&
                          int.parse(adv_discount[index].toString()) > 0
                          ? Container(
                        // Your original code with some modifications
                        decoration: const BoxDecoration(
                          color: Color(0xffc40001),
                          borderRadius:
                          BorderRadius.all(Radius.circular(5)),
                        ),
                        height: size.height * 0.02,
                        width: size.width * 0.35,
                        child: Center(
                          child: Text.rich(
                            TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: adv_saleprice[index].toString(),
                                  style: TextStyle(
                                    color: Colors.grey,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                                TextSpan(
                                  text: "RM " +
                                      (double.parse(adv_saleprice[index]) -
                                          (double.parse(adv_saleprice[
                                          index]) *
                                              (double.parse(
                                                  adv_discount[
                                                  index]) *
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
                          borderRadius:
                          BorderRadius.all(Radius.circular(5)),
                        ),
                        height: size.height * 0.02,
                        width: size.width * 0.30,
                        child: Center(
                          child: Text(
                            "RM " + adv_saleprice[index].toString(),
                            style: TextStyle(
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
          }),
        ) :
        Container(
          height: size.height*0.2,
          width: size.width,
          child: Center(child: Text("Filter-based product is not available",style: TextStyle(color: Colors.black,fontSize: 15),)),
        ) : adv2()

    );
  }
}


class adv2 extends StatefulWidget {
  const adv2({super.key});

  @override
  State<adv2> createState() => _adv2State();
}

class _adv2State extends State<adv2> {
  StreamController<List> _recently_viewedController = StreamController<List>();

  List recent = [];

  // List subcategories = [];

  @override
  void initState() {
    getrencent();
    super.initState();
  }

  @override
  void dispose() {
    _recently_viewedController.close();
    super.dispose();
  }

  getrencent() async {
    String url1 = "$root_web/getrecentlyviewed/2";
    // https://myrunciit.my/webservice/all_category
    dynamic response = await http.get(Uri.parse(url1));
    if (response.statusCode == 200) {
      print('success');
      print(response.body);
      dynamic jsonResponse = jsonDecode(response.body);

      // Check if the response is valid and contains the expected data
      if (jsonResponse != null &&
          jsonResponse['Response'] != null &&
          jsonResponse['Response']["recentlyViewedProducts"] != null) {
        setState(() {
          // Access the array of categories from the response
          recent = jsonResponse['Response']["recentlyViewedProducts"];
          _recently_viewedController.add(recent);

          print(recent);
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
    return Scaffold(
        body: StreamBuilder<List>(
          stream: _recently_viewedController.stream,
          builder: (context, snapshot) {
            if ((snapshot.hasData)) {
              List recent = snapshot.data!;
              return ListView.builder(
                itemCount: recent.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                      onTap: () {
                        if (added == 'true') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddToCart(
                                sub_category: recent[index]["sub_category_name"],
                                tax:recent[index]["tax"],
                                tax_type:recent[index]["tax_type"],
                                multi_price: recent[index]["multiple_price"],
                                product_muti_images: recent[index]["product_image"],
                                categoryName: recent[index]["title"].toString(),
                                categoryImage: recent[index]["banner"].toString(),
                                sale_price: recent[index]["sale_price"].toString(),
                                current_stock:
                                recent[index]["current_stock"].toString(),
                                description: recent[index]["description"].toString(),
                                discount: recent[index]["discount"].toString(),
                                product_id: recent[index]["product_id"].toString(),
                                options: recent[index]['options'],
                                brand_name: recent[index]['brand_name'],
                                cod_status: recent[index]['cod_status'].toString(),
                              ),
                            ),
                          );

                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CategoryDetailScreen(
                                tax: recent[index]["tax"],
                                tax_type: recent[index]["tax_type"],
                                multi_price: recent[index]["multiple_price"],
                                product_images: recent[index]["product_image"],
                                categoryName: recent[index]["title"].toString(),
                                categoryImage: recent[index]["banner"].toString(),
                                sale_price: recent[index]["sale_price"].toString(),
                                current_stock:
                                recent[index]["current_stock"].toString(),
                                product_id: recent[index]["product_id"].toString(),

                                description: recent[index]["description"].toString(),
                                discount: recent[index]["discount"].toString(),
                                brand_name: recent[index]["brand_name"].toString(),
                                // weight: recent[index]["option"].toString(),
                                options: recent[index]['options'],
                                cod_status: recent[index]['cod_status'].toString(),
                                sub_category: recent[index]['sub_category_name'].toString(),

                              ),
                            ),
                          );

                        }

                      },
                      behavior: HitTestBehavior.translucent,
                      child: Container(
                        height: size.height * 0.19,
                        color: Colors.white,
                        child: Column(
                          children: [
                            Container(
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
                              margin: EdgeInsets.all(8.0),
                              width: size.width,
                              // height: size.height * 0.15,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (int.tryParse(recent[index]["discount"]) !=
                                      null &&
                                      int.parse(recent[index]["discount"]) > 0)
                                    Padding(
                                      padding:
                                      const EdgeInsets.fromLTRB(8, 8, 0, 0),
                                      child: Container(
                                        height: size.height * 0.02,
                                        width: size.width * 0.15,
                                        decoration: BoxDecoration(
                                          color: Color.fromRGBO(244, 194, 37, 1),
                                          borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                        ),
                                        child: Center(
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.fromLTRB(
                                                    6, 2, 0, 2),
                                                child: Text(
                                                  recent[index]["discount"]
                                                      .toString() +
                                                      "% offer",
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      fontWeight: FontWeight.bold),
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
                                      const EdgeInsets.fromLTRB(8, 8, 0, 0),
                                      child: Container(
                                        height: size.height * 0.02,
                                        width: size.width * 0.15,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                        ),
                                      ),
                                    ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          height: 80,
                                          width: 100,
                                          child: recent[index]["banner"] != null
                                              ? Image.network(
                                            recent[index]["banner"]
                                                .toString(),
                                            errorBuilder:
                                                (BuildContext context,
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
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              recent[index]["title"].toString(),
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              height: size.height * 0.05,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  "RM ",
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 9,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                                if (int.tryParse(
                                                    recent[index]["discount"]) !=
                                                    null &&
                                                    int.parse(recent[index]["discount"]) >
                                                        0)
                                                  Text.rich(TextSpan(
                                                    // text: 'This item costs ',
                                                    children: <TextSpan>[
                                                      new TextSpan(
                                                        text:  recent[index]["sale_price"]
                                                            .toString(),
                                                        style: new TextStyle(
                                                          color: Colors.grey,
                                                          decoration: TextDecoration.lineThrough,
                                                        ),
                                                      ),

                                                      new TextSpan(
                                                        text:(double.parse(recent[index]["sale_price"]) -
                                                            (double.parse(recent[index]["sale_price"])

                                                                * (double.parse(recent[index]["discount"])
                                                                    *0.01)
                                                            )
                                                        ).toStringAsFixed(2),

                                                      ),
                                                    ],
                                                  ),

                                                  )  else
                                                  Text.rich(TextSpan(
                                                    // text: 'This item costs ',
                                                    children: <TextSpan>[
                                                      new TextSpan(
                                                        text:  recent[index]["sale_price"]
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
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ));
                },
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),));
            }
          },
        ));
  }
}
