import 'package:flutter/material.dart';

class CardWidget extends StatefulWidget {
  @override
  _CardWidgetState createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cardHolderController = TextEditingController();
  String _cardType = 'Debit';

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
          // Card type dropdown and title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'My Card',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              DropdownButton<String>(
                dropdownColor: Colors.green[800],
                value: _cardType,
                icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                underline: Container(),
                onChanged: (String? newValue) {
                  setState(() {
                    _cardType = newValue!;
                  });
                },
                items: ['Debit', 'Credit']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: TextStyle(color: Colors.white)),
                  );
                }).toList(),
              ),
            ],
          ),
          SizedBox(height: 30),
          // Card number input
          TextField(
            controller: _cardNumberController,
            maxLength: 16,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Card Number',
              labelStyle: TextStyle(color: Colors.white),
              counterText: "",
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          SizedBox(height: 30),
          // Cardholder name input
          TextField(
            controller: _cardHolderController,
            decoration: InputDecoration(
              labelText: 'Cardholder Name',
              labelStyle: TextStyle(color: Colors.white),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          SizedBox(height: 30),
          // Preview of entered details
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _cardHolderController.text.isEmpty
                    ? 'Enter Name'
                    : _cardHolderController.text,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
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

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    super.dispose();
  }
}
