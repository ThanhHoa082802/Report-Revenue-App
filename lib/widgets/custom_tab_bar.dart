import 'package:flutter/material.dart';

class CustomTabBar extends StatelessWidget {
  final String currentTab;
  final Function(String) onTabSelected;

  const CustomTabBar({super.key, required this.currentTab, required this.onTabSelected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top:30.0),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.blue.shade100,
          borderRadius: BorderRadius.circular(25.0),
        ),
        child: Row(
          children: <Widget>[
            _buildTabItem("DASHBOARD"),
            _buildTabItem("DOANH THU"),
            _buildTabItem("BÁC SĨ"),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem(String tabTitle) {
    bool isSelected = tabTitle == currentTab;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTabSelected(tabTitle),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue : Colors.transparent,
            borderRadius: BorderRadius.circular(25.0),
          ),
          child: Center(
            child: Text(
              tabTitle,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}