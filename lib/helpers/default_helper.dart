import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import 'package:open_eta/helpers/database_helper.dart';

class DefaultData {
//  File fileRoute = new File('assets/BusRoute.csv');
//  File fileStop = File('assets/BusStop.csv');
//  File fileRouteStop = File('/assets/RouteStop.csv');
  DatabaseHelper databaseHelper = DatabaseHelper();

  Future<int> insertDefaultBusRoute() async {
    databaseHelper.deleteBusRouteTable();
    String s = await loadBusRouteAssets();
    List<String> list = s.split(';').toList();
    int i;

    for (var count = 1, recordLength = 11;
        count * recordLength < list.length;
        count++) {
//      print(
//          '$count: ${list[count * recordLength + 0]}, ${list[count * recordLength + 1]}, ${list[count * recordLength + 2]}, ${list[count * recordLength + 3]}, ${list[count * recordLength + 4]},  ${list[count * recordLength + 5]}, ${list[count * recordLength + 6]}, ${list[count * recordLength + 7]}, ${list[count * recordLength + 8]}');

      databaseHelper.insertBusRouteAssets(
          '${list[count * recordLength + 0]}',
          '${list[count * recordLength + 1]}',
          '${list[count * recordLength + 2]}',
          '${list[count * recordLength + 3]}',
          '${list[count * recordLength + 4]}',
          '${list[count * recordLength + 5]}',
          '${list[count * recordLength + 6]}',
          '${list[count * recordLength + 7]}',
          '${list[count * recordLength + 8]}');
      i = count;
    }

//    int c = await databaseHelper.getBusRouteCount();
    return i;
  }

  Future<int> insertDefaultBusStop() async {
    databaseHelper.deleteBusStopTable();
    String s = await loadBusStopAssets();
    List<String> list = s.split(';').toList();
    int i;
    for (var count = 1, recordLength = 9;
        count * recordLength < list.length;
        count++) {
      databaseHelper.insertBusStopDataAssets(
          '${list[count * recordLength + 0]}',
          '${list[count * recordLength + 1]}',
          '${list[count * recordLength + 2]}',
          '${list[count * recordLength + 3]}',
          '${list[count * recordLength + 4]}',
          '${list[count * recordLength + 5]}',
          '${list[count * recordLength + 6]}');
//      print(
//          '${list[count * recordLength + 0]} - ${count * recordLength}/${list.length - recordLength}');
      i = count;
    }

//    int c = await databaseHelper.getBusStopDataCount();
    return i;
  }

//  Future<List<String>> listRouteStop() async {
//    String s = await loadRouteStopAssets();
//
//    List<String> result = s.split(';').toList();
//    print('$result');
//
//    databaseHelper.routeStopAssets(result);
//    return result;
//  }

  Future<int> insertDefaultRouteStop() async {
    databaseHelper.deleteRouteStopTable();
    String s = await loadRouteStopAssets();
    List<String> list = s.split(';').toList();
    int i;
//    print('Start insert: ${DateTime.now()}');
    for (var count = 1, recordLength = 8;
        count * recordLength < list.length;
        count++) {
      databaseHelper.insertRouteStopAssets(
          '${list[count * recordLength + 0]}',
          '${list[count * recordLength + 1]}',
          '${list[count * recordLength + 2]}',
          '${list[count * recordLength + 3]}',
          '${list[count * recordLength + 4]}',
          '${list[count * recordLength + 5]}');
      i = count;
    }

//    int c = await databaseHelper.getRouteStopDataCount();
    return i;
  }

//  Future<int> insertPreferStopTable() async {
//    databaseHelper.deletePreferStopTable();
//    String s = await loadPreferStopAssets();
//    List<String> list = s.split(';').toList();
//    int i;
//    for (var count = 1, recordLength = 9;
//        count * recordLength < list.length;
//        count++) {
//      databaseHelper.insertPreferStopAssets(
//          '${list[count * recordLength + 0]}',
//          '${list[count * recordLength + 1]}',
//          '${list[count * recordLength + 2]}',
//          '${list[count * recordLength + 3]}',
//          '${list[count * recordLength + 4]}',
//          '${list[count * recordLength + 5]}',
//          null);
//      i = count;
//    }
//    return i;
//  }

//  Future<int> insertPreferEtaTable() async {
//    databaseHelper.deletePreferEtaTable();
//    String s = await loadPreferEtaAssets();
//    List<String> list = s.split(';').toList();
//    int i;
//    for (var count = 1, recordLength = 9;
//        count * recordLength < list.length - 1;
//        count++) {
//      databaseHelper.insertPreferEtaAssets(
//          '${list[count * recordLength + 1]}',
//          '${list[count * recordLength + 2]}',
//          '${list[count * recordLength + 3]}',
//          '${list[count * recordLength + 4]}',
//          '${list[count * recordLength + 5]}',
//          '${list[count * recordLength + 6]}',
//          '${list[count * recordLength + 7]}',
//          int.parse('${list[count * recordLength + 8]}'));
//
////      print(
////          'START $count = ${list[count * recordLength + 1]}, ${list[count * recordLength + 2]}, '
////          '${list[count * recordLength + 3]}, ${list[count * recordLength + 4]}, '
////          '${list[count * recordLength + 5]}, ${list[count * recordLength + 6]}, '
////          '${list[count * recordLength + 7]} '
////          '- ${count * recordLength}/${list.length - recordLength} = END');
//
////      print(
////          '${list[count * recordLength + 3]} - ${count * recordLength}/${list.length - recordLength}');
//      i = count;
//    }
//    return i;
//  }

  Future<String> loadBusRouteAssets() async {
    return await rootBundle.loadString('assets/BusRoute.csv');
  }

  Future<String> loadBusStopAssets() async {
    return await rootBundle.loadString('assets/BusStop.csv');
  }

  Future<String> loadRouteStopAssets() async {
    return await rootBundle.loadString('assets/RouteStop.csv');
  }
}
