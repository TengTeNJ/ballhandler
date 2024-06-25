import 'package:code/constants/constants.dart';
import 'package:code/widgets/navigation/CustomAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TTWebViewController extends StatefulWidget {
  const TTWebViewController({super.key});

  @override
  State<TTWebViewController> createState() => _TTWebViewControllerState();
}

class _TTWebViewControllerState extends State<TTWebViewController> {
  late WebViewController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
            if(progress>=100){
              EasyLoading.dismiss();
            }else{
              EasyLoading.showProgress(progress.toDouble()/100);
            }
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(
          'https://potent-hockey.s3.eu-north-1.amazonaws.com/h5/service.html'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showBack: true,
        customBackgroundColor: Constants.baseControllerColor,
      ),
      body: Container(
        color: Constants.baseControllerColor,
        child: Column(
          children: [
            SizedBox(
              height: 16,
            ),
            Expanded(child: WebViewWidget(controller: controller))
          ],
        ),
      ),
    );
  }
}
