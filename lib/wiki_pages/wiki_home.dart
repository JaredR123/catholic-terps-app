import 'package:flutter/material.dart';

class WikiHome extends StatefulWidget {
  const WikiHome({super.key});

  @override
  State<WikiHome> createState() => _WikiHomeState();
}

class _WikiHomeState extends State<WikiHome> {
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
                    "Wiki Home",
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

// * NOTE: When directing to specific wiki pages, direct with PageScreen