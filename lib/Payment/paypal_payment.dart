import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/shared/dialog.dart';
import 'package:fitness_app/ui/plans.dart';
import 'package:flutter/material.dart';
import 'package:http_auth/http_auth.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

class PaypalPayment extends StatefulWidget {
  const PaypalPayment({
    Key? key,
    this.onFinish,
    this.planPrice,
    this.planID,
    this.plansList,
  }) : super(key: key);

  final List? plansList;
  final String? planPrice;
  final String? planID;
  final Function? onFinish;

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

  // String domain = "https://api-m.paypal.com";
  // "https://api-m.sandbox.paypal.com"; // for sandbox mode
//  String domain = "https://api.paypal.com"; // for production mode

  // change clientId and secret with your own, provided by paypal
  // String clientId =
  //     "AdyMIwwWQckG-yEWv5tpk_F0duYmO89z3bBX9l9TYVKaqij0SWpWrOpDU-m9nt_nnZ-6Abn7gZjlIYKf";
  // String secret =
  //     "EIaaSC9DTFzj9ktYBCl0gtA1Mnn9CBxF_6l1uorqeZUnbYY1HRxJJfM7xZx5cRV74lWCSWxXyI0S1V7R";

// //////////////

  String domain = "https://api.sandbox.paypal.com"; // for sandbox mode
//  String domain = "https://api.paypal.com"; // for production mode

  // change clientId and secret with your own, provided by paypal
  String clientId =
      'Ab4vS4vmfQFgUuQMH49F9Uy3L1FdNHtfGrASCyjNijm_EkHWCFM96ex0la-YFbwavw41R3rTKU3k_Bbm';
  String secret =
      'EDjvPfYgTYqdYWR2BfOiBW4dz_jeeuadqH7Z98pZMDvY33PcViiooqYFWVPFSGbfKBfNOb3LnroSI1hv';

// //////////////

  // you can change default currency according to your need
  Map<dynamic, dynamic> defaultCurrency = {
    "symbol": "USD ",
    "decimalDigits": 2,
    "symbolBeforeTheNumber": true,
    "currency": "USD"
  };

  bool isEnableShipping = false;
  bool isEnableAddress = false;

  String returnURL = 'return.example.com';
  String cancelURL = 'cancel.example.com';

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      try {
        accessToken = await getAcessToken();

        final transactions = getOrderParams();
        final res = await createPaypalPayment(transactions, accessToken);
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
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
  }

  Future<String?> getAcessToken() async {
    try {
      var client = BasicAuthClient(clientId, secret);
      var url =
          Uri.parse("$domain/v1/oauth2/token?grant_type=client_credentials");
      var response = await client.post(
        url,
      );
      if (response.statusCode == 200) {
        print(response.body);
        final body = convert.jsonDecode(response.body);
        return body["access_token"];
      }

      print(response.body);
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, String>?> createPaypalPayment(
      transactions, accessToken) async {
    var url1 = Uri.parse("${domain}/v1/payments/payment");
    try {
      var response = await http.post(url1,
          body: convert.jsonEncode(transactions),
          headers: {
            "content-type": "application/json",
            'Authorization': 'Bearer ' + accessToken
          });

      final body = convert.jsonDecode(response.body);
      if (response.statusCode == 201) {
        if (body["links"] != null && body["links"].length > 0) {
          List links = body["links"];

          String executeUrl = "";
          String approvalUrl = "";
          final item = links.firstWhere((o) => o["rel"] == "approval_url",
              orElse: () => null);
          if (item != null) {
            approvalUrl = item["href"];
          }
          final item1 = links.firstWhere((o) => o["rel"] == "execute",
              orElse: () => null);
          if (item1 != null) {
            executeUrl = item1["href"];
          }
          return {"executeUrl": executeUrl, "approvalUrl": approvalUrl};
        }
        return null;
      } else {
        print(response.body);
        throw Exception(body["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  // item name, price and quantity
  // String itemName = 'GYM Plan'; //'Meteology LiveCams Subscription';
  // String itemPrice = widget.planPrice!; //'9.90';
  // int quantity = 1;

  Map<String, dynamic> getOrderParams() {
    List items = [
      {
        "name": 'GYM Plan', // itemName,
        "quantity": 1, // quantity,
        "price": widget.planPrice!, // itemPrice,
        "currency": defaultCurrency["currency"]
      }
    ];

    // checkout invoice details
    String? totalAmount = widget.planPrice!; // '9.90';
    String? subTotalAmount = widget.planPrice!; //  '9.90';
    String? shippingCost = '0';
    int? shippingDiscountCost = 0;
    String? userFirstName = 'Test1'; // 'ΕΥΦΡΟΣΥΝΗ';
    String? userLastName = 'Test2'; // 'ΤΖΟΥΜΑ';
    String? addressCity = 'Washington DC'; // 'DRAKONTIO-LAGADAS';
    String? addressStreet = 'Street 11'; // 'DRAKONTIO';
    String? addressZipCode = '57200';
    String? addressCountry = 'Greece';
    String? addressState = 'GREECE';
    String? addressPhoneNumber = '+306971809450';

    Map<String, dynamic> temp = {
      "intent": "sale",
      "payer": {"payment_method": "paypal"},
      "transactions": [
        {
          "amount": {
            "total": totalAmount,
            "currency": defaultCurrency["currency"],
            "details": {
              "subtotal": subTotalAmount,
              "shipping": shippingCost,
              "shipping_discount": ((-1.0) * shippingDiscountCost).toString()
            }
          },
          "description": "The payment transaction description.",
          "payment_options": {
            "allowed_payment_method": "INSTANT_FUNDING_SOURCE"
          },
          "item_list": {
            "items": items,
            if (isEnableShipping && isEnableAddress)
              "shipping_address": {
                "recipient_name": userFirstName + " " + userLastName,
                "line1": addressStreet,
                "line2": "",
                "city": addressCity,
                "country_code": addressCountry,
                "postal_code": addressZipCode,
                "phone": addressPhoneNumber,
                "state": addressState
              },
          }
        }
      ],
      "note_to_payer": "Contact us for any questions on your order.",
      "redirect_urls": {"return_url": returnURL, "cancel_url": cancelURL}
    };
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    // var userprovider = Provider.of<UserProvider>(context);
    // var lnguage = Provider.of<LanguageProvider>(context);
    print(checkoutUrl);

    if (checkoutUrl != null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).backgroundColor,
          leading: GestureDetector(
            child: Icon(Icons.arrow_back_ios),
            onTap: () => Navigator.pop(context),
          ),
        ),
        body: WebView(
          initialUrl: checkoutUrl,
          javascriptMode: JavascriptMode.unrestricted,
          navigationDelegate: (NavigationRequest request) {
            if (request.url.contains(returnURL)) {
              final uri = Uri.parse(request.url);
              final payerID = uri.queryParameters['PayerID'];
              if (payerID != null) {
                executePayment(context, executeUrl!, payerID,
                    accessToken); // userprovider.userModel.data.id, lnguage.index
              } else {
                showDialog(
                    context: context,
                    builder: (_) => LogoutOverlay(
                          message: "Some error occur",
                        ));
                // Navigator.of(context).pop();
              }
              // Navigator.of(context).pop();
            }
            if (request.url.contains(cancelURL)) {
              Navigator.of(context).pop();
            }
            return NavigationDecision.navigate;
          },
        ),
      );
    } else {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          backgroundColor: Colors.black12,
          elevation: 0.0,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
  }

  Future<String?> executePayment(
      BuildContext context, String url, payerId, accessToken) async {
    // String id, String language
    try {
      var response = await http.post(Uri.parse(url),
          body: convert.jsonEncode({"payer_id": payerId}),
          headers: {
            "content-type": "application/json",
            'Authorization': 'Bearer ' + accessToken
          });

      final body = convert.jsonDecode(response.body);
      if (response.statusCode == 200) {
        String paymentid = body["id"];
        print(paymentid);
        var id = FirebaseAuth.instance.currentUser!.uid;
        addpayment(id, context, paymentid); // language,
        print("success");
      } else {
        return showDialog(
          context: context,
          builder: (_) => LogoutOverlay(
            message: "Some error occur",
          ),
        );
      }

      print(response.body);
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future addpayment(
      String userid,
      BuildContext context, // String language,
      String paymentid) async {
    // var url = Uri.parse(
    //     "{BaseUrl.baseurl}/payment/create-payment"); // add record to database
    // final response = await http.post(url, body: {
    //   "userId": userid,
    //   "paymentMethod": "PayPal",
    //   "amountPaid": "9.90",
    //   "paymentId": paymentid
    // });
    widget.plansList!.add({
      "userId": userid,
      "paymentMethod": "PayPal",
      "amountPaid": widget.planPrice,
      "paymentId": paymentid,
      'paidFor': widget.planID,
      'dateTime': DateTime.now().toString(),
    });
    FirebaseFirestore.instance.collection('users').doc(userid).update({
      'subscribedPlans': widget.plansList!,
    }).then((value) {
      showDialog(
        context: context,
        builder: (_) => LogoutOverlay(
          message: "Payment Success",
        ),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => const Plans(
                // lang: language,
                )),
        (Route<dynamic> route) => false,
      );
    }).onError((error, stackTrace) {
      showDialog(
        context: context,
        builder: (_) => LogoutOverlay(
          message: error.toString(),
        ),
      );
    });
    // if (4 == 200) {
    //   showDialog(
    //     context: context,
    //     builder: (_) => LogoutOverlay(
    //       message: "payment success",
    //     ),
    //   );
    //   Navigator.pushAndRemoveUntil(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => const Plans(),
    //     ),
    //     (Route<dynamic> route) => false,
    //   );
    // } else {
    //   showDialog(
    //     context: context,
    //     builder: (_) => LogoutOverlay(
    //       message: "Your payment is success but error in database contact us",
    //     ),
    //   );
    // }
  }
}
