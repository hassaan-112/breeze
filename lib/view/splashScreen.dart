import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    Future.delayed(Duration(seconds: 3), () {
      Get.toNamed(RouteName.homeScreen);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Center(
        child: Text("Splash screen"),
      ),
    );
  }
}
