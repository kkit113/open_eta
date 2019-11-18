class BusRoute {
  final String type;
  final String version;
  final String timeStamp;
  final List<BusRouteData> data;

  BusRoute({this.type, this.version, this.timeStamp, this.data});

  factory BusRoute.fromJson(Map<String, dynamic> json) {
    return BusRoute(
      type: json['type'],
      version: json['version'],
      timeStamp: json['generated_timestamp '],
      data: parseData(json),
    );
  }

  static List<BusRouteData> parseData(json) {
    List<BusRouteData> dataList = List<BusRouteData>();
//    print('parseRoute');
    try {
      var list = json['data'] as List;
      dataList = list.map((data) => BusRouteData.fromJson(data)).toList();
//      print('dataList - ${dataList.length}');
    } catch (e) {
      print('parseEta: $e');
    }
    return dataList;
  }

  Map toJson() {
    return {
      'type': type,
      'version': version,
      'timeStamp': timeStamp,
      'data': data,
    };
  }
}

class BusRouteData {
  int _id;
  String co;
  String route;
  String origTc;
  String origEn;
  String destTc;
  String destEn;
  String origSc;
  String destSc;
  String dataTimeStamp;

  BusRouteData(
      {this.co,
      this.route,
      this.origTc,
      this.origEn,
      this.destTc,
      this.destEn,
      this.origSc,
      this.destSc,
      this.dataTimeStamp});

  factory BusRouteData.fromJson(Map<String, dynamic> json) {
    return BusRouteData(
      co: json['co'],
      route: json['route'],
      origTc: json['orig_tc'],
      origEn: json['orig_en'],
      destTc: json['dest_tc'],
      destEn: json['dest_en'],
      origSc: json['orig_sc'],
      destSc: json['dest_sc'],
      dataTimeStamp: json['data_timestamp'],
    );
  }

  get id => _id;

  Map toJson() {
    return {
      'co': co,
      'route': route,
      'orig_tc': origTc,
      'orig_en': origEn,
      'dest_tc': destTc,
      'dest_en': destEn,
      'orig_sc': origSc,
      'dest_sc': destSc,
      'data_timestamp': dataTimeStamp
    };
  }

  BusRouteData.withId(this._id, this.co, this.route, this.origTc, this.origEn,
      this.destTc, this.destEn, this.origSc, this.destSc, this.dataTimeStamp);

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['co'] = co;
    map['route'] = route;
    map['origTc'] = origTc;
    map['origEn'] = origEn;
    map['destTc'] = destTc;
    map['destEn'] = destEn;
    map['origSc'] = origSc;
    map['destSc'] = destSc;
    map['dataTimeStamp'] = dataTimeStamp;
    return map;
  }

  BusRouteData.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this.co = map['co'];
    this.route = map['route'];
    this.origTc = map['origTc'];
    this.origEn = map['origEn'];
    this.destTc = map['destTc'];
    this.destEn = map['destEn'];
    this.origSc = map['origSc'];
    this.destSc = map['destSc'];
    this.dataTimeStamp = map['dataTimeStamp'];
  }

  String toString() {
    String s =
        '$co;$route;$origTc;$origEn;$destTc;$destEn;$origSc;$destSc;$dataTimeStamp;';
    return s;
  }
}
