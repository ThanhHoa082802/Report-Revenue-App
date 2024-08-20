import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../model/main_model.dart';
import '../services/getapi.dart';


class DateRangeSelector extends StatefulWidget {
  @override
  _DateRangeSelectorState createState() => _DateRangeSelectorState();
}

class _DateRangeSelectorState extends State<DateRangeSelector> {
  DateTime? _fromDate;
  DateTime? _toDate;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Chọn khoảng thời gian',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),
            _buildDateSelector('Từ:', _fromDate, (date) => setState(() => _fromDate = date)),
            SizedBox(height: 10),
            _buildDateSelector('Đến:', _toDate, (date) => setState(() => _toDate = date)),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                child: Text('Tìm kiếm'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  // Xử lý tìm kiếm ở đây
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector(String label, DateTime? selectedDate, Function(DateTime) onDateSelected) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          width: 50, // chiều rộng của box chọn ngày
          child: Text(label, style: TextStyle(fontSize: 16)),
        ),
        SizedBox(width: 10),
        Expanded(
          child: InkWell(
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: selectedDate ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (picked != null) {
                onDateSelected(picked);
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 13),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedDate != null
                        ? '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'
                        : 'Chọn ngày',
                    style: TextStyle(fontSize: 16),
                  ),
                  Icon(Icons.calendar_today),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}


class DashboardPage extends StatelessWidget {
  final GetApi getapi;

  const DashboardPage({Key? key, required this.getapi}) : super(key: key);


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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getapi.fetchDoanhThuData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          double maxY = getapi.revenueItems.isNotEmpty
              ? getapi.revenueItems.map((e) => e.value).reduce((a, b) => a > b ? a : b)
              : 0;

          return Container(
            color: const Color(0xFF294157),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: _buildFilterButtons(context), // Truyền context vào đây
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: PageView.builder(
                        itemCount: (getapi.revenueItems.length / 5).ceil(),
                        itemBuilder: (context, pageIndex) {
                          int startIndex = pageIndex * 5;
                          int endIndex = (startIndex + 5 < getapi.revenueItems.length)
                              ? startIndex + 5
                              : getapi.revenueItems.length;
                          List<MainModel> pageItems = getapi.revenueItems.sublist(startIndex, endIndex);

                          return _buildChart(pageItems, maxY);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildChart(List<MainModel> pageItems, double maxY) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 45, 16, 32),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxY,
          minY: 0,
          barTouchData: BarTouchData(
            enabled: false,
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (group) => Colors.transparent,
              tooltipPadding: EdgeInsets.zero,
              tooltipMargin: 10,
              getTooltipItem: (
                  BarChartGroupData group,
                  int groupIndex,
                  BarChartRodData rod,
                  int rodIndex,
                  ) {
                String tooltipText;
                if (rod.toY >= 1000000) {
                  double millions = rod.toY / 1000000;
                  String formattedMillions = millions.toStringAsFixed(2).replaceAll(RegExp(r'\.?0+$'), '');
                  tooltipText = '$formattedMillions Tr';
                } else if (rod.toY >= 1000) {
                  tooltipText = '${(rod.toY / 1000).toStringAsFixed(0)} N';
                } else {
                  tooltipText = rod.toY.toStringAsFixed(0);
                }
                return BarTooltipItem(
                  tooltipText,
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 120, // Tăng khoảng trống cho title nghiêng
                getTitlesWidget: (value, meta) {
                  if (value.toInt() >= 0 && value.toInt() < pageItems.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 10.0, left: 30),
                      child: Transform.rotate(
                        angle: -45 * 3.14159 / 180, // Chuyển đổi -45 độ sang radians
                        child: SizedBox(
                          width: 65, // Điều chỉnh chiều rộng theo nhu cầu
                          child: Text(
                            pageItems[value.toInt()].title,
                            style: TextStyle(color: Colors.white, fontSize: 10),
                            textAlign: TextAlign.right,
                            maxLines: 2, // Giới hạn số dòng
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    );
                  }
                  return Text('');
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '${(value / 1000000).toStringAsFixed(0)} Tr',
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  );
                },
              ),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: FlGridData(
            show: true,
            drawHorizontalLine: true,
            drawVerticalLine: true,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.white.withOpacity(0.2),
                strokeWidth: 1,
                dashArray: [5, 5],
              );
            },
            getDrawingVerticalLine: (value) {
              return FlLine(
                color: Colors.white.withOpacity(0.2),
                strokeWidth: 1,
                dashArray: [5, 5],
              );
            },
          ),
          borderData: FlBorderData(
            show: true,
            border: Border(
              left: BorderSide(color: Colors.white.withOpacity(0.5)),
              bottom: BorderSide(color: Colors.white.withOpacity(0.5)),
            ),
          ),
          barGroups: pageItems.asMap().entries.map((entry) {
            return BarChartGroupData(
              x: entry.key,
              barRods: [
                BarChartRodData(
                  toY: entry.value.value,
                  color: Colors.lightBlueAccent,
                  width: 16,
                ),
              ],
              showingTooltipIndicators: [0],
            );
          }).toList(),
        ),
      ),
    );
  }
}