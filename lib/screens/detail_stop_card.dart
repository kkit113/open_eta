import 'package:open_eta/helpers/api_helper.dart';
import 'package:open_eta/helpers/busdata_helper.dart';
import 'package:open_eta/helpers/preference_helper.dart';
import 'package:open_eta/helpers/ui_helper.dart';
import 'package:open_eta/models/current_detail.dart';
import 'package:open_eta/models/route.dart';
import 'package:open_eta/screens/route_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DetailStopCard extends StatefulWidget {
  final CurrentDetail currentDetail;

  DetailStopCard(this.currentDetail);

  @override
  _DetailStopCardState createState() =>
      _DetailStopCardState(this.currentDetail);
}

class _DetailStopCardState extends State<DetailStopCard> {
  CurrentDetail currentDetail;
  UiHelper uiHelper = UiHelper();
  ApiHelper apiHelper = ApiHelper();
  BusDataHelper busDataHelper = BusDataHelper();
  _DetailStopCardState(this.currentDetail);
  double scrWidth, scrHeight, fontSize, stdPadding;
  bool markedStop = false;
  AlwaysStoppedAnimation<Color> progressColor;
  bool markedBus = false;
  PreferencesHelper prefsHelper = PreferencesHelper();
  String _langValue = 'Tc';

  void getLangPrefs() async {
    String l = await prefsHelper.getLangPrefs() ?? 'Tc';
    setState(() {
      _langValue = l;
    });
  }

  @override
  void initState() {
    checkMarkedBus().then((value) {
      if (value) {
        setState(() {
          markedBus = value;
        });
      }
    });
    checkMarkedStop().then((stop) {
      if (stop) {
        setState(() {
          markedStop = stop;
        });
      }
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

    return body();
  }

  body() {
    String des =
        currentDetail.dir == 'I' ? currentDetail.origTc : currentDetail.destTc;

    return Container(
        margin: EdgeInsets.symmetric(horizontal: stdPadding * 3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    BusRouteData busRouteData = BusRouteData(
                        co: '${currentDetail.co}',
                        route: '${currentDetail.route}',
                        origTc: '${currentDetail.origTc}',
                        origEn: '${currentDetail.origEn}',
                        destTc: '${currentDetail.destTc}',
                        destEn: '${currentDetail.destEn}',
                        origSc: '${currentDetail.origSc}',
                        destSc: '${currentDetail.destTc}',
                        dataTimeStamp: '');
                    navigateToRoute(busRouteData, '${currentDetail.dir}');
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: scrWidth * 0.01),
                    width: currentDetail.route.length * scrWidth * 0.05,
                    child: Text(
                      '${currentDetail.route}',
                      style: uiHelper.size(26),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Container(
                  width: scrWidth * 0.73 -
                      (currentDetail.route.length * scrWidth * 0.045),
                  child: Text(
                    currentDetail.dir == 'I'
                        ? _langValue == 'Sc'
                            ? '${currentDetail.origSc}'
                            : _langValue == 'En'
                                ? '${currentDetail.origEn}'
                                : '${currentDetail.origTc}'
                        : _langValue == 'Sc'
                            ? '${currentDetail.destSc}'
                            : _langValue == 'En'
                                ? '${currentDetail.destEn}'
                                : '${currentDetail.destTc}',
                    style: uiHelper.size(22),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
                IconButton(
                    icon: Icon(Icons.directions_bus),
                    iconSize: fontSize * 1.5,
                    onPressed: () {
                      updatePreferEta();
                    },
                    color:
                        markedBus ? Colors.deepOrange[500] : Colors.teal[500]),
                Container(
                  width: scrWidth * 0.02,
                )
              ],
            ),
            SizedBox(
              width: scrWidth * 0.9,
              height: scrHeight * 0.07,
              child: FutureBuilder(
                  future: apiHelper.getEta(
                      co: '${currentDetail.co}',
                      stop: '${currentDetail.stop}',
                      route: '${currentDetail.route}'),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return Center(
                          child: CircularProgressIndicator(
                        valueColor: progressColor,
                      ));

                    if (snapshot.data.data.length == 0)
                      return Center(
                        child: Icon(
                          Icons.error,
                          color: Colors.redAccent,
                          size: fontSize * 2,
                        ),
                      );
                    return ListView.builder(
                        primary: false,
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data.data.length,
                        itemBuilder: (context, index) {
//                              if (snapshot.data.data[index].destTc
//                                      .toString()
//                                      .substring(0, 2)
//                                      .trim() !=
//                                  des.toString().substring(0, 2).trim()) {
//                                return Container(
//                                  width: scrWidth * 0.3,
//                                  child: Text(
//                                      '${snapshot.data.data[index].eta.length > 0 ? snapshot.data.data[index].eta.split('T').last.split('+').first.substring(0, 5) : snapshot.data.data[index].rmkTc} ${snapshot.data.data[index].destTc}'),
//                                );
//                              }
                          if (snapshot.data.data[index].eta.length > 0) {
                            int d;
                            try {
                              d = DateTime.parse(snapshot.data.data[index].eta
                                      .split('+')
                                      .first)
                                  .difference(DateTime.now())
                                  .inSeconds;
                            } catch (e) {
                              d = 5;
                            }

                            return Container(
                              width: scrWidth * 0.3,
                              child: Column(
//                                  crossAxisAlignment:
//                                      CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Text(
                                        '${snapshot.data.data[index].eta.split('T').last.split('+').first.substring(0, 5)}',
                                        textAlign: TextAlign.right,
                                        style: uiHelper.timeString(d, 26),
                                      ),
                                      Text(
                                        ':${snapshot.data.data[index].eta.split('T').last.split('+').first.split(':').last}',
                                        textAlign: TextAlign.left,
                                        style: uiHelper.timeString(d, 20),
                                      ),
//                                          Text(
//                                            ' (${snapshot.data.data[index].etaSeq})',
//                                            textAlign: TextAlign.center,
//                                            style: TextStyle(
//                                                fontSize: fontSize * 0.6),
//                                          ),
                                    ],
                                  ),
//                                      Text(
//                                        '${snapshot.data.data[index].destTc}',
//                                        textAlign: TextAlign.center,
//                                        style:
//                                            TextStyle(fontSize: fontSize * 0.7),
//                                        overflow: TextOverflow.ellipsis,
//                                      ),
                                ],
                              ),
                            );

//                                Column(
//                                  children: <Widget>[
//                                    Row(
//                                      mainAxisAlignment:
//                                          MainAxisAlignment.center,
//                                      crossAxisAlignment:
//                                          CrossAxisAlignment.end,
//                                      children: <Widget>[
//                                        Text(
//                                          '${snapshot.data.data[index].eta.split('T').last.split('+').first.substring(0, 5)}',
//                                          textAlign: TextAlign.right,
//                                          style: TextStyle(fontSize: fontSize),
//                                        ),
//                                        Text(
//                                          ':${snapshot.data.data[index].eta.split('T').last.split('+').first.split(':').last}',
//                                          textAlign: TextAlign.left,
//                                          style: TextStyle(
//                                              fontSize: fontSize * 0.8),
//                                        ),
//                                        Text(
//                                          ' (${snapshot.data.data[index].etaSeq})',
//                                          textAlign: TextAlign.center,
//                                          style: TextStyle(
//                                              fontSize: fontSize * 0.6),
//                                        ),
//                                      ],
//                                    ),
//                                    Text(
//                                      '${snapshot.data.data[index].destTc}',
//                                      textAlign: TextAlign.center,
//                                      style:
//                                          TextStyle(fontSize: fontSize * 0.7),
//                                    ),
//                                  ],
//                                );
                          } else {
                            return Container(
                              width: scrWidth * 0.3,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      _langValue == 'Sc'
                                          ? '${snapshot.data.data[index].rmkSc}'
                                          : _langValue == 'En'
                                              ? '${snapshot.data.data[index].rmkEn}'
                                              : '${snapshot.data.data[index].rmkTc}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: fontSize * 0.8,
                                          color: Colors.deepOrange[400]),
                                    ),
//                                  Text(
//                                    '${snapshot.data.data[index].destTc}',
//                                    textAlign: TextAlign.center,
//                                    style: TextStyle(fontSize: fontSize * 0.7),
//                                  ),
                                  ]),
                            );
                          }
                        });
                  }),
            ),
          ],
        ));
  }

  Future<bool> checkMarkedBus() async {
    return busDataHelper.checkPreferEta(
        this.currentDetail.co,
        this.currentDetail.route,
        this.currentDetail.dir,
        this.currentDetail.stop);
  }

  Future<bool> checkMarkedStop() async {
    return busDataHelper.checkPreferStop(this.currentDetail.stop);
  }

  void updatePreferEta() {
    if (!markedBus) {
      busDataHelper.insertPreferEta(
          this.currentDetail.co,
          this.currentDetail.route,
          this.currentDetail.dir,
          this.currentDetail.stop,
          this.currentDetail.nameTc,
          this.currentDetail.origTc,
          this.currentDetail.destTc,
          this.currentDetail.nameSc,
          this.currentDetail.origSc,
          this.currentDetail.destSc,
          this.currentDetail.nameEn,
          this.currentDetail.origEn,
          this.currentDetail.destEn,
          999);
    } else {
      busDataHelper.deletePreferEta(
          this.currentDetail.co,
          this.currentDetail.route,
          this.currentDetail.dir,
          this.currentDetail.stop);
    }

    setState(() {
      markedBus == true ? markedBus = false : markedBus = true;
    });
  }

  void updatePreferStop() {
    if (!markedStop) {
      busDataHelper.insertPreferStop(
          this.currentDetail.stop,
          this.currentDetail.nameTc,
          this.currentDetail.nameEn,
          this.currentDetail.latitude,
          this.currentDetail.longitude,
          this.currentDetail.nameSc,
          999);
    } else {
      busDataHelper.delPreferStop(this.currentDetail.stop);
    }

    setState(() {
      markedStop == true ? markedStop = false : markedStop = true;
    });
  }

  void navigateToRoute(BusRouteData busRouteData, String direction) async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return RouteDetail(busRouteData: busRouteData, direction: direction);
    }));
  }
}
