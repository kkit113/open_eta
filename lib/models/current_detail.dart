class CurrentDetail {
  int _id;
  String co;
  String route;
  String stop;
  String dir;
  int seq;
  String origTc;
  String destTc;
  String nameTc;
  String origSc;
  String destSc;
  String nameSc;
  String origEn;
  String destEn;
  String nameEn;
  String latitude;
  String longitude;

  CurrentDetail(
      this.co,
      this.route,
      this.stop,
      this.dir,
      this.seq,
      this.origTc,
      this.destTc,
      this.nameTc,
      this.origSc,
      this.destSc,
      this.nameSc,
      this.origEn,
      this.destEn,
      this.nameEn,
      this.longitude,
      this.latitude);

  CurrentDetail.withId(
    this._id,
    this.co,
    this.route,
    this.stop,
    this.dir,
    this.seq,
    this.origTc,
    this.destTc,
    this.nameTc,
    this.origSc,
    this.destSc,
    this.nameSc,
    this.origEn,
    this.destEn,
    this.nameEn,
    this.longitude,
    this.latitude,
  );

  get id => _id;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['co'] = co;
    map['route'] = route;
    map['stop'] = stop;
    map['dir'] = dir;
    map['seq'] = seq;
    map['origTc'] = origTc;
    map['destTc'] = destTc;
    map['nameTc'] = nameTc;
    map['origSc'] = origSc;
    map['destSc'] = destSc;
    map['nameSc'] = nameSc;
    map['origEn'] = origEn;
    map['destEn'] = destEn;
    map['nameEn'] = nameEn;
    map['latitude'] = latitude;
    map['longitude'] = longitude;
    return map;
  }

  CurrentDetail.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this.co = map['co'];
    this.route = map['route'];
    this.stop = map['stop'];
    this.dir = map['dir'];
    this.seq = map['seq'] as int;
    this.origTc = map['origTc'];
    this.destTc = map['destTc'];
    this.nameTc = map['nameTc'];
    this.origSc = map['origSc'];
    this.destSc = map['destSc'];
    this.nameSc = map['nameSc'];
    this.origEn = map['origEn'];
    this.destEn = map['destEn'];
    this.nameEn = map['nameEn'];
    this.latitude = map['latitude'];
    this.longitude = map['longitude'];
  }
}
