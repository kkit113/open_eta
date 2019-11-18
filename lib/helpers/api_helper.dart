import 'dart:convert';
import 'package:open_eta/models/route.dart';
import 'package:http/http.dart';
import 'package:open_eta/models/eta.dart';
import 'package:open_eta/helpers/http_helper.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:intl/intl.dart';

class ApiHelper {
  HttpHelper helper = HttpHelper();

  Future<ETA> getEta({String co, String stop, String route}) async {
    Response re = await helper.fetchEtaData(co, stop, route);
    if (re.statusCode == 200) {
      final jsonResponse = json.decode(re.body);
      return ETA.fromJson(jsonResponse);
    } else {
      print('http response error!');
      return null;
    }
  }

  Future<EtaData> getEtaData() async {
    List<EtaData> etaDataList = List();
    EtaData etaData;

    Response re = await HttpHelper().fetchEtaData('NWFB', '001111', '970');
    if (re.statusCode == 200) {
//      print('${re.body}');
      final jsonResponse = json.decode(re.body);
      etaDataList = ETA.fromJson(jsonResponse).data;
      for (int i = 0; i < etaDataList.length; i++) {
        etaData = etaDataList[i];
        print('eta ${etaData.dataTimeStamp}');
      }
    } else {
      print('http response error!');
    }
    return etaData;
  }

  Future<int> getBusRouteData(String co) async {
    List<BusRouteData> busRouteDataList = List();
    BusRouteData busRouteData;
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    String modifyDateTime = dateFormat.format(DateTime.now());
    Response re = await helper.fetchRouteListData('$co');
    String fileName = '$co.txt';
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$fileName');
    try {
      _fileDelete(file);
      print('file delete');
    } catch (e) {
      print('file delete error: $e');
    }
    int i;
    if (re.statusCode == 200) {
      final jsonResponse = json.decode(re.body);
      busRouteDataList = BusRoute.fromJson(jsonResponse).data;
      for (i = 0; i < busRouteDataList.length; i++) {
        busRouteData = busRouteDataList[i];
        String s =
            i.toString() + ';' + busRouteData.toString() + modifyDateTime + ';';
        print('String: $s');
        _write(s, fileName);
      }
    } else {
      print('http response error!');
    }

    return i;
  }

  _write(String text, String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$fileName');
    print('write: ${file.toString()}, $text');
    await file.writeAsString(
      text,
      mode: FileMode.writeOnlyAppend,
    );
  }

  _fileDelete(File file) async {
    await file.delete();
  }

  Future<List<String>> readRoute() async {
    List<String> textRow;
    try {
      final file = await _localFile;
      file.readAsLines().then((lines) => lines.forEach((l) => textRow.add(l)));
      file.readAsString().then((s) => print('Read as String: $s'));
    } catch (e) {}

    textRow.forEach((line) => print('list - $line'));
    return null;
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/NWFB.txt');
  }
}
