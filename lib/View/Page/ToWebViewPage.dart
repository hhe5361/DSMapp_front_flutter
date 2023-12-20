// import 'package:dasom_community_app/Data/Service/endpoint.dart';
// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class WebviewWithWebviewFlutterScreen extends StatefulWidget {
//   String newsUrl;
//   WebviewWithWebviewFlutterScreen({super.key, required this.newsUrl});

//   @override
//   State<WebviewWithWebviewFlutterScreen> createState() =>
//       _WebviewWithWebviewFlutterScreenState();
// }

// class _WebviewWithWebviewFlutterScreenState
//     extends State<WebviewWithWebviewFlutterScreen> {
//   WebViewController? _webViewController;
//   @override
//   void initState() {
//     _webViewController = WebViewController()
//       ..loadRequest(Uri.parse(HyoeunServer.webURI + widget.newsUrl))
//       ..setJavaScriptMode(JavaScriptMode.unrestricted);
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('DailNews')),
//       body: WebViewWidget(controller: _webViewController!),
//     );
//   }
// }

// class WebViewExample extends StatefulWidget {
//   @override
//   _WebViewExampleState createState() => _WebViewExampleState();
// }

// class _WebViewExampleState extends State<WebViewExample> {
//   @override
//   Widget build(BuildContext context) {
//     return WebView(
//       initialUrl: 'https://example.com', // 원하는 URL로 변경하세요.
//       javascriptMode: JavascriptMode.unrestricted,
//     );
//   }
// }