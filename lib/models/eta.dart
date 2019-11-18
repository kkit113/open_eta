class ETA {
  final String type;
  final String version;
  final String timeStamp;
  final List<EtaData> data;

  ETA({this.type, this.version, this.timeStamp, this.data});

  factory ETA.fromJson(Map<String, dynamic> json) {
//    var etaJson = json[ETA] as List;
//    List<EtaData> etaList = etaJson.map((i) => EtaData.fromJson(i)).toList();
//    etaList.sort((a, b) {
//      return a.seq.compareTo(b.seq);
//    });

    return ETA(
      type: json['type'],
      version: json['version'],
      timeStamp: json['generated_timestamp '],
      data: parseData(json),
    );
  }

  static List<EtaData> parseData(etaJson) {
    List<EtaData> dataList = List<EtaData>();
//    print('parseEtaData');
    try {
      var list = etaJson['data'] as List;
      dataList = list.map((data) => EtaData.fromJson(data)).toList();
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

class EtaData {
  final String co;
  final String route;
  final String dir;
  final int seq;
  final String stop;
  final String destTc;
  final String destEn;
  final String eta;
  final String rmkTc;
  final int etaSeq;
  final String destSc;
  final String rmkEn;
  final String rmkSc;
  final String dataTimeStamp;

  EtaData(
      {this.co,
      this.route,
      this.dir,
      this.seq,
      this.stop,
      this.destTc,
      this.destEn,
      this.eta,
      this.rmkTc,
      this.etaSeq,
      this.destSc,
      this.rmkEn,
      this.rmkSc,
      this.dataTimeStamp});

  factory EtaData.fromJson(Map<String, dynamic> json) {
    return EtaData(
      co: json['co'],
      route: json['route'],
      dir: json['dir'],
      seq: json['seq'] as int,
      stop: json['stop'],
      destTc: json['dest_tc'],
      destEn: json['dest_en'],
      eta: json['eta'],
      rmkTc: json['rmk_tc'],
      etaSeq: json['eta_seq'] as int,
      destSc: json['dest_sc'],
      rmkEn: json['rmk_en'],
      rmkSc: json['rmk_sc'],
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
      'dest_tc': destTc,
      'dest_en': destEn,
      'eta': eta,
      'rmk_tc': rmkTc,
      'eta_seq': etaSeq,
      'dest_sc': destSc,
      'rmk_en': rmkEn,
      'rmk_sc': rmkSc,
      'data_timestamp': dataTimeStamp
    };
  }
}
