class Location {
  String? lat;
  String? lng;

  Location({this.lat, this.lng});

  Location.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lat'] = lat;
    data['lng'] = lng;
    return data;
  }

  @override
  String toString() {
    return '{lat: $lat, lng: $lng}';
  }

  // Location.fromMap(Map<String, dynamic> map) {
  //   lat = map['lat'];
  //   lng = map['lng'];
  // }

  Map<String, dynamic> toMap() {
    return {
      'lat': lat,
      'lng': lng,
    };
  }

  factory Location.fromMap(Map<String, dynamic> map) {
    return Location(
      lat: map['lat'], lng: map['lng'],

      // id: int.parse(map['id']),
      // senderEmail: map['senderEmail'],
      // receiverEmail: map['receiverEmail'],
      // amount: map['amount'],
    );
  }

  static List<Location>? parseTransactionList(
      List<dynamic> list) {
    if (list == null) return null;

    final transactionList = <Location>[];
    for (final item in list) {
      transactionList.add(Location.fromMap(item));
    }

    return transactionList;
  }
}
