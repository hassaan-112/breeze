import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../res/routes/routeNames.dart';
class SplaashScreen extends StatefulWidget {
  const SplaashScreen({super.key});

  @override
  State<SplaashScreen> createState() => _SplaashScreenState();
}

class _SplaashScreenState extends State<SplaashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      Get.toNamed(RouteName.homeScreen);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black26,
      body:Center(
        // child: Lottie.asset("assets/lottee/weather.json",),
      ),
    );
  }
}
