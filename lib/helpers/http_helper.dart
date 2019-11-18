import 'dart:async';
import 'package:http/http.dart' as http;
import 'url_helper.dart';

class HttpHelper {
  Future<http.Response> fetchEtaData(
      String co, String stop, String route) async {
    String url = UrlHelper().getEtaUrl(co: co, stop: stop, route: route);
//    print('getEtaUrl: $url');
    return http.Client().get(url);
  }

  Future<http.Response> fetchRouteStopData(
      String co, String route, String bound) async {
    String url =
        UrlHelper().getRouteStopUrl(co: co, route: route, bound: bound);
//    print('getRouteStopUrl: $url');
    return http.Client().get(url);
  }

  Future<http.Response> fetchStopData(String stop) async {
    String url = UrlHelper().getStopUrl(stop: stop);
//    print('getStopUrl: $url');
    return http.Client().get(url);
  }

  Future<http.Response> fetchRouteListData(String co) async {
    String url = UrlHelper().getRouteListUrl(co: co);
//    print('getRouteListUrl: $url');
    return http.Client().get(url);
  }

  Future<http.Response> fetchRouteData(String co, String route) async {
    String url = UrlHelper().getRouteUrl(co: co, route: route);
//    print('getRouteUrl: $url');
    return http.Client().get(url);
  }

  Future<http.Response> fetchCompanyData(String co) async {
    String url = UrlHelper().getCompanyUrl(co: co);
//    print('getCompanyUrl: $url');
    return http.Client().get(url);
  }
}
