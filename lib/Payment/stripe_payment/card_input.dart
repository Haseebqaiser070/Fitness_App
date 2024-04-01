import 'package:fitness_app/Payment/stripe_payment/confirm_payment.dart';
import 'package:fitness_app/Payment/stripe_payment/services/payment_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

class CardInput extends StatefulWidget {
  CardInput({
    Key? key,
    this.amount,
    this.planId,
    this.plansList,
  }) : super(key: key);
  List? plansList;
  String? amount;
  String? planId;
  @override
  State<StatefulWidget> createState() {
    return CardInputState();
  }
}

class CardInputState extends State<CardInput> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    StripeService.init();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Column(
            children: <Widget>[
              CreditCardWidget(
                cardNumber: cardNumber,
                expiryDate: expiryDate,
                cardBgColor: Color.fromRGBO(0, 50, 78, 10),
                cardHolderName: cardHolderName,
                cvvCode: cvvCode,
                showBackView: isCvvFocused,
                obscureCardNumber: true,
                obscureCardCvv: true,
                onCreditCardWidgetChange: (CreditCardBrand) {},
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      CreditCardForm(
                        formKey: formKey,
                        obscureCvv: true,
                        obscureNumber: true,
                        cardNumber: cardNumber,
                        cvvCode: cvvCode,
                        cardHolderName: cardHolderName,
                        expiryDate: expiryDate,
                        themeColor: Color.fromRGBO(0, 50, 78, 10),
                        cardNumberDecoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromRGBO(0, 50, 78, 10),
                            ),
                          ),
                          labelText: 'Number',
                          hintText: 'XXXX XXXX XXXX XXXX',
                        ),
                        expiryDateDecoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Expired Date',
                          hintText: 'XX/XX',
                        ),
                        cvvCodeDecoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'CVV',
                          hintText: 'XXX',
                        ),
                        cardHolderDecoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Card Holder',
                        ),
                        onCreditCardModelChange: onCreditCardModelChange,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          primary: Color.fromRGBO(0, 50, 78, 10),
                        ),
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          child: const Text(
                            'Next',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'halter',
                              fontSize: 14,
                              package: 'flutter_credit_card',
                            ),
                          ),
                        ),
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();
                            List cards = [
                              {
                                'cardNumber': cardNumber,
                                'expiryDate': expiryDate,
                                'cardHolderName': cardHolderName,
                                'cvvCode': cvvCode,
                                'showBackView': false,
                              },
                            ];
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ConfirmPayment(
                                  cards: cards,
                                  planPrice: widget.amount,
                                  planID: widget.planId,
                                  plansList: widget.plansList,
                                ),
                              ),
                            );
                            Navigator.pop(context, result);
                            // if (result == '0') {
                            //  debugPrint('is empty $result');
                            // } else {
                            //  debugPrint('is not empty $result');
                            // }
                            debugPrint('valid!');
                          } else {
                            debugPrint('invalid!');
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}
