import 'package:flutter/material.dart';
import 'package:money_management/spends.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double balance = 80020;
  List<Allocation> recentAllocations = [];

  void allocate(String name, double amount, String icon) {
    if (balance >= amount) {
      setState(() {
        balance -= amount;
        recentAllocations.insert(
          0,
          Allocation(
            icon: icon,
            name: name,
            amount: amount,
            percentage: ((amount / 80020) * 100).toStringAsFixed(2) + '%',
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BalanceWidget(balance: balance),
                SizedBox(height: 20),
                CardWidget(),
                SizedBox(height: 20),
                AllocationWidget(onAllocate: allocate),
                SizedBox(height: 20),
                RecentAllocationWidget(allocations: recentAllocations),
                SizedBox(height: 20), // Add some space to avoid overflow
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationWidget(),
    );
  }
}

class BalanceWidget extends StatelessWidget {
  final double balance;

  BalanceWidget({required this.balance});

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
          '\$${balance.toStringAsFixed(2)}',
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

class AllocationWidget extends StatefulWidget {
  final Function(String, double, String) onAllocate;

  AllocationWidget({required this.onAllocate});

  @override
  _AllocationWidgetState createState() => _AllocationWidgetState();
}

class _AllocationWidgetState extends State<AllocationWidget> {
  final TextEditingController _nameController = TextEditingController();
  String _selectedIcon = '🔹';
  final double _allocationAmount = 1000;
  bool _isAllocating = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_isAllocating) ...[
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Allocation Name',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 10),
          DropdownButton<String>(
            value: _selectedIcon,
            items: ['🔹', '🔸', '🔺', '🔻'].map((String icon) {
              return DropdownMenuItem<String>(
                value: icon,
                child: Text(icon, style: TextStyle(fontSize: 24)),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedIcon = newValue!;
              });
            },
          ),
          SizedBox(height: 10),
        ],
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text('\$ 1000',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              flex: 1,
              child: ElevatedButton(
                child: Text(_isAllocating ? 'Confirm' : 'Allocate'),
                onPressed: () {
                  if (_isAllocating) {
                    if (_nameController.text.isNotEmpty) {
                      widget.onAllocate(_nameController.text, _allocationAmount,
                          _selectedIcon);
                      setState(() {
                        _isAllocating = false;
                        _nameController.clear();
                        _selectedIcon = '🔹';
                      });
                    }
                  } else {
                    setState(() {
                      _isAllocating = true;
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[400],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class RecentAllocationWidget extends StatelessWidget {
  final List<Allocation> allocations;

  RecentAllocationWidget({required this.allocations});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Recent Investments',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 20),
        ...allocations.map((allocation) {
          return Column(
            children: [
              AllocationItem(
                icon: allocation.icon,
                name: allocation.name,
                amount: '\$${allocation.amount}',
                percentage: allocation.percentage,
              ),
              SizedBox(height: 20),
            ],
          );
        }).toList(),
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

class Allocation {
  final String icon;
  final String name;
  final double amount;
  final String percentage;

  Allocation(
      {required this.icon,
      required this.name,
      required this.amount,
      required this.percentage});
}
