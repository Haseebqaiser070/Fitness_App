// import 'package:fitness_app/Payment/paypal_payment.dart';
import 'package:fitness_app/Payment/paypal/paypal_payment.dart';
import 'package:fitness_app/Payment/stripe_payment/card_input.dart';
import 'package:fitness_app/shared/const.dart';
import 'package:flutter/material.dart';

class PaymentModes extends StatefulWidget {
  const PaymentModes({
    Key? key,
    this.planId,
    this.planPrice,
    this.plansList,
  }) : super(key: key);
  final List? plansList;
  final String? planId;
  final String? planPrice;

  @override
  _PaymentModesState createState() => _PaymentModesState();
}

class _PaymentModesState extends State<PaymentModes> {
  int isPayPal = 2;

  @override
  Widget build(BuildContext context) {
    var mediaSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        height: mediaSize.height,
        child: Stack(
          children: [
            SizedBox(
              width: mediaSize.width,
              height: mediaSize.height,
              child: Image.asset(
                'assets/splash.png',
                fit: BoxFit.cover,
              ),
            ),
            Container(
              width: mediaSize.width,
              height: mediaSize.height, // * 0.5,
              color: Colors.transparent,
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, top: 20.0),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Image.asset('images/back_icon.png'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: Container(
                    width: mediaSize.width,
                    height: mediaSize.width * 0.8,
                    // color: Colors.grey.shade400,
                    decoration: BoxDecoration(
                      color: tileColor, //Colors.grey.shade300,
                      // border: BorderSide.none,//.all(width: 0),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.account_balance_wallet,
                                  color: Colors.amber,
                                  // Colors.indigo.shade700,
                                ),
                              ),
                            ),
                            Row(
                              children: const [
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Select Your Payment Method',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: SizedBox(
                                height: 30,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      icon: Icon(isPayPal != 0
                                          ? Icons.radio_button_off
                                          : Icons.radio_button_checked),
                                      onPressed: () {
                                        setState(() {
                                          if (isPayPal != 0) {
                                            isPayPal = 0;
                                          }
                                          // else {
                                          //   isCard = true;
                                          // }
                                        });
                                      },
                                    ),
                                    // Radio(
                                    //   value: isCard,
                                    //   groupValue: 0,
                                    //   onChanged: (value) {
                                    //     setState(() {
                                    //       isCard = value;
                                    //     });
                                    //   },
                                    // ),
                                    const Text(
                                      'By Card',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 28.0),
                                      child: Image.asset(
                                        'assets/credit.png',
                                        fit: BoxFit.cover,
                                        height: 30,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: SizedBox(
                                height: 30,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      icon: Icon(isPayPal != 1
                                          ? Icons.radio_button_off
                                          : Icons.radio_button_checked),
                                      onPressed: () {
                                        setState(() {
                                          if (isPayPal != 1) {
                                            isPayPal = 1;
                                          }
                                          //else {
                                          //   isCard = true;
                                          // }
                                        });
                                      },
                                    ),
                                    // Radio(
                                    //   value: isCard == true ? false : true,
                                    //   groupValue: 0,
                                    //   onChanged: (value) {},
                                    // ),
                                    const Text(
                                      'By PayPal',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 5.0),
                                          child: Image.asset(
                                            'assets/paypal_logo.png',
                                            fit: BoxFit.cover,
                                            height: 30,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 40.0,
                                bottom: 8.0,
                                right: 4.0,
                                left: 4.0,
                              ),
                              child: Container(
                                height: 40,
                                width: mediaSize.width * 0.72,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(22),
                                  color: tileColor,
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    if (isPayPal == 1) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PaypalPayment(
                                            currency: "USD",
                                            userFirstName: "MAG",
                                            userLastName: "Devs",
                                            userEmail:
                                                "magdevelopers24@gmail.com",
                                            payAmount: "10.8",
                                            sandBoxMode: "true",
                                            onFinish: (w) {},
                                          ),
                                        ),
                                      );

                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //     builder: (context) => PaypalPayment(
                                      //       planPrice: widget.planPrice,
                                      //       planID: widget.planId,
                                      //       plansList: widget.plansList,
                                      //     ),
                                      //   ),
                                      // );
                                    } else if (isPayPal == 0) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CardInput(
                                            amount: widget.planPrice,
                                            planId: widget.planId,
                                            plansList: widget.plansList,
                                          ),
                                        ),
                                      );
                                    }
                                    // Navigator.pushReplacement(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) =>
                                    //             Homescreen()));
                                  },
                                  child: const Text(
                                    "Next",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
