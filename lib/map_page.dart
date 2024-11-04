import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import 'app_lat_long.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {

  Completer<YandexMapController> mapControllerCompleter = Completer<YandexMapController>();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: YandexMap(
        onMapCreated: (controller) {
          mapControllerCompleter.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => initPermission(),
        backgroundColor: Colors.blue,
        child: Icon(Icons.location_searching),
      ),
    );
  }




  Future<void> initPermission() async {
    if (!await checkPermission()) {
      await requestPermission();
      moveToMyLocation(await getCurrentLocation());
    } else {
      moveToMyLocation(await getCurrentLocation());
    }
  }













  Future<bool> requestPermission() {
    return Geolocator.requestPermission().then((value) =>
    value == LocationPermission.always || value == LocationPermission.whileInUse).catchError((_) => false);
  }


  Future<bool> checkPermission() {
    return Geolocator.checkPermission().then((value) =>
    value == LocationPermission.always || value == LocationPermission.whileInUse).catchError((_) => false);
  }

  Future<AppLatLong> getCurrentLocation() async {
    return Geolocator.getCurrentPosition().then((value) {
      return AppLatLong(lat: value.latitude, long: value.longitude);
    }).catchError((_) => AppLatLong(lat: 41.3775, long: 64.5853),//xatolik bo'lganda default locationni ko'rsaish uchun
    );
  }



  void moveToMyLocation(AppLatLong appLatLong,) async {
    (await mapControllerCompleter.future).moveCamera(animation: const MapAnimation(type: MapAnimationType.linear, duration: 1),
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target: Point(
              latitude: appLatLong.lat,
              longitude: appLatLong.long,
            ),
            zoom: 20,
            tilt: 100
        ),
      ),
    );
  }







}
