import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class OverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Implement the action to add expenses
          },
          child: Icon(Icons.add),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                SizedBox(height: 20),
                _buildBalanceSection(context),
                SizedBox(height: 20),
                _buildChart(),
                SizedBox(height: 20),
                TabBar(
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Colors.cyan,
                  tabs: [
                    Tab(text: 'Incomes'),
                    Tab(text: 'Expenses'),
                  ],
                ),
                SizedBox(height: 20),
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildIncomesList(),
                      _buildExpensesList(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back, color: Colors.black),
        ),
        Text(
          'Overview',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        CircleAvatar(
          backgroundImage: NetworkImage('https://example.com/avatar.jpg'),
          radius: 20,
        ),
      ],
    );
  }

  Widget _buildBalanceSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '\$80,020',
          style: TextStyle(
              fontSize: 36, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _buildChart() {
    return Container(
      height: 200,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: 6,
          minY: 0,
          maxY: 6,
          lineBarsData: [
            LineChartBarData(
              spots: [
                FlSpot(0, 3),
                FlSpot(1, 1),
                FlSpot(2, 4),
                FlSpot(3, 2),
                FlSpot(4, 5),
                FlSpot(5, 3),
                FlSpot(6, 4),
              ],
              color: Colors.cyan,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(show: false),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIncomesList() {
    return Column(
      children: [
        _buildIncomeItem(Icons.lightbulb_outline, 'Electricity',
            'June 2, 05:20pm', '+\$250'),
        _buildIncomeItem(
            Icons.fitness_center, 'Gym', 'June 16, 01:30pm', '+\$100'),
        _buildIncomeItem(Icons.movie, 'Netflix', 'June 24, 08:10am', '+\$55'),
        _buildIncomeItem(
            Icons.local_gas_station, 'Gas', 'June 26, 08:10am', '+\$70'),
      ],
    );
  }

  Widget _buildExpensesList() {
    return Column(
      children: [
        _buildExpenseItem(Icons.lightbulb_outline, 'Electricity',
            'June 2, 05:20pm', '-\$250'),
        _buildExpenseItem(
            Icons.fitness_center, 'Gym', 'June 16, 01:30pm', '-\$100'),
        _buildExpenseItem(Icons.movie, 'Netflix', 'June 24, 08:10am', '-\$55'),
        _buildExpenseItem(
            Icons.local_gas_station, 'Gas', 'June 26, 08:10am', '-\$70'),
      ],
    );
  }

  Widget _buildIncomeItem(
      IconData icon, String title, String date, String amount) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.black),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
                Text(date, style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          Text(amount,
              style:
                  TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildExpenseItem(
      IconData icon, String title, String date, String amount) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.black),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
                Text(date, style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          Text(amount,
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
