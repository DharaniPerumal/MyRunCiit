import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'package:animated_text_kit/animated_text_kit.dart';

class Carousel_slider extends StatefulWidget {
  @override
  _Carousel_sliderState createState() => _Carousel_sliderState();
}

class _Carousel_sliderState extends State<Carousel_slider>
    with TickerProviderStateMixin {
  late String product2;
  AnimationController? _controller1;
  Animation<Offset>? _animation;
  late String image2;
  late String image3;
  late String image4;
  late String image5;

  late AnimationController _textAnimationController;

  final CarouselController _controller = CarouselController();
  List<Widget> _slides = [];
  List text1 = [];
  bool isVisible = false;
  late String name;

  @override
  void initState() {
    getProduct1();
    super.initState();
    _controller1 = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation = Tween<Offset>(
      begin: const Offset(0.0, 0.0),
      end: const Offset(0.0, -2),
    ).animate(CurvedAnimation(
      parent: _controller1!,
      curve: Curves.easeInCubic,
    ));
    Future.delayed(const Duration(milliseconds: 3000), () {
      _controller1!.forward();
    });
  }
  void getProduct1() async {
    String url1 = "https://myrunciit.my/Webservice/home_sliders";
    dynamic response = await http.get(Uri.parse(url1));

    if (response.statusCode == 200) {
      print('success');
      print(response.body);

      dynamic jsonResponse = jsonDecode(response.body);
      if (jsonResponse != null &&
          jsonResponse['response'] != null &&
          jsonResponse['response'] is List &&
          jsonResponse['response'].isNotEmpty) {
        Map<String, List<Map<String, dynamic>>> groupedTexts = {};
        jsonResponse['response'].forEach((element) {
          List<dynamic> texts = element['elements']['texts'];

          if (texts != null) {
            texts.forEach((text) {
               name = text['name'];
              if (!groupedTexts.containsKey(name)) {
                groupedTexts[name] = [];
              }
              groupedTexts[name]?.add(text);
            });
          }
        });
        groupedTexts.forEach((name, texts) {
          print('Group: $name');
          texts.forEach((text) {
            print('Text: ${text['text']}');
          });
        });

        setState(() {
          _slides = jsonResponse['response'].map<Widget>((element) {
            String backgroundImg = element['background_img'];
            print('backgroundImg$backgroundImg');
            List<dynamic> texts = element['elements']['texts'];
            int i = 0;
            for( i  ; i< texts.length - 3 ; i++)
              print('texts123456' + texts[i]['text']);
            print(texts.length);


            String image = element['texts'] ?? '';
            print('image123456$image');

            return Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(backgroundImg),
                  fit: BoxFit.fill,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Stack(
                        children: <Widget>[
                          if (texts[0]['text'] == '+')
                            Container(
                                child:
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.deepPurpleAccent),
                                            child: Padding(
                                              padding: const EdgeInsets.all(3.0),
                                              child: Text(texts[0]['text'],style: TextStyle(color: Colors.white, fontSize: 25),),
                                            )),
                                        SizedBox(width: 10,),
                                        Text(texts[1]['text'],style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                            decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.deepPurpleAccent),
                                            child: Padding(
                                              padding: const EdgeInsets.all(3.0),
                                              child: Text(texts[2]['text'],style: TextStyle(color: Colors.white, fontSize: 25),),
                                            )),
                                        SizedBox(width: 10,),
                                        Text(texts[3]['text'],style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                            decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.deepPurpleAccent),
                                            child: Padding(
                                              padding: const EdgeInsets.all(3.0),
                                              child: Text(texts[4]['text'],style: TextStyle(color: Colors.white, fontSize: 25),),
                                            )),
                                        SizedBox(width: 10,),
                                        Text(texts[5]['text'],style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                            decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.deepPurpleAccent),
                                            child: Padding(
                                              padding: const EdgeInsets.all(3.0),
                                              child: Text(texts[6]['text'],style: TextStyle(color: Colors.white, fontSize: 25),),
                                            )),
                                        SizedBox(width: 10,),
                                        Text(texts[7]['text'],style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                            decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.deepPurpleAccent),
                                            child: Padding(
                                              padding: const EdgeInsets.all(3.0),
                                              child: Text(texts[8]['text'],style: TextStyle(color: Colors.white, fontSize: 25),),
                                            )),
                                        SizedBox(width: 10,),
                                        Text(texts[9]['text'],style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),),
                                      ],
                                    ),

                                  ],
                                )
                            )
                           else
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  child: Center(
                                    child: AnimatedTextKit(
                                      totalRepeatCount: 5,
                                      pause: const Duration(seconds: 5),
                                      animatedTexts: [
                                        FadeAnimatedText(
                                          texts[0]['text'],
                                          textStyle: const TextStyle(
                                            fontSize: 20.0,
                                            fontFamily: 'Horizon',
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5,),
                                Container(
                                  child: Center(
                                    child: AnimatedTextKit(
                                      totalRepeatCount: 5,
                                      pause: const Duration(seconds: 5),
                                      animatedTexts: [
                                        FadeAnimatedText(
                                          texts[1]['text'],
                                          textStyle: const TextStyle(
                                              fontSize: 20.0,
                                              fontFamily: 'Horizon',
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5,),

                                Container(
                                  child: Center(
                                    child: AnimatedTextKit(
                                      totalRepeatCount: 5,
                                      pause: const Duration(seconds: 5),
                                      animatedTexts: [
                                        FadeAnimatedText(
                                          texts[2]['text'],
                                          textStyle: const TextStyle(
                                              fontSize: 20.0,
                                              fontFamily: 'Horizon',
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),





                          // DefaultTextStyle(
                          //   style: const TextStyle(
                          //     fontSize: 15.0,
                          //     fontFamily: 'Horizon',
                          //   ),
                          //   child: AnimatedTextKit(
                          //     animatedTexts: [
                          //       TyperAnimatedText('AWESOME'),
                          //     ],
                          //     isRepeatingAnimation: false,
                          //     onFinished: () {
                          //       setState(() {
                          //         isVisible = true;
                          //       });
                          //     },
                          //   ),
                          // ),
                          // Visibility(
                          //   visible: isVisible,
                          //   child: Row(
                          //     children: texts.map<Widget>((text) {
                          //       return Text(text['text']);
                          //     }).toList(),
                          //   ),
                          // )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList();
        });
      } else {
        print("Invalid response format or missing data");
      }
    } else {
      print("Failure: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 4),
        enlargeCenterPage: true,
        viewportFraction: 1,
        aspectRatio: 1 / 1,
      ),
      carouselController: _controller,
      items: _slides,
    );
  }
}
