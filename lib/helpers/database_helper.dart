import 'dart:io';

import 'package:open_eta/models/current_detail.dart';
import 'package:open_eta/models/prefer_eta.dart';
import 'package:open_eta/models/prefer_stop.dart';
import 'package:open_eta/models/route.dart';
import 'package:open_eta/models/route_stop.dart';
import 'package:open_eta/models/stop_detail.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'bus.db';

    Database busDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return busDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE PreferEta(Id INTEGER PRIMARY KEY AUTOINCREMENT, co TEXT'
        ', route TEXT, dir TEXT, stop TEXT, nameTc TEXT, origTc TEXT, destTc TEXT'
        ', nameSc TEXT, origSc TEXT, destSc TEXT'
        ', nameEn TEXT, origEn TEXT, destEn TEXT'
        ', preferOrder INTEGER)');
    await db.execute(
        'CREATE TABLE PreferStop(Id INTEGER PRIMARY KEY AUTOINCREMENT, stop TEXT'
        ', nameTc TEXT, nameEn TEXT, latitude TEXT, longitude TEXT, nameSc TEXT, preferOrder INTEGER)');
    await db.execute(
        'CREATE TABLE BusRoute(Id INTEGER PRIMARY KEY AUTOINCREMENT, co TEXT'
        ', route TEXT, origTc TEXT, origEn TEXT, destTc TEXT, destEn TEXT, origSc TEXT, destSc TEXT, dataTimeStamp TEXT)');
    await db.execute(
        'CREATE TABLE RouteStop(Id INTEGER PRIMARY KEY AUTOINCREMENT, co TEXT'
        ', route TEXT, dir TEXT, seq Text, stop TEXT, dataTimeStamp TEXT)');
    await db.execute(
        'CREATE TABLE BusStop(Id INTEGER PRIMARY KEY AUTOINCREMENT, stop TEXT'
        ', nameTc TEXT, nameEn TEXT, latitude TEXT, longitude TEXT, nameSc TEXT, dataTimeStamp TEXT)');
  }

//BusRoute

  Future<List<Map<String, dynamic>>> getBusRouteMapList() async {
    Database db = await this.database;
    var result = await db.query('BusRoute', orderBy: 'route ASC');
    return result;
  }

  Future<List<BusRouteData>> getBusRouteList() async {
    var busRouteMapList = await getBusRouteMapList();
    int count = busRouteMapList.length;
    List<BusRouteData> busRouteList = List<BusRouteData>();
    for (int i = 0; i < count; i++) {
      busRouteList.add(BusRouteData.fromMapObject(busRouteMapList[i]));
    }
    return busRouteList;
  }

  Future<List<String>> getBusRoutePrefixList() async {
    var busRouteMapList = await getBusRouteMapList();
    int count = busRouteMapList.length;
    List<String> busRouteList = List<String>();
    for (int i = 0; i < count; i++) {
      String p =
          BusRouteData.fromMapObject(busRouteMapList[i]).route.substring(0, 1);
      try {
        int.parse(p);
      } catch (e) {
        busRouteList.add(p);
      }
    }
    var l = busRouteList.toSet().toList();
    return l;
  }

  Future<List<Map<String, dynamic>>> dynamicBusRouteMapList(
      String input) async {
    Database db = await this.database;
    var result = await db.rawQuery(
        'SELECT * from BusRoute WHERE route LIKE \'\%$input\%\' ORDER BY route');
    return result;
  }

  Future<List<BusRouteData>> dynamicBusRouteList(String input) async {
    var busRouteMapList = await dynamicBusRouteMapList(input);
    int count = busRouteMapList.length;
    List<BusRouteData> busRouteList = List<BusRouteData>();
//    List<String> emptyR = await emptyRoute();
    for (int i = 0; i < count; i++) {
//      if (!emptyR
//          .contains(BusRouteData.fromMapObject(busRouteMapList[i]).route))
      busRouteList.add(BusRouteData.fromMapObject(busRouteMapList[i]));
    }
    return busRouteList;
  }

  Future<List<String>> circularRoute() async {
    Database db = await this.database;
    var result = await db.rawQuery(
        'SELECT BusRoute.co, a.route, BusRoute.origTc, BusRoute.origEn'
        ', BusRoute.destTc, BusRoute.destEn, BusRoute.origSc, BusRoute.destSc'
        ', BusRoute.dataTimeStamp'
        ' from(SELECT route, count(case when dir = \'I\' then dir END) I'
        ', count(case when dir = \'O\' then dir END) O'
        ' FROM RouteStop GROUP BY route) a'
        ' join BusRoute on BusRoute.route = a.route'
        ' where a.I = 0 or a.O = 0');
    int count = result.length;
    List<String> circularRouteList = List<String>();
    for (int i = 0; i < count; i++) {
      circularRouteList.add(BusRouteData.fromMapObject(result[i]).route);
    }
    return circularRouteList;
  }

  Future<List<String>> emptyRoute() async {
    Database db = await this.database;
    var result = await db.rawQuery('SELECT * from BusRoute'
        ' where BusRoute.route not in ('
        ' SELECT DISTINCT route from RouteStop)');
    int count = result.length;
    List<String> routeList = List<String>();
    for (int i = 0; i < count; i++) {
      routeList.add(BusRouteData.fromMapObject(result[i]).route);
    }
    print('emptyRoute: ${routeList.length}');
    return routeList;
  }

  Future<int> insertBusRoute(BusRouteData busRouteData) async {
    Database db = await this.database;
    var result = await db.insert('BusRoute', busRouteData.toMap());
    return result;
  }

  void insertBusRouteAssets(
      String co,
      String route,
      String origTc,
      String origEn,
      String destTc,
      String destEn,
      String origSc,
      String destSc,
      String dataTimeStamp) {
    BusRouteData busRouteData = BusRouteData(
        co: co,
        route: route,
        origTc: origTc,
        origEn: origEn,
        destTc: destTc,
        destEn: destEn,
        origSc: origSc,
        destSc: destSc,
        dataTimeStamp: dataTimeStamp);
    insertBusRoute(busRouteData);
  }

  Future<int> updateBusRoute(BusRouteData busRouteData) async {
    Database db = await this.database;
    var result = await db.update('BusRoute', busRouteData.toMap(),
        where: 'Id = ?', whereArgs: [busRouteData.id]);
    return result;
  }

  Future<int> deleteBusRoute(int id) async {
    Database db = await this.database;
    int result = await db.rawDelete('DELETE FROM BusRoute WHERE Id = $id');
    return result;
  }

  Future<int> deleteRoutes(String co) async {
    Database db = await this.database;
    int result = await db.rawDelete('DELETE FROM BusRoute WHERE co = \'$co\'');
    return result;
  }

  Future<int> deleteCtbRoute() async {
    Database db = await this.database;
    int result = await db.rawDelete('DELETE FROM BusRoute WHERE co = \'CTB\'');
    return result;
  }

  Future<int> deleteNwfbRoute() async {
    Database db = await this.database;
    int result = await db.rawDelete('DELETE FROM BusRoute WHERE co = \'NWFB\'');
    return result;
  }

  Future<int> getBusRouteCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from BusRoute');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<int> getCtbRouteDataCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from BusRoute WHERE co = \'CTB\'');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<int> getNwfbRouteDataCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from BusRoute WHERE co = \'NWFB\'');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  //BusRoute

  Future<List<Map<String, dynamic>>> getRouteStopMapList() async {
    Database db = await this.database;
    var result = await db.query('RouteStop', orderBy: 'stop ASC');
    return result;
  }

  Future<List<RouteStopData>> getRouteStopList() async {
    var routeStopMapList = await getBusRouteMapList();
    int count = routeStopMapList.length;
    List<RouteStopData> routeStopList = List<RouteStopData>();
    for (int i = 0; i < count; i++) {
      routeStopList.add(RouteStopData.fromMapObject(routeStopMapList[i]));
    }
    return routeStopList;
  }

  Future<int> getDistinctBusStopDataCount() async {
    List<Map<String, dynamic>> x = await getDistinctStopMapList();
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<Map<String, dynamic>>> getDistinctStopMapList() async {
    Database db = await this.database;
    var result = db.rawQuery('SELECT DISTINCT stop from RouteStop');
    return result;
  }

  Future<List<String>> getStopList() async {
    var busRouteMapList = await getDistinctStopMapList();
    int count = busRouteMapList.length;
    List<String> stopList = List<String>();
    for (int i = 0; i < count; i++) {
      stopList.add(busRouteMapList[i].toString());
    }
    return stopList;
  }

  Future<int> insertRouteStop(RouteStopData routeStopData) async {
    Database db = await this.database;
    var result = await db.insert('RouteStop', routeStopData.toMap());
    return result;
  }

  Future<int> insertRouteStopAssets(String co, String route, String dir,
      String seq, String stop, String dataTimeStamp) async {
    RouteStopData routeStopData = RouteStopData(
        co: co,
        route: route,
        dir: dir,
        seq: int.parse(seq),
        stop: stop,
        dataTimeStamp: dataTimeStamp);
    var result = insertRouteStop(routeStopData);
    return result;
  }

  Future<int> updateRouteStop(RouteStopData routeStopData) async {
    Database db = await this.database;
    var result = await db.update('RouteStop', routeStopData.toMap(),
        where: 'Id = ?', whereArgs: [routeStopData.id]);
    return result;
  }

  Future<int> deleteRouteStop(int id) async {
    Database db = await this.database;
    int result = await db.rawDelete('DELETE FROM RouteStop WHERE Id = $id');
    return result;
  }

  Future<int> deleteRouteStops(String co, String route, String bound) async {
    Database db = await this.database;
    int result = await db.rawDelete(
        'DELETE FROM RouteStop WHERE co = \'$co\' AND route = \'$route\' AND dir = \'$bound\'');

    print('deleteRouteStops: $co, $route, $bound: $result');
    return result;
  }

  Future<int> getRouteStopDataCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from RouteStop');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<int> insertBusStopData(BusStopDetailsData stopData) async {
    Database db = await this.database;
    var result = await db.insert('BusStop', stopData.toMap());
    return result;
  }

  Future<int> insertBusStopDataAssets(String stop, String nameTc, String nameEn,
      String latitude, String longitude, String nameSc, String dataTimeStamp) {
    BusStopDetailsData busStopDetailsData = BusStopDetailsData(
        stop: stop,
        nameTc: nameTc,
        nameEn: nameEn,
        latitude: latitude,
        longitude: longitude,
        nameSc: nameSc,
        dataTimeStamp: dataTimeStamp);
    var result = insertBusStopData(busStopDetailsData);
    return result;
  }

  Future<int> updateBusStopData(BusStopDetailsData stopData) async {
    var db = await this.database;
    var result = await db.update('BusStop', stopData.toMap(),
        where: 'id = ?', whereArgs: [stopData.id]);
    return result;
  }

  Future<int> deleteBusStopData(String stop) async {
    Database db = await this.database;
    int result =
        await db.rawDelete('DELETE FROM BusStop WHERE stop = \'$stop\'');

    print('deleteStops: $stop: $result');
    return result;
  }

  Future<int> getBusStopDataCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from BusStop');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<Map<String, dynamic>>> getBusStopDataMapList() async {
    Database db = await this.database;
    var result = await db.query('BusStop', orderBy: 'stop ASC');
    return result;
  }

  Future<List<BusStopDetailsData>> getStopDataList() async {
    var busStopDataMapList =
        await getBusStopDataMapList(); // Get 'Map List' from database
    int count = busStopDataMapList
        .length; // Count the number of map entries in db table

    List<BusStopDetailsData> busStopDataList = List<BusStopDetailsData>();
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      busStopDataList
          .add(BusStopDetailsData.fromMapObject(busStopDataMapList[i]));
    }
    return busStopDataList;
  }

  Future<List<Map<String, dynamic>>> getSingleStopDataMapList(
      String stop) async {
    Database db = await this.database;
    var result = await db.rawQuery(
        'SELECT RouteStop.co, RouteStop.route, RouteStop.stop, RouteStop.dir'
        ', BusRoute.origTc, BusRoute.destTc, BusStop.nameTc'
        ', BusRoute.origSc, BusRoute.destSc, BusStop.nameSc'
        ', BusRoute.origEn, BusRoute.destEn, BusStop.nameEn'
        ', BusStop.longitude, BusStop.latitude'
        ' from RouteStop'
        ' join BusRoute on BusRoute.route = RouteStop.route'
        ' join BusStop on BusStop.stop = RouteStop.stop'
        ' where RouteStop.stop = \'$stop\''
        ' order by RouteStop.route');

    return result;
  }

  Future<List<BusStopDetailsData>> getSingleStopDataList(String strStop) async {
    var singleStopDataMapList =
        await getSingleStopDataMapList(strStop); // Get 'Map List' from database
    int count = singleStopDataMapList
        .length; // Count the number of map entries in db table

    List<BusStopDetailsData> singleStopDataList = List<BusStopDetailsData>();
    for (int i = 0; i < count; i++) {
      singleStopDataList
          .add(BusStopDetailsData.fromMapObject(singleStopDataMapList[i]));
    }
    return singleStopDataList;
  }

//  Future<List<Map<String, dynamic>>> getSingleBoundRouteMapList() async {
//    Database db = await this.database;
////		var result = await db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');
//    var result = await db.rawQuery('SELECT RouteStop.route, RouteStop.dir'
//        ' from RouteStop'
//        ' order by RouteStop.route');
//    return result;
//  }
//
//  Future<List<CurrentDetail>> getSingleBoundRoute() async {
//    var routesMapList = await getSingleBoundRouteMapList();
//    int count = routesMapList.length;
//
//    routesMapList[1].
//    List<String> currentBusStopDataList = List<String>();
//    for (int i = 0; i < count; i++) {
//      currentBusStopDataList
//          .add(CurrentDetail.fromMapObject(currentBusStopMapList[i]));
//    }
//    return currentBusStopDataList;
//  }

  Future<List<Map<String, dynamic>>> getCurrentBusStopMapList(
      String strStop) async {
    Database db = await this.database;
//		var result = await db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');
    var result = await db.rawQuery(
        'SELECT RouteStop.co, RouteStop.route, RouteStop.stop, RouteStop.dir'
        ', CAST(RouteStop.seq as INT) seq'
        ', BusRoute.origTc, BusRoute.destTc, BusStop.nameTc'
        ', BusRoute.origSc, BusRoute.destSc, BusStop.nameSc'
        ', BusRoute.origEn, BusRoute.destEn, BusStop.nameEn'
        ', BusStop.longitude, BusStop.latitude'
        ' from RouteStop'
        ' join BusRoute on BusRoute.route = RouteStop.route'
        ' join BusStop on BusStop.stop = RouteStop.stop'
        ' where RouteStop.stop = \'$strStop\''
        ' order by RouteStop.route');
    return result;
  }

  Future<List<CurrentDetail>> getCurrentStopBus(String strStop) async {
    var currentBusStopMapList = await getCurrentBusStopMapList(strStop);
    int count = currentBusStopMapList.length;

    List<CurrentDetail> currentBusStopDataList = List<CurrentDetail>();
    for (int i = 0; i < count; i++) {
      currentBusStopDataList
          .add(CurrentDetail.fromMapObject(currentBusStopMapList[i]));
    }
    return currentBusStopDataList;
  }

  Future<List<Map<String, dynamic>>> getCurrentRouteMapList(
      String route, String direction) async {
    Database db = await this.database;
    var result = await db.rawQuery(
        'SELECT RouteStop.co, RouteStop.route, RouteStop.stop, RouteStop.dir'
        ', CAST(RouteStop.seq as INT) seq'
        ', BusRoute.origTc, BusRoute.destTc, BusStop.nameTc'
        ', BusRoute.origSc, BusRoute.destSc, BusStop.nameSc'
        ', BusRoute.origEn, BusRoute.destEn, BusStop.nameEn'
        ', BusStop.longitude, BusStop.latitude'
        ' from RouteStop'
        ' join BusRoute on BusRoute.route = RouteStop.route'
        ' join BusStop on BusStop.stop = RouteStop.stop'
        ' where RouteStop.route = \'$route\''
        ' and RouteStop.dir = \'$direction\''
        ' order by CAST(RouteStop.seq as INT)');
    return result;
  }

  Future<List<CurrentDetail>> getCurrentRouteStop(
      String route, String direction) async {
    var currentRouteStopMapList =
        await getCurrentRouteMapList(route, direction);
    int count = currentRouteStopMapList.length;
    List<CurrentDetail> currentRouteStopDataList = List<CurrentDetail>();
    try {
      for (int i = 0; i < count; i++) {
//        print('getCurrentRouteStop: ${currentRouteStopMapList[i].values}');
        currentRouteStopDataList
            .add(CurrentDetail.fromMapObject(currentRouteStopMapList[i]));
      }
//      print('get routeStop length: ${currentRouteStopDataList.length}');
    } catch (e) {
      print('error: $e');
    }
    return currentRouteStopDataList;
  }

  Future deleteBusStopTable() async {
    Database db = await this.database;
    await db.delete('BusStop');
  }

  Future deleteBusRouteTable() async {
    Database db = await this.database;
    await db.delete('BusRoute');
  }

  Future deleteRouteStopTable() async {
    Database db = await this.database;
    await db.delete('RouteStop');
  }

  Future deleteAllTable() async {
    Database db = await this.database;
    await db.delete('BusRoute');
    await db.delete('RouteStop');
    await db.delete('BusStop');
    await db.delete('PreferRoute');
    await db.delete('PreferStop');
    await db.delete('PreferEta');
  }

  Future deletePreferStopTable() async {
    Database db = await this.database;
    await db.delete('PreferStop');
  }

  Future deletePreferEtaTable() async {
    Database db = await this.database;
    await db.delete('PreferEta');
  }

  Future deletePreferTable() async {
    Database db = await this.database;
//    await db.delete('PreferRoute');
    await db.delete('PreferStop');
    await db.delete('PreferEta');
  }

  //Bus Stop
  Future<int> getTableCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery(
        'SELECT count(*) FROM sqlite_master WHERE type = \'table\' AND name != \'android_metadata\' AND name != \'sqlite_sequence\'');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<int> deleteEmptyRecord(String tableName, String emptyKey) async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('DELETE FROM $tableName WHERE $emptyKey IS NULL');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  //Preferred Stops

  // Fetch Operation: Get all not  objects from database
  Future<List<Map<String, dynamic>>> getPreferStopMapList() async {
    Database db = await this.database;
    var result = await db.query('PreferStop', orderBy: 'preferOrder');
    return result;
  }

  // Insert Operation: Insert an object to database
  Future<int> insertPreferStop(PreferStop preferStop) async {
    Database db = await this.database;
    if (preferStop.preferOrder == null)
      preferStop.preferOrder = await getPreferStopCount() + 1;

    var result = await db.insert('PreferStop', preferStop.toMap());
    updatePreferStopOrder();
    return result;
  }

  Future<int> insertPreferStopAssets(
    String stop,
    String nameTc,
    String nameEn,
    String latitude,
    String longitude,
    String nameSc,
    int preferOrder,
  ) async {
    PreferStop preferStop = PreferStop('$stop', '$nameTc', '$nameEn',
        '$latitude', '$longitude', '$nameSc', preferOrder);

    return insertPreferStop(preferStop);
  }

  // Update Operation: Update a Note object and save it to database
  Future<int> updatePreferStop(PreferStop preferStop) async {
    var db = await this.database;
    var result = await db.update('PreferStop', preferStop.toMap(),
        where: 'id = ?', whereArgs: [preferStop.id]);
    print('updatePreferStop: ${preferStop.id} - ${preferStop.preferOrder}');
    return result;
  }

  Future<int> deletePreferStop(PreferStop preferStop) async {
    var db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('Delete from PreferStop where id = ${preferStop.id}');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<int> getPreferStop(String stop) async {
    var db = await this.database;
    List<Map<String, dynamic>> x = await db
        .rawQuery('Select count(stop) from PreferStop where stop = \'$stop\'');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<int> delPreferStop(String stop) async {
    var db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('delete from PreferStop where stop = \'$stop\'');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  // Get number of Note objects in database
  Future<int> getPreferStopCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db
        .rawQuery('SELECT COUNT (*) from PreferStop order by preferOrder');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'Note List' [ List<Note> ]
  Future<List<PreferStop>> getPreferStopList() async {
    var preferStopMapList =
        await getPreferStopMapList(); // Get 'Map List' from database
    int count =
        preferStopMapList.length; // Count the number of map entries in db table
    List<PreferStop> preferStopList = List<PreferStop>();
    for (int i = 0; i < count; i++) {
      preferStopList.add(PreferStop.fromMapObject(preferStopMapList[i]));
    }
//    print('dbHelper, getPreferStopList - ${preferStopList.length}');
    return preferStopList;
  }

  //Preferred Eta

  // Fetch Operation: Get all not  objects from database
  // Insert Operation: Insert an object to database
  Future<int> insertPreferEta(PreferEta preferEta) async {
    Database db = await this.database;
    var result = await db.insert('PreferEta', preferEta.toMap());
    updatePreferEtaOrder();
    return result;
  }

  Future<int> insertPreferEtaAssets(
      String co,
      String route,
      String dir,
      String stop,
      String nameTc,
      String origTc,
      String destTc,
      String nameSc,
      String origSc,
      String destSc,
      String nameEn,
      String origEn,
      String destEn,
      int preferOrder) async {
    PreferEta preferEta = PreferEta(co, route, dir, stop, nameTc, origTc,
        destTc, nameSc, origSc, destSc, nameEn, origEn, destEn, preferOrder);
    return insertPreferEta(preferEta);
  }

  // Update Operation: Update a Note object and save it to database
  // Update Operation: Update a Note object and save it to database
  Future<int> updatePreferEta(PreferEta preferEta) async {
    var db = await this.database;
    var result = await db.update('PreferEta', preferEta.toMap(),
        where: 'Id = ?', whereArgs: [preferEta.id]);
    return result;
  }

  Future<int> getPreferEta(
      String co, String route, String dir, String stop) async {
    var db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery(
        'Select count(route) from PreferEta where co = \'$co\' AND route = \'$route\' AND dir = \'$dir\' AND stop = \'$stop\'');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<int> delPreferEta(
      String co, String route, String dir, String stop) async {
    var db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery(
        'delete from PreferEta where co = \'$co\' AND route = \'$route\' AND dir = \'$dir\' AND stop = \'$stop\'');
    int result = Sqflite.firstIntValue(x);
    print('delete Eta: $result');
    return result;
  }

  Future<int> deletePreferEta(PreferEta preferEta) async {
    var db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('Delete from PreferEta where Id = ${preferEta.id}');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  // Get number of Note objects in database
  Future<int> getPreferEtaCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db
        .rawQuery('SELECT COUNT (*) from PreferEta order by preferOrder');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<Map<String, dynamic>>> getPreferEtaMapList() async {
    Database db = await this.database;
    var result = await db.query('PreferEta', orderBy: 'preferOrder, route');
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'Note List' [ List<Note> ]
  Future<List<PreferEta>> getPreferEtaList() async {
    var preferEtaMapList =
        await getPreferEtaMapList(); // Get 'Map List' from database
    int count =
        preferEtaMapList.length; // Count the number of map entries in db table
    List<PreferEta> preferEtaList = List<PreferEta>();
    for (int i = 0; i < count; i++) {
      preferEtaList.add(PreferEta.fromMapObject(preferEtaMapList[i]));
    }
//    print('dbHelper, getPreferEtaList - ${preferEtaList.length}');
    return preferEtaList;
  }

  Future<int> updatePreferEtaOrder() async {
    var db = await this.database;
    List<PreferEta> list = await getPreferEtaList();
    int count = list.length;
    var result;
    for (int i = 0; i < count; i++) {
//      print(
//          'before reorder: ${list[i].Id}, ${list[i].route}, ${list[i].nameTc}, ${list[i].preferOrder}');
      list[i].preferOrder = i;
      result = await db.update('PreferEta', list[i].toMap(),
          where: 'Id = ?', whereArgs: [list[i].id]);
//      print(
//          'after reorder: ${list[i].Id} ${list[i].route}, ${list[i].nameTc}, ${list[i].preferOrder}');
    }
    return result;
  }

  Future<int> updatePreferStopOrder() async {
    var db = await this.database;
    List<PreferStop> list = await getPreferStopList();
    int count = list.length;
    var result;
    for (int i = 0; i < count; i++) {
//      print(
//          'before reorder: ${list[i].Id}, ${list[i].route}, ${list[i].nameTc}, ${list[i].preferOrder}');
      list[i].preferOrder = i;
      result = await db.update('PreferStop', list[i].toMap(),
          where: 'Id = ?', whereArgs: [list[i].id]);
//      print(
//          'after reorder: ${list[i].Id} ${list[i].route}, ${list[i].nameTc}, ${list[i].preferOrder}');
    }
    return result;
  }

  Future<List<Map<String, dynamic>>> getPreferEtaStopMapList(
      String stop) async {
    Database db = await this.database;
    var result = await db.query('PreferEta',
        where: 'Stop = ?', whereArgs: [stop], orderBy: 'preferOrder, route');
    return result;
  }

  Future<List<PreferEta>> getPreferStopEtaList(String stop) async {
    var preferEtaStopMapList =
        await getPreferEtaStopMapList(stop); // Get 'Map List' from database
    int count = preferEtaStopMapList
        .length; // Count the number of map entries in db table
    List<PreferEta> preferStopEtaList = List<PreferEta>();
    for (int i = 0; i < count; i++) {
      preferStopEtaList.add(PreferEta.fromMapObject(preferEtaStopMapList[i]));
    }
    return preferStopEtaList;
  }
}
