import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class InternetCheckWidget extends StatefulWidget {
  final Widget child;

  const InternetCheckWidget({Key? key, required this.child}) : super(key: key);

  @override
  _InternetCheckWidgetState createState() => _InternetCheckWidgetState();
}

class _InternetCheckWidgetState extends State<InternetCheckWidget> {
  bool _isConnected = true;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    Connectivity().onConnectivityChanged.listen((result) {
      setState(() {
        _isConnected = result != ConnectivityResult.none;
      });
    });
  }

  Future<void> _checkConnectivity() async {
    var result = await Connectivity().checkConnectivity();
    setState(() {
      _isConnected = result != ConnectivityResult.none;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isConnected
        ? widget.child
        : Center(
      child: Text(
        'No Internet Connection',
        style: TextStyle(fontSize: 18, color: Colors.red),
      ),
    );
  }
}
