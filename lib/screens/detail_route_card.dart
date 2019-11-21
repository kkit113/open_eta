import 'package:open_eta/helpers/api_helper.dart';
import 'package:open_eta/helpers/busdata_helper.dart';
import 'package:open_eta/helpers/preference_helper.dart';
import 'package:open_eta/helpers/ui_helper.dart';
import 'package:open_eta/models/current_detail.dart';
import 'package:open_eta/screens/stop_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  String _langValue;
  List<String> circularRoutes;

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    scrWidth = uiHelper.scrWidth(context);
    scrHeight = uiHelper.scrHeight(context);
    fontSize = uiHelper.stdFont(context);
    stdPadding = uiHelper.stdPadding(context);
    progressColor = uiHelper.progressColor;
    final settings = Provider.of<PreferencesHelper>(context);
    _langValue = settings.getLangPrefs;

    return body();
  }

  body() {
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
                                    ],
                                  ),
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
