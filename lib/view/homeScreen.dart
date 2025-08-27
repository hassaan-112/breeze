import 'package:breeze/res/assets/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../view_model/homeVM.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _homeVM=Get.put(HomeVM());
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _homeVM.getCurrentLocation();
    final hour=DateTime.now().hour;

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
      appBar: PreferredSize(preferredSize:Size(double.infinity, 60), child: Container(
        color: Colors.deepPurple,
        child: Row(crossAxisAlignment: CrossAxisAlignment.center,
          children: [Container(height: double.infinity,),
          Obx(()=> Visibility(visible: _homeVM.search.value,child: IconButton(onPressed: (){_homeVM.search.value=false;}, icon: Icon(Icons.cancel_outlined,color: Colors.white,))))
        ],),
      )),
      body: Stack(
        children: [


          Obx(()=>Column(mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(_homeVM.weather.value.current==null?"":_homeVM.weather.value.current!.tempC.toString()),
                Text(_homeVM.weather.value.current==null?"":"${_homeVM.weather.value.location!.name},${_homeVM.weather.value.location!.region}"),
                Text(_homeVM.weather.value.current==null?"":_homeVM.weather.value.current!.condition!.text.toString()),
                Center(child: Text("${_homeVM.lat.value} , ${_homeVM.long.value}")),
          SizedBox(
            height: 80,
            child: ListView.builder(
              controller: _scrollController,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: 24,
              itemBuilder: (context, index) {
                return Container(
                  color: index==DateTime.now().hour?Colors.red:Colors.white,
                  width: 70,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(_homeVM.weather.value.forecast!
                            .forecastday![0].hour![index].time!
                            .split(" ")[1]),
                        Text(_homeVM.weather.value.forecast!
                            .forecastday![0].hour![index].chanceOfRain
                            .toString()),
                        Text(_homeVM.weather.value.forecast!
                            .forecastday![0].hour![index].cloud
                            .toString()),
                      ],
                    ),
                  ),
                );
              },
            ),
          )          ],
            ),
          ),
          Obx(()=>Visibility(
              visible: _homeVM.search.value,
              child: SizedBox(
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: Colors.white.withValues(alpha: .7),
                  child: Padding(
                    padding:  EdgeInsets.only(top: 60),
                    child: Center(child: ListView.builder(
                        itemCount: _homeVM.cities.length,
                        itemBuilder: (context,index){
                      return GestureDetector(
                        onTap: (){
                          _homeVM.lat.value=_homeVM.cities[index].latitude.toString();
                          _homeVM.long.value=_homeVM.cities[index].longitude.toString();
                          _homeVM.getWeatherData();
                          _homeVM.search.value=false;
                          _homeVM.scrollController.clear();
                          _homeVM.focusNode.unfocus();
                          _homeVM.cities.value=Constants.cities;
                        },
                        child: ListTile(
                          title: Text(_homeVM.cities[index].name),

                          ),
                      );
                    }),),
                  ),
                ),
              ),
            ),
          ),
          TextFormField(
            onTap: (){
              _homeVM.search.value=true;
            },
            controller: _homeVM.scrollController,
            focusNode: _homeVM.focusNode,
            onChanged: _homeVM.onSearchTextChanged,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _homeVM.getWeatherData,
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
