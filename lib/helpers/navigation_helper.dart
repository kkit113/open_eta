import 'package:open_eta/models/current_detail.dart';
import 'package:open_eta/models/route.dart';
import 'package:open_eta/screens/route_detail.dart';
import 'package:open_eta/screens/stop_detail.dart';
import 'package:open_eta/screens/stop_list.dart';
import 'package:flutter/material.dart';

class NavigationHelper {
  void navigateToStop(BuildContext context, CurrentDetail currentDetail) async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return StopDetail(currentDetail);
    }));
  }

  void navigateToRoute(
      BuildContext context, BusRouteData busRouteData, String direction) async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return RouteDetail(busRouteData: busRouteData, direction: direction);
    }));
  }

  void navigateToStopList(BuildContext context) async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return BusStopList();
    }));
  }
}
