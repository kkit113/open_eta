import 'package:open_eta/helpers/navigation_helper.dart';
import 'package:open_eta/helpers/preference_helper.dart';
import 'package:open_eta/helpers/ui_helper.dart';
import 'package:open_eta/models/route.dart';
import 'package:open_eta/screens/stop_list.dart';
import 'package:flutter/material.dart';
import 'package:open_eta/helpers/database_helper.dart';
import 'package:sqflite/sqlite_api.dart';

class RouteList extends StatefulWidget {
  @override
  _RouteListState createState() => _RouteListState();
}

class _RouteListState extends State<RouteList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  UiHelper uiHelper = UiHelper();
  TextEditingController routeInputController = TextEditingController();
  NavigationHelper navigationHelper = NavigationHelper();
  PreferencesHelper prefsHelper = PreferencesHelper();
  List<BusRouteData> busRouteDataList;
  List<String> routePrefix;
  BusRouteData selectedBusRouteData;
  double scrWidth, scrHeight, fontSize;
  int count = 0;
  int prefixCount = 0;
  AlwaysStoppedAnimation<Color> progressColor;
  String selectedPrefix;
  String langPrefs = 'Tc';

  @override
  void initState() {
    updateListView();
    dynamicUpdateListView('*');
    prefixList();
    getLangPrefs();
    super.initState();
  }

  @override
  void dispose() {
    routeInputController.dispose();
    super.dispose();
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<BusRouteData>> busRouteDataListFuture =
          databaseHelper.getBusRouteList();
      busRouteDataListFuture.then((busRouteDataList) {
        setState(() {
          this.busRouteDataList = busRouteDataList;
          this.count = busRouteDataList.length;
        });
      });
    });
  }

  void dynamicUpdateListView(String input) {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<BusRouteData>> busRouteDataListFuture =
          databaseHelper.dynamicBusRouteList(input);
      busRouteDataListFuture.then((busRouteDataList) {
        setState(() {
          this.busRouteDataList = busRouteDataList;
          this.count = busRouteDataList.length;
        });
      });
    });
  }

  Future<List<String>> prefixList() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<String>> busRoutePrefixListFuture =
          databaseHelper.getBusRoutePrefixList();
      busRoutePrefixListFuture.then((prefixList) {
        setState(() {
          routePrefix = prefixList;
          prefixCount = prefixList.length;
        });
      });
    });
    return routePrefix as Future;
  }

  void getLangPrefs() async {
    String l = await prefsHelper.getLangPrefs();
    setState(() {
      langPrefs = l;
    });
  }

//  void loopBusRoute(String co) async {
//    int tableCount = await databaseHelper.getTableCount();
//    print('tableCount before Insert $tableCount');
//    BusRoute busRoute = await _getBusRouteJson(co: co);
//    int count = busRoute.data.length;
//    int result;
//    for (int i = 0; i < count; i++) {
//      BusRouteData busRouteData = busRoute.data[i];
//      print('Insert data $busRouteData');
//      result = await databaseHelper.insertBusRoute(busRouteData);
//      print('Insert data result: $result');
//    }
//  }

  void navigateToStopList() async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return BusStopList();
    }));
  }

//  Future<BusRoute> _getBusRouteJson({String co}) async {
//    Response re = await HttpHelper().fetchRouteListData(co);
//    if (re.statusCode == 200) {
//      final jsonResponse = json.decode(re.body);
//      print('$co - BusRoute: $jsonResponse');
//      return BusRoute.fromJson(jsonResponse);
//    } else {
//      throw Exception('Fail to load from Internet![${re.statusCode}]');
//    }
//  }

  @override
  Widget build(BuildContext context) {
    scrWidth = uiHelper.scrWidth(context);
    scrHeight = uiHelper.scrHeight(context);
    fontSize = uiHelper.stdFont(context);
    progressColor = uiHelper.progressColor;

    if (busRouteDataList == null) {
      busRouteDataList = List<BusRouteData>();
      updateListView();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          langPrefs == 'Sc'
              ? '路线'
              : langPrefs == 'En'
                  ? 'Routes'
                  : '路線'
                      '  ($count)',
          style: uiHelper.size(26),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.format_list_numbered,
              size: scrWidth * .08,
            ),
            onPressed: () {
              navigationHelper.navigateToStopList(context);
            },
          ),
          Container(
            width: scrWidth * .04,
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: getBusRouteListView(),
          ),
          Container(
            height: scrHeight * 0.07,
            color: Colors.blueGrey[200],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: scrHeight * .05,
                  width: scrWidth * .46,
                  child: TextField(
                    controller: routeInputController,
                    onChanged: (value) {
                      if (value.length > 0) {
                        setState(() {
                          dynamicUpdateListView('$value');
                        });
                      }
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                ),
                Container(width: scrWidth * 0.11, child: prefixDropDown()),
                RaisedButton(
                  onPressed: () {
                    if (routeInputController.text.length > 0) {
                      routeInputController.clear();
                      FocusScope.of(context).unfocus();
                    } else {
                      updateListView();
                    }
                  },
                  child: Text(
                    langPrefs == 'En'
                        ? 'Clear'
                        : langPrefs == 'Sc' ? '清除' : '清除',
                    style: uiHelper.size(20),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
//  void deleteAllTable() async {
//    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
//    dbFuture.then((database) {
//      databaseHelper.deleteRouteStopTable();
//      databaseHelper.deleteBusStopTable();
//      databaseHelper.deleteBusRouteTable();
//    });
//    int s = await databaseHelper.getBusStopDataCount();
//    print('BusStopCount $s');
//    int c = await databaseHelper.getRouteStopDataCount();
//    print('RouteStopCount $c');
//    int r = await databaseHelper.getBusRouteCount();
//    print('BusRouteCount $r');
//  }

//  void deleteTables() async {
//    int result = await databaseHelper.deleteBusRouteTable();
//    print('Detele Table executed');
//    int tableCount = await databaseHelper.getTableCount();
//    print('deleteBusRouteTable: $result($tableCount)');
//  }

  Widget getBusRouteListView() {
    if (busRouteDataList == null)
      return Center(
        child: SizedBox(
          width: scrWidth * 0.5,
          height: scrWidth * 0.5,
          child: CircularProgressIndicator(
            valueColor: progressColor,
          ),
        ),
      );

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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: scrWidth * .04,
                ),
                Container(
                  width: scrWidth * .18,
                  child: Text(
                    '${this.busRouteDataList[position].route}',
                    style: uiHelper.size(24),
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    navigationHelper.navigateToRoute(
                        context, this.busRouteDataList[position], 'I');
                  }, //Inbound
                  child: Container(
                    width: scrWidth * .36,
                    child: Text(
                      langPrefs == 'En'
                          ? '${this.busRouteDataList[position].origEn}'
                          : langPrefs == 'Sc'
                              ? '${this.busRouteDataList[position].origSc}'
                              : '${this.busRouteDataList[position].origTc}',
                      style: uiHelper.size(24),
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Container(
                  width: scrWidth * .01,
                ),
                GestureDetector(
                  onTap: () {
                    navigationHelper.navigateToRoute(
                        context, this.busRouteDataList[position], 'O');
                  }, //outbound
                  child: Container(
                    width: scrWidth * .36,
                    child: Text(
                      langPrefs == 'En'
                          ? '${this.busRouteDataList[position].destEn}'
                          : langPrefs == 'Sc'
                              ? '${this.busRouteDataList[position].destSc}'
                              : '${this.busRouteDataList[position].destTc}', //towards destTc = outbound
                      style: uiHelper.size(24),
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget prefixDropDown() {
    if (routePrefix != null && routePrefix.length > 0)
      return DropdownButton<String>(
        value: selectedPrefix,
        items: routePrefix.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Container(width: scrWidth * 0.04, child: Text(value)),
          );
        }).toList(),
        onChanged: (newValue) {
          setState(() {
            selectedPrefix = newValue;
          });
          routeInputController.text = routeInputController.text + newValue;
          dynamicUpdateListView('${routeInputController.text}');
        },
      );
    return Center(
      child: CircularProgressIndicator(
        valueColor: progressColor,
      ),
    );
  }
}
