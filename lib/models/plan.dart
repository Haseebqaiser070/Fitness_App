class Plan {
  String? dateTime;
  String? description;
  String? name;
  String? price;
  String? url;

  Plan({
    this.dateTime,
    this.description,
    this.name,
    this.price,
    this.url,
  });

  Plan.fromJson(Map<String, dynamic> json) {
    dateTime = json['dateTime'];
    description = json['description'];
    name = json['name'];
    price = json['price'];
    url = json['url'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['dateTime'] = dateTime;
    data['description'] = description;
    data['name'] = name;
    data['price'] = price;
    data['url'] = url;
    return data;
  }
}
