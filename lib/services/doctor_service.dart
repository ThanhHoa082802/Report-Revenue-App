//Author: Ngô Phước Đông
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/report_doctor_model.dart';

class DoctorService {
  final String baseUrl = 'https://apishpt.doctorsaigon.net/api/v2/his/DataTest';

  Future<List<DoanhThu>> fetchReportData(String dataType) async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final body = jsonResponse['body'];
      final decodedBody = jsonDecode(body);
      final obdataString = decodedBody['obdata'];

      if (obdataString != null) {
        final obdataJson = jsonDecode(obdataString);
        final dsdoanhthutheobs = jsonDecode(
            dataType == 'BÁC SĨ THỰC HIỆN'
                ? obdataJson['dsdoanhthutheobsthuchien']
                : obdataJson['dsdoanhthutheobs']
        );

        if (dsdoanhthutheobs != null) {
          return List<DoanhThu>.from(dsdoanhthutheobs.map((x) => DoanhThu.fromJson(x)));
        } else {
          return [];
        }
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load data');
    }
  }
}
