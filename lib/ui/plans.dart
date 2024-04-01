import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/Payment/paymentmode.dart';
import 'package:fitness_app/models/user.dart';
import 'package:fitness_app/shared/const.dart';
import 'package:fitness_app/ui/admin_panel.dart';
import 'package:fitness_app/ui/video_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Plans extends StatefulWidget {
  static const String routeName = '/plans';
  const Plans({Key? key}) : super(key: key);

  @override
  _PlansState createState() => _PlansState();
}

class _PlansState extends State<Plans> {
  final _auth = FirebaseAuth.instance;

  bool? isAdmin = false;
  List<SubscribedPlans> subscribedPlansList = [];
  List<String> subscribedPlansIDList = [];
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  // CollectionReference<Map<String, dynamic>> designs =
  //     FirebaseFirestore.instance.collection('Designs');

  var data = [];

  var planIDs = [];
  List plansList = [];
  void getCurrentUser() async {
    //if(_auth.currentUser!())
    //final user = await _auth.currentUser();
    // if (user != null) {}
  }
  Future getPlans() async {
    await firestore.collection('plans').get().then((response) {
      setState(() {
        data = response.docs;
        print(data);
        // _datasearch = response.docs;
        // debugPrint("data=of search screen======== $_data");
        // var d = listExample("Ad3OZdJg8RHc3nbcGt4H");
      });
      setState(() {});
    });
    //debugPrint(_data.length.runtimeType);
  }

  @override
  void initState() {
    super.initState();
    getPlans();
    getUserAccess();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Center(
          child: Image.asset(
            'images/plan_logo.png',
            fit: BoxFit.cover,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 34, 38, 45),
        actions: <Widget>[
          IconButton(
            icon: Image.asset('images/search_icon.png'),
            onPressed: () {
              // getUserAccess();
            },
          ),
        ],
        leading: isAdmin!
            ? IconButton(
                icon: const Icon(Icons.admin_panel_settings_outlined),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AdminPanel(),
                    ),
                  );
                },
              )
            : Container(),
      ),
      body: Container(
        color: const Color.fromARGB(255, 34, 38, 45),
        //Colors.blueGrey[900],
        child: Column(
          children: [
            const SizedBox(height: 20.0),
            const Center(
              child: Text(
                kt3,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 5.0),
            const Center(
              child: Text(
                kt4,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30, //25.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            data != null
                ? Expanded(
                    flex: 10,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) {
                        QueryDocumentSnapshot q = data[index];
                        // print('IDDD   ' + q.id);
                        return Center(
                          child: Column(
                            children: [
                              InkResponse(
                                onTap: () {
                                  if (!isAdmin!) {
                                    if (planIDs.contains(q.id)) {
                                      print('yes');
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => VideoList(
                                            videos: q.get('url'),
                                          ),
                                        ),
                                      );
                                    } else {
                                      print('no');
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PaymentModes(
                                            planId: q.id,
                                            planPrice: q.get('price'),
                                            plansList: plansList,
                                          ),
                                        ),
                                      );
                                    }
                                  } else {
                                    print('I am admin');
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => VideoList(
                                          videos: q.get('url'),
                                          //[q.get('url'), q.get('url')],
                                        ),
                                      ),
                                    );
                                  }
                                  // var i = subscribedPlansIDList.contains(q.id);
                                  // print('IDDD  $i ' + q.id);
                                  // for (var i = 0;
                                  //     i < subscribedPlansList.length;
                                  //     i++) {}
                                  // if (q.id ==
                                  //     subscribedPlansList[0]['paidFor']) {
                                  // } else {}
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) => VideoList(
                                  //       videos: [q.get('url')],
                                  //     ),
                                  //   ),
                                  // );
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) => PaymentModes(
                                  //       planId: q.id,
                                  //       planPrice: q.get('price'),
                                  //     ),
                                  //   ),
                                  // );
                                },
                                child: Container(
                                  // height: 125, //90,
                                  width: MediaQuery.of(context).size.width,
                                  color: tileColor, // Colors.grey,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 14.0),
                                          child: Image.asset(
                                            'images/signup_img.png',
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 7,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    left: 8.0,
                                                    top: 8.0,
                                                  ),
                                                  child: Text(
                                                    q.get('name').toString(),
                                                    // "All Round Shape & Strength. \nLets Grow Pecs",
                                                    textAlign: TextAlign.right,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    left: 8.0,
                                                    top: 8.0,
                                                  ),
                                                  child: Wrap(
                                                    children: [
                                                      Text(
                                                        q.get('description'),
                                                        // "All Round Shape & Strength. \nLets Grow Pecs",
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 15.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          overflow:
                                                              TextOverflow.clip,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    left: 8.0,
                                                    top: 8.0,
                                                  ),
                                                  child: Text(
                                                    '\$${q.get('price')}',
                                                    // "\$10.00",
                                                    style: const TextStyle(
                                                      color: Colors.blue,
                                                      fontSize: 15.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        );
                      },
                    ),
                  )
                : const CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }

  Future<void> getUserAccess() async {
    var userId = FirebaseAuth.instance.currentUser!.uid;
    await firestore.collection('users').doc(userId).get().then((value) {
      print('object');
      print(value.get('isAdmin'));
      setState(() {
        isAdmin = value.get('isAdmin');
      });
      // var pland = value.data()!['subscribedPlans'];
      // var genreIdsFromJson = jsonMap['genre_ids'];
      // List<SubscribedPlans> idsList = List<SubscribedPlans>.from(pland);
      print('objectss');
      // subscribedPlansList = value.data()!['subscribedPlans'];
      //.cast<SubscribedPlans>();
      // as List<SubscribedPlans>;
      // var a = [];
      // print('$subscribedPlansList');
      // print(subscribedPlansList![0]['paidFor']);
      // setState(() {});
      // if (subscribedPlansList != null) {
      //   for (var i = 0; i <= subscribedPlansList.length; i++) {
      //     subscribedPlansIDList[i] = subscribedPlansList[i]['paidFor'];
      //   }
      //   print(subscribedPlansIDList);
      // }

      setState(() {});
      // QueryDocumentSnapshot<Object?> q =
      //     value.data() as QueryDocumentSnapshot<Object?>;
      // var subscribedPlans = q.get('subscribedPlans');
      //get('subscribedPlans');
      // var s = subscribedPlans.get('paidFor');
      // print('$s');
      // var a = FitnessUser.fromJson(jsonDecode(value.data().toString()));
      // print('email');
      // print(a.email);
    });
    planIDs.clear();
    var response = await firestore
        .collection('users')
        .doc(userId)
        .get()
        .whenComplete(() => print('swiss'));
    print('${response.get('subscribedPlans')}');
    plansList = response.get('subscribedPlans');
    print(plansList[0]['paidFor']);
    for (var i = 0; i < plansList.length; i++) {
      print(i);
      planIDs.add(plansList[i]['paidFor']);
    }
    print(planIDs);
  }
}
