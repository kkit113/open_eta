import 'package:open_eta/helpers/database_helper.dart';
import 'package:open_eta/helpers/preference_helper.dart';
import 'package:open_eta/helpers/ui_helper.dart';
import 'package:open_eta/models/current_detail.dart';
import 'package:open_eta/models/route.dart';
import 'package:open_eta/screens/detail_route_card.dart';
import 'package:flutter/material.dart';

class RouteDetail extends StatefulWidget {
  final BusRouteData busRouteData;
  final String direction;
  RouteDetail({this.busRouteData, this.direction});

  @override
  _RouteDetailState createState() =>
      _RouteDetailState(this.busRouteData, this.direction);
}

class _RouteDetailState extends State<RouteDetail> {
  BusRouteData busRouteData;
  String direction, des, initDir, dest;
  String langPrefs = 'Tc';
  _RouteDetailState(this.busRouteData, this.direction);
  List<CurrentDetail> currentDetail;
  DatabaseHelper databaseHelper = DatabaseHelper();
  UiHelper uiHelper = UiHelper();
  PreferencesHelper prefsHelper = PreferencesHelper();
  double scrWidth, scrHeight, fontSize, stdPadding;
  AlwaysStoppedAnimation<Color> progressColor;
  Future<List<CurrentDetail>> currentRouteFuture;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  Future<List<CurrentDetail>> getCurrentRoute(
      BusRouteData busRouteData, String currentDirection) async {
    List<CurrentDetail> list = await databaseHelper.getCurrentRouteStop(
        '${busRouteData.route}', currentDirection);
//    print('getCurrentRoute: $currentDirection - ${list.length}');

    if (list.length == 0) {
      String d = currentDirection == 'I' ? 'O' : 'I';
      List<CurrentDetail> r =
          await databaseHelper.getCurrentRouteStop('${busRouteData.route}', d);
      print('$d - ${r.length}');
      currentDirection = d;
      list = r;
    }

    setState(() {
//      print('setState: ${list.length}');
//      des = getDest(currentDirection);
      currentDetail = list;
    });

//    print('after $currentDirection');
    return list;
  }

  String getDest(String d) {
    String s = d == 'I'
        ? langPrefs == 'Sc'
            ? busRouteData.origSc
            : langPrefs == 'En' ? busRouteData.origEn : busRouteData.origTc
        : langPrefs == 'Sc'
            ? busRouteData.destSc
            : langPrefs == 'En' ? busRouteData.destEn : busRouteData.destTc;
    String to = langPrefs == 'Sc' ? ' 往 ' : langPrefs == 'En' ? ' To ' : ' 往 ';
//    print('getDest: $to $s($d) ${busRouteData.origSc} ');

    return to + s;
  }

  void getLangPrefs() async {
    String p = await prefsHelper.getLangPrefs();
    setState(() {
      langPrefs = p;
    });
  }

  @override
  void initState() {
    initDir = this.direction;
    currentRouteFuture = getCurrentRoute(this.busRouteData, this.direction);
    getLangPrefs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    scrWidth = uiHelper.scrWidth(context);
    scrHeight = uiHelper.scrHeight(context);
    fontSize = uiHelper.stdFont(context);
    stdPadding = uiHelper.stdPadding(context);
    progressColor = uiHelper.progressColor;

    dest = getDest(direction);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '${busRouteData.route}  $dest',
            style: uiHelper.size(26),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.swap_horiz),
              iconSize: fontSize * 1.6,
              onPressed: () {
                direction = direction == 'I' ? 'O' : 'I';
//                if (dir == 'I') {
//                  dir = 'O';
//                } else {
//                  dir = 'I';
//                }
                setState(() {
                  des = getDest(direction);
                  currentRouteFuture = getCurrentRoute(busRouteData, direction);
                });
              },
            ),
          ],
        ),
        body: bodyWidget(),
        //currentDetail.map(CurrentDetail) => DetailRouteCard(currentDetail[position]);
      ),
    );
  }

  Widget bodyWidget() {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _onRefresh,
      child: FutureBuilder(
        future: currentRouteFuture,
        builder: (BuildContext context,
            AsyncSnapshot<List<CurrentDetail>> snapshot) {
//          print('11 - ${snapshot.data.length}');

          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData)
//          if (snapshot.connectionState == ConnectionState.done)
            return ListView.builder(
//              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data.length,
              itemBuilder: (context, position) {
                return DetailRouteCard(snapshot.data[position], initDir);
//                  Text('${currentDetail.nameTc}');
              },
            );

          return Center(
            child: SizedBox(
              width: scrWidth * 0.5,
              height: scrWidth * 0.5,
              child: CircularProgressIndicator(
                valueColor: progressColor,
              ),
            ),
          );
        },
      ),
    );
  }

//  Future<List<CurrentDetail>> _onReverse() {
//    print('_onReverse');
//    direction = direction == 'I' ? 'O' : 'I';
//    Future<List<CurrentDetail>> list = getCurrentRoute(busRouteData, direction);
//    setState(() {
//      des = getDest(direction);
//      currentRouteFuture = list;
//    });
//    return list;
//  }

  Future<List<CurrentDetail>> _onRefresh() {
//    print('_onRefresh');
    Future<List<CurrentDetail>> list =
        getCurrentRoute(this.busRouteData, direction);
    setState(() {
      currentRouteFuture = list;
    });
    return list;
  }
}
