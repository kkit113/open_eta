import 'package:open_eta/helpers/database_helper.dart';
import 'package:open_eta/helpers/preference_helper.dart';
import 'package:open_eta/helpers/ui_helper.dart';
import 'package:open_eta/models/current_detail.dart';
import 'package:open_eta/models/route_stop.dart';
import 'package:open_eta/screens/detail_stop_card.dart';
import 'package:flutter/material.dart';

class StopDetail extends StatefulWidget {
//  final RouteStopData routeStopData;
  final CurrentDetail currentDetail;

  StopDetail(this.currentDetail);
  @override
  _StopDetailState createState() => _StopDetailState(this.currentDetail);
}

class _StopDetailState extends State<StopDetail> {
  _StopDetailState(this.currentDetail);
  CurrentDetail currentDetail;

  RouteStopData routeStopData;
//  String stop, nameTc;
  UiHelper uiHelper = UiHelper();
  DatabaseHelper databaseHelper = DatabaseHelper();
  double scrWidth, scrHeight, fontSize, stdPadding;
  AlwaysStoppedAnimation<Color> progressColor;
  List<CurrentDetail> currentDetailList;
  Future<List<CurrentDetail>> currentStopFuture;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  PreferencesHelper prefsHelper = PreferencesHelper();
  String _langValue = 'Tc';

  void getLangPrefs() async {
    String l = await prefsHelper.getLangPrefs() ?? 'Tc';
    setState(() {
      _langValue = l;
    });
  }

  Future<List<CurrentDetail>> getCurrentStop(String stop) async {
    currentDetailList = await databaseHelper.getCurrentStopBus(stop);
    return currentDetailList;
  }

  @override
  void initState() {
    setState(() {
      currentStopFuture = getCurrentStop('${currentDetail.stop}');
    });
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

    if (currentStopFuture == null) {
//      print('StopDetail: ${currentStopFuture.toString()}');
      setState(() {
        currentStopFuture = getCurrentStop('${currentDetail.stop}');
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _langValue == 'Sc'
              ? '${currentDetail.nameSc}'
              : _langValue == 'En'
                  ? '${currentDetail.nameEn}'
                  : '${currentDetail.nameTc}',
          style: uiHelper.size(26),
        ),
      ),
      body: bodyWidget(),
      floatingActionButton: Container(
        margin: EdgeInsets.only(right: 20.0, bottom: 16.0),
        child: FloatingActionButton.extended(
            onPressed: () {
              Navigator.pop(context);
            },
            label: Text(_langValue == 'Sc'
                ? '返回'
                : _langValue == 'En' ? 'Back' : '返回')),
      ),
    );
  }

  bodyWidget() {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _onRefresh,
      child: FutureBuilder(
          future: currentStopFuture,
          builder: (BuildContext context,
              AsyncSnapshot<List<CurrentDetail>> snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData)
              return ListView.builder(
//              scrollDirection: Axis.horizontal,
                itemCount: snapshot.data.length,
                itemBuilder: (context, position) {
                  print('${snapshot.data[position].route}');
                  return DetailStopCard(snapshot.data[position]);
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
          }),
    );
  }

  Future<List<CurrentDetail>> _onRefresh() {
//    print('_onRefresh');
    Future<List<CurrentDetail>> list = getCurrentStop('${currentDetail.stop}');
    setState(() {
      currentStopFuture = list;
    });
    return list;
  }
}
