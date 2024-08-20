import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/main_model.dart';

class GetApi {
  List<MainModel> revenueItems = [];

  Future<void> fetchDoanhThuData() async {
    final response = await http.get(Uri.parse('https://apishpt.doctorsaigon.net/api/v2/his/DataTest'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      if (jsonData.containsKey('body')) {
        final decodedBodyData = json.decode(jsonData['body']);

        if (decodedBodyData.containsKey('obdata')) {
          final obdata = json.decode(decodedBodyData['obdata']);

          if (obdata.containsKey('dsdoanhthu')) {
            final doanhThuList = json.decode(obdata['dsdoanhthu']);

            // In ra chuỗi JSON của dsluotdichvu
            print('dsdoanhthu JSON: ${json.encode(doanhThuList)}');

            // Chuyển đổi từng phần tử trong doanhThuList thành đối tượng DoanhThuItem
            revenueItems = doanhThuList.map<MainModel>((item) => MainModel.fromJson(item)).toList();

            // In ra các DoanhThuItem đã chuyển đổi
            for (var item in revenueItems) {
              print('Title: ${item.title}, Value: ${item.value}');
            }
          } else {
            throw Exception('dsluotdichvu not found in obdata');
          }
        } else {
          throw Exception('obdata not found in decodedBodyData');
        }
      } else {
        throw Exception('body not found in jsonData');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }
}