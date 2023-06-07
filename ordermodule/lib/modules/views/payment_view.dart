import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:providermodule/providermodule.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentView extends StatefulWidget {
  final url;
  PaymentView({Key key, this.url}) : super(key: key);

  @override
  _PaymentViewState createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    //if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Feather.arrow_left,
            size: 30,
            color: Colors.black,
          ),
        ),
        title: Text(
          '',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
        actions: <Widget>[
          // NavigationControls(_controller.future),
        ],
      ),
      body: Builder(builder: (BuildContext context) {
        return Stack(
          children: [
            // WebView(
            //   initialUrl: '${widget.url}',
            //   javascriptMode: JavascriptMode.unrestricted,
            //   onWebViewCreated: (WebViewController webViewController) {
            //     _controller.complete(webViewController);
            //   },
            //   javascriptChannels: <JavascriptChannel>[
            //     _toasterJavascriptChannel(context),
            //   ].toSet(),
            //   navigationDelegate: (NavigationRequest request) {
            //     if (request.url.startsWith('${widget.url}')) {
            //       if (!PublicVar.onProduction)
            //         print('blocking navigation to $request}');
            //       return NavigationDecision.navigate;
            //     }
            //     if (!PublicVar.onProduction)
            //       print('allowing navigation to $request');
            //     return NavigationDecision.navigate;
            //   },
            //   onPageStarted: (String url) {
            //     setState(() {
            //       isLoading = true;
            //     });
            //     if (!PublicVar.onProduction)
            //       print('Page started loading: $url');
            //   },
            //   onWebResourceError: (error) {},
            //   onPageFinished: (String url) {
            //     setState(() {
            //       isLoading = false;
            //     });
            //     if (!PublicVar.onProduction)
            //       print('Page finished loading: $url');
            //   },
            //   gestureNavigationEnabled: true,
            //   debuggingEnabled: true,
            // ),
            isLoading
                ? Center(
                    child: ShowPageLoading(),
                  )
                : SizedBox(),
          ],
        );
      }),
    );
  }

  // JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
  //   return JavascriptChannel(
  //       name: 'Toaster',
  //       onMessageReceived: (JavascriptMessage message) {
  //         // ignore: deprecated_member_use
  //         AppActions()
  //             .showSuccessToast(context: context, text: message.message);
  //       });
  // }
  //
  // Widget favoriteButton() {
  //   return FutureBuilder<WebViewController>(
  //       future: _controller.future,
  //       builder: (BuildContext context,
  //           AsyncSnapshot<WebViewController> controller) {
  //         if (controller.hasData) {
  //           return FloatingActionButton(
  //             onPressed: () async {
  //               final String url = await controller.data.currentUrl();
  //               // ignore: deprecated_member_use
  //               AppActions()
  //                   .showSuccessToast(context: context, text: 'Favorited $url');
  //             },
  //             child: const Icon(Icons.favorite),
  //           );
  //         }
  //         return Container();
  //       });
  // }
}

// class NavigationControls extends StatelessWidget {
//   const NavigationControls(this._webViewControllerFuture)
//       : assert(_webViewControllerFuture != null);
//
//   final Future<WebViewController> _webViewControllerFuture;
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<WebViewController>(
//       future: _webViewControllerFuture,
//       builder:
//           (BuildContext context, AsyncSnapshot<WebViewController> snapshot) {
//         final bool webViewReady =
//             snapshot.connectionState == ConnectionState.done;
//         final WebViewController controller = snapshot.data;
//         return IconButton(
//           icon: const Icon(
//             Ionicons.ios_refresh,
//           ),
//           onPressed: !webViewReady
//               ? null
//               : () {
//                   controller.reload();
//                 },
//         );
//       },
//     );
//   }
// }
