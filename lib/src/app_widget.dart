import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;

import 'app_controller.dart';

JsonEncoder encoder = const JsonEncoder.withIndent('     ');

class AppPage extends StatefulWidget {
  const AppPage({super.key});

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  final controller = AppController();
  late bool _enabled;
  late String _content;

  @override
  void initState() {
    _enabled = false;
    _content = '';

    controller
        .init(
      onLocation: _onLocation,
    )
        .then((bg.State state) async {
      await controller.enableBackground(true);
      setState(() {
        _enabled = state.enabled;
      });
    });

    super.initState();
  }

  void _onLocation(bg.Location location) {
    print('[location] - $location');

    final String odometerKM = (location.odometer / 1000.0).toStringAsFixed(1);
    print(odometerKM);

    setState(() {
      _content = encoder.convert(location.toMap());

    // location.coords.latitude
    // location.coords.longitude 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Background Geolocation'),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: MaterialButton(
                minWidth: 50.0,
                color: _enabled ? Colors.red : Colors.green,
                onPressed: () {
                  setState(() {
                    _enabled = !_enabled;
                  });
                  controller.enableBackground(_enabled);
                },
                child: Icon(_enabled ? Icons.pause : Icons.play_arrow,
                    color: Colors.white)),
          ),
        ],
      ),
      body: SingleChildScrollView(child: Text(_content)),
    );
  }
}
