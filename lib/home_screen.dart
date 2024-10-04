import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double balance = 0;
  List<Allocation> recentAllocations = [];

  // Method to allocate money and add details
  void allocate(String name, double amount, String icon,
      DateTime allocationDate, DateTime returnDate, double returnAmount) {
    if (balance >= amount) {
      setState(() {
        balance -= amount;
        recentAllocations.insert(
          0,
          Allocation(
            icon: icon,
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
    }
  }

  // Method to add balance manually
  void addBalance(double amount) {
    setState(() {
      balance += amount;
    });
  }

  // Method to close a transaction and add return amount to balance
  void closeTransaction(Allocation allocation) {
    setState(() {
      balance += allocation.returnAmount;
      recentAllocations.remove(allocation);
    });
  }

  // Method to delete a transaction
  void deleteTransaction(Allocation allocation) {
    setState(() {
      recentAllocations.remove(allocation);
    });
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
                BalanceWidget(balance: balance, onAddBalance: addBalance),
                SizedBox(height: 20),
                CardWidget(),
                SizedBox(height: 20),
                AllocationWidget(onAllocate: allocate),
                SizedBox(height: 20),
                RecentAllocationWidget(
                    allocations: recentAllocations,
                    onCloseTransaction: closeTransaction,
                    onDeleteTransaction: deleteTransaction),
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
  final Function(double) onAddBalance;

  BalanceWidget({required this.balance, required this.onAddBalance});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _balanceController = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Balance',
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '\$${balance.toStringAsFixed(2)}',
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            ElevatedButton(
              child: Text('Add Balance'),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Add Balance'),
                    content: TextField(
                      controller: _balanceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Enter Amount',
                      ),
                    ),
                    actions: [
                      TextButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text('Add'),
                        onPressed: () {
                          final double amount =
                              double.tryParse(_balanceController.text) ?? 0;
                          if (amount > 0) {
                            onAddBalance(amount);
                            Navigator.of(context).pop();
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        SizedBox(height: 10),
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
  final Function(String, double, String, DateTime, DateTime, double) onAllocate;

  AllocationWidget({required this.onAllocate});

  @override
  _AllocationWidgetState createState() => _AllocationWidgetState();
}

class _AllocationWidgetState extends State<AllocationWidget> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _returnAmountController = TextEditingController();
  String _selectedIcon = '🔹';
  DateTime? _allocationDate;
  DateTime? _returnDate;
  bool _isAllocating = false;

  // Helper to show a date picker and format date
  Future<void> _selectDate(
      BuildContext context, Function(DateTime) onSelect) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (pickedDate != null) onSelect(pickedDate);
  }

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
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Allocation Amount',
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
          TextField(
            controller: _returnAmountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Return Amount',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  child: Text(_allocationDate == null
                      ? 'Select Allocation Date'
                      : DateFormat('dd-MM-yyyy').format(_allocationDate!)),
                  onPressed: () {
                    _selectDate(context, (date) {
                      setState(() {
                        _allocationDate = date;
                      });
                    });
                  },
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  child: Text(_returnDate == null
                      ? 'Select Return Date'
                      : DateFormat('dd-MM-yyyy').format(_returnDate!)),
                  onPressed: () {
                    _selectDate(context, (date) {
                      setState(() {
                        _returnDate = date;
                      });
                    });
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
        ],
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                child: Text(_isAllocating ? 'Confirm' : 'Allocate'),
                onPressed: () {
                  if (_isAllocating) {
                    final double amount =
                        double.tryParse(_amountController.text) ?? 0;
                    final double returnAmount =
                        double.tryParse(_returnAmountController.text) ?? 0;

                    if (_nameController.text.isNotEmpty &&
                        amount > 0 &&
                        _allocationDate != null &&
                        _returnDate != null) {
                      widget.onAllocate(
                        _nameController.text,
                        amount,
                        _selectedIcon,
                        _allocationDate!,
                        _returnDate!,
                        returnAmount,
                      );
                      setState(() {
                        _isAllocating = false;
                        _nameController.clear();
                        _amountController.clear();
                        _returnAmountController.clear();
                        _allocationDate = null;
                        _returnDate = null;
                        _selectedIcon = '🔹';
                      });
                    }
                  } else {
                    setState(() {
                      _isAllocating = true;
                    });
                  }
                },
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
  final Function(Allocation) onCloseTransaction;
  final Function(Allocation) onDeleteTransaction;

  RecentAllocationWidget(
      {required this.allocations,
      required this.onCloseTransaction,
      required this.onDeleteTransaction});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Recent Transactions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 20),
        ...allocations.map((allocation) {
          return GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Manage Transaction'),
                  content: Text(
                      'Would you like to close or delete this transaction?'),
                  actions: [
                    TextButton(
                      child: Text('Close'),
                      onPressed: () {
                        onCloseTransaction(allocation);
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text('Delete'),
                      onPressed: () {
                        onDeleteTransaction(allocation);
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              );
            },
            child: AllocationItem(
              icon: allocation.icon,
              name: allocation.name,
              amount: '\$${allocation.amount}',
              percentage: allocation.percentage,
              allocationDate: allocation.allocationDate,
              returnDate: allocation.returnDate,
              returnAmount: allocation.returnAmount,
            ),
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
  final DateTime allocationDate;
  final DateTime returnDate;
  final double returnAmount;

  AllocationItem(
      {required this.icon,
      required this.name,
      required this.amount,
      required this.percentage,
      required this.allocationDate,
      required this.returnDate,
      required this.returnAmount});

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
              Text(
                  'Allocated: ${DateFormat('dd-MM-yyyy').format(allocationDate)}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              Text('Return: ${DateFormat('dd-MM-yyyy').format(returnDate)}',
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
            Text('Return: \$${returnAmount.toStringAsFixed(2)}',
                style: TextStyle(color: Colors.blue, fontSize: 12)),
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
            onPressed: () {}),
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
  final DateTime allocationDate;
  final DateTime returnDate;
  final double returnAmount;

  Allocation(
      {required this.icon,
      required this.name,
      required this.amount,
      required this.percentage,
      required this.allocationDate,
      required this.returnDate,
      required this.returnAmount});
}
