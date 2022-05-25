import 'package:final_bassem/Screens/attendace.dart';
import 'package:final_bassem/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hexcolor/hexcolor.dart';

import '../widgets/home_partition.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Position? _currentPosition;
  late double _totalDistance;
  LocationPermission? permission;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //HandleAttendance().getSubmitData();
  }

  Future _calculateDistance(double latitude, double longitude, String inOut) async {
    permission = await Geolocator.checkPermission();
    if (await Geolocator.isLocationServiceEnabled()) {
      Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
          .then((Position position) {
        setState(() {
          _currentPosition = position;
          _totalDistance = Geolocator.distanceBetween(
            latitude,
            longitude,
            _currentPosition!.latitude,
            _currentPosition!.longitude,
          );
        });
        if (_totalDistance < 20) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => MyHomePage(inOut: inOut,)),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'get ${_totalDistance > 1000 ? (_totalDistance / 1000).toStringAsFixed(2) : _totalDistance.toStringAsFixed(2)} ${_totalDistance > 1000 ? 'KM' : 'meters'} more closer'),
              duration: const Duration(seconds: 1),
            ),
          );
        }
      }).catchError((err) {
        if (kDebugMode) {
          print(err);
        }
      });
    } else {
      if (kDebugMode) {
        print("GPS is off.");
      }
      await Geolocator.requestPermission();
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content:  const Text('Make sure your GPS is on!'),
              actions: <Widget>[
                TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    })
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(right: 10, left: 10, top: 50),
        decoration: BoxDecoration(
            color: HexColor('#001b26'),
        ),
        child: Column(
          children: const [
            HomePartition(
              latitude: 30.1036198,
              longitude: 31.3087801,
              imagePath: 'assets/images/2dara.jpg',
            ),
            HomePartition(
              latitude: 30.1264050,
              longitude: 31.3332300,
              imagePath: 'assets/images/so5na.jpg',
            ),
            HomePartition(
              latitude: 30.1341857,
              longitude: 31.3411773,
              imagePath: 'assets/images/3almen.jpg',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.cyan,
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const Attendance())),
        child: const Icon(Icons.notes),
      ),
    );
  }
}
