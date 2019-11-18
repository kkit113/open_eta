import 'package:open_eta/helpers/api_helper.dart';
import 'package:open_eta/helpers/busdata_helper.dart';
import 'package:open_eta/helpers/preference_helper.dart';
import 'package:open_eta/helpers/ui_helper.dart';
import 'package:open_eta/models/current_detail.dart';
import 'package:open_eta/screens/stop_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DetailRouteCard extends StatefulWidget {
  final CurrentDetail currentDetail;
  final String initDir;

  DetailRouteCard(this.currentDetail, this.initDir);

  @override
  _DetailRouteCardState createState() =>
      _DetailRouteCardState(this.currentDetail, this.initDir);
}

class _DetailRouteCardState extends State<DetailRouteCard> {
  CurrentDetail currentDetail;
  String initDir;
  UiHelper uiHelper = UiHelper();
  ApiHelper apiHelper = ApiHelper();
  BusDataHelper busDataHelper = BusDataHelper();
  _DetailRouteCardState(this.currentDetail, this.initDir);
  double scrWidth, scrHeight, fontSize, stdPadding;
  bool markedStop = false;
  AlwaysStoppedAnimation<Color> progressColor;
  bool markedBus = false;
  PreferencesHelper prefsHelper = PreferencesHelper();

  String _langValue = 'Tc';
  List<String> circularRoutes;

  void getLangPrefs() async {
    String l = await prefsHelper.getLangPrefs() ?? 'Tc';
    setState(() {
      _langValue = l;
    });
  }

  void getCircularRoute() async {
    circularRoutes = await busDataHelper.getCircularRoute();
  }

  @override
  void initState() {
    getCircularRoute();
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

    ///TODO database to keep circular routes
//    circularRoutes = ['11', '37A', '37B', '37x'];

    return body();
  }

  body() {
//    print('RouteDetailBody: $initDir vs   ${currentDetail.dir}');
//    String des = initDir == 'I'
//        ? _langValue == 'Sc'
//            ? currentDetail.origSc
//            : _langValue == 'En' ? currentDetail.origEn : currentDetail.origTc
//        : _langValue == 'Sc'
//            ? currentDetail.destSc
//            : _langValue == 'En' ? currentDetail.destEn : currentDetail.destTc;
//    print('Route detail: ${currentDetail.dir}');
    return Container(
        margin: EdgeInsets.symmetric(horizontal: stdPadding * 3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(horizontal: scrWidth * 0.01),
                  width: scrWidth * 0.08,
                  child: Text(
                    '${currentDetail.seq}',
                    style: uiHelper.size(16),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    navigateToStop(currentDetail);
                  },
                  child: Container(
                    width: scrWidth * 0.55,
                    child: Text(
                      _langValue == 'Sc'
                          ? '${currentDetail.nameSc}'
                          : _langValue == 'En'
                              ? '${currentDetail.nameEn}'
                              : '${currentDetail.nameTc}',
                      style: uiHelper.size(22),
                      overflow: TextOverflow.ellipsis,
                    ),
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
                  color: markedBus ? Colors.deepOrange[500] : Colors.teal[500],
                ),
                IconButton(
                    icon: Icon(Icons.location_on),
                    onPressed: () {
                      updatePreferStop();
                    },
                    color: markedStop
                        ? Colors.deepOrange[500]
                        : Colors.lightGreen[500],
                    iconSize: fontSize * 1.5),
                Container(
                  width: scrWidth * 0.03,
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
//                          String defaultDest =
//                              snapshot.data.data[index].dir == 'O'
//                                  ? _langValue == 'Sc'
//                                      ? '${currentDetail.destSc}'
//                                      : _langValue == 'En'
//                                          ? '${currentDetail.destEn}'
//                                          : '${currentDetail.destTc}'
//                                  : _langValue == 'Sc'
//                                      ? '${currentDetail.origSc}'
//                                      : _langValue == 'En'
//                                          ? '${currentDetail.origEn}'
//                                          : '${currentDetail.origTc}';
//
//                          String etaDest = _langValue == 'Sc'
//                              ? '${snapshot.data.data[index].destSc}'
//                              : _langValue == 'En'
//                                  ? '${snapshot.data.data[index].destEn}'
//                                  : '${snapshot.data.data[index].destTc}';
//
//                          if (snapshot.data.data[index].seq == 1)
//                            print(
//                                'route vs sch (${snapshot.data.data[index].route}) ${snapshot.data.data[index].seq}: ${defaultDest.split(' ').join('')} vs ${etaDest.replaceAll(RegExp(r'\s\b|\b\s'), '')}');
//
//                          if (!defaultDest.split(' ').join('').contains(etaDest
//                                  .split(' ')
//                                  .join('')
//                                  .substring(0, 2)) &&
//                              !circularRoutes
//                                  .contains(snapshot.data.data[index].route)) {
//                            print(
//                                'detail_card: ${snapshot.data.data[index].route} ${snapshot.data.data[index].seq} - ${defaultDest.split(' ').join('')} vs ${etaDest.split(' ').join('')}'
//                                '${defaultDest.split(' ').join('').contains(etaDest.split(' ').join(''))}');
//                            return Container(
//                              width: scrWidth * 0.3,
//                              child: Column(
//                                children: <Widget>[
//                                  if (snapshot.data.data[index].eta.length > 0)
//                                    Text(_langValue == 'Sc'
//                                        ? '${snapshot.data.data[index].eta.split('T').last.split('+').first.substring(0, 5)}'
//                                        : _langValue == 'En'
//                                            ? '${snapshot.data.data[index].eta.split('T').last.split('+').first.substring(0, 5)}'
//                                            : '${snapshot.data.data[index].eta.split('T').last.split('+').first.substring(0, 5)}'),
//                                  Text(_langValue == 'Sc'
//                                      ? '${snapshot.data.data[index].destEn} '
//                                      : _langValue == 'En'
//                                          ? '${snapshot.data.data[index].destEn}'
//                                          : '${snapshot.data.data[index].destTc}'),
//                                  if (snapshot.data.data[index].eta.length == 0)
//                                    Text(
//                                      _langValue == 'Sc'
//                                          ? '${snapshot.data.data[index].rmkSc}'
//                                          : _langValue == 'En'
//                                              ? '${snapshot.data.data[index].rmkEn}'
//                                              : '${snapshot.data.data[index].rmkTc}',
//                                      style: TextStyle(
//                                          color: Colors.deepOrange[400]),
//                                    ),
//                                ],
//                              ),
//                            );
//                          }
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
//                                      Text(
//                                        ' (${snapshot.data.data[index].etaSeq})',
//                                        textAlign: TextAlign.center,
//                                        style:
//                                            TextStyle(fontSize: fontSize * 0.6),
//                                      ),
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

  void navigateToStop(CurrentDetail currentDetail) async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return StopDetail(currentDetail);
    }));
  }
}
