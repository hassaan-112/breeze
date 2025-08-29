import 'package:breeze/res/assets/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../res/urls/weatherUtils.dart';
import '../view_model/homeVM.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _homeVM = Get.put(HomeVM());
  final ScrollController _scrollController = ScrollController();
  RxInt selectedHourIndex = DateTime.now().hour.obs;

  @override
  void initState() {
    super.initState();
    _homeVM.getCurrentLocation();
    final hour = DateTime.now().hour;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      const double itemWidth = 70;

      double targetOffset = (hour * itemWidth) -
          (MediaQuery.of(context).size.width / 2) +
          (itemWidth / 2);

      if (targetOffset < 0) targetOffset = 0;

      _scrollController.jumpTo(targetOffset);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => Container(
        decoration: BoxDecoration(
          gradient: WeatherUtils.getBackgroundGradient(_homeVM,selectedHourIndex.value),
        ),

        child: Stack(
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 60),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Weather Icon - Updates based on selected hour
                    Obx(() => Container(
                        width: 530,
                        margin: const EdgeInsets.only(bottom: 20),
                        child: Lottie.asset(WeatherUtils.getWeatherIcon(_homeVM,selectedHourIndex.value),
                            height: 250
                        )
                      // child: Icon(
                      //   WeatherUtils.getWeatherIcon(_homeVM,selectedHourIndex.value),
                      //   size: 100,
                      //   color: WeatherUtils.getTextColor(_homeVM,selectedHourIndex.value).withValues(alpha: .9),
                      // ),
                    )),

                    // Temperature - Show selected hour data
                    Obx(() => Text(
                      _homeVM.weather.value.current == null
                          ? "Breeze"
                          : WeatherUtils.getSelectedHourData(_homeVM,selectedHourIndex.value) != null
                          ? "${WeatherUtils.getSelectedHourData(_homeVM,selectedHourIndex.value).tempC?.round()}°C"
                          : "${_homeVM.weather.value.current!.tempC.toString()}°C",
                      style: TextStyle(
                        fontSize: 72,
                        fontWeight: FontWeight.w300,
                        color: WeatherUtils.getTextColor(_homeVM,selectedHourIndex.value),
                        shadows: [
                          Shadow(
                            blurRadius: 10.0,
                            color: Colors.black.withValues(alpha: .3),
                            offset: const Offset(2.0, 2.0),
                          ),
                        ],
                      ),
                    )),

                    // Location
                    Text(
                      _homeVM.weather.value.current == null
                          ? ""
                          : "${_homeVM.weather.value.location!.name}, ${_homeVM.weather.value.location!.region}",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: WeatherUtils.getTextColor(_homeVM,selectedHourIndex.value).withValues(alpha: .8),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Weather Condition - Show selected hour data
                    Obx(() => Text(
                      _homeVM.weather.value.current == null
                          ? ""
                          : WeatherUtils.getSelectedHourData(_homeVM,selectedHourIndex.value) != null
                          ? WeatherUtils.getSelectedHourData(_homeVM,selectedHourIndex.value).condition?.text ?? ""
                          : _homeVM.weather.value.current!.condition!.text.toString(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: WeatherUtils.getTextColor(_homeVM,selectedHourIndex.value).withValues(alpha: .7),
                      ),
                    )),

                    // Time indicator for selected hour
                    Obx(() => Container(
                      margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: .2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        selectedHourIndex.value == DateTime.now().hour
                            ? "Current Weather"
                            : "Forecast for ${WeatherUtils.getSelectedHourData(_homeVM,selectedHourIndex.value)?.time?.split(" ")[1] ?? ""}",
                        style: TextStyle(
                          fontSize: 12,
                          color: WeatherUtils.getTextColor(_homeVM,selectedHourIndex.value).withValues(alpha: .8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )),

                    const SizedBox(height: 20),

                    // Additional weather details for selected hour
                    Obx(() => WeatherUtils.getSelectedHourData(_homeVM,selectedHourIndex.value) != null ? Container(
                      margin: const EdgeInsets.symmetric(horizontal: 32),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: .1),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: .1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildDetailItem(
                              Icons.water_drop,
                              "Rain",
                              "${WeatherUtils.getSelectedHourData(_homeVM,selectedHourIndex.value).chanceOfRain}%"
                          ),
                          _buildDetailItem(
                              Icons.air,
                              "Wind",
                              "${WeatherUtils.getSelectedHourData(_homeVM,selectedHourIndex.value).windKph?.round()} km/h"
                          ),
                          _buildDetailItem(
                              Icons.visibility,
                              "Visibility",
                              "${WeatherUtils.getSelectedHourData(_homeVM,selectedHourIndex.value).visKm?.round()} km"
                          ),
                          _buildDetailItem(
                              Icons.thermostat,
                              "Feels like",
                              "${WeatherUtils.getSelectedHourData(_homeVM,selectedHourIndex.value).feelslikeC?.round()}°"
                          ),
                        ],
                      ),
                    ) : const SizedBox()),

                    const SizedBox(height: 20),

                    // Hourly Forecast
                    if (_homeVM.weather.value.forecast?.forecastday?.isNotEmpty == true)
                      Container(
                        height: 100,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          // color: Colors.white.withValues(alpha: .1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: .1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ListView.builder(
                          controller: _scrollController,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: 24,
                          itemBuilder: (context, index) {
                            final hourData = _homeVM.weather.value.forecast!
                                .forecastday![0].hour![index];

                            return GestureDetector(
                              onTap: () {
                                selectedHourIndex.value = index;
                              },
                              child: Obx(()=>Container(
                                margin: const EdgeInsets.symmetric(horizontal: 2),
                                width: 70,
                                decoration: BoxDecoration(
                                  color: WeatherUtils.getHourItemColor(index, hourData.condition?.text?.toLowerCase() ?? '',selectedHourIndex.value),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      // Time
                                      Text(
                                        Constants.times[index],
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),

                                      // Temperature
                                      Text(
                                        "${hourData.tempC?.round()}°",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),

                                      // Rain chance with icon
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.water_drop,
                                            size: 10,
                                            color: Colors.white.withValues(alpha: .7),
                                          ),
                                          Text(
                                            "${hourData.chanceOfRain}%",
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.white.withValues(alpha: .7),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              ),
                            );
                          },
                        ),
                      ),

                    const SizedBox(height: 20),

                    // Coordinates (smaller and less prominent)
                    Text(
                      "Lat: ${_homeVM.lat.value}, Long: ${_homeVM.long.value}",
                      style: TextStyle(
                        fontSize: 12,
                        color: WeatherUtils.getTextColor(_homeVM,selectedHourIndex.value).withValues(alpha: .5),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Search Overlay
            Visibility(
              visible: _homeVM.search.value,
              child: Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.black.withValues(alpha: .8),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 60),
                    child: Container(
                      margin: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: .2),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: ListView.builder(
                        itemCount: _homeVM.cities.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              _homeVM.lat.value = _homeVM.cities[index].latitude.toString();
                              _homeVM.long.value = _homeVM.cities[index].longitude.toString();
                              _homeVM.getWeatherData();
                              _homeVM.search.value = false;
                              _homeVM.scrollController.clear();
                              _homeVM.focusNode.unfocus();
                              _homeVM.cities.value = Constants.cities;
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey.withValues(alpha: .2),
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    color: Colors.blue,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    _homeVM.cities[index].name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Search Input
            Positioned(
              top: 60,
              left: 16,
              right: 16,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .2),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: .1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: TextFormField(
                  onTap: () {
                    _homeVM.search.value = true;
                  },
                  controller: _homeVM.scrollController,
                  focusNode: _homeVM.focusNode,
                  onChanged: _homeVM.onSearchTextChanged,
                  style: TextStyle(color: WeatherUtils.getTextColor(_homeVM,selectedHourIndex.value)),
                  decoration: InputDecoration(
                    hintText: "Search for a city...",
                    hintStyle: TextStyle(color: WeatherUtils.getTextColor(_homeVM,selectedHourIndex.value).withValues(alpha: .6)),
                    prefixIcon: Icon(
                      Icons.search,
                      color: WeatherUtils.getTextColor(_homeVM,selectedHourIndex.value).withValues(alpha: .7),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  ),
                ),
              ),
            ),

            // Floating Action Button
            Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton(
                onPressed: _homeVM.getWeatherData,
                backgroundColor: Colors.white.withValues(alpha: .2),
                elevation: 8,
                child: Icon(
                  Icons.my_location,
                  color: WeatherUtils.getTextColor(_homeVM,selectedHourIndex.value),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }

  // Function to get selected hour data


  // Helper method to build detail items
  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 20,
          color: WeatherUtils.getTextColor(_homeVM,selectedHourIndex.value).withValues(alpha: .8),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color:WeatherUtils.getTextColor(_homeVM,selectedHourIndex.value).withValues(alpha: .6),
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            color: WeatherUtils.getTextColor(_homeVM,selectedHourIndex.value),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
