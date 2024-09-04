import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myrunciit/add_to_cart/cart_available.dart';
import 'package:myrunciit/bottom_navigationbar/deals.dart';
// import 'package:myrunciit/bottom_navigationbar/deals_page/deals_sub_category/today_sub_category.dart';
import 'package:myrunciit/drawer/Address/add_address.dart';
import 'package:myrunciit/drawer/wishlist.dart';
import 'package:myrunciit/product_screen/product_main_screen.dart';
import 'package:myrunciit/roots/roots.dart';
import 'package:myrunciit/widget/cart.dart';
import 'package:shared_preferences/shared_preferences.dart';

var initial = 0;
var productname;
var productimage;
var productprice;
var productstock;
var productdesc;
var productdiscount;
var addedToCart;
var product_id;
var productadded1;
var product_idsds;
List compareList1 = [];
var productname1;
var cartcount1;
var compare_name;
var compare_image;
var compare_price;
var compare_stock;
var compare_desc;
var compare_discount;
var compare_id;
var product_id1;
var compare_brand;
var compare_sub_category;
var name_category;
var cur_pos = 0;
List check_wish_list = [];
// var cur_pos = 0;
var show_price = "0";
CarouselController controller = CarouselController();
List cart = [];
var cartcount;
var slides;
int itemCount1 = 0;
var productadded;
List<Map<String, dynamic>> options = [];
var option;
var value;
Map<String, int> selectedIndexes = {};

class AddToCart extends StatefulWidget {
  final String categoryName,
      categoryImage,
      sale_price,
      current_stock,
      description,
      discount,options,
      multi_price,
      product_id,
      cod_status,
      sub_category,
      tax,
      tax_type,
  brand_name;

  List product_muti_images;

  AddToCart({
    required this.categoryName,
    required this.categoryImage,
    required this.sale_price,
    required this.current_stock,
    required this.description,
    required this.discount,
    required this.multi_price,
    required this.product_muti_images,
    required this.tax,
    required this.sub_category,
    required this.tax_type,
    required this.product_id, required this.options, required this.brand_name, required this.cod_status,
  });

  @override
  _AddToCartState createState() => _AddToCartState();
}

class _AddToCartState extends State<AddToCart> {
  int itemCount = 0;
  var selectedTabIndex = 0;
  bool addedTocart = false;
  List cartItems = [];
  bool selected = true;
  late String item;
  List<int> idList = [];
  List<String> reviewuser = [];
  List<String> reviewimage = [];
  List<String> reviewrating = [];
  List<String> reviewtitle = [];
  List<String> reviewdesc = [];
  List<String> reviewdate = [];
  List<String> reviewname = [];
  List<String> titles = [];

  define_price(i,index) {
    if (i == 0) {
      var h = jsonDecode(widget.multi_price);
      if (h.length > 0) {
        setState(() {
          show_price = h[index]["amount"].toString();
        });
      }
      else {
        setState(() {
          show_price = widget.sale_price.toString();
        });
      }
    }
  }

  show_price_data()
  {
    if(initial == 0)
    {
      setState(() {
        initial = 1;
      });
      print("i am inside");
      var h = jsonDecode(widget.multi_price);
      var index = 0;
      var low = 10000000000000000;
      if(h.length != 0)
      {
        for(var hello=0;hello<h.length;hello++)
        {
          if(int.parse(h[hello]["amount"]) < low)
          {
            low = int.parse(h[hello]["amount"]);
            index = hello;
          }
        }
        setState(() {
          selectedIndexes[titles[0]] = index;
        });
        define_price(0, index);
      }
      else
      {
        setState(() {
          show_price = widget.sale_price.toString();
        });
      }
    }

  }

  void wishlist_list() async {
    String url1 = "$root_web/wishlist/list/0/${user_id == null ? 12 : user_id}";
    print('wishlist_list ----> $root_web/wishlist/list/0/${user_id}');
    print('wishlist_list ----> $url1');
    dynamic response = await http.get(Uri.parse(url1));
    if (response.statusCode == 200) {
      print('success1');
      print(response.body);
      dynamic jsonResponse = jsonDecode(response.body);
      wishlist_list_data = jsonResponse["Response"]["wishlistProducts"];
      print('wishlist_list_response ----> $wishlist_list_data');
      if (jsonResponse != null && jsonResponse['Response']['wishlistProducts'] != null) {
        setState(() {
          wishlist_list_details = jsonResponse['Response']['wishlistProducts'];
        });
        for(int i = 0; i < wishlist_list_details.length; i++ ) {
          if(widget.product_id == wishlist_list_details[i]['product_id'])
          {
            setState(() {
              selected = false;
            });
          }
          print('check_wish_list ---->  $selected');
        }
        print('wishlist_list $wishlist_list_details');
      } else {
        print("Invalid response format or missing data");
      }
    } else {
      print("failure");
    }
  }

  void addToCart() {
    setState(() {
      var existingItemIndex = cartItems.indexWhere((item) =>
          item['categoryName'] == widget.categoryName &&
          item['sale_price'] == widget.sale_price &&
          item['discount'] == widget.discount);
      print('existingItemIndex$existingItemIndex');

      if (existingItemIndex != -1) {
        cartItems[existingItemIndex]['count']++;
        print(cartItems[existingItemIndex]['count']++);
        print('cart_items4$cartItems');
      } else {
        cartItems.add({
          'categoryName': widget.categoryName,
          'categoryImage': widget.categoryImage,
          'sale_price': widget.sale_price,
          'current_stock': widget.current_stock,
          'description': widget.description,
          'discount': widget.discount,
          'count': 1,
        });

        print('cart_items_5$cartItems');
      }
      print('cart_items_3$cartItems');
      showCustomToast();
    });
  }

  void addToCart1() async {
    final SharedPreferences prefs1 = await SharedPreferences.getInstance();
    List<String> item_name1 = prefs1.getStringList('product_name') ?? [];
    print('item_name1$item_name1');
    print("selectedIndexes =>> ${selectedIndexes}");

    // setState(() {//okokokokokokokokokokokokok
      print('productname$productname');
      print('item_name$item_name');
      bool itemFound = false;
    // });
      for (String item in item_name1) {
        if (widget.categoryName == item) {
          print(widget.categoryName);
          print('productname$productname');
          print('item_name$item_name');
          showAlertDialog();
          showCustomToast();
          cartcount = itemCount;
          print('cartcount$cartcount');
          print('countAsInt----$countAsInt');

          addedTocart = true;
          itemFound = true;
          break;
        }
      }


      if (!itemFound) {
        print("object");
        showCustomToast();
        productadded = 'true';
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        List<String> a = [];
        List<String> b = [];
        List<String> c = [];
        List<String> d = [];
        List<String> e = [];
        List<String> f = [];
        List<String> g = [];
        List<String> h = [];
        List<String> i = [];
        List<String> j = [];
        List<String> k = [];
        List<String> l = [];
        List<String> m = [];

        product_id = widget.product_id;
        i = prefs.getStringList('product_id') ?? [];
        print('product_id$product_id');
        if (i.contains(product_id))
          await prefs.setString('product_added', '${productadded}');
        print('productadded$productadded');

        productname = widget.categoryName;
        print('productname$productname');
        a = prefs.getStringList('product_name') ?? [];
        print('a$a');
        a.add(productname);
        print('a1$a');
        await prefs.setStringList('product_name', a);

        productimage = widget.categoryImage;
        print('productimage$productimage');
        print('b$b');
        b = prefs.getStringList('product_image') ?? [];
        b.add(productimage);
        print('b1$b');
        await prefs.setStringList('product_image', b);

        c = prefs.getStringList('qty') ?? [];
        c.add("1");
        await prefs.setStringList('qty', c);

        productprice = show_price;
        d = prefs.getStringList('product_price') ?? [];
        d.add(productprice);
        await prefs.setStringList('product_price', d);

        productstock = widget.current_stock;
        e = prefs.getStringList('product_stock') ?? [];
        e.add(productstock);
        await prefs.setStringList('product_stock', e);

        productdesc = widget.description;
        f = prefs.getStringList('product_desc') ?? [];
        f.add(productdesc);
        await prefs.setStringList('product_desc', f);

        productdiscount = widget.discount;
        g = prefs.getStringList('product_discount') ?? [];
        g.add(productdiscount);
        await prefs.setStringList('product_discount', g);

        cart = cartItems;
        h = prefs.getStringList('cart_items') ?? [];
        h.add(cart.toString());
        await prefs.setStringList('cart_items', h);

        i.add(product_id.toString());
        await prefs.setStringList('product_id', i);
        print("i am printing the j before =>> ${j}");

        j = prefs.getStringList('cod_status') ?? [];
        j.add(widget.cod_status.toString());
        await prefs.setStringList('cod_status', j);
        print("i am printing the j =>> ${j}");

        k = prefs.getStringList('tax') ?? [];
        k.add(widget.tax.toString());
        await prefs.setStringList('tax', k);
        print("i am printing the j =>> ${j}");

        l = prefs.getStringList('tax_type') ?? [];
        l.add(widget.cod_status.toString());
        await prefs.setStringList('tax_type', l);
        print("i am printing the j =>> ${j}");

        m = prefs.getStringList('options') ?? [];
        m.add(selectedIndexes.toString());
        await prefs.setStringList('options', m);
        print("i am printing the j =>> ${m}");

        setState(() {
          countAsInt = a.length;
        });
      }


    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('cartcount', '${cartcount}');
  }

  void showCustomToast() {
    OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 80,
        child: Material(
          color: Colors.transparent,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.085,
                width: 70,
                color: Colors.grey.shade900,
                child: const Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: 50,
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.085,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  // borderRadius: BorderRadius.circular(8),
                  color: Color(0xff014282),
                ),
                child: const Center(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 8, 70, 10),
                    child: Text(
                      'SUCCESS : You have added Product to \nyour shopping cart!',
                      style: TextStyle(color: Colors.white, fontSize: 14.0),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry);

    Future.delayed(Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }

  void compareCart() {
    setState(() {
      var existingItemIndex = cartItems.indexWhere((item) =>
      item['categoryName'] == widget.categoryName &&
          item['sale_price'] == widget.sale_price &&
          item['discount'] == widget.discount);
      print('existingItemIndex$existingItemIndex');

      if (existingItemIndex != -1) {
        cartItems[existingItemIndex]['count']++;
        print(cartItems[existingItemIndex]['count']++);
        print('cart_items4$cartItems');
      } else {
        cartItems.add({
          'categoryName': widget.categoryName,
          'categoryImage': widget.categoryImage,
          'sale_price': widget.sale_price,
          'current_stock': widget.current_stock,
          'description': widget.description,
          'discount': widget.discount,
          'brand': widget.brand_name,
          'sub_category': widget.sub_category,
          'count': 1,
        });

        print('cart_items_5$cartItems');
      }
      print('cart_items_3$cartItems');
      showCustomToast();
    });
  }

  void comparetoCart1() async {
    final SharedPreferences prefs1 = await SharedPreferences.getInstance();
    List<String> item_name1 = prefs1.getStringList('product_name') ?? [];
    print('item_name1$item_name1');

    setState(() async {
      print('productname$productname1');
      // print('item_name$item_name');
      bool itemFound = false;

      for (String item in item_name1) {
        if (widget.categoryName == item) {
          print(widget.categoryName);
          // print('productname$productname');
          // print('item_name$item_name');
          // showAlertDialog();
          showCustomToast();
          cartcount1 = itemCount1;
          print('cartcount$cartcount1');
          print('countAsInt----$countAsInt');
          addedTocart = true;
          itemFound = true;
          break;
        }
      }

      if (!itemFound) {
        print("object");
        showCustomToast();
        productadded1 = 'true';
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        List<String> a = [];
        List<String> b = [];
        List<String> c = [];
        List<String> d = [];
        List<String> e = [];
        List<String> f = [];
        List<String> g = [];
        List<String> h = [];
        List<String> i = [];
        List<String> j = [];
        List<String> k = [];

        compare_id = widget.product_id;
        i = prefs.getStringList('product_id') ?? [];
        print('compare_id$compare_id');
        if (i.contains(compare_id))
          await prefs.setString('product_added1', '${productadded1}');
        print('productadded1$productadded1');

        compare_name = widget.categoryName;
        print('compare_name$compare_name');
        a = prefs.getStringList('compare_name') ?? [];
        print('a$a');
        a.add(compare_name);
        print('a1$a');
        await prefs.setStringList('compare_name', a);

        compare_image = widget.categoryImage;
        print('compare_image$compare_image');
        print('b$b');
        b = prefs.getStringList('compare_image') ?? [];
        b.add(compare_image);
        print('b1$b');
        await prefs.setStringList('compare_image', b);

        c = prefs.getStringList('qty') ?? [];
        c.add("1");
        await prefs.setStringList('qty', c);

        compare_price = widget.sale_price;
        d = prefs.getStringList('compare_price') ?? [];
        d.add(compare_price);
        await prefs.setStringList('compare_price', d);

        compare_stock = widget.current_stock;
        e = prefs.getStringList('compare_stock') ?? [];
        e.add(compare_price);
        await prefs.setStringList('compare_stock', e);

        compare_desc = widget.description;
        f = prefs.getStringList('compare_desc') ?? [];
        f.add(compare_desc);
        await prefs.setStringList('compare_desc', f);

        compare_discount = widget.discount;
        g = prefs.getStringList('compare_discount') ?? [];
        g.add(compare_discount);
        await prefs.setStringList('compare_discount', g);

        compare_brand = widget.brand_name;
        j = prefs.getStringList('compare_brand') ?? [];
        j.add(compare_brand);
        await prefs.setStringList('compare_brand', j);

        compare_sub_category = widget.sub_category;
        k = prefs.getStringList('compare_sub_category') ?? [];
        k.add(compare_sub_category);
        await prefs.setStringList('compare_sub_category', k);

        cart1 = cartItems;
        h = prefs.getStringList('cart_items1') ?? [];
        h.add(cart1.toString());
        await prefs.setStringList('cart_items1', h);

        i.add(product_id1.toString());
        await prefs.setStringList('product_id1', i);

        setState(() {
          countAsInt = a.length;
        });
      }
    });

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('cartcount', '${cartcount1}');
  }

  void compare_add() async {
      String url1 = "$root_web/compare/add/${widget.product_id}/${user_id}";
      print('compare ----> $url1');
      dynamic response = await http.get(Uri.parse(url1));
      if (response.statusCode == 200) {
        print('success1 compare');
        print(response.body);
        dynamic jsonResponse = jsonDecode(response.body);
        if (jsonResponse != null && jsonResponse['message'] != null) {
          Fluttertoast.showToast(
              msg: 'Product Added to Compare List...!',
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

  void wishlist_add() async {
    if(!selected){
      String url1 = "$root_web/wishlist/add/${widget.product_id}/${user_id}";
      print('wishlist_add ----> $url1');
      dynamic response = await http.get(Uri.parse(url1));
      if (response.statusCode == 200) {
        print('success1');
        print(response.body);
        dynamic jsonResponse = jsonDecode(response.body);
        if (jsonResponse != null && jsonResponse['Response'] != null) {
        } else {
          print("Invalid response format or missing data");
        }
      } else {
        print("failure");
      }
    }else{
      String url1 = "$root_web/wishlist/remove/${widget.product_id}/${user_id}";
      print('wishlist_remove ----> $url1');
      dynamic response = await http.get(Uri.parse(url1));
      if (response.statusCode == 200) {
        print('wishlist_remove');
        print(response.body);
        dynamic jsonResponse = jsonDecode(response.body);
        if (jsonResponse != null && jsonResponse['Response'] != null) {
        } else {
          print("Invalid response format or missing data");
        }
      } else {
        print("failure");
      }
    }
  }

  void showAlertDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: AlertDialog(
            title: Center(
                child: Text(
              "Product already added",
              style: TextStyle(fontSize: 16),
            )),
            content: Text(
              "Increase the quantity from the cart",
              style: TextStyle(fontSize: 14),
            ),
            actions: [
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.06,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Color(0xff7ec600),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'OK',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> get_user_id() async {
    SharedPreferences prefs1 = await SharedPreferences.getInstance();
    setState(() {
      user_id = prefs1.getString('user_id');
    });
    print('address_list_grid_userid===>>> $user_id');
  }

  @override
  void initState() {
    // TODO: implement initState
    print("hi mulit =>> ${widget.product_muti_images}");
    print("cod_status =>> ${widget.cod_status}");
    setState(() {
      initial = 0;
      get_user_id();
      wishlist_list();
      show_price = "0";
      // define_price(0);
      cur_pos = 0;
      slides = widget.product_muti_images.map<Widget>((element) {
        print("element is =>> ${element}");
        return Container(
          child: Image.network("${element}"),
        );
      }).toList();
    });
    super.initState();
    loadData();

  }
  Future<void> loadData() async {
    await showReviews();
    setState(() {
    });
  }

  Future<void> showReviews() async {
    String url = "$root_web/getProductReviews";
    Map data = {"product_id": widget.product_id};
    print("registration_Api_connect ====>>> ${data}");

    http.Response response = await http.post(Uri.parse(url), body: jsonEncode(data));
    var jsonResponse = jsonDecode(response.body);
    var status = jsonResponse["status"];
    var message = jsonResponse["message"];
    var responseMap = jsonResponse["response"];

    if (responseMap != null) {
      var reviews = responseMap["reviews"];
      var imageUrl = responseMap["image"];

      if (reviews is List) {
        for (var responseItem in reviews) {
          var id = int.parse(responseItem["id"]);
          var productId = responseItem["product_id"];
          var userId = responseItem["user_id"];
          var rating = responseItem["rating"];
          var title = responseItem["title"];
          var image = responseItem["image"];
          var description = responseItem["description"];
          var createdDate = responseItem["created_date"];
          var status = responseItem["status"];
          var orderId = responseItem["order_id"];
          var saleId = responseItem["sale_id"];
          var date = responseItem["created_date"];
          var name = responseItem["username"];

          print('ID: $id');
          print('Product ID: $productId');

          idList.add(id);
          reviewrating.add(rating);
          reviewtitle.add(title);
          reviewdesc.add(description);
          reviewdate.add(date);
          reviewuser.add(userId);
          reviewname.add(name);
        }
        print('ID List: $idList');
        print('ID List: $reviewrating');
      } else {
        print('Invalid response type for reviews. Expected a List.');
      }

      if (imageUrl is String) {
        print('Image URL: $imageUrl');
      } else {
        print('Invalid response type for image. Expected a String.');
      }
    } else {
      print('Invalid response type for responseMap. Expected a Map.');
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.options);
    options = json.decode(widget.options ?? "[]").cast<Map<String, dynamic>>();
    print('object ->> ${options}');
    for (option in options) {
      String title = option['title'];
      titles.add(title);
      print("options----" + option['title']);
      List<String> optionValues = List<String>.from(option['option'] ?? []);
      for (value in optionValues) {
        print(value);
      }
    }
    show_price_data();
    Size size = MediaQuery.of(context).size;
    bool isOutOfStock = int.tryParse(widget.current_stock) == null ||
        int.tryParse(widget.current_stock)! <= 0;

    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  Deals(selectedTabIndex: selectedTabIndex)),

        );
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff014282),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          Deals(selectedTabIndex: selectedTabIndex)),
                );
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
            "Item Details",
            style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold),
          )),
          actions: [
            ShoppingCart(
              itemCount: countAsInt,
            )
          ],
        ),
        body: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      // height: size.height * 0.4,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [ //here
                      CarouselSlider(
                      options: CarouselOptions(
                        onPageChanged: (index, reason) {
                          setState(() {
                            cur_pos = index;
                          });
                        },
                      autoPlay: false,
                        autoPlayInterval: Duration(seconds: 4),
                        enlargeCenterPage: true,
                        viewportFraction: 1,
                        aspectRatio: 1 / 1,
                      ),
                      carouselController: controller,

                      items: slides
                    ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              DotsIndicator(
                                decorator: DotsDecorator(color: Colors.grey.withOpacity(0.5),activeColor: Color(0xff014282)),
                                dotsCount: widget.product_muti_images.length,
                                position: cur_pos,
                              ),
                            ],
                          ),

                          // Row(
                          //   crossAxisAlignment: CrossAxisAlignment.start,
                          //   mainAxisAlignment: MainAxisAlignment.start,
                          //   children: [
                          //     Padding(
                          //       padding: const EdgeInsets.all(20.0),
                          //       child: Container(
                          //         height: size.height * 0.2,
                          //         width: size.width * 0.4,
                          //         child: Image.network(widget.categoryImage),
                          //       ),
                          //     ),
                          //     SizedBox(
                          //       width: size.width * 0.2,
                          //     ),
                          //     Padding(
                          //       padding: const EdgeInsets.only(top: 25),
                          //       child: Container(
                          //         height: size.height * 0.07,
                          //         width: size.width * 0.15,
                          //         decoration: BoxDecoration(
                          //             border:
                          //                 Border.all(color: Colors.grey.shade200)),
                          //         child: Image.network(widget.categoryImage),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          SizedBox(
                            height: size.height * 0.01,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Container(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context).size.width *
                                                  0.4,
                                              child: AutoSizeText(
                                                widget.categoryName,
                                                style: const TextStyle(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width *
                                                  0.25,
                                            ),

                                          ],
                                        ),
                                        SizedBox(
                                          height: size.height * 0.001,
                                        ),
                                        Container(
                                          width: size.width*0.9,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  const Text(
                                                    "RM ",
                                                    style: TextStyle(
                                                        color: Colors.red, fontSize: 9),
                                                  ),
                                                  if (int.tryParse(widget.discount) !=
                                                          null &&
                                                      int.parse(widget.discount) > 0)
                                                    Text.rich(
                                                      TextSpan(
                                                        // text: 'This item costs ',
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                            text: show_price,
                                                            style: const TextStyle(
                                                              color: Colors.grey,
                                                              decoration: TextDecoration
                                                                  .lineThrough,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: (double.parse(show_price) -
                                                                    (double.parse(show_price) *
                                                                        (double.parse(widget
                                                                                .discount) *
                                                                            0.01)))
                                                                .toStringAsFixed(2),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  else
                                                    Text.rich(
                                                      TextSpan(
                                                        // text: 'This item costs ',
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                            text: show_price,
                                                            style: TextStyle(
                                                              color: Colors.black,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  // Text(
                                                  //   widget.sale_price,
                                                  //   style: TextStyle(color: Colors.red),
                                                  // ),
                                                ],
                                              ),
                                              // SizedBox(width: MediaQuery.of(context).size.width * 0.35,),
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Container(
                                                  child: int.tryParse(
                                                                  widget.current_stock) !=
                                                              null &&
                                                          int.tryParse(
                                                                  widget.current_stock)! >
                                                              0
                                                      ? const Text("In stock ",
                                                          style: TextStyle(
                                                              color: Colors.green))
                                                      : const Text("Out of stock",
                                                          style: TextStyle(
                                                              color: Colors.red)),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            for (int i = 0; i < titles.length; i++)
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  if (i < options.length)
                                                    Text(titles[i], style: TextStyle(fontSize: 15)),

                                                  if (options.length > i && options[i]['option'] != null)
                                                    Container(
                                                      color: Colors.white,
                                                      width: size.width * 0.9,
                                                      child: Wrap(
                                                        crossAxisAlignment: WrapCrossAlignment.start,
                                                        children: [
                                                          for (int index = 0;
                                                          index < options[i]['option'].length;
                                                          index++)
                                                            Row(
                                                              children: [
                                                                Radio(
                                                                  value: index,
                                                                  groupValue: selectedIndexes[titles[i]] ?? 0,
                                                                  onChanged: (int? value) {
                                                                    setState(() {
                                                                      print("index =>> ${index}");
                                                                      print("i =>> ${i}");
                                                                      define_price(i,index);
                                                                      selectedIndexes[titles[i]] = value!;
                                                                    });
                                                                  },
                                                                  activeColor: Colors.orange,
                                                                ),
                                                                AutoSizeText(
                                                                  options[i]['option'][index],
                                                                  style: TextStyle(
                                                                      fontSize: 11, fontWeight: FontWeight.bold),
                                                                ),
                                                              ],
                                                            ),
                                                        ],
                                                      ),
                                                    ),
                                                ],
                                              ),
                                          ],
                                        )

                                      ],

                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selected = !selected;
                            });
                            wishlist_add();
                          },
                          child: Container(
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                  const EdgeInsets.all(8.0),
                                  child: Icon(
                                    selected
                                        ? Icons.favorite_outline
                                        : Icons.favorite,
                                    color: Colors.red,
                                    size: 30,
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
                Container(
                  height: size.height * 0.05,
                  width: size.width,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          const Text(
                            "Brand: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(widget.brand_name,style: TextStyle(color: Colors.grey,fontSize: 12.0),)
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  height: size.height * 0.05,
                  width: size.width,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300)),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Product Details: ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 10),
                  child: Html(
                    data: """${widget.description}"""),
                    // data: """<p>70% MEAT <br>30% <b>BONESCUTTING<b><p>"""),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: reviewuser.length,
                  itemBuilder: (context, index) {
                    String dateString = reviewdate[index];
                    DateTime dateTimeFromString = DateTime.parse(dateString);
                    String formattedDate = DateFormat.yMMMMd().format(dateTimeFromString);
                    print("Formatted Date: $formattedDate");


                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: size.width,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                        ),
                        child: Row(
                          children: [
                            if (reviewimage.isNotEmpty && reviewimage.length > index)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  color: Colors.white,
                                  height: size.height * 0.07,
                                  width: size.width * 0.18,
                                  child: Image.network(
                                    reviewimage[index].toString(),
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                              )
                            else
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  color: Colors.white,

                                  height: size.height * 0.12,
                                  width: size.width * 0.22,
                                  child: Text(''),
                                ),
                              ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(4, 8, 8, 4),
                                  child: Container(
                                    color: Colors.white,
                                    width: size.width * 0.65,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          color: Colors.white,
                                          width: size.width*0.9,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              AutoSizeText(
                                                reviewname[index],
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                  fontSize: 13,
                                                ),
                                                maxLines: 4,
                                              ),

                                            ],
                                          ),
                                        ),
                                        Container(
                                          color: Colors.white,
                                          width: size.width*1.5,
                                          child: AutoSizeText(
                                            "Commented on: ${formattedDate}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey,
                                              fontSize: 13,
                                            ),
                                            maxLines: 4,
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(4, 0, 4, 4),
                                  child: Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(color: Colors.green.shade600,borderRadius: BorderRadius.all(Radius.circular(8))),
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Row(
                                            children: [
                                              Text(reviewrating[index].toString(),style: TextStyle(fontSize: 13,color: Colors.white,fontWeight: FontWeight.bold),),
                                              Icon(Icons.star,color: Colors.white,size: 15,),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10,),
                                      Container(
                                          color: Colors.white,
                                          width: size.width*0.5,
                                          height: size.height*0.05,
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 4),
                                            child: AutoSizeText(reviewtitle[index].toString(),style: TextStyle(fontSize: 13,color: Colors.black),maxLines: 2,),
                                          )),

                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: AutoSizeText(
                                    reviewdesc[index],
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13,
                                    ),
                                    maxLines: 4,
                                  ),
                                ),



                              ],
                            ),
                          ],
                        ),
                      ),
                    );

                  },
                ),

              ],
            ),
          ],
        ),
        bottomNavigationBar: Container(
          color: Color(0xffc40001),
          height: 50, // Set the desired height
          width: size.width,
          child: Row(
            children: [
              InkWell(
                onTap: (){
                  compare_add();
                  // compareCart();
                  // comparetoCart1();
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.height * 2,
                  decoration: const BoxDecoration(
                      color: Colors.lightBlue,
                      borderRadius: BorderRadius.all(Radius.circular(2))),
                  child: const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.compare_arrows_rounded,
                            color: Colors.white,
                            size: 35,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Compare',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // SizedBox(width: MediaQuery.of(context).size.width * 0.2,),

              isOutOfStock
                  ? Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: MediaQuery.of(context).size.height * 2,
                      child: InkWell(
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              "Add To Cart",
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: MediaQuery.of(context).size.height * 2,
                      child: InkWell(
                        onTap: () async {
                          addToCart();
                          addToCart1();
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              "Add To Cart",
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
            ],
          ),
        ),

        // bottomNavigationBar: isOutOfStock
        //     ? Container(
        //         color: Color(0xffc40001),
        //         height: 50, // Set the desired height
        //         width: size.width,
        //         child: Center(
        //           child: Text(
        //             "Add To Cart",
        //             style: TextStyle(
        //               fontSize: 13,
        //               fontWeight: FontWeight.bold,
        //               color: Colors.grey.shade300,
        //             ),
        //           ),
        //         ),
        //       )
        //     : Container(
        //         color: Color(0xffc40001),
        //         height: 50, // Set the desired height
        //         width: size.width,
        //         child: InkWell(
        //           onTap: () async {
        //             addToCart();
        //             addToCart1();
        //             productadded = 'true';
        //             final SharedPreferences prefsadded =
        //                 await SharedPreferences.getInstance();
        //             await prefsadded.setString(
        //                 'product_added', '${productadded}');
        //             print('productadded$productadded');
        //             productname = widget.categoryName;
        //             List<String> a = [];
        //             List<String> b = [];
        //             List<String> c = [];
        //             List<String> d = [];
        //             List<String> e = [];
        //             List<String> f = [];
        //             List<String> g = [];
        //             List<String> h = [];
        //             final SharedPreferences prefs =
        //                 await SharedPreferences.getInstance();
        //             a = prefs.getStringList('product_name') ?? [];
        //             a.add(productname);
        //             await prefs.setStringList('product_name', a);
        //
        //             productimage = widget.categoryImage;
        //             b = prefs.getStringList('product_image') ?? [];
        //             b.add(productimage);
        //             await prefs.setStringList('product_image', b);
        //
        //             c = prefs.getStringList('qty') ?? [];
        //             c.add("1");
        //             await prefs.setStringList('qty', c);
        //
        //             productprice = widget.sale_price;
        //             d = prefs.getStringList('product_price') ?? [];
        //             d.add(productprice);
        //             await prefs.setStringList('product_price', d);
        //
        //             productstock = widget.current_stock;
        //             e = prefs.getStringList('product_stock') ?? [];
        //             e.add(productstock);
        //             await prefs.setStringList('product_stock', e);
        //
        //             productdesc = widget.description;
        //             f = prefs.getStringList('product_desc') ?? [];
        //             f.add(productdesc);
        //             await prefs.setStringList('product_desc', f);
        //
        //             productdiscount = widget.discount;
        //             g = prefs.getStringList('product_discount') ?? [];
        //             g.add(productdiscount);
        //             await prefs.setStringList('product_discount', g);
        //
        //             cart = cartItems;
        //             h = prefs.getStringList('cart_items') ?? [];
        //             h.add(cart.toString());
        //             await prefs.setStringList('cart_items', h);
        //
        //             setState(() {
        //               countAsInt = a.length;
        //             });
        //           },
        //           child: Center(
        //             child: Text(
        //               "Add To Cart",
        //               style: TextStyle(
        //                 fontSize: 13,
        //                 fontWeight: FontWeight.bold,
        //                 color: Colors.white,
        //               ),
        //             ),
        //           ),
        //         ),
        //       ),
      ),
    );
  }
}
