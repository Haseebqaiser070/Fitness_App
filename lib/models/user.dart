class FitnessUser {
  DateTime? dateTime;
  String? email;
  bool? isAdmin;
  String? name;
  String? password;
  List<SubscribedPlans>? subscribedPlans;

  FitnessUser({
    this.dateTime,
    this.email,
    this.isAdmin,
    this.name,
    this.password,
    this.subscribedPlans,
  });

  FitnessUser.fromJson(Map<String, dynamic> json) {
    dateTime = json['dateTime'];
    email = json['email'];
    isAdmin = json['isAdmin'];
    name = json['name'];
    password = json['password'];
    if (json['subscribedPlans'] != null) {
      subscribedPlans = <SubscribedPlans>[];
      json['subscribedPlans'].forEach((v) {
        subscribedPlans!.add(SubscribedPlans.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['dateTime'] = dateTime;
    data['email'] = email;
    data['isAdmin'] = isAdmin;
    data['name'] = name;
    data['password'] = password;
    if (subscribedPlans != null) {
      data['subscribedPlans'] =
          subscribedPlans!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubscribedPlans {
  String? amountPaid;
  DateTime? dateTime;
  String? paidFor;
  String? paymentMethod;
  String? paymentId;
  String? userId;

  SubscribedPlans({
    this.amountPaid,
    this.dateTime,
    this.paidFor,
    this.paymentMethod,
    this.userId,
    this.paymentId,
  });

  SubscribedPlans.fromJson(Map<String, dynamic> json) {
    amountPaid = json['amountPaid'];
    dateTime = json['dateTime'];
    paidFor = json['paidFor'];
    paymentMethod = json['paymentMethod'];
    userId = json['userId'];
    paymentId = json['paymentId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amountPaid'] = amountPaid;
    data['dateTime'] = dateTime;
    data['paidFor'] = paidFor;
    data['paymentMethod'] = paymentMethod;
    data['paymentId'] = paymentId;
    data['userId'] = userId;
    return data;
  }
}
