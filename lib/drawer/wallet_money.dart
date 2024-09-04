import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:myrunciit/bottom_navigationbar/account.dart';
import 'package:myrunciit/bottom_navigationbar/sub_category_2/categories_2.dart';
import 'package:myrunciit/bottom_navigationbar/deals.dart';
import 'package:myrunciit/bottom_navigationbar/favourites.dart';
import 'package:myrunciit/drawer/your_account.dart';
import 'package:myrunciit/main.dart';
import 'package:myrunciit/main_screen/login_screen.dart';
import 'package:myrunciit/product_screen/product_main_screen.dart';
import 'package:myrunciit/roots/roots.dart';
import 'package:myrunciit/webview/wallet_add.dart';
import 'package:myrunciit/widget/cart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../widget/drawer.dart';
import 'package:http/http.dart' as http;

var user_id;
var wallet_add_url;
var wallet_response_url;

class WalletMoney extends StatefulWidget {
  const WalletMoney({super.key});
  @override
  State<WalletMoney> createState() => _WalletMoneyState();
}
class _WalletMoneyState extends State<WalletMoney> {

  TextEditingController moneyController = TextEditingController();
  int itemCount = 0;
  int selectedContainerIndex = -1;

  List<Color> containerColors = [
    Colors.white,
    Colors.white,
    Colors.white,
    Colors.white,
    Colors.white,
  ];
  List<Color> textColors = [
    Colors.black,
    Colors.black,
    Colors.black,
    Colors.black,
    Colors.black,
  ];
  List<String> amounts = ["250", "500", "1000", "10000", "20000"];
  void updateContainerColor(int index) {
    setState(() {
      for (int i = 0; i < containerColors.length; i++) {
        if (i == index) {
          containerColors[i] = Colors.black;
          textColors[i] = Colors.white;
        } else {
          containerColors[i] = Colors.white;
          textColors[i] = Colors.black;
        }
      }
      moneyController.text = amounts[index];
    });
  }
  void addToCart() {
    setState(() {
      itemCount++;
    });
  }
  get_wallet_amount() async {
    print('wallet_enter_amount -------> ${moneyController.text} -------> user_id -------> $user_id');
    String url1 = "$root_web/profile/wallet/add/ipay/${moneyController.text}/$user_id";
    dynamic response = await http.get(Uri.parse(url1));
    var jsonResponse = jsonDecode(response.body);
    var status = jsonResponse["status"];
    var message = jsonResponse["Message"];
    setState(() {
      wallet_response_url = jsonResponse["Response"]["url"];
    });
    if (status == 'SUCCESS') {
      print('wallet_added_successfully-----------------');
      print(response.body);
      if (jsonResponse != null &&
          jsonResponse['Response'] != null &&
          jsonResponse['Response']["url"] != null) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => wallet_add(wallet_response_url: wallet_add_url,)));
      } else {
        print("wallet_add_failed");
      }
    } else {
      print("failure");
    }
  }
  Future<void> getstoreid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      user_id = prefs.getString('user_id');
    });
  }

  @override
  void initState() {
    setState(() {
      getstoreid();
    });
    super.initState();
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
        appBar: AppBar(
          backgroundColor: Color(0xff014282),
          leading: IconButton(onPressed: (){Navigator.pop(context);},icon: Icon(Icons.keyboard_arrow_left,size: 35,color: Colors.white),),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[Text("Wallet Money", style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold),)],
          ),
          actions: [ShoppingCart()],
        ),
        body: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  updateContainerColor(-1);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 4),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            ClipOval(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: size.height * 0.05,
                                  width: size.width * 0.2,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    image: DecorationImage(
                                      image: AssetImage('asset/walletzz.png'),
                                      alignment: Alignment.center,
                                    ),
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 2,
                                    ),
                                  ),
                                  child: Text(""),
                                ),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Add money to your Sauda wallet",
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.05,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (int i = 0; i < amounts.length; i++)
                    buildMoneyContainer(i, amounts[i]),
                ],
              ),
              SizedBox(
                height: size.height * 0.05,
              ),
              TextFormField(
                controller: moneyController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  labelText: "Enter Amount",
                  suffixIcon: Icon(Icons.attach_money_outlined),
                ),
              ),
              InkWell(
                onTap: (){
                  get_wallet_amount();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: size.height * 0.05,
                    width: size.width,
                    color: Color(0xffc40001),
                    child: Center(
                      child: Text(
                        'Add Amount',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
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
          currentIndex: 4,
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
                break;
              case 1:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Categories2()),
                );
                break;
              case 2:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Favourites()),
                );
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
                    ),
                  ),
                );
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



                  if (myValue != null  && isLoggedIn == true)
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
          },
        ),
      ),
    );
  }

  Widget buildMoneyContainer(int index, String moneyAmount) {
    return GestureDetector(
      onTap: () {
        updateContainerColor(index);
      },
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            color: containerColors[index],
            border: Border.all(color: Colors.black, width: 0.5),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "\$",
                  style: TextStyle(color: textColors[index]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  moneyAmount,
                  style: TextStyle(
                    color: textColors[index],
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
