// ignore_for_file: import_of_legacy_library_into_null_safe, must_be_immutable

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/Payment/stripe_payment/services/payment_service.dart';
import 'package:fitness_app/models/user.dart';
import 'package:fitness_app/shared/dialog.dart';
import 'package:fitness_app/ui/plans.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
// import 'package:lobfo/payment/dialog.dart';
// import 'package:lobfo/payment/services/payment_service.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:stripe_payment/stripe_payment.dart';

class ConfirmPayment extends StatefulWidget {
  List? cards;
  final String? planPrice;
  final String? planID;
  List? plansList;
  ConfirmPayment({
    Key? key,
    this.cards,
    this.planPrice,
    this.planID,
    this.plansList,
  }) : super(key: key);

  @override
  ConfirmPaymentState createState() => ConfirmPaymentState();
}

class ConfirmPaymentState extends State<ConfirmPayment> {
  List cards = [
    {
      'cardNumber': '4242424242424242',
      'expiryDate': '04/24',
      'cardHolderName': 'Muhammad Ahsan Ayaz',
      'cvvCode': '424',
      'showBackView': false,
    },
  ];
  // var plans = [];

  payViaExistingCard(BuildContext context, card, String amount) async {
    ProgressDialog dialog = ProgressDialog(context);
    dialog.style(message: 'Please wait...');
    await dialog.show();
    var expiryArr = card['expiryDate'].split('/');
    CreditCard stripeCard = CreditCard(
      number: card['cardNumber'],
      expMonth: int.parse(expiryArr[0]),
      expYear: int.parse(expiryArr[1]),
    );
    var response = await StripeService.payViaExistingCard(
      amount: amount, // '99',
      currency: 'USD',
      card: stripeCard,
    );
    await dialog.hide();
    if (response.success == false) {
      print(response.message);
      showDialog(
        context: context,
        builder: (ctx) => LogoutOverlay(
          message: "Some error occur",
        ),
      );
      // adddPlan();
    } else {
      var userid = FirebaseAuth.instance.currentUser!.uid;

      widget.plansList!.add({
        "userId": userid,
        "paymentMethod": "Card",
        "amountPaid": widget.planPrice,
        "paymentId": 'paymentid',
        'paidFor': widget.planID,
        'dateTime': DateTime.now().toString(),
      });
      FirebaseFirestore.instance.collection('users').doc(userid).update({
        'subscribedPlans': widget.plansList!,
        //  {
        //   "userId": userid,
        //   "paymentMethod": "Card",
        //   "amountPaid": widget.planPrice,
        //   // "paymentId": paymentid,
        //   'paidFor': widget.planID,
        //   'dateTime': DateTime.now().toString(),
        // }
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
            builder: (context) => const Plans(),
          ),
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
      debugPrint(response.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(0, 50, 78, 10),
        title: const Text('Pay Now'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: ListView.builder(
          itemCount: widget.cards!.length,
          itemBuilder: (BuildContext context, int index) {
            var card = widget.cards![index];
            return Column(children: [
              CreditCardWidget(
                cardNumber: card['cardNumber'],
                expiryDate: card['expiryDate'],
                cardHolderName: card['cardHolderName'],
                cvvCode: card['cvvCode'],
                showBackView: false,
                onCreditCardWidgetChange: (CreditCardBrand creditCardBrand) {
                  // creditCardBrand.brandName = CardType.mastercard;
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: MaterialButton(
                  elevation: 4.0,
                  color: const Color.fromRGBO(0, 50, 78, 10),
                  minWidth: 200,
                  height: 50,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22.0),
                  ),
                  child: const Text(
                    "PayNow",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    payViaExistingCard(context, card, widget.planPrice!);
                  },
                ),
              )
            ]);
          },
        ),
      ),
    );
  }

  void adddPlans() {
    var userid = FirebaseAuth.instance.currentUser!.uid;
    widget.plansList!.add(SubscribedPlans(
      userId: userid,
      paymentMethod: "Card",
      amountPaid: widget.planPrice,
      paymentId: 'paymentid',
      paidFor: widget.planID,
      dateTime: DateTime.now(),
    ).toJson());
    FirebaseFirestore.instance.collection('users').doc(userid).update({
      'subscribedPlans': widget.plansList!,
    }).whenComplete(() {
      debugPrint('Plan Successfully Added');
    });
  }
}
