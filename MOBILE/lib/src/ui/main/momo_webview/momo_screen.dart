
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MomoScreen extends StatefulWidget {
  String? url;
  MomoScreen({Key? key, this.url}) : super(key: key);

  @override
  State<MomoScreen> createState() => _MomoScreenState();
}

class _MomoScreenState extends State<MomoScreen> {
  String? url;
  @override
  void initState() {
    url = widget.url!;
    if (Platform.isAndroid) WebView.platform = AndroidWebView();

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    print("URL $url");
    return SafeArea(
      child: WebView(
         initialUrl: url,
         javascriptMode: JavascriptMode.unrestricted,
       ),
    );
  }
}