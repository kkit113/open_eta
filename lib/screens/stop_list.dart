import 'package:open_eta/helpers/preference_helper.dart';
import 'package:open_eta/helpers/ui_helper.dart';
import 'package:open_eta/models/current_detail.dart';
import 'package:open_eta/models/eta.dart';
import 'package:open_eta/models/route_stop.dart';
import 'package:open_eta/models/stop_detail.dart';
import 'package:open_eta/screens/stop_detail.dart';
import 'package:open_eta/helpers/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

class BusStopList extends StatefulWidget {
  @override
  _BusStopListState createState() => _BusStopListState();
}

class _BusStopListState extends State<BusStopList> {
  double scrWidth;
  double scrHeight;
  double fontSize;

//  _BusStopListState();
  DatabaseHelper databaseHelper = DatabaseHelper();
  UiHelper uiHelper = UiHelper();
  String _langValue = 'Tc';
  CurrentDetail currentDetail;

  List<BusStopDetailsData> stopDataList;
  List<String> distinctStop;
  int count;
  RouteStopData routeStopData;
  BusStopDetailsData stopData;
  ETA futureEta;
  AlwaysStoppedAnimation<Color> progressColor;

  void initialList() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<BusStopDetailsData>> busStopDataListFuture =
          databaseHelper.getStopDataList();
      busStopDataListFuture.then((busStopDataList) {
        setState(() {
          this.stopDataList = busStopDataList;
          this.count = busStopDataList.length;
        });
      });
    });
  }

  @override
  void initState() {
    initialList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    scrWidth = uiHelper.scrWidth(context);
    scrHeight = uiHelper.scrHeight(context);
    fontSize = scrWidth / 100 * 5;
    progressColor = uiHelper.progressColor;
    final settings = Provider.of<PreferencesHelper>(context);
    _langValue = settings.getLangPrefs;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bus Stop List ($count)',
          style: TextStyle(fontSize: fontSize * 1.2),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.directions_bus,
                size: scrWidth * .08,
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/routeList');
              }),
          Container(
            width: scrWidth * .04,
          ),
        ],
      ),
      body: bodyWidget(),
//      getBusStopListView(),
    );
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
//      Future<int> result = databaseHelper.deleteEmptyRecord('BusStop', 'stop');
//      print('Delete empty');

      Future<List<BusStopDetailsData>> busStopDataListFuture =
          databaseHelper.getStopDataList();
      busStopDataListFuture.then((busStopDataList) {
        setState(() {
          this.stopDataList = busStopDataList;
          this.count = busStopDataList.length;
          print('stopDataCount ${this.count}.');
        });
      });
    });
  }

  void distinctStopList(String strStop) {
//    print('Bus Stop: $strStop');
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<BusStopDetailsData>> singleStopDataListFuture =
          databaseHelper.getSingleStopDataList(strStop);
      singleStopDataListFuture.then((singleStopDataList) {
        setState(() {
          this.stopDataList = singleStopDataList;
//          print('stopDataCount ${this.count}.');
        });
      });
    });
  }

//  Widget busStopList() {
//    return FutureBuilder();
//  }

  Widget bodyWidget() {
    if (stopDataList == null)
      return Center(
        child: SizedBox(
          width: scrWidth * 0.5,
          height: scrWidth * 0.5,
          child: CircularProgressIndicator(
            valueColor: progressColor,
          ),
        ),
      );
    return getBusStopListView();
  }

//  ETA currentETA(Future<ETA> futureETA) {}

  ListView getBusStopListView() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Container(
          height: scrHeight * 0.06,
          margin: EdgeInsets.symmetric(
            horizontal: scrWidth * 0.01,
          ),
          child: Card(
            color: Colors.white60,
            elevation: 2.0,
            child: GestureDetector(
              onTap: () {
                currentDetail = CurrentDetail(
                    null,
                    null,
                    '${stopDataList[position].stop}',
                    null,
                    null,
                    null,
                    null,
                    '${stopDataList[position].nameTc}',
                    null,
                    null,
                    '${stopDataList[position].nameSc}',
                    null,
                    null,
                    '${stopDataList[position].nameEn}',
                    '${stopDataList[position].longitude}',
                    '${stopDataList[position].latitude}');
                navigateToStop(currentDetail);
//                    navigateToRoute(this.busRouteDataList[position]);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).orientation ==
                            Orientation.portrait
                        ? this.stopDataList[position].stop.length *
                            scrWidth *
                            0.03
                        : (this.stopDataList[position].stop.length *
                                scrWidth *
                                0.03) *
                            (scrHeight / scrWidth),
                    child: Text(
                      '${this.stopDataList[position].stop}',
                      style: uiHelper.size(16),
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    width: scrWidth * .02,
                  ),
                  Container(
                    width: MediaQuery.of(context).orientation ==
                            Orientation.portrait
                        ? scrWidth * .90 -
                            (this.stopDataList[position].stop.length *
                                scrWidth *
                                0.03)
                        : (scrWidth * .90 -
                                (this.stopDataList[position].stop.length *
                                    scrWidth *
                                    0.03)) *
                            (scrHeight / scrWidth),
                    child: Text(
                      _langValue == 'Sc'
                          ? '${this.stopDataList[position].nameSc}'
                          : _langValue == 'En'
                              ? '${this.stopDataList[position].nameEn}'
                              : '${this.stopDataList[position].nameTc}',
                      style: _langValue == 'En'
                          ? uiHelper.size(20)
                          : uiHelper.size(26),
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
//                  Container(
//                    width: fontSize * 3,
//                    child: Text(
//                      '${this.stopDataList[position].longitude}',
//                      style: TextStyle(fontSize: fontSize * .6),
//                      textAlign: TextAlign.left,
//                      overflow: TextOverflow.ellipsis,
//                    ),
//                  ),
//                  Container(
//                    width: fontSize * 3,
//                    child: Text(
//                      '${this.stopDataList[position].latitude}',
//                      style: TextStyle(fontSize: fontSize * .6),
//                      textAlign: TextAlign.left,
//                      overflow: TextOverflow.ellipsis,
//                    ),
//                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void navigateToStop(CurrentDetail currentDetail) async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return StopDetail(currentDetail);
    }));
  }
}
