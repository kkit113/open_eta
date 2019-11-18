class UrlHelper {
  String baseUrl = 'http://rt.data.gov.hk';
  String transportUrl = '/v1/transport';
  String companyUrl = '/citybus-nwfb/';

  String dataUrl(
      [String type, String co, String stopId, String route, String direction]) {
    co = co != null ? '$co/' : '';

    ///print('dataURL - co:$co');
    stopId = stopId != null ? '$stopId/' : '';

    ///print('dataURL - stop:$stopId');
    route = route != null ? '$route/' : '';

    ///print('dataURL - route:$route');
    direction = direction != null ? '$direction/' : '';

    ///print('dataURL - direction:$direction');

    return baseUrl +
        transportUrl +
        companyUrl +
        type +
        co +
        stopId +
        route +
        direction;
  }

  String getCompanyUrl({String co}) {
    return dataUrl('company/', co, null, null, null);
  }

  String getRouteUrl({String co, String route}) {
    return dataUrl('route/', co, route, null, null);
  }

  String getRouteListUrl({String co}) {
    return dataUrl('route/', co, null, null, null);
  }

  String getStopUrl({String stop}) {
    return dataUrl('stop/', null, stop, null, null);
  }

  String getRouteStopUrl({String co, String route, String bound}) {
    return dataUrl('route-stop/', co, null, route, bound);
  }

  String getEtaUrl({String co, String stop, String route}) {
    return dataUrl('eta/', co, stop, route, null);
  }
}
