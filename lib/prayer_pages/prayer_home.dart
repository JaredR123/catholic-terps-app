import 'package:flutter/material.dart';

class PrayerHome extends StatefulWidget {
  const PrayerHome({super.key});

  @override
  State<PrayerHome> createState() => _PrayerHomeState();
}

class _PrayerHomeState extends State<PrayerHome> {
  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0), 
                  child: Text(
                    "Prayer Home",
                    style: TextStyle(color: Colors.red),
                    ),
                ),
              ],
            ),
        /*
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(
                Icons.menu,
                color: Colors.red, // App Icon color
                ),
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
            );
          },
        ),
        */
      ),
    );
  }
}