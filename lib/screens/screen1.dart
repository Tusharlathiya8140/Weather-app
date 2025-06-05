import 'dart:convert';
import 'dart:ffi';
import 'package:eight_course_app/screens/home_screen.dart';
import 'package:eight_course_app/screens/screen2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Screen1 extends StatefulWidget {
  final weatherData;
  const Screen1({super.key, this.weatherData});

  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  var emoji = "";
  var weatherStatus = "";
  var cityName = "Current Location";
  var temp = "";

  @override
  void initState() {
    // TODO: implement initState
    updateUI(widget.weatherData);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/screen1.jpeg'),
            fit: BoxFit.fill,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.near_me, size: 30, color: Colors.white),
                      onPressed: () {
                        setState(() {
                          cityName = "Current Location";
                          updateUI(widget.weatherData);
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.location_pin,
                        size: 30,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        cityName = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Screen2()),
                        );
                        print(cityName);
                        if (cityName != null || cityName != "") {
                          var weatherData = await getWeatherDataFromCityName(
                            cityName,
                          );
                          updateUI(weatherData);
                        }
                      },
                    ),
                  ],
                ),
                Text(
                  cityName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  temp.toString() + "°C",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(emoji, width: 80, height: 80),
                    SizedBox(width: 15),
                    Text(
                      weatherStatus,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
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
  }

  Future<dynamic> getWeatherDataFromCityName(String cityName) async {
    var lat;
    var lon;
    var cityAPI = Uri.parse(
      "https://nominatim.openstreetmap.org/search?format=json&q=${cityName}",
    );
    var response = await http.get(cityAPI);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      lat = data[0]['lat'];
      lon = data[0]['lon'];
      var Data = await getWeatherFromLocation(lat, lon);
      return Data;
    }
  }

  Future<dynamic> getWeatherFromLocation(String lat, String lon) async {
    var apiUrl = Uri.parse(
      'https://api.open-meteo.com/v1/forecast?latitude=${lat}&longitude=${lon}&current=temperature_2m,weather_code',
    );
    print(apiUrl);
    var response = await http.get(apiUrl);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data;
    }
  }

  void updateUI(weatherData) {
    var weatherid = weatherData['current']['weather_code'];
    print(weatherData['current']['weather_code']);
    if (weatherid == 0) {
      setState(() {
        emoji = "https://cdn-icons-png.flaticon.com/512/3262/3262946.png";
        weatherStatus = 'Clear sky';
      });
    } else if (weatherid <= 3) {
      setState(() {
        emoji = "https://cdn-icons-png.flaticon.com/512/3222/3222800.png";
        weatherStatus = 'Cloudy';
      });
    } else if (weatherid == 45 || weatherid == 48) {
      setState(() {
        emoji = "https://cdn-icons-png.flaticon.com/512/1197/1197102.png";
        weatherStatus = 'Fog';
      });
    } else if (weatherid >= 51 && weatherid <= 57) {
      setState(() {
        emoji = "https://cdn-icons-png.flaticon.com/512/4837/4837659.png";
        weatherStatus = 'Drizzle';
      });
    } else if (weatherid >= 61 && weatherid <= 67) {
      setState(() {
        emoji = "https://cdn-icons-png.flaticon.com/512/6393/6393519.png";
        weatherStatus = 'Rain';
      });
    } else if (weatherid >= 71 && weatherid <= 82) {
      setState(() {
        emoji = "https://cdn-icons-png.flaticon.com/512/9176/9176581.png";
        weatherStatus = 'Snow';
      });
    } else if (weatherid >= 95 && weatherid <= 99) {
      setState(() {
        emoji = "https://cdn-icons-png.flaticon.com/512/4668/4668769.png";
        weatherStatus = 'Thunderstorm';
      });
    }
    setState(() {
      temp = (weatherData['current']['temperature_2m'].toInt()).toString();
    });
  }
}
