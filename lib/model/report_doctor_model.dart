//Author: Ngô Phước Đông

import 'dart:convert';

class DoanhThu {
  String? color;
  double? value;
  String? title;
  String? ghichu;
  String? obdata;
  String? ma;
  String? ten;
  String? loai;
  String? ten1;

  DoanhThu({
    this.color,
    this.value,
    this.title,
    this.ghichu,
    this.obdata,
    this.ma,
    this.ten,
    this.loai,
    this.ten1,
  });

  factory DoanhThu.fromJson(Map<String, dynamic> json) {
    return DoanhThu(
      color: json['color'],
      value: (json['value'] is int) ? (json['value'] as int).toDouble() : json['value'].toDouble(), // Đảm bảo giá trị là double
      title: json['title'],
      ghichu: json['ghichu'],
      obdata: json['obdata'],
      ma: json['ma'],
      ten: json['ten'],
      loai: json['loai'],
      ten1: json['ten1'],
    );
  }
}

class DoctorRevenueReport {
  List<DoanhThu>? doanhThuTheoBs;

  DoctorRevenueReport({this.doanhThuTheoBs});

  factory DoctorRevenueReport.fromJson(Map<String, dynamic> json) {
    final obdata = json['obdata'];
    final parsedObdata = jsonDecode(obdata);

    return DoctorRevenueReport(
      doanhThuTheoBs: List<DoanhThu>.from(
          parsedObdata['dsdoanhthutheobs'].map((x) => DoanhThu.fromJson(x))
      ),
    );
  }
}
