import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _currentPinController = TextEditingController();
  final _newPinController = TextEditingController();
  final _box = Hive.box('PIN');
  bool _isCurrentPinObscured = true;
  bool _isNewPinObscured = true;

  void _changePin() {
    if (_currentPinController.text == _box.get('pin') &&
        _newPinController.text.isNotEmpty) {
      _box.put('pin', _newPinController.text);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('PIN changed successfully'),
      ));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Current PIN is incorrect or new PIN is empty'),
      ));
    }
  }

  void _toggleCurrentPinVisibility() {
    setState(() {
      _isCurrentPinObscured = !_isCurrentPinObscured;
    });
  }

  void _toggleNewPinVisibility() {
    setState(() {
      _isNewPinObscured = !_isNewPinObscured;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/images/background_pin3.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _currentPinController,
                keyboardType: TextInputType.number,
                obscureText: _isCurrentPinObscured,
                decoration: InputDecoration(
                  hintText: 'Enter current PIN',
                  suffixIcon: IconButton(
                    icon: Icon(_isCurrentPinObscured
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: _toggleCurrentPinVisibility,
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _newPinController,
                keyboardType: TextInputType.number,
                obscureText: _isNewPinObscured,
                decoration: InputDecoration(
                  hintText: 'Enter new PIN',
                  suffixIcon: IconButton(
                    icon: Icon(_isNewPinObscured
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: _toggleNewPinVisibility,
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _changePin,
                child: Text('Change PIN'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
