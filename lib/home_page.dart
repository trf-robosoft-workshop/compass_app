import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_compass/flutter_compass.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _hasPermissions = false;
  CompassEvent? _lastRead;
  DateTime? _lastReadAt;

  @override
  void initState() {
    super.initState();
    _fetchPermissionStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Flutter Compass'),
      ),
      body:
      Builder(
        builder: (context) {
        if (_hasPermissions) {
          return Column(
            children: <Widget>[
              _buildManualReader(),
              Expanded(child: _buildCompass()),
            ],
          );
        } else {
          return _buildPermissionSheet();
        }
      }
      ),
    );
  }

  Widget _buildManualReader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: <Widget>[
          ElevatedButton(
            child: Text('Refresh'),
            onPressed: () async {
              final CompassEvent tmp = await FlutterCompass.events!.first;
              setState(() {
                _lastRead = tmp;
                _lastReadAt = DateTime.now();
              });
            },
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('$_lastRead', style: TextStyle(fontSize: 14)),
                  SizedBox(
                    height: 10,
                  ),
                  Text('$_lastReadAt', style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompass() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: 
      StreamBuilder<CompassEvent>(
        stream: FlutterCompass.events,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error reading heading: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          double? direction = snapshot.data!.heading;

          if (direction == null)
            return Center(
              child: Text("Device does not have sensors !"),
            );

          return Card(
            shape: CircleBorder(),
            clipBehavior: Clip.antiAlias,
            elevation: 4.0,
            child: Container(
              padding: EdgeInsets.all(16.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Transform.rotate(
                angle: (direction * (math.pi / 180 * -1)),
                child: Image.asset('assets/images/compass.jpg'),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPermissionSheet() {
    return Center(
      child: Column(
       mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Location Permission Required'),
          ElevatedButton(
            child: Text('Request Permissions'),
            onPressed: () {
              Permission.locationWhenInUse.request().then((ignored) {
                _fetchPermissionStatus();
              });
            },
          ),

        ],
      ),
    );
  }

  void _fetchPermissionStatus() {
    Permission.locationWhenInUse.status.then((status) {
      print('status $status');
        setState(() => _hasPermissions = status == PermissionStatus.granted); 
      print(_hasPermissions);
    });
  }
}
