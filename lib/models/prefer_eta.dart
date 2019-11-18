import 'package:flutter/foundation.dart';

class PreferEta with ChangeNotifier {
  int _id;
  String _co;
  String _route;
  String _dir;
  String _stop;
  String _nameTc;
  String _origTc;
  String _destTc;
  String _nameSc;
  String _origSc;
  String _destSc;
  String _nameEn;
  String _origEn;
  String _destEn;

  int _preferOrder;

  PreferEta(
      this._co,
      this._route,
      this._dir,
      this._stop,
      this._nameTc,
      this._origTc,
      this._destTc,
      this._nameSc,
      this._origSc,
      this._destSc,
      this._nameEn,
      this._origEn,
      this._destEn,
      this._preferOrder);

  PreferEta.withId(
      this._id,
      this._co,
      this._route,
      this._dir,
      this._stop,
      this._nameTc,
      this._origTc,
      this._destTc,
      this._nameSc,
      this._origSc,
      this._destSc,
      this._nameEn,
      this._origEn,
      this._destEn,
      this._preferOrder);

  int get id => _id;
  String get co => _co;
  String get route => _route;
  String get dir => _dir;
  String get stop => _stop;
  String get nameTc => _nameTc;
  String get origTc => _origTc;
  String get destTc => _destTc;
  String get nameSc => _nameSc;
  String get origSc => _origSc;
  String get destSc => _destSc;
  String get nameEn => _nameEn;
  String get origEn => _origEn;
  String get destEn => _destEn;
  int get preferOrder => _preferOrder;

  set co(String newCo) {
    this._co = newCo;
  }

  set route(String newRoute) {
    this._route = newRoute;
  }

  set dir(String newDir) {
    this._dir = newDir;
  }

  set stop(String newStop) {
    this._stop = newStop;
  }

  set nameTc(String newNameTc) {
    this._nameTc = newNameTc;
  }

  set destTc(String newDestTc) {
    this._destTc = newDestTc;
  }

  set origTc(String newOrigTc) {
    this._origTc = newOrigTc;
  }

  set nameSc(String newNameSc) {
    this._nameSc = newNameSc;
  }

  set destSc(String newDestSc) {
    this._destSc = newDestSc;
  }

  set origSc(String newOrigSc) {
    this._origSc = newOrigSc;
  }

  set nameEn(String newNameEn) {
    this._nameEn = newNameEn;
  }

  set destEn(String newDestEn) {
    this._destEn = newDestEn;
  }

  set origEn(String newOrigEn) {
    this._origEn = newOrigEn;
  }

  set preferOrder(int newOrder) {
    this._preferOrder = newOrder;
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (id != null) {
      map['Id'] = _id;
    }
    map['co'] = _co;
    map['route'] = _route;
    map['dir'] = _dir;
    map['stop'] = _stop;
    map['nameTc'] = _nameTc;
    map['origTc'] = _origTc;
    map['destTc'] = _destTc;
    map['nameSc'] = _nameSc;
    map['origSc'] = _origSc;
    map['destSc'] = _destSc;
    map['nameEn'] = _nameEn;
    map['origEn'] = _origEn;
    map['destEn'] = _destEn;
    map['preferOrder'] = _preferOrder;
    return map;
  }

  PreferEta.fromMapObject(Map<String, dynamic> map) {
    this._id = map['Id'];
    this._co = map['co'];
    this._route = map['route'];
    this._dir = map['dir'];
    this._stop = map['stop'];
    this._nameTc = map['nameTc'];
    this._origTc = map['origTc'];
    this._destTc = map['destTc'];
    this._nameSc = map['nameSc'];
    this._origSc = map['origSc'];
    this._destSc = map['destSc'];
    this._nameEn = map['nameEn'];
    this._origEn = map['origEn'];
    this._destEn = map['destEn'];
    this._preferOrder = map['preferOrder'];
  }
}
