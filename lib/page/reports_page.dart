import 'package:flutter/material.dart';
import '../services/getapi.dart';
import '../widgets/custom_tab_bar.dart';
import 'dashboard.dart';
import 'revenue.dart';
import 'doctor.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({Key? key}) : super(key: key);

  @override
  ReportsPageState createState() => ReportsPageState();
}

class ReportsPageState extends State<ReportsPage> {
  String currentTab = "DASHBOARD";
  final GetApi getapi = GetApi();

  Widget _getContentForCurrentTab() {
    switch (currentTab) {
      case "DASHBOARD":
        return DashboardPage(getapi: getapi);
      case "DOANH THU":
        return const RevenuePage();
      case "BÁC SĨ":
        return DoctorPage(initialDataType: 'BÁC SĨ CHỈ ĐỊNH',);
        //return const DoctorPage();
      default:
        return DashboardPage(getapi: getapi);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('REPORTS'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              // Xử lý khi nhấn vào nút tài khoản
            },
          ),
        ],
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            color: const Color(0xFFD9D9D9),
            height: 1.0,
          ),
          CustomTabBar(
            currentTab: currentTab,
            onTabSelected: (tab) {
              setState(() {
                currentTab = tab;
              });
            },
          ),
          const SizedBox(height: 37),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFF294157),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
                child: _getContentForCurrentTab(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}