import 'package:flutter/material.dart';
import 'package:money_management/spends.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BalanceWidget(),
              SizedBox(height: 20),
              CardWidget(),
              SizedBox(height: 20),
              AllocationWidget(),
              SizedBox(height: 20),
              RecentAllocationWidget(),
              Spacer(),
              BottomNavigationWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

class BalanceWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Balance',
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
        Text(
          '\$80,020',
          style: TextStyle(
              fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'See money allocation',
              style: TextStyle(color: Colors.blue[400], fontSize: 16),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.blue[400]),
          ],
        ),
      ],
    );
  }
}

class CardWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue[400],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('My Card',
                  style: TextStyle(color: Colors.white, fontSize: 18)),
              Text('Debit',
                  style: TextStyle(color: Colors.white, fontSize: 18)),
            ],
          ),
          SizedBox(height: 30),
          Text(
            '4873 4983 4837 1234',
            style:
                TextStyle(color: Colors.white, fontSize: 22, letterSpacing: 2),
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Asep Dedi Rukmana',
                  style: TextStyle(color: Colors.white, fontSize: 16)),
              Container(
                width: 40,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AllocationWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text('\$ 50.000',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          flex: 1,
          child: ElevatedButton(
            child: Text('Allocate'),
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              primary: Colors.blue[400],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              padding: EdgeInsets.symmetric(vertical: 15),
            ),
          ),
        ),
      ],
    );
  }
}

class RecentAllocationWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Recent Investments',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 20),
        AllocationItem(
            icon: '🚗',
            name: 'Car Washing Company',
            amount: '\$10,000',
            percentage: '5,00%'),
        SizedBox(height: 20),
        AllocationItem(
            icon: '₿',
            name: 'Bitcoin',
            amount: '\$75,500',
            percentage: '25,00%'),
        SizedBox(height: 20),
        AllocationItem(
            icon: 'F',
            name: 'Fixed Deposit',
            amount: '\$50,000',
            percentage: '7,00%'),
        SizedBox(height: 20),
        AllocationItem(
            icon: 'G', name: 'Gold', amount: '\$1,000', percentage: '1,00%'),
      ],
    );
  }
}

class AllocationItem extends StatelessWidget {
  final String icon;
  final String name;
  final String amount;
  final String percentage;

  AllocationItem(
      {required this.icon,
      required this.name,
      required this.amount,
      required this.percentage});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(icon, style: TextStyle(fontSize: 24)),
        ),
        SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text('12:40 am, 21 Jun 2021',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12)),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(amount,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(percentage,
                style: TextStyle(color: Colors.green, fontSize: 12)),
          ],
        ),
      ],
    );
  }
}

class BottomNavigationWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
            icon: Icon(Icons.home, color: Colors.blue), onPressed: () {}),
        IconButton(
            icon: Icon(Icons.calendar_today, color: Colors.grey),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OverviewScreen(),
                  ));
            }),
        IconButton(
            icon: Icon(Icons.notifications, color: Colors.grey),
            onPressed: () {}),
        IconButton(
            icon: Icon(Icons.person, color: Colors.grey), onPressed: () {}),
      ],
    );
  }
}
