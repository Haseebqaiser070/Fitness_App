import 'dart:core';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'paypal_services.dart';

var clientIdd =
    'AQpShS6a3kHXBWwcbFsSoUnKKNSD6Sc5Y2AaOab2ZGdvtJCkMdJvH-dQ5GIPup356hjbBB8ig953p41O';
var secretKey =
    'EOzaaWx1Q-xx1MI32xV0G-CxtEWGZ36-EpKIIUofnQR1IR_k2m5PYuBQfYoopcbSEefc-lECWL3HEhhK';

class PaypalPayment extends StatefulWidget {
  final Function onFinish;
  final String currency;
  final String userFirstName;
  final String userLastName;
  final String userEmail;
  final String payAmount;
  final String clientId = clientIdd;
  final String secret = secretKey;
  final String sandBoxMode;

  PaypalPayment({
    required this.onFinish,
    required this.currency,
    required this.userFirstName,
    required this.userLastName,
    required this.userEmail,
    required this.payAmount,
    // required this.clientId,
    // required this.secret,
    this.sandBoxMode = "false",
  });

  @override
  State<StatefulWidget> createState() {
    return PaypalPaymentState();
  }
}

class PaypalPaymentState extends State<PaypalPayment> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? checkoutUrl;
  String? executeUrl;
  String? accessToken;
  PaypalServices services = PaypalServices();
  var paymentResponse;
  List<String> payResponse = [];

  bool isEnableShipping = false;
  bool isEnableAddress = false;

  String returnURL = 'https://paypal.com';
  String cancelURL = 'cancel.example.com';

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      try {
        accessToken = await services.getAccessToken(
            widget.clientId, widget.secret, widget.sandBoxMode);
        final transactions = getOrderParams(widget.userFirstName,
            widget.userLastName, "Foods", widget.payAmount, widget.currency);
        final res =
            await services.createPaypalPayment(transactions, accessToken);
        if (res != null) {
          setState(() {
            checkoutUrl = res["approvalUrl"];
            executeUrl = res["executeUrl"];
          });
        }
      } catch (e) {
        print('exception: ' + e.toString());
        final snackBar = SnackBar(
          content: Text(e.toString()),
          duration: const Duration(seconds: 10),
          action: SnackBarAction(
            label: 'Close',
            onPressed: () {
              // Some code to undo the change.
            },
          ),
        );
        // _scaffoldKey.currentState.showSnackBar(snackBar);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
  }

  int quantity = 1;

  Map<String, dynamic> getOrderParams(
      userFirstName, userLastName, itemName, itemPrice, String currency) {
    Map<String, dynamic> params = {
      "intent": "sale",
      "payer": {"payment_method": "paypal"},
      "transactions": [
        {
          "amount": {
            "total": itemPrice,
            "currency": currency,
            "details": {
              "subtotal": itemPrice,
              "shipping": "0",
              "handling_fee": "0",
              "shipping_discount": "0"
            }
          },
          "description": "The payment transaction description.",
          "payment_options": {
            "allowed_payment_method": "INSTANT_FUNDING_SOURCE"
          },
          "item_list": {"items": []}
        }
      ],
      "note_to_payer": "Contact us for any questions on your order.",
      "redirect_urls": {"return_url": returnURL, "cancel_url": cancelURL}
    };
    return params;
  }

  Widget appBar(title) {
    return AppBar(
      iconTheme: const IconThemeData(
        color: Colors.black,
      ),
      elevation: 0.0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () => Navigator.pop(context),
      ),
      backgroundColor: Colors.white,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 18.0,
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (checkoutUrl != null) {
      return Scaffold(
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.blue,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: Colors.transparent, //.black12,
          elevation: 0.0,
        ),
        // appBar: const PreferredSize(
        //   preferredSize: Size.fromHeight(40),
        //   child: SafeArea(
        //     child: Center(
        //       child: Text("PayPal Payment"),
        //     ),
        //   ),
        // ),
        body: SafeArea(
          child: Center(
            child: WebView(
              initialUrl: checkoutUrl,
              javascriptMode: JavascriptMode.unrestricted,
              navigationDelegate: (NavigationRequest request) {
                if (request.url.contains(returnURL)) {
                  final uri = Uri.parse(request.url);
                  final payerID = uri.queryParameters['PayerID'];
                  if (payerID != null) {
                    services
                        .executePayment(executeUrl, payerID, accessToken)
                        .then((List<String>? ls) {
                      print("paymentMethod: $payerID $accessToken ${ls![0]}");
                      setState(() {
                        payResponse = ls;
                      });
                      widget.onFinish(ls[0]);
                      Navigator.of(context).pop();
                    });
                  } else {
                    Navigator.of(context).pop();
                  }
                }
                if (request.url.contains(cancelURL)) {
                  Navigator.of(context).pop();
                }
                return NavigationDecision.navigate;
              },
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        key: _scaffoldKey,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: Colors.transparent, //.black12,
          elevation: 0.0,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}
