class RouteStop {
  final String type;
  final String version;
  final String timeStamp;
  final List<RouteStopData> data;

  RouteStop({this.type, this.version, this.timeStamp, this.data});

  factory RouteStop.fromJson(Map<String, dynamic> json) {
    return RouteStop(
      type: json['type'],
      version: json['version'],
      timeStamp: json['generated_timestamp '],
      data: parseData(json),
    );
  }

  static List<RouteStopData> parseData(json) {
    List<RouteStopData> dataList = List<RouteStopData>();
//    print('parseRouteStop');
    try {
      var list = json['data'] as List;
      dataList = list.map((data) => RouteStopData.fromJson(data)).toList();
//      print('dataList - ${dataList.length}');
    } catch (e) {
      print('parseRouteStop: $e');
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

class RouteStopData {
  int _id;
  String co;
  String route;
  String dir; //inbound towards origin, outbound towards destination
  int seq;
  String stop;
  String dataTimeStamp;

  RouteStopData(
      {this.co, this.route, this.dir, this.seq, this.stop, this.dataTimeStamp});

  factory RouteStopData.fromJson(Map<String, dynamic> json) {
    return RouteStopData(
      co: json['co'],
      route: json['route'],
      dir: json['dir'],
      seq: json['seq'] as int,
      stop: json['stop'],
      dataTimeStamp: json['data_timestamp'],
    );
  }

  Map toJson() {
    return {
      'co': co,
      'route': route,
      'dir': dir,
      'seq': seq,
      'stop': stop,
      'data_timestamp': dataTimeStamp
    };
  }

  get id => _id;

  RouteStopData.withId(this._id, this.co, this.route, this.dir, this.seq,
      this.stop, this.dataTimeStamp);

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['co'] = co;
    map['route'] = route;
    map['dir'] = dir;
    map['seq'] = seq;
    map['stop'] = stop;
    map['dataTimeStamp'] = dataTimeStamp;
    return map;
  }

  RouteStopData.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this.co = map['co'];
    this.route = map['route'];
    this.dir = map['dir'];
    this.seq = map['seq'];
    this.stop = map['stop'];
    this.dataTimeStamp = map['dataTimeStamp'];
  }
}
