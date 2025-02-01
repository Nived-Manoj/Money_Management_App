import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_management/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double balance = 0;
  List<Allocation> recentAllocations = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      balance = prefs.getDouble('balance') ?? 0;
      List<String>? allocations = prefs.getStringList('recentAllocations');
      if (allocations != null) {
        recentAllocations = allocations
            .map((allocation) => Allocation.fromJson(jsonDecode(allocation)))
            .toList();
      }
    });
  }

  Future<void> _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('balance', balance);
    List<String> allocations = recentAllocations
        .map((allocation) => jsonEncode(allocation.toJson()))
        .toList();
    prefs.setStringList('recentAllocations', allocations);
  }

  void _addBalance(double amount) {
    setState(() {
      balance += amount;
    });
    _saveData();
  }

  void _allocate(String name, double amount, DateTime allocationDate,
      DateTime returnDate, double returnAmount) {
    if (balance >= amount) {
      setState(() {
        balance -= amount;
        recentAllocations.insert(
          0,
          Allocation(
            icon: 'default_icon', // Add the appropriate icon value here
            name: name,
            amount: amount,
            allocationDate: allocationDate,
            returnDate: returnDate,
            returnAmount: returnAmount,
            percentage:
                ((returnAmount - amount) / amount * 100).toStringAsFixed(2) +
                    '%',
          ),
        );
      });
      _saveData();
    }
  }

  void _closeTransaction(Allocation allocation) {
    setState(() {
      balance += allocation.returnAmount;
      recentAllocations.remove(allocation);
    });
    _saveData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BalanceWidget(balance: balance, onAddBalance: _addBalance),
                SizedBox(height: 20),
                CardWidget(),
                SizedBox(height: 20),
                AllocationWidget(onAllocate: _allocate),
                SizedBox(height: 20),
                RecentTransactionsWidget(
                  allocations: recentAllocations,
                  onClose: _closeTransaction,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BalanceWidget extends StatelessWidget {
  final double balance;
  final Function(double) onAddBalance;

  BalanceWidget({required this.balance, required this.onAddBalance});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Balance',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 16,
            ),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\$${balance.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => _showAddBalanceDialog(context),
                child: Text(
                  'Add Balance',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddBalanceDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text('Add Balance', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Amount',
            labelStyle: TextStyle(color: Colors.grey[400]),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[700]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.green[700]!),
            ),
          ),
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[700],
            ),
            onPressed: () {
              final amount = double.tryParse(controller.text);
              if (amount != null && amount > 0) {
                onAddBalance(amount);
                Navigator.pop(context);
              }
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green[900]!, Colors.green[700]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
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
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              letterSpacing: 2,
            ),
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('John Doe',
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
  final Function(String, double, DateTime, DateTime, double) onAllocate;

  AllocationWidget({required this.onAllocate});

  @override
  _AllocationWidgetState createState() => _AllocationWidgetState();
}

class _AllocationWidgetState extends State<AllocationWidget> {
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _returnAmountController = TextEditingController();
  DateTime? _allocationDate;
  DateTime? _returnDate;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green[700],
        minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: () => _showAllocationDialog(context),
      child: Text(
        'Allocate Funds',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  void _showAllocationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text('New Allocation', style: TextStyle(color: Colors.white)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: _inputDecoration('Allocation Name'),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 12),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration('Amount'),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 12),
              TextField(
                controller: _returnAmountController,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration('Return Amount'),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 12),
              _datePickerButton(
                'Allocation Date',
                _allocationDate,
                (date) => setState(() => _allocationDate = date),
              ),
              SizedBox(height: 12),
              _datePickerButton(
                'Return Date',
                _returnDate,
                (date) => setState(() => _returnDate = date),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[700],
            ),
            onPressed: () {
              final amount = double.tryParse(_amountController.text);
              final returnAmount =
                  double.tryParse(_returnAmountController.text);
              if (_nameController.text.isNotEmpty &&
                  amount != null &&
                  returnAmount != null &&
                  _allocationDate != null &&
                  _returnDate != null) {
                widget.onAllocate(_nameController.text, amount,
                    _allocationDate!, _returnDate!, returnAmount);
                Navigator.pop(context);
                _nameController.clear();
                _amountController.clear();
                _returnAmountController.clear();
                setState(() {
                  _allocationDate = null;
                  _returnDate = null;
                });
              }
            },
            child: Text('Create'),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.grey[400]),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey[700]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.green[700]!),
      ),
    );
  }

  Widget _datePickerButton(
      String label, DateTime? date, Function(DateTime) onSelect) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[800],
        minimumSize: Size(double.infinity, 50),
      ),
      onPressed: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.dark(
                  primary: Colors.green[700]!,
                  surface: Colors.grey[900]!,
                ),
              ),
              child: child!,
            );
          },
        );
        if (picked != null) onSelect(picked);
      },
      child: Text(
        date == null
            ? label
            : '${label}: ${DateFormat('dd-MM-yyyy').format(date)}',
      ),
    );
  }
}

class RecentTransactionsWidget extends StatelessWidget {
  final List<Allocation> allocations;
  final Function(Allocation) onClose;

  RecentTransactionsWidget({required this.allocations, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Transactions',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: allocations.length,
          itemBuilder: (context, index) {
            final allocation = allocations[index];
            return AllocationItem(
              allocation: allocation,
              onClose: () => onClose(allocation),
            );
          },
        ),
      ],
    );
  }
}

class AllocationItem extends StatelessWidget {
  final Allocation allocation;
  final VoidCallback onClose;

  AllocationItem({required this.allocation, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    allocation.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                      'Allocated: ${DateFormat('dd-MM-yyyy').format(allocation.allocationDate)}',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                  Text(
                      'Return: ${DateFormat('dd-MM-yyyy').format(allocation.returnDate)}',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('\$${allocation.amount.toStringAsFixed(2)}',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text(allocation.percentage,
                    style: TextStyle(color: Colors.green, fontSize: 12)),
                Text('Return: \$${allocation.returnAmount.toStringAsFixed(2)}',
                    style: TextStyle(color: Colors.blue, fontSize: 12)),
              ],
            ),
          ],
        ));
  }
}

// Allocation model with toJson and fromJson methods
class Allocation {
  final String icon;
  final String name;
  final double amount;
  final String percentage;
  final DateTime allocationDate;
  final DateTime returnDate;
  final double returnAmount;

  Allocation({
    required this.icon,
    required this.name,
    required this.amount,
    required this.percentage,
    required this.allocationDate,
    required this.returnDate,
    required this.returnAmount,
  });

  Map<String, dynamic> toJson() {
    return {
      'icon': icon,
      'name': name,
      'amount': amount,
      'percentage': percentage,
      'allocationDate': allocationDate.toIso8601String(),
      'returnDate': returnDate.toIso8601String(),
      'returnAmount': returnAmount,
    };
  }

  factory Allocation.fromJson(Map<String, dynamic> json) {
    return Allocation(
      icon: json['icon'],
      name: json['name'],
      amount: json['amount'],
      percentage: json['percentage'],
      allocationDate: DateTime.parse(json['allocationDate']),
      returnDate: DateTime.parse(json['returnDate']),
      returnAmount: json['returnAmount'],
    );
  }
}
