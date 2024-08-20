class MainModel {
  final double value;
  final String title;
  String currentTab = "DASHBOARD";

  MainModel({required this.value, required this.title});

  factory MainModel.fromJson(Map<String, dynamic> json) {
    return MainModel(
      value: json['value'] is num ? (json['value'] as num).toDouble() : 0.0,
      title: json['title'] as String? ?? '',
    );
  }
}