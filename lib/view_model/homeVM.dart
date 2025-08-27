import 'package:breeze/model/weatherModel.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:location/location.dart' hide LocationAccuracy;

import '../model/cities.dart';
import '../repository/weatherRepository.dart';
import '../res/assets/constants.dart';
import '../utils/Utils.dart';

class HomeVM extends GetxController{

  String locationMessage = "Press button to get location";
  RxString lat = "".obs;
  RxString long = "".obs;
  final _repo=WeatherRepo();
  var weather=Weather().obs;
  RxBool search=false.obs;

  //
  final scrollController = TextEditingController();
  final focusNode = FocusNode();
  RxList<Cities> cities =Constants.cities.obs;
  void onSearchTextChanged(String text) {
    if (text.isEmpty) {
      cities.value = Constants.cities;
    } else {

      cities.value =Constants.cities.where((city) =>city.name.toLowerCase().startsWith(text.toLowerCase())).toList().isNotEmpty?Constants.cities.where((city) =>city.name.toLowerCase().startsWith(text.toLowerCase())).toList() :Constants.cities
          .where((city) =>
          city.name.toLowerCase().contains(text.toLowerCase()))
          .toList();
    }
  }


  Future<void>getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Utils.toast("Location services are disabled", Colors.red);
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Utils.toast("Location permission denied", Colors.red);
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Utils.toast("Location permission denied forever", Colors.red);
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

      lat.value= position.latitude.toString();
      long.value= position.longitude.toString();
  }


  Future<void>getWeatherData() async {
    weather.value=await Weather.fromJson(await _repo.getWeatherData(lat.value, long.value));
  }





}