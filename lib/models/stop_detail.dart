class BusStopDetails {
  final String type;
  final String version;
  final String timeStamp;
  final BusStopDetailsData data;

  BusStopDetails({this.type, this.version, this.timeStamp, this.data});

  factory BusStopDetails.fromJson(Map<String, dynamic> json) {
    return BusStopDetails(
      type: json['type'],
      version: json['version'],
      timeStamp: json['generated_timestamp '],
      data: parseData(json),
    );
  }

  static BusStopDetailsData parseData(json) {
    //List<BusStopData> dataList = List<BusStopData>();
    var result;
//    print('parseStopData - $json');
    try {
//      print('json[data]: ${json['data']}');
      result = BusStopDetailsData.fromJson(json['data']);
//      dataList = list.map((data) => BusStopData.fromJson(data)).toList();
//      print('BusStopDataList - ${dataList.length}');
    } catch (e) {
      print('parseBusStopData: $e');
    }
    return result;
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

class BusStopDetailsData {
  int _id;
  String stop;
  String nameTc;
  String nameEn;
  String latitude;
  String longitude;
  String nameSc;
  String dataTimeStamp;

  BusStopDetailsData(
      {this.stop,
      this.nameTc,
      this.nameEn,
      this.latitude,
      this.longitude,
      this.nameSc,
      this.dataTimeStamp});

  factory BusStopDetailsData.fromJson(Map<String, dynamic> json) {
    return BusStopDetailsData(
      stop: json['stop'],
      nameTc: json['name_tc'],
      nameEn: json['name_en'],
      latitude: json['lat'],
      longitude: json['long'],
      nameSc: json['name_sc'],
      dataTimeStamp: json['data_timestamp'],
    );
  }

  get id => _id;

  Map toJson() {
    return {
      'stop': stop,
      'name_tc': nameTc,
      'name_en': nameEn,
      'lat': latitude,
      'long': longitude,
      'name_sc': nameSc,
      'data_timestamp': dataTimeStamp
    };
  }

  BusStopDetailsData.withId(this._id, this.stop, this.nameTc, this.nameEn,
      this.latitude, this.longitude, this.nameSc, this.dataTimeStamp);

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['stop'] = stop;
    map['nameTc'] = nameTc;
    map['nameEn'] = nameEn;
    map['latitude'] = latitude;
    map['longitude'] = longitude;
    map['nameSc'] = nameSc;
    map['dataTimeStamp'] = dataTimeStamp;
    return map;
  }

  BusStopDetailsData.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this.stop = map['stop'];
    this.nameTc = map['nameTc'];
    this.nameEn = map['nameEn'];
    this.latitude = map['latitude'];
    this.longitude = map['longitude'];
    this.nameSc = map['nameSc'];
    this.dataTimeStamp = map['dataTimeStamp'];
  }
}
