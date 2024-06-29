import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'notes_screen.dart';

class PinScreen extends StatefulWidget {
  @override
  _PinScreenState createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  final _pinController = TextEditingController();
  final _initialPinController = TextEditingController();
  Box? _box;
  bool _isPinVisible = false;
  bool _isInitialPinVisible = false;

  @override
  void initState() {
    super.initState();
    _initHive();
  }

  Future<void> _initHive() async {
    _box = await Hive.openBox('PIN');
    if (!_box!.containsKey('pin')) {
      _setInitialPin();
    }
  }

  void _setInitialPin() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(1),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                'Set Initial PIN',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: TextField(
                controller: _initialPinController,
                keyboardType: TextInputType.number,
                obscureText: !_isInitialPinVisible,
                decoration: InputDecoration(
                  hintText: 'Enter new PIN',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isInitialPinVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isInitialPinVisible = !_isInitialPinVisible;
                      });
                    },
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    if (_initialPinController.text.isNotEmpty) {
                      _box!.put('pin', _initialPinController.text);
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text('Set PIN'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _checkPin() {
    if (_pinController.text == _box!.get('pin')) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => NotesScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Incorrect PIN'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        'Enter PIN',
        style: TextStyle(fontWeight: FontWeight.bold),
      )),
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _pinController,
                keyboardType: TextInputType.number,
                obscureText: !_isPinVisible,
                decoration: InputDecoration(
                  hintText: 'Enter PIN',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPinVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPinVisible = !_isPinVisible;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _checkPin,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
