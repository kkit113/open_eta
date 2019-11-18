import 'dart:convert';
import 'package:open_eta/helpers/database_helper.dart';
import 'package:open_eta/helpers/http_helper.dart';
import 'package:open_eta/models/eta.dart';
import 'package:open_eta/models/prefer_eta.dart';
import 'package:open_eta/models/prefer_stop.dart';
import 'package:open_eta/models/route.dart';
import 'package:open_eta/models/route_stop.dart';
import 'package:open_eta/models/stop_detail.dart';
import 'package:http/http.dart';

class BusDataHelper {
  DatabaseHelper databaseHelper = DatabaseHelper();
  void insertBusRoute(String co) async {
    BusRoute busRoute = await _getBusRouteJson(co: co);
    int count = busRoute.data.length;
    await databaseHelper.deleteRoutes(co);
    for (int i = 0; i < count; i++) {
      BusRouteData busRouteData = busRoute.data[i];
      await databaseHelper.insertBusRoute(busRouteData);
      insertRouteStop(busRouteData.co, busRouteData.route, 'inbound');
      insertRouteStop(busRouteData.co, busRouteData.route, 'outbound');
    }
  }

  void insertRouteStop(String co, String route, String bound) async {
    RouteStop routeStop =
        await _getRouteStopJson(co: co, route: route, bound: bound);
    await databaseHelper.deleteRouteStops(
        co, route, bound.toUpperCase().substring(0, 1));
    int count = routeStop.data.length;
    for (int i = 0; i < count; i++) {
      RouteStopData routeStopData = routeStop.data[i];
      await databaseHelper.insertRouteStop(routeStopData);
    }
  }

  void insertStop() async {
    List<String> stops = await databaseHelper.getStopList();
    int count = stops.length;

    for (int i = 0; i < count; i++) {
      if (stops[i] != null) {
        BusStopDetails stop = await _getStopJson(stop: stops[i]);
        BusStopDetailsData stopData = stop.data;
        await databaseHelper.deleteBusStopData('${stop.data.stop}');
        await databaseHelper.insertBusStopData(stopData);
      }
    }
  }

  Future<int> routeCount() async => await databaseHelper.getBusRouteCount();

  void deleteRouteStop(RouteStopData routeStopData) async {
    await databaseHelper.deleteRouteStop(routeStopData.id);
  }

  Future<BusRoute> _getBusRouteJson({String co}) async {
    Response re = await HttpHelper().fetchRouteListData(co);
    if (re.statusCode == 200) {
      final jsonResponse = json.decode(re.body);
      return BusRoute.fromJson(jsonResponse);
    } else {
      throw Exception('Fail to load from Internet![${re.statusCode}]');
    }
  }

  Future<BusStopDetails> _getStopJson({String stop}) async {
    Response re = await HttpHelper().fetchStopData(stop);
    if (re.statusCode == 200) {
      final jsonResponse = json.decode(re.body);
      return BusStopDetails.fromJson(jsonResponse);
    } else {
      throw Exception('Fail to load from Internet![${re.statusCode}]');
    }
  }

  Future<RouteStop> _getRouteStopJson(
      {String co, String route, String bound}) async {
    Response re = await HttpHelper().fetchRouteStopData(co, route, bound);
    if (re.statusCode == 200) {
      final jsonResponse = json.decode(re.body);
      return RouteStop.fromJson(jsonResponse);
    } else {
      throw Exception('Fail to load from Internet![${re.statusCode}]');
    }
  }

  Future<ETA> getETA({String co, String stop, String route}) async {
    Response re = await HttpHelper().fetchEtaData(co, stop, route);
    if (re.statusCode == 200) {
      final jsonResponse = json.decode(re.body);
      return ETA.fromJson(jsonResponse);
    } else {
      throw Exception('Fail to load from Internet![${re.statusCode}]');
    }
  }

  void deleteAllTables() {
    databaseHelper.deleteBusRouteTable();
    databaseHelper.deleteBusStopTable();
    databaseHelper.deleteRouteStopTable();
    databaseHelper.deletePreferTable();
  }

  void deletePreferTable() {
    databaseHelper.deletePreferTable();
  }

  void deleteStops() {
    databaseHelper.deleteBusStopTable();
  }

  void deleteCtbRoutes() {
    databaseHelper.deleteCtbRoute();
  }

  void deleteNwfbRoutes() {
    databaseHelper.deleteNwfbRoute();
  }

  Future<int> busStopCount() async {
    int result = await databaseHelper.getBusStopDataCount();
    return result;
  }

  Future<int> distinctBusStopCount() async {
    int result = await databaseHelper.getDistinctBusStopDataCount();
    return result;
  }

  Future<int> nwfbRouteCount() async {
    int result = await databaseHelper.getNwfbRouteDataCount();
    return result;
  }

  Future<int> ctbRouteCount() async {
    int result = await databaseHelper.getCtbRouteDataCount();
    return result;
  }

  Future<int> routeStopCount() async {
    int result = await databaseHelper.getRouteStopDataCount();
    return result;
  }

  Future<int> preferStopCount() async =>
      await databaseHelper.getPreferStopCount();

  void deletePreferStop(PreferStop preferStop) async {
    await databaseHelper.deletePreferStop(preferStop);
  }

  void delPreferStop(String stop) async {
    await databaseHelper.delPreferStop(stop);
  }

  Future<bool> checkPreferStop(String stop) async {
    int i = await databaseHelper.getPreferStop(stop);
    if (i > 0) return true;
    return false;
  }

  void insertPreferStop(String stop, String nameTc, String nameEn,
      String latitude, String longitude, String nameSc, int preferOrder) async {
    if (preferOrder == null)
      preferOrder = await databaseHelper.getPreferStopCount() + 1;
    PreferStop preferStop = PreferStop(
        stop, nameTc, nameEn, latitude, longitude, nameSc, preferOrder);
    await databaseHelper.insertPreferStop(preferStop);
  }

  void updatePreferStopOrder(List<PreferStop> preferStopList) {
    for (int i = 0; i < preferStopList.length; i++) {
      databaseHelper.updatePreferStop(preferStopList[i]);
    }
  }

  getPreferStop() async {
    return await databaseHelper.getPreferStopList();
  }

  Future<int> preferEtaCount() async =>
      await databaseHelper.getPreferEtaCount();

  void deletePreferEta(String co, String route, String dir, String stop) async {
    await databaseHelper.delPreferEta(co, route, dir, stop);
  }

  void insertPreferEta(
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
    PreferEta preferRoute = PreferEta(co, route, dir, stop, nameTc, origTc,
        destTc, nameSc, origSc, destSc, nameEn, origEn, destEn, preferOrder);
    await databaseHelper.insertPreferEta(preferRoute);
  }

  getPreferEta() async {
    return await databaseHelper.getPreferEtaList();
  }

  getPreferStopEta(String stop) async {
    return await databaseHelper.getPreferStopEtaList(stop);
  }

  Future<bool> checkPreferEta(
      String co, String route, String dir, String stop) async {
    int i = await databaseHelper.getPreferEta(co, route, dir, stop);
    if (i > 0) return true;
    return false;
  }

  Future<int> delPreferEta(
      String co, String route, String dir, String stop) async {
    int r = await databaseHelper.delPreferEta(co, route, dir, stop);
    return r;
  }

  Future<List<String>> getCircularRoute() async {
    List<String> list = await databaseHelper.circularRoute();
    return list;
  }
}
