import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../main.dart';

class HomePartition extends StatefulWidget {
  final String imagePath;
  final double latitude;
  final double longitude;

  const HomePartition(
      {Key? key,
      required this.imagePath, required this.latitude, required this.longitude})
      : super(key: key);

  @override
  State<HomePartition> createState() => _HomePartitionState();
}

class _HomePartitionState extends State<HomePartition> {
  Position? _currentPosition;
  late double _totalDistance;
  LocationPermission? permission;

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
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: InkWell(
        onTap: () {
          showAdaptiveActionSheet(
            context: context,
            actions: [
              BottomSheetAction(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    Text('حضور'),
                    SizedBox(width: 10,),
                    Icon(Icons.login),
                  ],
                ),
                onPressed: () {
                  Navigator.pop(context);
                  _calculateDistance(widget.latitude, widget.longitude, 'in');
                },
              ),
              BottomSheetAction(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    Text('إنصراف'),
                    SizedBox(width: 10,),
                    Icon(Icons.logout),
                  ],
                ),
                onPressed: () {
                  Navigator.pop(context);
                  _calculateDistance(widget.latitude, widget.longitude, 'out');
                },
              ),
              BottomSheetAction(title: SizedBox(height: MediaQuery.of(context).size.height * 0.02,), onPressed: (){}),
            ],
          );
        },
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(widget.imagePath),
              fit: BoxFit.cover,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(15)),
          ),
          alignment: Alignment.bottomLeft,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.15,
        ),
      ),
    );
  }
}
