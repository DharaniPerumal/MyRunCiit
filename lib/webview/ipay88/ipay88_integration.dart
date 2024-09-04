import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../add_to_cart/final_order.dart';

class ipay88 extends StatefulWidget {
  var response_url;

  ipay88({ required this.response_url });

  @override
  State<ipay88> createState() => _ipay88State();
}

class _ipay88State extends State<ipay88> {

  var web = true;

  payment_cancelled()async
  {
    print('knhfugmfihg');
    setState(() {
      web = true;
    });
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('payment', 'cancelled');
    Fluttertoast.showToast(
        msg: 'Payment Cancelled...!',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 3,
        backgroundColor: Color(0xff014282),
        textColor: Colors.white,
        fontSize: 15,
        webPosition: "center");
    Navigator.pop(context);
  }

  @override
  void initState() {

    print('webviewdgf_page_here1');
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WebViewController webViewController = WebViewController();
    return SafeArea(
      child: Scaffold(
        body: web ? WebViewWidget(controller: WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setBackgroundColor(const Color(0x00000000))
          ..setNavigationDelegate(
            NavigationDelegate(
              onProgress: (int progress) {
                print("onpage hello =>>>>>>>>>>>> ${progress}");
              },
              onPageStarted: (String url) {
                print("onpage =>>>>>>>>>>>> ${url}");
                if(url.toString().contains("PaymentCancel")) {
                  payment_cancelled();
                }
              },
              onPageFinished: (String url) {},
              onWebResourceError: (WebResourceError error) {},
              onNavigationRequest: (NavigationRequest request) {
                print("url is =>>>>>>>>>>>>>>> ${request.url}");
                if(request.url.toString().contains("PaymentCancel")) {
                  payment_cancelled();
                  return NavigationDecision.prevent;
                }
                return NavigationDecision.navigate;
              },
            ),
          )
          ..loadRequest(Uri.parse('${response_url}'))) : SizedBox(),
      ),
    );
  }
}