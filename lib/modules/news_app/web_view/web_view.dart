

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebViewScreen extends StatelessWidget{

  final String url ;
  WebViewScreen(this.url, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: Uri.parse(url)),

      ),
    );
  }

}

