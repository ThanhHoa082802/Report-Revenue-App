import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DoctorRevenueChart extends StatelessWidget {
  final String tenBacSi;
  final List<FlSpot> duLieu;

  DoctorRevenueChart({required this.tenBacSi, required this.duLieu});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        width: MediaQuery.of(context).size.width * 0.90,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Biểu đồ doanh thu - $tenBacSi',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.red, // Đặt màu chữ là màu đỏ
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Từ ngày 23/07 đến 28/07',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Container(
              height: 200,
              child: LineChart(_buildChartData()),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'Đóng',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      ],
    );
  }

  LineChartData _buildChartData() {
    return LineChartData(
      gridData: FlGridData(show: true),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              if (value % 10 == 0) {
                return Text((value / 1000000).toStringAsFixed(0) + ' Tr');
              }
              return Text('');
            },
            reservedSize: 40,
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              switch (value.toInt()) {
                case 23:
                  return Text('23');
                case 24:
                  return Text('24');
                case 25:
                  return Text('25');
                case 26:
                  return Text('26');
                case 27:
                  return Text('27');
                case 28:
                  return Text('28');
                default:
                  return Text('');
              }
            },
            reservedSize: 40,
          ),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false), // Ẩn tiêu đề ở phía trên biểu đồ
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false), // Ẩn tiêu đề ở phía bên phải biểu đồ
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: Colors.black12),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: duLieu,
          isCurved: true,
          color: Colors.blue,
          barWidth: 2,
          belowBarData: BarAreaData(
            show: true,
            color: Colors.blue.withOpacity(0.3),
          ),
        ),
      ],
    );
  }
}
