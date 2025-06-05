import 'package:flutter/material.dart';

class Screen2 extends StatefulWidget {
  const Screen2({super.key});

  @override
  State<Screen2> createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
  TextEditingController cityNameController = TextEditingController();
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
            image: AssetImage('assets/images/screen2.jpeg'),
            fit: BoxFit.fill,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, size: 30, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(height: 15),
                TextField(
                  controller: cityNameController,
                  style: TextStyle(fontSize: 25),
                  decoration: InputDecoration(
                    hint: Text(
                      'Enter Your City Name',
                      style: TextStyle(fontSize: 25),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ),
                SizedBox(height: 10),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context, cityNameController.text);
                    },
                    child: Text(
                      'Get Weather',
                      style: TextStyle(fontSize: 30, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
