import 'package:flutter/material.dart';
import 'package:myrunciit/drawer/wallet_money.dart';
import 'package:webview_flutter/webview_flutter.dart';

class wallet_add extends StatefulWidget {
  var wallet_response_url;


  wallet_add({ required this.wallet_response_url});

  @override
  State<wallet_add> createState() => _wallet_addState();
}

class _wallet_addState extends State<wallet_add> {

  final controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
        },
        onPageStarted: (String url) {},
        onPageFinished: (String url) {},
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) {
          if (request.url.startsWith('https://www.google.com/')) {
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    )
    ..loadRequest(Uri.parse('${wallet_response_url}'));

  @override
  void initState() {
    print('webview_page_wallet');
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    WebViewController webViewController = WebViewController();
    return SafeArea(
      child: Scaffold(
        body: WebViewWidget(controller: controller),
      ),
    );
  }
}
