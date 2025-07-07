import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class RunningTrackScreen extends StatefulWidget {
  @override
  _RunningTrackScreenState createState() => _RunningTrackScreenState();
}

class _RunningTrackScreenState extends State<RunningTrackScreen> {
  GoogleMapController? mapController;
  LatLng? currentPosition;
  List<LatLng> routePoints = []; // 存储用户的路线

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  // 获取用户当前位置
  Future<void> _getCurrentLocation() async {
    final hasPermission = await _checkLocationPermission();
    if (!hasPermission) return;

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      currentPosition = LatLng(position.latitude, position.longitude);
      routePoints.add(currentPosition!); // 起始位置加入路线
    });

    // 持续监听用户位置变化
    Geolocator.getPositionStream(
        locationSettings:
        const LocationSettings(accuracy: LocationAccuracy.high))
        .listen((Position newPosition) {
      setState(() {
        routePoints.add(LatLng(newPosition.latitude, newPosition.longitude));
      });
    });
  }

  // 检查并请求定位权限
  Future<bool> _checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Location permission denied")));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Location permissions are permanently denied")));
      return false;
    }
    return true;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Running Track"),
      ),
      body: currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
        initialCameraPosition: CameraPosition(
          target: currentPosition!,
          zoom: 15,
        ),
        onMapCreated: (controller) => mapController = controller,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        polylines: {
          Polyline(
            polylineId: const PolylineId("runningRoute"),
            points: routePoints,
            color: Colors.blue,
            width: 5,
          ),
        },
      ),
    );
  }
}
