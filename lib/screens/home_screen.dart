import 'dart:convert';

import 'package:eight_course_app/screens/screen1.dart';
import 'package:eight_course_app/services/location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    if (mounted) {
      getLocation();
    }
    super.initState();
  }

  void getLocation() async {
    Location location = Location();
    await location.getCurrentLocation();
    double lat = location.latitude;
    double lon = location.longitude;
    var apiUrl = Uri.parse(
      'https://api.open-meteo.com/v1/forecast?latitude=${lat.toString()}&longitude=${lon.toString()}&current=temperature_2m,weather_code',
    );
    print(apiUrl);
    var response = await http.get(apiUrl);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Screen1(weatherData: data)),
      );
    } else {
      throw Exception('Failed to load weather');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: SpinKitDoubleBounce(color: Colors.grey, size: 100)),
    );
  }
}
