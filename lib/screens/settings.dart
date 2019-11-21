import 'package:open_eta/helpers/busdata_helper.dart';
import 'package:open_eta/helpers/default_helper.dart';
import 'package:open_eta/helpers/preference_helper.dart';
import 'package:open_eta/helpers/ui_helper.dart';
import 'package:open_eta/screens/disclaimer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  UiHelper uiHelper = UiHelper();
  DefaultData defaultData = DefaultData();
  BusDataHelper busDataHelper = BusDataHelper();
  Disclaimer disclaimer = Disclaimer();
//  CustomDialog customDialog = CustomDialog();
  int routes, routeStops, stops, stopsFuture;
  double stdPadding, scrWidth, scrHeight, fontSize;
  String _langValue = 'Tc';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<int> rCountFuture() async => await busDataHelper.routeCount();
  Future<int> sCountFuture() async => await busDataHelper.busStopCount();
  Future<int> rStopCountFuture() async => busDataHelper.routeStopCount();
  Future<int> etaCountFuture() async => busDataHelper.preferEtaCount();
  Future<int> preferStopCountFuture() async => busDataHelper.preferStopCount();

  void rCount() async {
    await defaultData.insertDefaultBusRoute();
    setState(() {
      rCountFuture();
    });
  }

  void sCount() async {
    await defaultData.insertDefaultBusStop();
    setState(() {
      sCountFuture();
    });
  }

  void rStopCount() async {
    await defaultData.insertDefaultRouteStop();
    setState(() {
      rStopCountFuture();
    });
  }

  @override
  Widget build(BuildContext context) {
    scrWidth = uiHelper.scrWidth(context);
    scrHeight = uiHelper.scrHeight(context);
    fontSize = scrWidth * 0.05;
    stdPadding = scrWidth * 0.01;
    final settings = Provider.of<PreferencesHelper>(context);
    _langValue = settings.getLangPrefs;

    //    getLanguagePreference();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            _langValue == 'Sc' ? '设定' : _langValue == 'En' ? 'Settings' : '設定',
            style: TextStyle(fontSize: fontSize),
          ),
        ),
        body: Container(
          margin: EdgeInsets.all(stdPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(),
              ),
              Container(
                margin: EdgeInsets.all(stdPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        RaisedButton(
                          onPressed: () {
                            rCount();
                          },
                          child: Text(_langValue == 'Sc'
                              ? '路线'
                              : _langValue == 'En' ? 'Routes' : '路線'),
                        ),
                        FutureBuilder(
                          future: rCountFuture(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return Text('${snapshot.data}');
                            } else {
                              return CircularProgressIndicator(
                                valueColor: uiHelper.progressColor,
                              );
                            }
                          },
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        RaisedButton(
                          onPressed: () {
                            rStopCount();
                          },
                          child: Text(_langValue == 'Sc'
                              ? '路线站点'
                              : _langValue == 'En' ? 'Route Stops' : '路線站點'),
                        ),
                        FutureBuilder(
                          future: rStopCountFuture(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done)
                              return Text('${snapshot.data}');
                            if (snapshot.connectionState ==
                                ConnectionState.waiting)
                              return CircularProgressIndicator(
                                valueColor: uiHelper.progressColor,
                              );
                            return Container(
                              child: Icon(
                                Icons.error,
                                color: Colors.red,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        RaisedButton(
                          onPressed: () {
                            sCount();
                          },
                          child: Text(_langValue == 'Sc'
                              ? '站点'
                              : _langValue == 'En' ? 'Stops' : '站點'),
                        ),
                        FutureBuilder<int>(
                          future: sCountFuture(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return Text('${snapshot.data}');
                            } else {
                              return CircularProgressIndicator(
                                valueColor: uiHelper.progressColor,
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(),
              ),
              Container(
                margin: EdgeInsets.all(stdPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RaisedButton(
                      onPressed: () {
                        busDataHelper.deleteAllTables();
//                        rCount();
//                        sCount();
//                        rStopCount();
                      },
                      child: Text(_langValue == 'Sc'
                          ? '清除记录'
                          : _langValue == 'En' ? 'Clear Records' : '清除記錄'),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Container(),
              ),
              Divider(
                thickness: 1,
                color: Colors.deepPurple,
                indent: stdPadding,
                endIndent: stdPadding,
              ),
              Expanded(
                child: Container(),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    _langValue == 'Sc'
                        ? '设定语言'
                        : _langValue == 'En' ? 'Language Setting:' : '設定語言',
                    style: uiHelper.size(22),
                    textAlign: TextAlign.center,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Radio(
                          value: 'En',
                          groupValue: settings.getLangPrefs,
                          onChanged: (T) {
                            settings.setLangPrefs(T);
                          }),
                      Text(
                        'Eng',
                        style: uiHelper.size(22),
                      ),
                      Radio(
                          value: 'Tc',
                          groupValue: settings.getLangPrefs,
                          onChanged: (T) {
                            settings.setLangPrefs(T);
                          }),
                      Text(
                        '繁',
                        style: uiHelper.size(22),
                      ),
                      Radio(
                          value: 'Sc',
                          groupValue: settings.getLangPrefs,
                          onChanged: (T) {
                            settings.setLangPrefs(T);
                          }),
                      Text(
                        '简',
                        style: uiHelper.size(22),
                      ),
                    ],
                  ),
                ],
              ),
              Expanded(
                child: Container(),
              ),
              Divider(
                thickness: 1,
                color: Colors.deepPurple,
                indent: stdPadding,
                endIndent: stdPadding,
              ),
              Expanded(
                child: Container(),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      IconButton(
                        tooltip: 'Route List',
                        icon: Icon(
                          Icons.directions_bus,
                          size: fontSize * 2,
                          color: Colors.teal[500],
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/routeList');
                        },
                      ),
//
                      IconButton(
                        tooltip: 'Stop List',
                        icon: Icon(
                          Icons.place,
                          size: fontSize * 2,
                          color: Colors.lightGreen[500],
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/stopList');
                        },
                      ),
                    ],
                  ),
                ],
              ),
              Expanded(
                child: Container(),
              ),
              Divider(
                thickness: 1,
                color: Colors.deepPurple,
                indent: stdPadding,
                endIndent: stdPadding,
              ),
              Expanded(
                child: Container(),
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RaisedButton(
                      onPressed: () {
                        busDataHelper.insertBusRoute('NWFB');
                      },
                      child: Text('NWFB'),
                    ),
                    RaisedButton(
                      onPressed: () {
                        busDataHelper.insertBusRoute('CTB');
                      },
                      child: Text('CTB'),
                    ),
                    RaisedButton(
                      onPressed: () {
                        busDataHelper.insertStop();
                      },
                      child: Text('Stops'),
                    ),
                  ]),
              Expanded(
                child: Container(),
              ),
              Divider(
                thickness: 1,
                color: Colors.deepPurple,
                indent: stdPadding,
                endIndent: stdPadding,
              ),
              Expanded(
                child: Container(),
              ),
              Container(
                child: FlatButton(
                    onPressed: () {
                      disclaimer.showDisclaimer(context);
                    },
                    child: Text(
                      _langValue == 'Sc'
                          ? '免责声明'
                          : _langValue == 'En' ? 'Disclaimer' : '免責聲明',
                      style: uiHelper.size(20),
                    )),
              ),
              Expanded(
                child: Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
