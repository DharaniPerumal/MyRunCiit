import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myrunciit/main_screen/login_screen.dart';
import 'package:myrunciit/roots/roots.dart';
import 'package:myrunciit/widget/cart.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Review extends StatefulWidget {
  var order_id,productname,product_id,user_id ,sale_id;
  Review({super.key, required this.order_id,
    required this.productname,
    required this.product_id,
    required this.user_id,
    required this.sale_id});

  @override
  State<Review> createState() => _ReviewState();
}

class _ReviewState extends State<Review> {
  TextEditingController desccontroller = TextEditingController();
  TextEditingController titlecontroller = TextEditingController();
  var ratings;
  Future<void> review_api() async {
    print('orderstoreid');
    String url = "$root_web/invoice/${widget.order_id}";
    print('invoice_details ====>>> $url');
    dynamic response = await http.get(Uri.parse(url));
    print('invoice_api${response.body}');
    print(response.statusCode);
    print(response);
    var jsonResponse = jsonDecode(response.body);
    var status = jsonResponse["status"];
    var order_id = jsonResponse ['status']['Response']['order_id'];
    print('order_id$order_id');
  }


  @override
  void initState() {
    review_api();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);        return Future.value(true);
      },

      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff014282),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.keyboard_arrow_left,
              size: 35,color: Colors.white,
            ),
          ),
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[Text("Ratings & Review",style: TextStyle(color: Colors.white, fontSize: 15),)],
          ),
          actions: [ShoppingCart()],
        ),
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 20, 8, 20),
                    child: Center(child: Text("${widget.productname}",style: TextStyle(fontSize: 17,color: Colors.black,fontWeight: FontWeight.bold),)),
                  ),
                  Center(child: Text("Rate this Product",style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),)),
                  SizedBox(height: 15,),
                  Center(
                    child: RatingBar.builder(
                      initialRating: 0,
                      minRating: 0,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        ratings = rating;
                        print(rating);
                      },
                    ),
                  ),
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(child: Text("Review this Product",style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold))),
                  ),
                  Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              width: size.width,
                              decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Description",style: TextStyle(fontSize: 18),),
                              )),
                          TextField(
                            controller: desccontroller,
                            keyboardType: TextInputType.multiline,
                            maxLines: 7,
                            decoration: InputDecoration(
                                hintText: "Description....",
                                hintStyle: TextStyle(fontWeight: FontWeight.bold),
                                border:  OutlineInputBorder(
                                    borderSide: BorderSide(width: 1, color: Colors.grey)
                                ) ,
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1, color: Colors.grey)
                                )
                            ),

                          ),

                        ],
                      )
                  ),
                  Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              width: size.width,
                              decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Title (Optional)",style: TextStyle(fontSize: 18),),
                              )),
                          TextField(
                            controller: titlecontroller,
                            keyboardType: TextInputType.multiline,
                            maxLines: 1,
                            decoration: InputDecoration(
                                hintText: "Review Title....",
                                hintStyle: TextStyle(fontWeight: FontWeight.bold),
                                border:  OutlineInputBorder(
                                    borderSide: BorderSide(width: 1, color: Colors.grey)
                                ) ,
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1, color: Colors.grey)
                                )
                            ),

                          ),

                        ],
                      )
                  ),
                ])),
        bottomNavigationBar: Container(
          color: Color(0xffc40001),
          height: 60, // Set the desired height
          width: size.width,
          child: InkWell(
            onTap: () {
              _valiadtion_form();
              // _onRegisterform();
            },
            child: Center(
              child: Text(
                "Submit Review",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),


      ),
    );
  }

  _valiadtion_form() {
    if(ratings == null && titlecontroller.text == ""){
      Fluttertoast.showToast(
          msg: 'Please, fill the fields...!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: Color(0xff014282),
          textColor: Colors.white,
          fontSize: 15,
          webPosition: "center");
    }else if(ratings == null){
      Fluttertoast.showToast(
          msg: 'Please, give ratings...!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: Color(0xff014282),
          textColor: Colors.white,
          fontSize: 15,
          webPosition: "center");
    }else if(titlecontroller.text == ""){
      Fluttertoast.showToast(
          msg: 'Please, give title...!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: Color(0xff014282),
          textColor: Colors.white,
          fontSize: 15,
          webPosition: "center");
    }else{
      _onRegisterform();
    }
  }
  Future<void> _onRegisterform() async {
    String url = "$root_web/add_review";
    print(widget.product_id);
    print(widget.user_id);
    print(widget.productname);
    print("rating-----------------$ratings-----------${titlecontroller.text}-------------${desccontroller.text}");
    print(desccontroller.text);
    print(widget.order_id);
    print(widget.sale_id);
    Map data = {
      "pid": widget.product_id,
      "user_id": widget.user_id,
      "title": titlecontroller.text,
      "rating": ratings,
      "description": desccontroller.text,
      "order_id": widget.order_id,
      "sale_id": widget.sale_id
    };
    print("registeration_Api_connect ====>>> ${data}");
    http.Response response =
    await http.post(Uri.parse(url), body: jsonEncode(data));
    var jsonResponse = jsonDecode(response.body);
    var status = jsonResponse["status"];
    var message = jsonResponse["message"];
    print('register status$status');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var status1 = await prefs.setString('review_status',status );
    if (status == "SUCCESS") {
      Navigator.pop(context);
      Fluttertoast.showToast(
          msg: '${jsonResponse["message"]}',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: Color(0xff014282),
          textColor: Colors.white,
          fontSize: 15,
          webPosition: "center");
    } else {
      Navigator.pop(context);
      Fluttertoast.showToast(
          msg: '${jsonResponse["message"]}',
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
