import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myrunciit/bottom_navigationbar/deals_page/most_viewed.dart';
import 'package:myrunciit/roots/roots.dart';
import 'package:myrunciit/widget/cart.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'add_to_cart.dart';


var get_name, get_city, get_state, get_country, get_vendor_id, store_id;
List<String> items = [];
List<String> items1 = [];
List<String> days = [];
var pre_dat = false;
var showpre = false;
var last_data = "";
var tot = [];
List<DateTime?> _rangeDatePickerValueWithDefaultValue = [
  DateTime(1999, 5, 6),
  DateTime(1999, 5, 21),
];
String? selectedValue12;
String? selectedValue123;

class Pickup extends StatefulWidget {
  final String categoryName, categoryImage, sale_price, subcategory,current_stock, description, discount , multi_price ,options, brand_name, cod_status, tax, tax_type;
  List product_images = [];

  Pickup({super.key, required this.categoryName, required this.categoryImage,
    required this.sale_price,
    required this.current_stock,
    required this.description,
    required this.product_images,
    required this.subcategory,
    required this.multi_price,
    required this.discount, required this.options, required this.brand_name, required this.cod_status, required this.tax, required this.tax_type,
  });

  @override
  State<Pickup> createState() => _PickupState();
}

class _PickupState extends State<Pickup> {
  int selectedValue = 0;
  int selecteddays = -1;
  int selectedpre = -1;

  bool slot = false;
  var datecontroller = TextEditingController();
  bool showdays = false;
  TextEditingController startslot = TextEditingController();
  TextEditingController stopslot = TextEditingController();

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        datecontroller.text = "${selectedDate.day}-${selectedDate.month}-${selectedDate.year}";

      });
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('pc_date', datecontroller.text.toString());
    }
  }

  get_pick_up_address() async{
    String url1 = "$root_web/getPickupLocation/${store_id}";
    print('get_pick_up_ajhddress ----> $url1');
    dynamic response = await http.get(Uri.parse(url1));
    var jsonresponse = jsonDecode(response.body);
    var status = jsonresponse['status'];
    if (status == 'SUCCESS') {
      setState(() {
        print('get_pick_up_address_success');
        get_vendor_id = jsonresponse['response'][0]['vendor_id'];
        get_name = jsonresponse['response'][0]['name'];
        get_city = jsonresponse['response'][0]['city'];
        get_state = jsonresponse['response'][0]['state'];
        get_country = jsonresponse['response'][0]['country'];
        print('get_pick_up_address_success${get_name} ${get_city} ${get_state} ${get_country}');
      });

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

  check_preorder() async {
    // if (showdays == true) {
    String url = "$root_web/getAllPreOrders";
    Map data = {"currentDate": new DateTime.now().toString()};
    print('data=====> $data');
    http.Response response =
    await http.post(Uri.parse(url), body: jsonEncode(data));
    print("database connectivity of pre order =>> ${response.body}");
    print(response.statusCode);
    print(response);
    var jsonResponse = jsonDecode(response.body);
    if(jsonResponse["status"] == "SUCCESS")
    {
      setState(() {
        pre_dat = true;
      });
    }
    else
    {
      setState(() {
        pre_dat = false;
      });
    }

  }

  get_available() async {
    // if (showdays == true) {
      String url = "$root_web/getPickupDetailAsVendor";
      Map data = {"vendorId": get_vendor_id ?? 2};
      print('data=====> $data');
      http.Response response =
          await http.post(Uri.parse(url), body: jsonEncode(data));
      print("database connectivity${response.body}");
      print(response.statusCode);
      print(response);
      var jsonResponse = jsonDecode(response.body);
      setState(() {
        selectedValue12=null;
        selectedValue123 = null;
        var status = jsonResponse["status"];
        print('status$status');
        if (status == "SUCCESS") {
          var optionPriceString = jsonResponse["response"]["option_price"];
          var optionPrice = jsonDecode(optionPriceString);
          print("in da =>> ${optionPrice["pickupDetail"]}");
          var timeList = optionPrice["timeList"];
          var av = optionPrice["pickupDetail"];
          tot = av;
          days = [];
          for(var u=0;u<av.length;u++)
          {
              setState(() {
                days.add(jsonDecode(av[u]["slot_days"])[0].toString());
              });
          }
          List<String> startTimeList = [];
          List<String> endTimeList = [];

          // timeList.forEach((key, value) {
          //   items.add(value["slot_start_time"].toString());
          //   items1.add(value["slot_end_time"].toString());
          // });
          // items.removeAt(timeList.length-1);
          // items1.removeAt(timeList.length-1);
          // items1.removeAt(0);

          print('Start Time List: $items');
          print('End Time List: $items1');
        }
        get_time(0);
      });
  }

  get_time(ss)
  {
    var t=tot[ss]["slot_start"];
    var e=tot[ss]["slot_end"];
    var main_hr = t.toString().contains("pm")? int.parse(t.toString().split(":")[0]) + 12 : int.parse(t.toString().split(":")[0]) == 12 ? 00 : int.parse(t.toString().split(":")[0]);
    var main_min =  int.parse(t.toString().split(" ")[0].toString().split(":")[1].toString());
    var sec_hr = e.toString().contains("pm")? int.parse(e.toString().split(":")[0]) + 12 : int.parse(e.toString().split(":")[0]) == 12 ? 00 : int.parse(e.toString().split(":")[0]);
    var sec_min =  int.parse(e.toString().split(" ")[0].toString().split(":")[1].toString());
    items = [];
    items1 = [];

    var flg = true;
    setState(() {
      selectedValue123=null;
      selectedValue12=null;
      items.add("${main_hr.toString().length == 1 && main_hr != 0 ? "0" : ""}${main_hr == 0 ? 12 : main_hr}:${main_min.toString().length ==1 ? "0" : ""}${main_min} ${t.toString().contains("pm") ? "Pm" : "Am"}");
    });

    while(flg)
     {
       TimeOfDay originalTime = TimeOfDay(hour: main_hr, minute: main_min);
       TimeOfDay newTime = addOneHour(originalTime,int.parse(tot[ss]["interval_in_minute"]));
       print("i am there =>> ${newTime.hour}:${newTime.minute}");
       setState(() {
         last_data = "${newTime.hourOfPeriod.toString().length ==1 ? "0" : ""}${newTime.hourOfPeriod}:${newTime.minute.toString().length ==1 ? "0" : ""}${newTime.minute} ${e.toString().contains("pm") ? "Pm" : "Am"}";
       });
       if(newTime.hour < sec_hr)
       {
         setState(() {
           items.add("${newTime.hourOfPeriod.toString().length ==1 ? "0" : ""}${newTime.hourOfPeriod}:${newTime.minute.toString().length ==1 ? "0" : ""}${newTime.minute} ${newTime.period.name}");
           main_hr = newTime.hour;
           main_min = newTime.minute;
         });
       }
       else
       {
         flg = false;
       }

     }
    print("item data =>> ${items}");

  }

  second_data(data)
  {
    setState(() {
      selectedValue123=null;
      items1 = [];
      var index = items.indexOf(data);
      for(var b=index+1;b<items.length;b++)
      {
        items1.add(items[b]);
      }
      items1.add(last_data);
      selectedValue123 = items1[0];
    });

  }


  TimeOfDay addOneHour(TimeOfDay time,int mins) {
    int newMinute = (time.minute + mins) % 60;
    int newHour = time.hour + (time.minute + mins) ~/ 60;

    return TimeOfDay(hour: newHour % 24, minute: newMinute);
  }

  getstoreid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      store_id = prefs.getString('storeid');
    });
    print('gridview3store_id===>>> $store_id');
    get_pick_up_address();
    get_available();
  }

  @override
  void initState() {

    setState(() {
      showpre = false;
      pre_dat = false;
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
          leading: IconButton(onPressed: (){Navigator.pop(context);},icon: Icon(Icons.keyboard_arrow_left,size: 35,color: Colors.white,),),
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              AutoSizeText("Pickup",style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold),),
            ],
          ),
          actions: [
            ShoppingCart()        ],
        ),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: size.width*0.3,
                      child: Image.asset('asset/logo.png'),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Pickup Location",style: TextStyle(color: Colors.black,fontSize: 19,fontWeight: FontWeight.bold),),
                ),
                SizedBox(height: 15,),
                Container(
                  width: size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Radio(     value: 1,
                              groupValue: selectedValue,
                              onChanged: (value) {
                                setState(() {
                                  get_available();
                                  check_preorder();
                                  showdays = true;
                                  selectedValue = value as int;
                                });
                              },),
                          Container(child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('${get_name}',style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.bold),),
                          ),decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5.0)),color: Color(0xffc40001)),)
                        ],
                      ),
                      SizedBox(height: 7,),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(50,  0, 0, 8),
                        child: Text('${get_city}, ${get_state}, ${get_country}',style: TextStyle(fontSize: 15,color: Colors.black),),
                      ),
                      if (pre_dat == true)
                      Row(
                        children: [
                          Radio(
                            value: 1,
                            groupValue: selectedpre,
                            onChanged: (value) {
                              setState(() {
                                selectedpre = value as int;
                                showpre = true;
                              });
                            },),
                          Text('Pre-Order',style: TextStyle(fontWeight: FontWeight.bold),),
                        ],
                      ),
                      if (showpre == true)
                        Padding(
                          padding: const EdgeInsets.only(left: 40.0,right: 40,bottom: 20,top: 5),
                          child: TextField(
                             controller: datecontroller,
                            readOnly: true,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.black,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.calendar_month),
                                  onPressed: () {
                                    _selectDate(context);
                                  },
                                ),
                              )
                          ),
                        ),

                      if (showdays == true)
                        Center(child: Text('Available Days',style: TextStyle(color: Colors.black,fontSize: 17,fontWeight: FontWeight.bold),)),
                      if (showdays == true)
                        Container(
                            child:  SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5.0,right: 15),
                                child: Row(
                                  children: <Widget>[
                                    for(var r=0;r<days.length;r++)
                                    Row(
                                      children: <Widget>[
                                        Radio(
                                          value: r,
                                          groupValue: selecteddays,
                                          onChanged: (value) {

                                            setState(() {
                                              slot = true;
                                              selecteddays = value as int;
                                              get_time(r);
                                            });
                                          },
                                        ),
                                        Text('${days[r]}',style: TextStyle(fontWeight: FontWeight.bold),),
                                      ],
                                    ),

                                  ],
                                ),
                              ),
                            )),
                      if (slot == true)
                        Column(
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('Pickup Slot Start',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15),),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10.0,right: 10),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton2<String>(
                                        isExpanded: true,
                                        hint: Text(
                                          'Select',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Theme.of(context).hintColor,
                                          ),
                                        ),
                                        items: items
                                            .map((String item) => DropdownMenuItem<String>(
                                          value: item,
                                          child: Text(
                                            item,
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ))
                                            .toList(),
                                        value: selectedValue12,
                                        onChanged: (String? value) {
                                          setState(() {
                                            selectedValue12 = value;
                                            print("changed value =>> ${value}");
                                            second_data(value);
                                          });
                                        },
                                        buttonStyleData: const ButtonStyleData(
                                          padding: EdgeInsets.symmetric(horizontal: 16),
                                          height: 40,
                                          width: 140,
                                        ),
                                        menuItemStyleData: const MenuItemStyleData(
                                          height: 40,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('Pickup Slot Stop',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15),),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10.0,right: 10),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton2<String>(
                                        isExpanded: true,
                                        hint: Text(
                                          'Select',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Theme.of(context).hintColor,
                                          ),
                                        ),
                                        items: items1
                                            .map((String item) => DropdownMenuItem<String>(
                                          value: item,
                                          child: Text(
                                            item,
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ))
                                            .toList(),
                                        value: selectedValue123,
                                        onChanged: null,
                                        // onChanged: (String? value) {
                                        //   setState(() {
                                        //     selectedValue123 = value;
                                        //   });
                                        // },
                                        buttonStyleData: const ButtonStyleData(
                                          padding: EdgeInsets.symmetric(horizontal: 16),
                                          height: 40,
                                          width: 140,
                                        ),

                                        menuItemStyleData: const MenuItemStyleData(
                                          height: 40,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10,),
                            GestureDetector(
                              onTap: ()async{
                                final SharedPreferences prefs = await SharedPreferences.getInstance();
                                await prefs.setString('pickup_delivery', 'pickup');
                                // if((prefs.getString('pc_date') ?? "-") == "-")
                                // {
                                //   await prefs.setString('pc_date', DateFormat('yyyy-MM-dd').format(DateTime.now()).toString());
                                // }
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AddToCart(
                                          sub_category: widget.subcategory,
                                          tax: widget.tax,
                                          tax_type: widget.tax_type,
                                          multi_price: widget.multi_price,
                                          product_muti_images: widget.product_images,
                                          categoryName: widget.categoryName,
                                          categoryImage: widget.categoryImage,
                                          sale_price: widget.sale_price,
                                          current_stock: widget.current_stock,
                                          description: widget.description,
                                          discount: widget.discount,
                                          product_id: widget.discount,
                                          options: widget.options,
                                          brand_name: widget.brand_name,
                                          cod_status: widget.cod_status,
                                        )));
                              },
                              child: Container(child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text('Continue',style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.bold),),
                              ),decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5.0)),color: Color(0xffc40001)),),
                            )

                          ],
                        )


                    ],
                  ),
                ),

                TextButton(onPressed: (){Navigator.pop(context);}, child: Text("Back",style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold)))

              ],
            ),
          ),
        )
      ),
    );
  }
}
