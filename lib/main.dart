import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Random Number Receiver',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RandomNumberScreen(),
    );
  }
}

class RandomNumberScreen extends StatefulWidget {
  @override
  _RandomNumberScreenState createState() => _RandomNumberScreenState();
}

class _RandomNumberScreenState extends State<RandomNumberScreen> {
  String _number = 'Press the button to get a number';
  String _countdownMessage = '';
  int _countdown = 10;
  Timer? _timer;

  Future<int> _fetchNumber() async {
    var url =
        "http://192.168.107.144:5000/random_number"; // Edit the IP part according to the IP Address
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      int number = json.decode(response.body)[
          'random_number']; // Server returning a JSON object with a number field
      return number;
    } else {
      throw Exception('Failed to load number');
    }
  }

  void _startCountdown() {
    _countdown = 10;
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (_countdown == 0) {
        setState(() {
          _countdownMessage = 'Press the button to fetch another number!';
          timer.cancel();
        });
      } else {
        setState(() {
          _countdownMessage = 'Time remaining: $_countdown seconds';
          _countdown--;
        });
      }
    });
  }

  void _updateNumber() async {
    try {
      int getNumber = await _fetchNumber();
      setState(() {
        _number = "Random Number: $getNumber";
        _countdownMessage = '';
        _startCountdown();
      });
    } catch (e) {
      setState(() {
        _number = "Failed to load number";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Random Number HC-05 Bluetooth Module Receiver'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _number,
              style: Theme.of(context).textTheme.headline4,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateNumber,
              child: Text('Get Random Number'),
            ),
            SizedBox(height: 20),
            Text(
              _countdownMessage,
              style: _countdown == 0
                  ? TextStyle(color: Colors.green, fontSize: 16)
                  : TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
