import 'package:flutter/material.dart';

import '../data/network/networkApiServices.dart';
import '../res/urls/urls.dart';
import '../utils/Utils.dart';

class WeatherRepo{


  final _apiServices=NetworkApiServices();
  Future<dynamic> getWeatherData(String lat,String long) async {
    return await _apiServices.getApi(AppUrls.getWeatherForecast+"?"+AppUrls.key+"&q=$lat,$long", {});

  }
}