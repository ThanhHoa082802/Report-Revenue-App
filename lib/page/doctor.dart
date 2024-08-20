import 'package:flutter/material.dart';
import '../services/doctor_service.dart';
import '../model/report_doctor_model.dart';
import 'package:fl_chart/fl_chart.dart';
import '../widgets/doctor_revenue_chart.dart';
import '../widgets/date_range_selector.dart';
import 'package:intl/intl.dart';

class DoctorPage extends StatefulWidget {
  final String initialDataType;

  DoctorPage({required this.initialDataType});

  @override
  _DoctorPageState createState() => _DoctorPageState();
}

class _DoctorPageState extends State<DoctorPage> {
  late String currentDataType;
  List<DoanhThu> reportData = [];
  final ScrollController _scrollController = ScrollController();
  final DoctorService _doctorService = DoctorService();

  @override
  void initState() {
    super.initState();
    currentDataType = widget.initialDataType;
    fetchReportData();
  }

  Future<void> fetchReportData() async {
    try {
      final data = await _doctorService.fetchReportData(currentDataType);
      setState(() {
        reportData = data;
      });
    } catch (e) {
      setState(() {
        reportData = [];
      });
    }
    _scrollController.jumpTo(0);
  }

  void _onTabButtonPressed(String dataType) {
    setState(() {
      currentDataType = dataType;
      fetchReportData();
    });
  }

  void _showDoctorRevenueChart(BuildContext context, String doctorName) {
    final List<FlSpot> dataPoints = [
      FlSpot(23, 25000000),  // 23/07
      FlSpot(24, 21000000),  // 24/07
      FlSpot(25, 34000000),  // 25/07
      FlSpot(26, 25000000),  // 26/07
      FlSpot(27, 15000000),  // 27/07
      FlSpot(28, 30000000),  // 28/07
    ];

    showDialog(
      context: context,
      builder: (context) {
        return DoctorRevenueChart(
          tenBacSi: doctorName,
          duLieu: dataPoints,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFF294157),
        child: Column(
          children: [
            SizedBox(height: 8.0),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(25.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8.0,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildTabButton(context, 'BÁC SĨ CHỈ ĐỊNH', currentDataType == 'BÁC SĨ CHỈ ĐỊNH'),
                  _buildTabButton(context, 'BÁC SĨ THỰC HIỆN', currentDataType == 'BÁC SĨ THỰC HIỆN'),
                ],
              ),
            ),
            SizedBox(height: 8.0),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                child: _buildFilterButtons(context),
              ),
            ),
            SizedBox(height: 8.0),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: reportData.isEmpty
                    ? Center(child: CircularProgressIndicator())
                    : GridView.builder(
                  controller: _scrollController,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: reportData.length,
                  itemBuilder: (context, index) {
                    final item = reportData[index];
                    return _buildReportCard(
                      context,
                      item.ten ?? 'Unknown Title',
                      item.value ?? 0.0,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButtons(BuildContext context) {
    final Color buttonColor = Colors.white.withOpacity(0.6);
    final Color textColor = Colors.black87;

    return Container(
      decoration: BoxDecoration(
        color: buttonColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => DateRangeSelector(),
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: buttonColor,
                borderRadius: BorderRadius.horizontal(left: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_today, color: textColor, size: 16),
                  SizedBox(width: 4),
                  Text(
                    'Tháng này',
                    style: TextStyle(color: textColor, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.horizontal(right: Radius.circular(20)),
            ),
            child: Icon(Icons.filter_list, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(BuildContext context, String title, bool selected) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          _onTabButtonPressed(title);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          decoration: BoxDecoration(
            color: selected ? Colors.blue : Colors.transparent,
            borderRadius: BorderRadius.circular(25.0),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                  color: selected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReportCard(BuildContext context, String title, double value) {
    final formatter = NumberFormat('#,##0', 'en_US');
    String formattedValue = formatter.format(value);

    return GestureDetector(
      onTap: () {
        _showDoctorRevenueChart(context, title);
      },
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Color(0xFF103D67),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                  title,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.only(top: 30.0),
                child: Text(
                  formattedValue + ' VND',
                  style: TextStyle(color: Colors.yellow),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
