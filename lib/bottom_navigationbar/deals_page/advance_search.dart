import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:myrunciit/bottom_navigationbar/deals_page/deals_sub_category/today_sub_category.dart';
import 'package:myrunciit/widget/cart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../add_to_cart/add_to_cart.dart';

List<String> adv_title = [];
List<String> adv_tax = [];
List<String> adv_taxtype = [];
List<String> adv_sub = [];
List<String> adv_multipleprice = [];
List<String> adv_saleprice = [];
List<String> adv_currentstock = [];
List<String> adv_description = [];
List<String> adv_discount = [];
List<String> adv_productid = [];
List<String> adv_options = [];
List<String> adv_image = [];
List<String> adv_codstatus = [];
List<String> adv_brandname = [];
List<String> adv_banner = [];
var adv_status;
class AdvSearch extends StatefulWidget {
  List product1 = [];
  AdvSearch({Key? key}) : super(key: key);
  @override
  _AdvSearchState createState() => _AdvSearchState();
}

class _AdvSearchState extends State<AdvSearch> {
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
    });
    print('gridview3store_id===>>> $store_id');
    adv_title = prefs.getStringList('advtitle') ?? [];
    adv_tax = prefs.getStringList('advtax') ?? [];
    adv_sub = prefs.getStringList('adv_sub') ?? [];
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
    print(widget.product1);
    print('object1111111111');
    print(widget.product1);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child:
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
      ) : Container(
        height: size.height*0.2,
        width: size.width,
        child: Center(child: Text("Filter-based product is not available",style: TextStyle(color: Colors.black,fontSize: 15),)),
      )

    );
  }
}
