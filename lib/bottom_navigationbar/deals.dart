import 'dart:convert';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:myrunciit/bottom_navigationbar/account.dart';
import 'package:myrunciit/bottom_navigationbar/deals_page/Featured_products.dart';
import 'package:myrunciit/bottom_navigationbar/deals_page/advance_search.dart';
import 'package:myrunciit/bottom_navigationbar/deals_page/latest_products.dart';
import 'package:myrunciit/bottom_navigationbar/deals_page/most_viewed.dart';
import 'package:myrunciit/bottom_navigationbar/deals_page/recently_viewed.dart';
import 'package:myrunciit/bottom_navigationbar/deals_page/today_deals.dart';
import 'package:myrunciit/bottom_navigationbar/favourites.dart';
import 'package:myrunciit/bottom_navigationbar/sub_category_2/categories_2.dart';
import 'package:myrunciit/drawer/your_account.dart';
import 'package:myrunciit/main_screen/login_screen.dart';
import 'package:myrunciit/product_screen/product_main_screen.dart';
import 'package:myrunciit/roots/roots.dart';
import 'package:myrunciit/widget/cart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../main.dart';
import '../widget/drawer.dart';

class Deals extends StatefulWidget {
  final int selectedTabIndex;

  Deals({required this.selectedTabIndex});

  @override
  State<Deals> createState() => _DealsState();
}

class _DealsState extends State<Deals> {
  int itemCount = 0;
  late int selectedTabIndex;

  @override
  void initState() {
    super.initState();
    selectedTabIndex = widget.selectedTabIndex;
  }

  void addToCart() {
    setState(() {
      itemCount++;
    });
  }

  void onTabSelected(int index) {
    setState(() {
      selectedTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProductScreen()),
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
              icon: Icon(Icons.keyboard_arrow_left,
                  color: Colors.white, size: 35),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProductScreen()),
                );
              },
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "Offers of the week",
                style: TextStyle(color: Colors.white, fontSize: 15),
              )
            ],
          ),
          actions: [
            ShoppingCart(
              itemCount: itemCount,
            )
          ],
        ),

        // ElevatedButton(
        //   onPressed: addToCart,
        //   child: Text('Add to Cart'),
        // ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                  height: size.height * 0.8,
                  width: size.width,
                  child: TabView(
                    onSelectTab: onTabSelected,
                    selectedTabIndex: selectedTabIndex,
                  )),
            ),
          ],
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
          currentIndex: 3,
          selectedItemColor: Colors.green.shade600,
          unselectedItemColor: Colors.black,
          selectedIconTheme: IconThemeData(color: Colors.green.shade600),
          unselectedIconTheme: IconThemeData(color: Colors.black),
          onTap: (int index) async {
            switch (index) {
              case 0:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProductScreen()),
                );

                print('Tapped on Home');
                break;
              case 1:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Categories2()),
                );
                print('Tapped on Categories');
                break;
              case 2:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Favourites()),
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

                  if (myValue != null && isLoggedIn == true)
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

class TabView extends StatefulWidget {
  final Function(int) onSelectTab;
  final int selectedTabIndex;

  TabView({required this.onSelectTab, required this.selectedTabIndex});
  @override
  _TabViewState createState() => _TabViewState();
}

class _TabViewState extends State<TabView> with SingleTickerProviderStateMixin {
  bool today = false;
  bool recent = false;
  bool featured = false;
  bool most = false;
  bool latest = false;

  late TabController _tabController;
  TextEditingController allcategory = TextEditingController();
  DropDownValueModel? selectedCategory;
  DropDownValueModel? selectedSubCategory;
  DropDownValueModel? selectedBrand;
  DropDownValueModel? categoryValue;
  DropDownValueModel? subcategoryvalue;


  int _selectedIndex = 0;
  List product1 = [];
  List category1 = [];

  var brand = '0';
  var min_value = '0';
  var max_value = '0';
  double startval1 = 0.0;
  double endval1 = 500.0;
  bool isDropdownVisible = false;
  TextEditingController brandcontroller = TextEditingController();
  TextEditingController categorycontroller = TextEditingController();
  TextEditingController subcategorycontroler = TextEditingController();
  TextEditingController searchnamecontroller = TextEditingController();
  bool isDropdownExpanded = false;
  bool categoriessearch = false;
  bool categoriessearch2 = false;
  bool categoriessearch3 = false;
  // late List<DropDownValueModel> categoryNames;
  List<String> productImagesList = [];
  late String brandId = '0';
  @override
  void initState() {
    advancecategory();
    super.initState();
    _selectedIndex = widget.selectedTabIndex;
    _tabController = TabController(length: 6, vsync: this);
    _tabController.index = _selectedIndex;
  }

  List<DropDownValueModel> brandNames = [];
  List<DropDownValueModel> categoryNames = [];
  List<DropDownValueModel> subCategories = [];

  advancecategory() async {
    String url1 = "$root_web/all_category/2";

    try {
      var response = await http.get(Uri.parse(url1));
      if (response.statusCode == 200) {
        print('Success');
        print(response.body);
        dynamic jsonResponse = jsonDecode(response.body);
        if (jsonResponse != null &&
            jsonResponse['status'] == 'SUCCESS' &&
            jsonResponse['Response'] != null &&
            jsonResponse['Response']['category'] != null) {
          List<dynamic> categories = jsonResponse['Response']['category'];

          // Extracted brandNames outside the loop
          List<DropDownValueModel> allBrands = [];

          categoryNames = categories.map((category) {
            String categoryName = category['category_name'];
            String categoryId = category['category_id'];

            if (categoryId == categoryValue?.value) {
              List<String> dataBrandsList =
                  (category['data_brands'] as String).split(';;;;;;');
              print('Sub brand Names: $dataBrandsList');

              // Update brandNames with filtered brands
              allBrands = dataBrandsList.map((brand) {
                List<String> parts = brand.split(':::');
                String brandName = parts.length > 1 ? parts[1] : brand;

                return DropDownValueModel(
                  name: brand,
                  value: brand,
                );
              }).toList();
            }

            return DropDownValueModel(
              name: categoryName,
              value: categoryId,
            );
          }).toList();

          setState(() {
            brandNames = allBrands.map((brand) {
              List<String> parts = brand.name.split(':::');
              String brandName = parts.length > 1 ? parts[1] : brand.name;

              return DropDownValueModel(
                name: brandName,
                value: brand.value,
              );
            }).toList();
          });

          print('Category Names: $categoryNames');
          print('brandNames Names: $brandNames');

          print('category id: ${categoryValue?.value}');

          selectedCategory =
              selectedCategory ?? DropDownValueModel(name: '0', value: '0');
          categoryValue =
              categoryValue ?? DropDownValueModel(name: '0', value: '0');
          selectedSubCategory =
              selectedSubCategory ?? DropDownValueModel(name: '0', value: '0');
          selectedBrand =
              selectedBrand ?? DropDownValueModel(name: '0', value: '0');
        } else {
          print("Invalid response format or missing data");
        }
      } else {
        print("Failure - Status Code: ${response.statusCode}");
      }
    } catch (error) {
      print("Error: $error");
    }
  }

  String? selectedCategoryValue;
  sortingout() async {
    String url1 = "$root_web/category/${categoryValue?.value}/0/2";

    try {
      var response = await http.get(Uri.parse(url1));
      if (response.statusCode == 200) {
        print('Success');
        print(response.body);
        dynamic jsonResponse = jsonDecode(response.body);
        if (jsonResponse != null && jsonResponse['status'] == 'SUCCESS') {
          if (jsonResponse['Response'] != null) {
            List<dynamic> categories = jsonResponse['Response'];
            print('categories12345$categories');

            subCategories = categories.map((category) {
              return DropDownValueModel(
                value: category['sub_category_id'] as String,
                name: category['sub_category_name'] as String,
              );
            }).toList();
            setState(() {
              subCategories;
            });

            print('subCategories: $subCategories');
          } else {
            print("No data in the 'Response' field");
          }
        } else {
          print("Invalid response format or missing data");
        }
      } else {
        print("Failure - Status Code: ${response.statusCode}");
      }
    } catch (error) {
      print("Error: $error");
    }
  }

  // Future<void> getProduct1() async {
  //   print("here is selected tab index");
  //   print(widget.selectedTabIndex);
  //   String url1;
  //
  //   // Clear SharedPreferences data
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.remove('advtitle');
  //   await prefs.remove('advtax');
  //   await prefs.remove('advtax_type');
  //   await prefs.remove('advmultiple_price');
  //   await prefs.remove('advsale_price');
  //   await prefs.remove('advcurrent_stock');
  //   await prefs.remove('advdescription');
  //   await prefs.remove('advdiscount');
  //   await prefs.remove('advproduct_id');
  //   await prefs.remove('advoptions');
  //   await prefs.remove('advimage');
  //   await prefs.remove('advbanner');
  //   await prefs.remove('advbrand_name');
  //   await prefs.remove('advcod_status');
  //
  //   switch (_selectedIndex) {
  //     case 0:
  //       url1 =
  //       "$root_web/ajax_others_product/2/todays_deal/${categoryValue?.value}/${selectedSubCategory!.value}/$brandId/$startval1/$endval1/${searchnamecontroller.text}";
  //       break;
  //     case 1:
  //       url1 =
  //       "$root_web/ajax_others_product/2/recently_viewed/${categoryValue?.value}/${selectedSubCategory!.value}/$brandId/$startval1/$endval1/${searchnamecontroller.text}";
  //       break;
  //     case 2:
  //       url1 =
  //       "$root_web/ajax_others_product/2/featured/${categoryValue?.value}/${selectedSubCategory!.value}/$brandId/$startval1/$endval1/${searchnamecontroller.text}";
  //       break;
  //     case 3:
  //       url1 =
  //       "$root_web/ajax_others_product/2/most_viewed/${categoryValue?.value}/${selectedSubCategory!.value}/$brandId/$startval1/$endval1/${searchnamecontroller.text}";
  //       break;
  //     case 4:
  //       url1 =
  //       "$root_web/ajax_others_product/2/latest/${categoryValue?.value}/${selectedSubCategory!.value}/$brandId/$startval1/$endval1/${searchnamecontroller.text}";
  //       break;
  //     default:
  //       url1 =
  //       "$root_web/ajax_others_product/2/todays_deal/${categoryValue?.value}/${selectedSubCategory!.value}/$brandId/$startval1/$endval1/${searchnamecontroller.text}";
  //   }
  //
  //   try {
  //     var response = await http.get(Uri.parse(url1));
  //     print("url1url1$url1");
  //
  //     if (response.statusCode == 200) {
  //       print('success');
  //       print(response.body);
  //       dynamic jsonResponse = jsonDecode(response.body);
  //       var status1 = jsonResponse['Status'];
  //       if (status1 == 'SUCCESS'&& jsonResponse != null &&
  //           jsonResponse['Response'] != null &&
  //           jsonResponse['Response']["products"] != null) {
  //         List<dynamic> products = jsonResponse['Response']['products'];
  //         var response1 = jsonResponse['Response'];
  //         final SharedPreferences prefs1 = await SharedPreferences.getInstance();
  //
  //         print("statusstatus$status");
  //         print("response1response1$response1");
  //         await prefs1.setString('advstatus', status);
  //
  //         List<String> productTitles = products
  //             .map((product) => (product["title"] ?? "").toString())
  //             .toList();
  //         List<String> tax = products
  //             .map((product) => (product["tax"] ?? "").toString())
  //             .toList();
  //         List<String> tax_type = products
  //             .map((product) => (product["tax_type"] ?? "").toString())
  //             .toList();
  //         List<String> multiple_price = products
  //             .map((product) => (product["multiple_price"] ?? "").toString())
  //             .toList();
  //         List<String> sale_price = products
  //             .map((product) => (product["sale_price"] ?? "").toString())
  //             .toList();
  //         List<String> current_stock = products
  //             .map((product) => (product["current_stock"] ?? "").toString())
  //             .toList();
  //         List<String> description = products
  //             .map((product) => (product["description"] ?? "").toString())
  //             .toList();
  //         List<String> discount = products
  //             .map((product) => (product["discount"] ?? "").toString())
  //             .toList();
  //         List<String> product_id = products
  //             .map((product) => (product["product_id"] ?? "").toString())
  //             .toList();
  //         List<String> options = products
  //             .map((product) => (product["options"] ?? "").toString())
  //             .toList();
  //         List<String> productImages = products
  //             .map((product) => (product["product_image"] ?? "").toString())
  //             .toList();
  //         List<String> banner = products
  //             .map((product) => (product["banner"] ?? "").toString())
  //             .toList();
  //         List<String> brand_name = products
  //             .map((product) => (product["brand_name"] ?? "").toString())
  //             .toList();
  //         List<String> cod_status = products
  //             .map((product) => (product["cod_status"] ?? "").toString())
  //             .toList();
  //
  //         setState(() {
  //           product1 = productTitles;
  //           productImagesList = productImages;
  //           print("hello205");
  //           print(product1);
  //         });
  //
  //         await prefs.setStringList('advtitle', productTitles);
  //         await prefs.setStringList('advtax', tax);
  //         await prefs.setStringList('advtax_type', tax_type);
  //         await prefs.setStringList('advmultiple_price', multiple_price);
  //         await prefs.setStringList('advsale_price', sale_price);
  //         await prefs.setStringList('advcurrent_stock', current_stock);
  //         await prefs.setStringList('advdescription', description);
  //         await prefs.setStringList('advdiscount', discount);
  //         await prefs.setStringList('advproduct_id', product_id);
  //         await prefs.setStringList('advoptions', options);
  //         await prefs.setStringList('advimage', productImagesList);
  //         await prefs.setStringList('advbanner', banner);
  //         await prefs.setStringList('advbrand_name', brand_name);
  //         await prefs.setStringList('advcod_status', cod_status);
  //         print(productImagesList);
  //
  //         print("productStringsproductStrings$product1");
  //       } else {
  //         print("Invalid response format or missing data");
  //       }
  //     } else {
  //       await prefs.setString('advstatus', 'FAILED');
  //     }
  //   } catch (error) {
  //     print("Error: $error");
  //   }
  // }
  Future<void> getProduct1() async {
    print("here is selected tab index");
    print(widget.selectedTabIndex);
    String url1;

    // Clear SharedPreferences data
    today = true;
    recent = true;
    featured = true;
    most = true;
    latest = true;

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print("todaytoday$today");
    print("recentrecent$recent");
    print("featuredfeatured$featured");
    print("mostmost$most");
    print("latestlatest$latest");


    await prefs.remove('advtitle');
    await prefs.remove('advtax');
    await prefs.remove('advtax_type');
    await prefs.remove('advmultiple_price');
    await prefs.remove('advsale_price');
    await prefs.remove('advcurrent_stock');
    await prefs.remove('advdescription');
    await prefs.remove('advdiscount');
    await prefs.remove('advproduct_id');
    await prefs.remove('advoptions');
    await prefs.remove('advimage');
    await prefs.remove('advbanner');
    await prefs.remove('advbrand_name');
    await prefs.remove('advcod_status');

    switch (_selectedIndex) {
      case 0:
        url1 =
        "$root_web/ajax_others_product/2/todays_deal/${categoryValue?.value}/${selectedSubCategory!.value}/$brandId/$startval1/$endval1/${searchnamecontroller.text}";
        await prefs.setBool('toadys_deals', today);
        break;
      case 1:
        url1 =
        "$root_web/ajax_others_product/2/recently_viewed/${categoryValue?.value}/${selectedSubCategory!.value}/$brandId/$startval1/$endval1/${searchnamecontroller.text}";
        await prefs.setBool('Recent', recent);
        break;
      case 2:
        url1 =
        "$root_web/ajax_others_product/2/featured/${categoryValue?.value}/${selectedSubCategory!.value}/$brandId/$startval1/$endval1/${searchnamecontroller.text}";
        await prefs.setBool('Featured', featured);
        break;
      case 3:
        url1 =
        "$root_web/ajax_others_product/2/most_viewed/${categoryValue?.value}/${selectedSubCategory!.value}/$brandId/$startval1/$endval1/${searchnamecontroller.text}";
        await prefs.setBool('Most', most);
        break;
      case 4:
        url1 =
        "$root_web/ajax_others_product/2/latest/${categoryValue?.value}/${selectedSubCategory!.value}/$brandId/$startval1/$endval1/${searchnamecontroller.text}";
        await prefs.setBool('Latest', latest);
        break;
      default:
        url1 =
        "$root_web/ajax_others_product/2/todays_deal/${categoryValue?.value}/${selectedSubCategory!.value}/$brandId/$startval1/$endval1/${searchnamecontroller.text}";
    }

    try {
      var response = await http.get(Uri.parse(url1));
      print("url1url1$url1");

      if (response.statusCode == 200) {
        print('success');
        print(response.body);
        dynamic jsonResponse = jsonDecode(response.body);
        var status = jsonResponse['Status'];

        if (status == 'SUCCESS' &&
            jsonResponse != null &&
            jsonResponse['Response'] != null &&
            jsonResponse['Response']["products"] != null) {
          List<dynamic> products = jsonResponse['Response']['products'];
          var response1 = jsonResponse['Response'];
          final SharedPreferences prefs1 = await SharedPreferences.getInstance();

          print("statusstatus$status");
          print("response1response1$response1");
          await prefs1.setString('advstatus', status);

          List<String> productTitles = products
              .map((product) => (product["title"] ?? "").toString())
              .toList();
          List<String> product_sub_cat = products
              .map((product) => (product["title"] ?? "").toString())
              .toList();
          List<String> tax = products
              .map((product) => (product["tax"] ?? "").toString())
              .toList();
          List<String> tax_type = products
              .map((product) => (product["tax_type"] ?? "").toString())
              .toList();
          List<String> multiple_price = products
              .map((product) => (product["multiple_price"] ?? "").toString())
              .toList();
          List<String> sale_price = products
              .map((product) => (product["sale_price"] ?? "").toString())
              .toList();
          List<String> current_stock = products
              .map((product) => (product["current_stock"] ?? "").toString())
              .toList();
          List<String> description = products
              .map((product) => (product["description"] ?? "").toString())
              .toList();
          List<String> discount = products
              .map((product) => (product["discount"] ?? "").toString())
              .toList();
          List<String> product_id = products
              .map((product) => (product["product_id"] ?? "").toString())
              .toList();
          List<String> options = products
              .map((product) => (product["options"] ?? "").toString())
              .toList();
          List<String> productImages = products
              .map((product) => (product["product_image"] ?? "").toString())
              .toList();
          List<String> banner = products
              .map((product) => (product["banner"] ?? "").toString())
              .toList();
          List<String> brand_name = products
              .map((product) => (product["brand_name"] ?? "").toString())
              .toList();
          List<String> cod_status = products
              .map((product) => (product["cod_status"] ?? "").toString())
              .toList();



          setState(() {
            product1 = productTitles;
            productImagesList = products
                .map((product) => (product["product_image"] ?? "").toString())
                .toList();
            print("hello205");
            print(product1);
          });

          await prefs.setStringList('advtitle', productTitles);
          await prefs.setStringList('advsub_cat', productTitles);
          await prefs.setStringList('advtax', tax);
          await prefs.setStringList('advtax_type', tax_type);
          await prefs.setStringList('advmultiple_price', multiple_price);
          await prefs.setStringList('advsale_price', sale_price);
          await prefs.setStringList('advcurrent_stock', current_stock);
          await prefs.setStringList('advdescription', description);
          await prefs.setStringList('advdiscount', discount);
          await prefs.setStringList('advproduct_id', product_id);
          await prefs.setStringList('advoptions', options);
          await prefs.setStringList('advimage', productImagesList);
          await prefs.setStringList('advbanner', banner);
          await prefs.setStringList('advbrand_name', brand_name);
          await prefs.setStringList('advcod_status', cod_status);
          print(productImagesList);

          print("productStringsproductStrings$product1");
        } else {
          print("Invalid response format or missing data");
          await prefs.setString('advstatus', 'FAILED');
        }
      } else {
        print("HTTP request failed with status: ${response.statusCode}");
        await prefs.setString('advstatus', 'FAILED');
      }
    } catch (error) {
      print("Error: $error");
    }
  }


  List<Widget> tabContentWidgets = [
    TodayDeals(),
    Recently_viewed(),
    FeaturedProducts(),
    Most_viewed(),
    LatestDeals(),
    AdvSearch(),
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<String> separatedBrands = [];

    for (var brand in brandNames) {
      String value = brand.value ?? '';
      List<String> parts = value.split(':::');

      if (parts.length == 2) {
        String prefix = parts[0];
        String name = parts[1];
        String separatedBrand = '$prefix: $name';

        separatedBrand = separatedBrand.replaceAll(RegExp(r'[0-9,]'), '');

        separatedBrand = separatedBrand.replaceFirst(':', '');

        separatedBrands.add(separatedBrand);
      } else {
        print("Error in separating brand name");
      }
    }

    List<String> combinedBrandList = List.from(separatedBrands);

    print('Combined Brand List: $combinedBrandList');

    return DefaultTabController(
      length: 5,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            Container(
              height: size.height * 0.04,
              width: size.width,
              color: Colors.white,
              child: TabBar(
                isScrollable: true,
                labelColor: Colors.green,
                unselectedLabelColor: Colors.black,
                indicator: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                controller: _tabController,
                tabs: [
                  _buildTab("TODAY'S DEALS", 0),
                  _buildTab("RECENTLY VIEWED", 1),
                  _buildTab("FEATURED PRODUCTS", 2),
                  _buildTab("MOST VIEWED", 3),
                  _buildTab("LATEST PRODUCTS", 4),
                  _buildTab("", 5),
                ],
                onTap: (index) async {
                  setState(() {
                    _selectedIndex = index;
                    print("here is the index");
                    print(_selectedIndex);


                  });
                  today = false;
                  recent = false;
                  most = false;
                  featured = false;
                  latest = false;
                  final SharedPreferences prefs1 = await SharedPreferences.getInstance();
                  await prefs1.setBool('toadys_deals', today);
                  await prefs1.setBool('Recent', recent);
                  await prefs1.setBool('Featured', featured);
                  await prefs1.setBool('Most', most);
                  await prefs1.setBool('Latest', latest);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Container(
                color: Colors.white,
                height: size.height * 0.04,
                width: size.width,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isDropdownVisible = !isDropdownVisible;
                    });
                  },
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('Filters'),
                        SizedBox(width: 5),
                        Icon(
                          isDropdownVisible
                              ? Icons.arrow_drop_up
                              : Icons.arrow_drop_down,
                          size: 30,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: isDropdownVisible,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        // height: size.height * 0.02,
                        child: Text(
                          "Advanced Search",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'All Categories',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.black),
                          ),
                          SingleChildScrollView(
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  child: DropDownTextField(
                                    listSpace: 5,
                                    listPadding:
                                        ListPadding(top: 10, bottom: 10),
                                    enableSearch: true,
                                    validator: (String? value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please select a category";
                                      } else {
                                        return null;
                                      }
                                    },
                                    dropDownList: categoryNames,
                                    listTextStyle:
                                        const TextStyle(color: Colors.red),
                                    dropDownItemCount: 5,
                                    onChanged: (dynamic selectedValue) async {
                                      setState(() {
                                        selectedCategoryValue =
                                            selectedValue.value;
                                        categoryValue = selectedValue
                                            as DropDownValueModel?;
                                      });

                                      await sortingout();
                                      await advancecategory();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sub Categories',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                          SingleChildScrollView(
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  child: DropDownTextField(
                                    listSpace: 5,
                                    listPadding:
                                        ListPadding(top: 10, bottom: 10),
                                    enableSearch: true,
                                    validator: (String? value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please select a subcategory";
                                      } else {
                                        return null;
                                      }
                                    },
                                    dropDownList: subCategories,
                                    listTextStyle:
                                        const TextStyle(color: Colors.red),
                                    dropDownItemCount: 6,
                                    onChanged: (dynamic selectedValue) {
                                      setState(() {
                                        selectedSubCategory = selectedValue
                                            as DropDownValueModel?;
                                        print('Selected Sub Category ID: ${selectedSubCategory!.value}');

                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'All Brands',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.black),
                          ),
                          SingleChildScrollView(
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  child: DropDownTextField(
                                    listSpace: 5,
                                    listPadding:
                                        ListPadding(top: 10, bottom: 10),
                                    enableSearch: true,
                                    validator: (String? value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please select a brand";
                                      } else {
                                        return null;
                                      }
                                    },
                                    dropDownList: brandNames,
                                    listTextStyle:
                                        const TextStyle(color: Colors.red),
                                    dropDownItemCount: 6,
                                    onChanged: (dynamic selectedValue) {
                                      // selectedBrand =
                                      //     selectedValue as DropDownValueModel?;
                                      print(
                                          'Selected Brand: ${selectedBrand?.name}');
                                      setState(() {
                                        selectedBrand = selectedValue as DropDownValueModel?;

                                        // Extract the number from the brand field
                                        if (selectedBrand != null) {
                                          String brandValue = selectedBrand!.value;
                                          RegExpMatch? match = RegExp(r'\d+').firstMatch(brandValue);
                                          if (match != null) {
                                             brandId = match.group(0)!;
                                            print('Selected Brand ID: $brandId');
                                          } else {
                                            print('Brand ID not found in the string');
                                          }
                                        }
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    RangeSlider(
                      min: 0,
                      max: 500,
                      divisions: 10, //slide interval
                      labels: RangeLabels("Rs. $startval1", "Rs. $endval1"),
                      values: RangeValues(startval1, endval1),
                      onChanged: (RangeValues value) {
                        setState(() {
                          startval1 = value.start;
                          endval1 = value.end;
                        });
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 0, 8),
                      child: Container(
                        height: size.height * 0.04,
                        width: size.width,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: searchnamecontroller,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20),
                                autofocus: false,
                                decoration: InputDecoration(
                                  focusColor: Colors.grey.shade300,
                                  hintText: "What are you Looking for?",
                                  border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.transparent),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.transparent),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.transparent),
                                  ),
                                  hintStyle: TextStyle(fontSize: 15),
                                  labelStyle: TextStyle(
                                      color: Colors.black, fontSize: 15),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                      child: GestureDetector(
                        onTap: () async {
                          await getProduct1();
                          print("product1product1$product1");

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Deals(

                                selectedTabIndex: _selectedIndex,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Color(0xFFc40001),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          height: 50,
                          width: size.width,
                          child: Center(
                              child: Text(
                            'Search',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                controller: _tabController,
                children: tabContentWidgets,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String text, int index) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 0),
      child: Container(
        decoration: BoxDecoration(
          color:
              _selectedIndex == index ? Color(0xffc40001) : Colors.transparent,
          border: Border.all(
            color: _selectedIndex == index
                ? Color(0xffc40001)
                : Colors.transparent,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Tab(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text(
                text,
                style: TextStyle(
                    color:
                        _selectedIndex == index ? Colors.white : Colors.black,
                    fontSize: 10.5,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
