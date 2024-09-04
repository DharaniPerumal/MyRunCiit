import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myrunciit/bottom_navigationbar/account.dart';
import 'package:myrunciit/bottom_navigationbar/categories.dart';
import 'package:myrunciit/bottom_navigationbar/deals.dart';
import 'package:myrunciit/drawer/Info/my_info.dart';
import 'package:myrunciit/drawer/compare.dart';
import 'package:myrunciit/drawer/my_orders.dart';
import 'package:myrunciit/drawer/wishlist.dart';
import 'package:myrunciit/drawer/your_account.dart';
import 'package:myrunciit/main.dart';
import 'package:myrunciit/main_screen/login_screen.dart';
import 'package:myrunciit/main_screen/register_screen.dart';
import 'package:myrunciit/roots/roots.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

var myValue,user_id, wishlist_count1;

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  var isLoggedIn;

  Future<void> get_user_id() async {
    SharedPreferences prefs1 = await SharedPreferences.getInstance();
    setState(() {
      user_id = prefs1.getString('user_id') ?? "";
    });
    print('address_list_grid_userid===>>> $user_id');
    prefs1.setBool(SplashScreenState.KEYlOGIN, true);
    isLoggedIn = prefs1.getBool(SplashScreenState.KEYlOGIN);
    print("isLoggedIn: $isLoggedIn");
  }

  void wishlist_count() async {
    SharedPreferences prefs1 = await SharedPreferences.getInstance();
    setState(() {
      user_id = prefs1.getString('user_id');
    });
      String url1 = "$root_web/wishlist/count/0/${user_id}";
      print('wishlist_count ----> $url1');
      dynamic response = await http.get(Uri.parse(url1));
      if (response.statusCode == 200) {
        print('wishlist_count');
        print(response.body);
        dynamic jsonResponse = jsonDecode(response.body);
        setState(() {
          wishlist_count1 = jsonResponse['Response']['WishlistCount'];
        });
        if (jsonResponse != null && jsonResponse['Response']['WishlistCount'] != null) {
          print('wishlist_count ----> ${jsonResponse['Response']['WishlistCount']}');
        } else {
          print("Invalid response format or missing data");
        }
      } else {
        print("failure");
      }
  }

  @override
  void initState() {
    getMyValue();
    setState(() {
      get_user_id();
      wishlist_count();
    });
    super.initState();
  }

  Future<void> getMyValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      myValue = prefs.getString('first_name') == null ? 'Guest' : prefs.getString('first_name');
    });
    print('myvalue ===>>> $myValue');
  }

  @override
  Widget build(BuildContext context) {
    print('myvalue2 ===>>> $myValue');

    Size size = MediaQuery.of(context).size;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            height: size.height * 0.13,
            decoration: BoxDecoration(
              color: Color(0xff014282),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () async {
                    if (user_id != '') {
                      print(isLoggedIn);
                      print(status);
                      print(status);
                      print(name);
                      print(first_name1);
                      print(myValue);

                      if (myValue != 'Guest' && isLoggedIn == true)
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => YourAccount()),
                        );
                      else
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Account()),
                        );
                    }

                    // Navigator.push(
                    //     context, MaterialPageRoute(builder: (context) => Account()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(18, 20, 0, 0),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage('asset/halfimg.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                user_id != ""
                    ? Center(
                        child: Row(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                              11.5,
                              20,
                              0,
                              0,
                            ),
                            child: Text(
                              "Hello, $myValue",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ))
                    : (user_id != '')
                        ? Center(
                            child: Row(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  11.5,
                                  20,
                                  0,
                                  0,
                                ),
                                child: Text(
                                  "Hello, $first_name1",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ],
                          ))
                        : Container(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 35),
                              child: Column(
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 11.5),
                                        child: Text(
                                          "Hello",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        LoginScreen()),
                                              );
                                            },
                                            child: Text(
                                              "Login",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Text(
                                            "or",
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        RegisterScreen()),
                                              );
                                            },
                                            child: Text(
                                              "Register",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
              ],
            ),
          ),
          Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Container(
                    height: size.height * 0.05,
                    child: ListTile(
                      title: Text(
                        'Home',
                        style: TextStyle(
                            fontSize: 13.5,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        // Handle the onTap action for Home
                        Navigator.pop(context); // Close the drawer
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Container(
                    height: size.height * 0.05,
                    child: ListTile(
                      title: Text('Shop by categories',
                          style: TextStyle(
                              fontSize: 13.5,
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                      onTap: () {
                        // Handle the onTap action for Settings
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Categories()),
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Container(
                    height: size.height * 0.05,
                    child: ListTile(
                      title: Text("Today's deals",
                          style: TextStyle(
                              fontSize: 13.5,
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                      onTap: () async {
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
                        await prefs1.setBool('Latest', latest);                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Deals(
                                    selectedTabIndex: 0,
                                  )),
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Container(
                    height: size.height * 0.05,
                    child: ListTile(
                      title: Text('Recently Viewed',
                          style: TextStyle(
                              fontSize: 13.5,
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                      onTap: () async {
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
                        await prefs1.setBool('Latest', latest);                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Deals(
                                    selectedTabIndex: 1,
                                  )),
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Container(
                    height: size.height * 0.05,
                    child: ListTile(
                      title: Text('Featured',
                          style: TextStyle(
                              fontSize: 13.5,
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                      onTap: () async {
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
                        await prefs1.setBool('Latest', latest);                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Deals(
                                    selectedTabIndex: 2,
                                  )),
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Container(
                    height: size.height * 0.05,
                    child: ListTile(
                      title: Text('Most Viewed',
                          style: TextStyle(
                              fontSize: 13.5,
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                      onTap: () async {
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
                              builder: (context) => Deals(selectedTabIndex: 3)),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: Colors.grey.shade300),
                    top: BorderSide(color: Colors.grey.shade300))),
            child: Column(
              children: [
                if (isLoggedIn == true || status == 'SUCCESS')
                  if ( myValue != 'Guest')
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Container(
                    height: size.height * 0.05,
                    child: ListTile(
                      title: Text('My Orders',
                          style: TextStyle(
                              fontSize: 13.5,
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                      onTap: () {
                        // Handle the onTap action for Home
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MyOrders()),
                        );
                      },
                    ),
                  ),
                ),
                myValue != 'Guest' ?
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Container(
                        height: size.height * 0.05,
                        child: ListTile(
                          title: Text('Wishlist',
                              style: TextStyle(
                                  fontSize: 13.5,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => wishList()),
                            ).then((value){
                              wishlist_count();
                            });
                          },
                          trailing: Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            constraints: BoxConstraints(
                              minWidth: 25,
                              minHeight: 25,
                            ),
                            child: Text(
                              '${wishlist_count1}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ) : Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Container(
                    height: size.height * 0.05,
                    child: ListTile(
                      title: Text('Wishlist',
                          style: TextStyle(
                              fontSize: 13.5,
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              height: MediaQuery.of(context).size.height * 0.2,
                              child: AlertDialog(
                                title: Text(
                                  "sign in",
                                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.black),
                                ),
                                insetPadding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.37),
                                content: Center(
                                    child: Text(
                                      "Do you want to sign in ?",
                                      style: TextStyle(fontSize: 16),
                                    )),
                                actions: [
                                  Row(
                                    mainAxisAlignment : MainAxisAlignment.end,
                                    children: [
                                      InkWell(
                                        onTap:(){
                                          Navigator.pop(context);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                            child: Text(
                                              'Cancel',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(color: Colors.green, fontSize: 15.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 7,),
                                      InkWell(
                                        onTap: (){
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => LoginScreen()),
                                          );
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                            child: Text(
                                              'Sign in',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(color: Colors.green, fontSize: 15.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
                myValue != 'Guest' ?
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Container(
                        height: size.height * 0.05,
                        child: ListTile(
                          title: Text('Compare',
                              style: TextStyle(
                                  fontSize: 13.5,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                          onTap: () {
                            // Handle the onTap action for Home
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Compare()),
                            );
                          },
                        ),
                      ),
                    ) : Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Container(
                    height: size.height * 0.05,
                    child: ListTile(
                      title: Text('Compare',
                          style: TextStyle(
                              fontSize: 13.5,
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              height: MediaQuery.of(context).size.height * 0.2,
                              child: AlertDialog(
                                title: Text(
                                  "sign in",
                                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.black),
                                ),
                                insetPadding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.37),
                                content: Center(
                                    child: Text(
                                      "Do you want to sign in ?",
                                      style: TextStyle(fontSize: 16),
                                    )),
                                actions: [
                                  Row(
                                    mainAxisAlignment : MainAxisAlignment.end,
                                    children: [
                                      InkWell(
                                        onTap:(){
                                          Navigator.pop(context);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                            child: Text(
                                              'Cancel',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(color: Colors.green, fontSize: 15.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 7,),
                                      InkWell(
                                        onTap: (){
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => LoginScreen()),
                                          );
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                            child: Text(
                                              'Sign in',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(color: Colors.green, fontSize: 15.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
                if ( myValue != 'Guest')
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Container(
                        height: size.height * 0.05,
                        child: ListTile(
                          title: Text('Your Account',
                              style: TextStyle(
                                  fontSize: 13.5,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                          onTap: () {
                            // Handle the onTap action for Home
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => YourAccount()),
                            );
                          },
                        ),
                      ),
                    ),
                if ( myValue != 'Guest')
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Container(
                        height: size.height * 0.05,
                        child: ListTile(
                          title: Text('Edit Profile',
                              style: TextStyle(
                                  fontSize: 13.5,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                          onTap: () {
                            // Handle the onTap action for Home
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MyInfo()),
                            );
                          },
                        ),
                      ),
                    ),
              ],
            ),
          ),
          if ( myValue != 'Guest')
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: ListTile(
                  title: Text('Logout',
                      style: TextStyle(
                          fontSize: 13.5,
                          color: Colors.black,
                          fontWeight: FontWeight.bold)),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Center(child: Text('Are you sure want to Logout?',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15.0))),
                        actions: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop(false);
                                },
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.width * 0.1,
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    // color: Color(0xFF64DD17),
                                    color: Colors.lightGreen,

                                    border: Border.all(color: Colors.white),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Center(
                                      child: Text(
                                    'No',
                                    style: TextStyle(color: Colors.white),
                                  )),
                                ),
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  SharedPreferences preferences =
                                      await SharedPreferences.getInstance();
                                  await preferences.clear();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginScreen()),
                                  );
                                  // This will close the app
                                },
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.width * 0.1,
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    // color: Color(0xFF64DD17),
                                    color: Colors.lightGreen,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Yes',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ).then((value) => value ?? false);
                  },
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: ListTile(
                  title: Text('Login',
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.bold)),
                  onTap: () {
                    // Handle the onTap action for Home
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                ),
              )
        ],
      ),
    );
  }
}
