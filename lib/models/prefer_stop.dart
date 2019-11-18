class PreferStop {
  int _id;
  String _stop;
  String _nameTc;
  String _nameEn;
  String _latitude;
  String _longitude;
  String _nameSc;
  int _preferOrder;

  PreferStop(this._stop, this._nameTc, this._nameEn, this._latitude,
      this._longitude, this._nameSc, this._preferOrder);

  PreferStop.withId(this._id, this._stop, this._nameTc, this._nameEn,
      this._latitude, this._longitude, this._nameSc, this._preferOrder);

  int get id => _id;
  String get stop => _stop;
  String get nameTc => _nameTc;
  String get nameEn => _nameEn;
  String get latitude => _latitude;
  String get longitude => _longitude;
  String get nameSc => _nameSc;
  int get preferOrder => _preferOrder;

  set stop(String newStop) {
    this._stop = newStop;
  }

  set nameTc(String newNameTc) {
    this._nameTc = newNameTc;
  }

  set nameEn(String newNameEn) {
    this._nameEn = newNameEn;
  }

  set latitude(String newLatitude) {
    this._latitude = newLatitude;
  }

  set longitude(String newLongitude) {
    this._longitude = newLongitude;
  }

  set nameSc(String newNameSc) {
    this._nameSc = newNameSc;
  }

  set preferOrder(int newPreferOrder) {
    this._preferOrder = newPreferOrder;
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['stop'] = _stop;
    map['nameTc'] = _nameTc;
    map['nameEn'] = _nameEn;
    map['latitude'] = _latitude;
    map['longitude'] = _longitude;
    map['nameSc'] = _nameSc;
    map['preferOrder'] = _preferOrder;
    return map;
  }

  PreferStop.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._stop = map['stop'];
    this._nameTc = map['nameTc'];
    this._nameEn = map['nameEn'];
    this._latitude = map['latitude'];
    this._longitude = map['longitude'];
    this._nameSc = map['nameSc'];
    this._preferOrder = map['preferOrder'];
  }
}
