import 'package:open_eta/helpers/busdata_helper.dart';
import 'package:open_eta/helpers/navigation_helper.dart';
import 'package:open_eta/helpers/preference_helper.dart';
import 'package:open_eta/helpers/ui_helper.dart';
import 'package:open_eta/models/current_detail.dart';
import 'package:open_eta/models/prefer_eta.dart';
import 'package:open_eta/models/prefer_stop.dart';
import 'package:open_eta/screens/eta_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DefaultPage extends StatefulWidget {
  @override
  _DefaultPageState createState() => _DefaultPageState();
}

class _DefaultPageState extends State<DefaultPage> {
  double scrWidth,
      scrHeight,
      fontSize,
      stdPadding,
      appBarHeight,
      bottomRowHeight;
  UiHelper uiHelper = UiHelper();
  BusDataHelper busDataHelper = BusDataHelper();
  NavigationHelper navigationHelper = NavigationHelper();
  PreferencesHelper prefsHelper = PreferencesHelper();
  String _langValue = 'Tc';
  CurrentDetail currentDetail;

  List<PreferEta> preferEtaList;
  AlwaysStoppedAnimation<Color> progressColor;
  Future<List<PreferEta>> preferEtaFuture;
  List<PreferStop> preferStopList;
  Future<List<PreferStop>> preferStopFuture;
  PreferStop selectPreferStop;
  String sysMsg;
  bool scrollHorizontal;

//  bool etaLoaded, stopLoaded;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    preferStopFuture = getPreferStopList();
    preferEtaFuture = getPreferEtaList();
    getLangPrefs();
    super.initState();
  }

  void getLangPrefs() async {
    String l = await prefsHelper.getLangPrefs() ?? 'Tc';
    setState(() {
      _langValue = l;
    });
  }

  @override
  Widget build(BuildContext context) {
    scrWidth = uiHelper.scrWidth(context);
    scrHeight = uiHelper.scrHeight(context);
    fontSize = uiHelper.stdFont(context);
    stdPadding = uiHelper.stdPadding(context);
    progressColor = uiHelper.progressColor;

//    getLangPrefs();

//    print('$_langValue');
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            _langValue == 'Sc'
                ? '抵站时间'
                : _langValue == 'En' ? 'Bus ETA' : '抵站時間',
            style: uiHelper.size30,
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.directions_bus,
                size: fontSize * 1.3,
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/routeList');
              },
            ),
//            IconButton(
//              icon: Icon(
//                Icons.place,
//                size: fontSize * 1.3,
//              ),
//              onPressed: () {
//                Navigator.pushNamed(context, '/stopList');
//              },
//            ),
            IconButton(
              icon: Icon(
                Icons.settings,
                size: fontSize * 1.3,
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
            Container(
              width: stdPadding * 2,
            ),
          ],
        ),
        body: portraitMode2(),
      ),
    );
  }

  Widget bodyLayout() {
//    preferStopFuture = getPreferStopList();
//    preferEtaFuture = getPreferEtaList();
//
//    print('bodyLayout: etaListFuture:$preferEtaFuture');
//    print('bodyLayout: stopListFuture:$preferStopFuture');
//
//    print(
//        'bodyLayout: EtaList:${preferEtaList.length}, StopList:${preferStopList.length}');
    return OrientationBuilder(builder: (context, orientation) {
      return orientation == Orientation.portrait
          ? portraitMode2()
          : landscapeMode2();
    });
  }

  Widget portraitMode2() {
    double sectionHeight = scrHeight * 0.75;

//    return Column(
//      children: <Widget>[
//        Container(
//          height: sectionHeight,
//          child: FutureBuilder(
//            future: preferEtaFuture,
//            builder: (context, snapshot) {
//              if (snapshot.hasData)
//                return GridView.count(
//                  scrollDirection: Axis.horizontal,
//                  childAspectRatio: ((sectionHeight / scrWidth) / 1),
//                  crossAxisCount: 2,
//                  children: List.generate(
//                    preferEtaList.length,
//                    (position) {
//                      etaLoaded = false;
//                      return SizedBox(
//                          width: scrWidth / 2,
//                          height: sectionHeight / 2,
//                          child: EtaCard(preferEtaList[position]));
//                    },
//                  ),
//                );
//              return Center(
//                child: SizedBox(
//                    width: scrWidth * 0.5,
//                    height: scrWidth * 0.5,
//                    child: CircularProgressIndicator(
//                      valueColor: progressColor,
//                    )),
//              );
//            },
//          ),
//        ),
//        Expanded(
//          child: Center(
//            child: Text(
//              '${sysMsg ?? ''}',
//              style: uiHelper.size20,
//              overflow: TextOverflow.ellipsis,
//            ),
//          ),
//        ),
//        Container(
//          height: scrHeight * 0.085,
//          child: Column(
//            mainAxisAlignment: MainAxisAlignment.center,
//            children: <Widget>[
//              bottomRow(),
////                FutureBuilder(
////                    builder: (BuildContext context, AsyncSnapshot snapshot) {
////                  return ListView();
////                }),
//            ],
//          ),
//        ),
//      ],
//    );

    if (preferEtaList == null) {
      getPreferEtaList();
      return Center(
        child: SizedBox(
          width: scrWidth * 0.6,
          height: scrWidth * 0.6,
          child: CircularProgressIndicator(
            valueColor: progressColor,
          ),
        ),
      );
    }

    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _onRefresh,
      child: Column(
        children: <Widget>[
          Container(
            height: sectionHeight,
            child: GridView.count(
//              scrollDirection: Axis.horizontal,
              childAspectRatio: (1 / (sectionHeight / scrWidth)),
              crossAxisCount: 2,
              children: List.generate(
                preferEtaList.length,
                (position) {
//                  etaLoaded = false;
                  return SizedBox(
                      width: scrWidth / 2,
                      height: sectionHeight / 2,
                      child: EtaCard(preferEtaList[position], _langValue));
                },
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                '${sysMsg ?? ''}',
                style: uiHelper.size(16),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Container(
            height: scrHeight * 0.080,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                bottomRow(),
              ],
            ),
          ),
        ],
      ),
    );
  }

//  Widget portraitMode() {
//    double sectionHeight = scrHeight * 0.75;
//    if (preferEtaList == null)
//      return Center(
//        child: SizedBox(
//            width: scrWidth * 0.5,
//            height: scrWidth * 0.5,
//            child: CircularProgressIndicator(
//              valueColor: progressColor,
//            )),
//      );
//    return Column(
//      children: <Widget>[
//        Container(
//          height: sectionHeight,
//          child: GridView.count(
//            scrollDirection: Axis.horizontal,
//            childAspectRatio: ((sectionHeight / scrWidth) / 1),
//            crossAxisCount: 2,
//            children: List.generate(
//              preferEtaList.length,
//              (position) {
//                return SizedBox(
//                    width: scrWidth / 2,
//                    height: sectionHeight / 2,
//                    child: EtaCard(preferEtaList[position]));
//              },
//            ),
//          ),
//        ),
//        Expanded(
//          child: Center(
//            child: Text(
//              '${sysMsg ?? ''}',
//              style: uiHelper.size20,
//              overflow: TextOverflow.ellipsis,
//            ),
//          ),
//        ),
//        Container(
//          height: scrHeight * 0.085,
//          child: Column(
//            mainAxisAlignment: MainAxisAlignment.center,
//            children: <Widget>[
//              bottomRow(),
////                FutureBuilder(
////                    builder: (BuildContext context, AsyncSnapshot snapshot) {
////                  return ListView();
////                }),
//            ],
//          ),
//        ),
//      ],
//    );
//  }

  Widget landscapeMode2() {
    if (preferEtaList == null) {
      getPreferEtaList();
      return Center(
        child: SizedBox(
          width: scrWidth * 0.6,
          height: scrWidth * 0.6,
          child: CircularProgressIndicator(
            valueColor: progressColor,
          ),
        ),
      );
    }

    return Row(
      children: <Widget>[
        Expanded(
          child: Center(
            child: Container(
              height: scrWidth - 56,
              child: GridView.count(
                scrollDirection: Axis.horizontal,
                childAspectRatio: ((scrHeight * 0.8 / scrWidth) / 1),
                crossAxisCount: 1,
                children: List.generate(
                  preferEtaList.length,
                  (position) {
//                  etaLoaded = false;
                    return SizedBox(
                        width: scrWidth / 2,
                        height: scrWidth / 2,
                        child: EtaCard(preferEtaList[position], _langValue));
                  },
                ),
              ),
            ),
          ),
        ),
        Container(
          width: scrHeight * 0.2,
          child: ListView.builder(
              itemCount: preferStopList.length,
              itemBuilder: (context, position) {
                return GestureDetector(
                  onTap: () {
                    currentDetail = CurrentDetail(
                        null,
                        null,
                        '${this.preferStopList[position].stop}',
                        null,
                        null,
                        null,
                        null,
                        '${this.preferStopList[position].nameTc}',
                        null,
                        null,
                        '${this.preferStopList[position].nameSc}',
                        null,
                        null,
                        '${this.preferStopList[position].nameEn}',
                        '${this.preferStopList[position].longitude}',
                        '${this.preferStopList[position].latitude}');
                    //navigateToStop(currentDetail);

                    navigationHelper.navigateToStop(context, currentDetail);
                  },
                  child: Container(
                    height: scrWidth / 12,
                    child: Card(
                      elevation: 5.0,
                      child: Text(
                        _langValue == 'Sc'
                            ? '${preferStopList[position].nameSc}'
                            : _langValue == 'En'
                                ? '${preferStopList[position].nameEn}'
                                : '${preferStopList[position].nameTc}',
                        style: _langValue == 'En'
                            ? uiHelper.size(18)
                            : uiHelper.size(20),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                );
              }),
        )
      ],
    );
  }

//  Widget landscapeMode() {
//    return Row(
//      children: <Widget>[
//        Expanded(
//          child: FutureBuilder(
//            future: preferEtaFuture,
//            builder: (context, item) {
////              if (preferEtaList == null || preferEtaList.length == 0)
////                return Center(
////                  child: SizedBox(
////                    width: scrHeight * 0.25,
////                    height: scrHeight * 0.25,
////                    child: CircularProgressIndicator(
////                      valueColor: progressColor,
////                    ),
////                  ),
////                );
//
//              return GridView.count(
//                childAspectRatio: (1 / 1.2),
//                crossAxisCount: int.parse(
//                        (scrHeight / scrWidth).toString().split('.').first) +
//                    2,
//                children: List.generate(
//                  item.data.length,
//                  (position) {
//                    return EtaCard(item.data[position]);
//                  },
//                ),
//              );
//
////                ListView.builder(
////                scrollDirection: Axis.horizontal,
////                itemCount: preferEtaList.length,
////                itemBuilder: (context, position) {
////                  return EtaCard(preferEtaList[position]);
////                },
////              );
//            },
//          ),
//        ),
//        VerticalDivider(
//          color: Colors.lightGreen,
//          indent: stdPadding * 5,
//          endIndent: stdPadding * 5,
//          thickness: stdPadding,
//          width: scrHeight * 0.02,
//        ),
////        GridView.count(crossAxisCount: 4),
//        Container(
//          width: scrHeight * .2,
//          child: FutureBuilder(
//            future: getPreferStopList(),
//            builder: (context, item) {
//              print('FutureBuilder ${item.data.length}');
//              if (item.hasData)
//                return ListView.builder(
//                  itemCount: item.data.length,
//                  itemBuilder: (context, index) {
////                    print('builder ListView ...');
//                    return GestureDetector(
//                      onTap: () {
//                        navigationHelper.navigateToStop(
//                            context,
//                            '${item.data[index].stop}',
//                            '${item.data[index].nameTc}');
//                      },
//                      child: Container(
//                        decoration: BoxDecoration(
//                          border: Border.all(color: Colors.orangeAccent),
//                          borderRadius: BorderRadius.all(
//                            Radius.circular(12.0),
//                          ),
//                        ),
//                        margin: EdgeInsets.all(stdPadding),
//                        child: Text(
//                          '${item.data[index].nameTc}',
//                          style: TextStyle(fontSize: fontSize * 0.7),
//                          overflow: TextOverflow.ellipsis,
//                        ),
//                      ),
//                    );
//                  },
//                );
//              if (!item.hasData)
//                return Center(
//                  child: Icon(Icons.error_outline),
//                );
//              return Center(
//                child: CircularProgressIndicator(),
//              );
//            },
//          ),
//        ),
//      ],
//    );
//  }

  Widget bottomRow() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
              margin: EdgeInsets.symmetric(horizontal: stdPadding * 2),
              width: scrWidth * 0.88,
              child: preferStopDropDown()),
//          RaisedButton(
//            onPressed: () {
//              navigationHelper.navigateToStop(context,
//                  '${selectPreferStop.stop}', '${selectPreferStop.nameTc}');
//            },
//            child: Text(
//              'Go',
//              style: TextStyle(fontSize: fontSize),
//            ),
//          ),
        ],
      ),
    );
  }

  Widget preferStopDropDown() {
//    if (preferStopList == null) {
//      getPreferStopList();
//      return Center(
//        child: CircularProgressIndicator(
//          valueColor: progressColor,
//        ),
//      );
//    }
//    selectPreferStop = PreferStop('001111', '', '', '', '', '', 999);
//    if (preferStopList != null && preferStopList.length > 0)
    return FutureBuilder(
      future: preferStopFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(
            child: CircularProgressIndicator(
              valueColor: progressColor,
            ),
          );
        return DropdownButton<PreferStop>(
//      value: selectPreferStop ??
//          PreferStop('001111', '蒲飛路, 薄扶林道', '', '', '', '', 999),
          isExpanded: true,
          hint: Text(_langValue == 'Sc'
              ? '预选巴士站'
              : _langValue == 'En' ? 'Selected Stops' : '預選巴士站'),
          items: preferStopList.map((PreferStop preferStop) {
//        stopLoaded = false;

            return DropdownMenuItem<PreferStop>(
              value: preferStop,
              child: Container(
                width: scrWidth * 0.8,
                child: Card(
                  elevation: 2.0,
                  child: Text(
                    _langValue == 'Sc'
                        ? '${preferStop.nameSc}'
                        : _langValue == 'En'
                            ? '${preferStop.nameEn}'
                            : '${preferStop.nameTc}',
                    style: TextStyle(fontSize: fontSize),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            );
          }).toList(),
          value: selectPreferStop,
          onChanged: (PreferStop newValue) {
            currentDetail = CurrentDetail(
                null,
                null,
                '${newValue.stop}',
                null,
                null,
                null,
                null,
                '${newValue.nameTc}',
                null,
                null,
                '${newValue.nameSc}',
                null,
                null,
                '${newValue.nameEn}',
                '${newValue.longitude}',
                '${newValue.latitude}');
            navigationHelper.navigateToStop(context, currentDetail);

            setState(() {
              selectPreferStop = newValue;
            });

            //        print('${selectPreferStop.nameTc} vs ${newValue.nameTc}');
          },
        );
      },
    );
//    return Center(
//      child: CircularProgressIndicator(
//        valueColor: progressColor,
//      ),
//    );
  }

  Future<List<PreferEta>> _onRefresh() async {
    print('_onRefresh');
    await getPreferStopList();
    return getPreferEtaList();
  }

  Future<List<PreferEta>> getPreferEtaList() async {
    List<PreferEta> list = await busDataHelper.getPreferEta();
//    print('getPreferEtaList: ${list.length}');

//    print('list - ${list.length}');
    setState(() {
      preferEtaList = list;
    });
//    etaLoaded = true;
//    print('${preferEtaList.length}');
//    print('getPreferEtaList: ${preferEtaList.length}');

    return list;
  }

  Future<List<PreferStop>> getPreferStopList() async {
    List<PreferStop> list = await busDataHelper.getPreferStop();
//    print('getPreferStopList: ${list.length}');
    if (list != null && list.length > 0) preferStopList = null;
    setState(() {
      preferStopList = list;
    });
//    print('${preferStopList.length}');
//    stopLoaded = true;
    return list;
  }
}
