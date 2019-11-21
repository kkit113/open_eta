import 'package:open_eta/helpers/database_helper.dart';
import 'package:open_eta/helpers/preference_helper.dart';
import 'package:open_eta/helpers/ui_helper.dart';
import 'package:open_eta/models/current_detail.dart';
import 'package:open_eta/models/route.dart';
import 'package:open_eta/screens/detail_route_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  String _langValue;
  _RouteDetailState(this.busRouteData, this.direction);
  List<CurrentDetail> currentDetail;
  DatabaseHelper databaseHelper = DatabaseHelper();
  UiHelper uiHelper = UiHelper();
  double scrWidth, scrHeight, fontSize, stdPadding;
  AlwaysStoppedAnimation<Color> progressColor;
  Future<List<CurrentDetail>> currentRouteFuture;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  Future<List<CurrentDetail>> getCurrentRoute(
      BusRouteData busRouteData, String currentDirection) async {
    List<CurrentDetail> list = await databaseHelper.getCurrentRouteStop(
        '${busRouteData.route}', currentDirection);

    if (list.length == 0) {
      String d = currentDirection == 'I' ? 'O' : 'I';
      List<CurrentDetail> r =
          await databaseHelper.getCurrentRouteStop('${busRouteData.route}', d);
      print('$d - ${r.length}');
      currentDirection = d;
      list = r;
    }

    setState(() {
      currentDetail = list;
    });

    return list;
  }

  String getDest(String d) {
    String s = d == 'I'
        ? _langValue == 'Sc'
            ? busRouteData.origSc
            : _langValue == 'En' ? busRouteData.origEn : busRouteData.origTc
        : _langValue == 'Sc'
            ? busRouteData.destSc
            : _langValue == 'En' ? busRouteData.destEn : busRouteData.destTc;
    String to =
        _langValue == 'Sc' ? ' 往 ' : _langValue == 'En' ? ' To ' : ' 往 ';

    return to + s;
  }

  @override
  void initState() {
    initDir = this.direction;
    currentRouteFuture = getCurrentRoute(this.busRouteData, this.direction);
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
    final settings = Provider.of<PreferencesHelper>(context);
    _langValue = settings.getLangPrefs;

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

                setState(() {
                  des = getDest(direction);
                  currentRouteFuture = getCurrentRoute(busRouteData, direction);
                });
              },
            ),
          ],
        ),
        body: bodyWidget(),
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
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData)
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, position) {
                return DetailRouteCard(snapshot.data[position], initDir);
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

  Future<List<CurrentDetail>> _onRefresh() {
    Future<List<CurrentDetail>> list =
        getCurrentRoute(this.busRouteData, direction);
    setState(() {
      currentRouteFuture = list;
    });
    return list;
  }
}
