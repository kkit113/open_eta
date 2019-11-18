import 'package:open_eta/helpers/api_helper.dart';
import 'package:open_eta/helpers/busdata_helper.dart';
import 'package:open_eta/helpers/navigation_helper.dart';
import 'package:open_eta/helpers/preference_helper.dart';
import 'package:open_eta/helpers/ui_helper.dart';
import 'package:open_eta/models/current_detail.dart';
import 'package:open_eta/models/prefer_eta.dart';
import 'package:open_eta/models/route.dart';
import 'package:open_eta/screens/route_detail.dart';
import 'package:open_eta/screens/stop_detail.dart';
import 'package:flutter/material.dart';

class EtaCard extends StatefulWidget {
  final PreferEta preferEta;
  final String langPrefs;
  EtaCard(this.preferEta, this.langPrefs);
  @override
  _EtaCardState createState() => _EtaCardState(this.preferEta, this.langPrefs);
}

class _EtaCardState extends State<EtaCard> {
  PreferEta preferEta;
  double scrWidth, scrHeight, fontSize, stdPadding, cardWidth, cardHeight;
  ApiHelper apiHelper = ApiHelper();
  BusDataHelper busDataHelper = BusDataHelper();
  UiHelper uiHelper = UiHelper();
  NavigationHelper navigationHelper = NavigationHelper();
  PreferencesHelper prefsHelper = PreferencesHelper();
  String langPrefs;

  _EtaCardState(this.preferEta, this.langPrefs);
  CurrentDetail currentDetail;
  AlwaysStoppedAnimation<Color> progressColor;

//  void getLangPrefs() async {
//    String l = await prefsHelper.getLangPrefs() ?? 'Tc';
//    setState(() {
//      _langValue = l;
//    });
//    print('eta_card langPrefs: $l');
//  }

  @override
  Widget build(BuildContext context) {
    scrWidth = uiHelper.scrWidth(context);
    scrHeight = uiHelper.scrHeight(context);
    fontSize = uiHelper.stdFont(context);
    stdPadding = uiHelper.stdPadding(context);
    progressColor = uiHelper.progressColor;
    cardWidth = scrHeight * 0.5;
    cardHeight = scrHeight * 0.75 * 0.5;

//    getLangPrefs();

    return Container(
      width: cardWidth,
      height: cardHeight,
      margin: EdgeInsets.symmetric(
          vertical: scrWidth * 0.01, horizontal: scrWidth * 0.015),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.orangeAccent),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(stdPadding),
                decoration: BoxDecoration(
                    color: Colors.teal[200],
                    borderRadius: BorderRadius.all(Radius.circular(12.0))),
                child: GestureDetector(
                  onTap: () {
                    BusRouteData busRouteData = BusRouteData(
                        co: preferEta.co,
                        route: preferEta.route,
                        origTc: preferEta.origTc,
                        origEn: preferEta.destEn,
                        destTc: preferEta.destTc,
                        destEn: preferEta.destEn,
                        origSc: preferEta.origSc,
                        destSc: preferEta.destSc,
                        dataTimeStamp: preferEta.nameTc);
                    navigationHelper.navigateToRoute(
                        context, busRouteData, '${preferEta.dir}');
                  },
                  child: Text(
                    '${preferEta.route}',
                    style: uiHelper.size(28),
                  ),
                ),
              ),
              Container(
//                      key: nameKey,
                decoration: BoxDecoration(
                  color: Colors.yellow[200],
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                margin: EdgeInsets.symmetric(
                    vertical: stdPadding, horizontal: stdPadding),
//                      width: scrWidth * 0.3,
                child: GestureDetector(
                  onTap: () {
                    currentDetail = CurrentDetail(
                        '${preferEta.co}',
                        '${preferEta.route}',
                        '${preferEta.stop}',
                        '${preferEta.dir}',
                        null,
                        '${preferEta.origTc}',
                        '${preferEta.destTc}',
                        '${preferEta.nameTc}',
                        '${preferEta.origSc}',
                        '${preferEta.destSc}',
                        '${preferEta.nameSc}',
                        '${preferEta.origEn}',
                        '${preferEta.destEn}',
                        '${preferEta.nameEn}',
                        null,
                        null);
                    navigationHelper.navigateToStop(context, currentDetail);
                  },
                  child: Text(
                    langPrefs == 'Sc'
                        ? '${preferEta.nameSc}'
                        : langPrefs == 'En'
                            ? '${preferEta.nameEn}'
                            : '${preferEta.nameTc}',
                    style: langPrefs == 'En'
                        ? uiHelper.size(20)
                        : uiHelper.size(26),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
            ],
          ),
          Divider(
//            key: dividerKey,
            color: Colors.deepPurple,
            endIndent: scrWidth * .03,
            indent: scrWidth * .03,
            thickness: 2,
          ),
          SizedBox(
            width: cardWidth * 0.8,
            height: cardHeight * 0.6,
            child: FutureBuilder(
                future: apiHelper.getEta(
                    co: '${preferEta.co}',
                    stop: '${preferEta.stop}',
                    route: '${preferEta.route}'),
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
                        size: fontSize * 3,
                      ),
                    );
                  return ListView.builder(
                      primary: false,
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
                          return Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                    '${snapshot.data.data[index].eta.split('T').last.split('+').first.substring(0, 5)}',
                                    textAlign: TextAlign.right,
                                    style: uiHelper.timeString(d, 28),
                                  ),
                                  Text(
                                    ':${snapshot.data.data[index].eta.split('T').last.split('+').first.split(':').last}',
                                    textAlign: TextAlign.left,
                                    style: uiHelper.timeString(d, 20),
                                  ),
//                                  Text(
//                                    ' (${snapshot.data.data[index].etaSeq})',
//                                    textAlign: TextAlign.center,
//                                    style: uiHelper.timeString(d, 16),
//                                  ),
                                ],
                              ),
                              Text(
                                langPrefs == 'Sc'
                                    ? '${snapshot.data.data[index].destSc}'
                                    : langPrefs == 'En'
                                        ? '${snapshot.data.data[index].destEn}'
                                        : '${snapshot.data.data[index].destTc}',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: fontSize * 0.7),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          );
                        } else {
                          return Column(children: <Widget>[
                            Text(
                              langPrefs == 'Sc'
                                  ? '${snapshot.data.data[index].rmkSc}'
                                  : langPrefs == 'En'
                                      ? '${snapshot.data.data[index].rmkEn}'
                                      : '${snapshot.data.data[index].rmkTc}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: fontSize * 0.8,
                                  color: Colors.deepOrange[400]),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              langPrefs == 'Sc'
                                  ? '${snapshot.data.data[index].destSc}'
                                  : langPrefs == 'En'
                                      ? '${snapshot.data.data[index].destEn}'
                                      : '${snapshot.data.data[index].destTc}',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: fontSize * 0.7),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ]);
                        }
                      });
                }),
          ),
        ],
      ),
    );
  }
}
