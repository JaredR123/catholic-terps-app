// import 'dart:js_interop';

import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
import 'api.dart';
import 'dart:convert';
// import 'terpview_pages/home.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
// import 'test_home.dart';
import 'navigator.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // runApp(const MyHome());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const NavigationBar(),
      // home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class NavigationBar extends StatefulWidget {
  const NavigationBar({super.key});

  @override
  State<NavigationBar> createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  int _barIndex = 2;

  static const TextStyle optionStyle = TextStyle(
    color: Colors.black,
    fontSize: 30,
    fontWeight: FontWeight.bold,
  );

  static const List<Widget> _bottomOptions = <Widget>[
    Text(
      'Index -1: News',
      style: optionStyle,
    ),
    Text(
      'Index 0: Bible',
      style: optionStyle,
    ),
    HomePage(title: ''),
    Text(
      'Index 2: Catholic History',
      style: optionStyle,
    ),
    Text(
      'Index 3: Prayers',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int idx) {
    setState(() {
      _barIndex = idx;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _bottomOptions.elementAt(_barIndex),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: _barIndex,
        backgroundColor: Colors.white,
        color: Colors.black,
        buttonBackgroundColor: Colors.black,
        height: 55,
        items: const [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.newspaper, color: Colors.grey),
              Text('News', style: TextStyle(color: Colors.grey))
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.book, color: Colors.grey),
              Text('Bible', style: TextStyle(color: Colors.grey))
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.home, color: Colors.grey),
              Text('TerpView', style: TextStyle(color: Colors.grey, fontSize: 12))
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.church, color: Colors.grey),
              Text('History', style: TextStyle(color: Colors.grey))
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.voice_chat, color: Colors.grey),
              Text('Prayers', style: TextStyle(color: Colors.grey))
            ],
          ),
        ],
        onTap: _onItemTapped,
        animationDuration: Duration(milliseconds: 150),
        animationCurve: Curves.easeIn,
      ),
    );
  }
}

class SearchTextField extends StatefulWidget {
  @override
  _SearchTextFieldState createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  String url = '';
  String queryText = 'Query:';
  var data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          TextField(
            onChanged: (value) {
              setState(() {
                url = 'http://127.0.0.1:5000/api?Query=' + value;
              });
            },
            decoration: InputDecoration(
              hintText: 'Search anything',
              suffixIcon: IconButton(
                icon: Icon(Icons.search),
                onPressed: () async {
                  try {
                    data = await Getdata(url);
                    var decodeData = jsonDecode(data);
                    setState(() {
                      queryText = decodeData['Query'];
                      debugPrint(queryText);
                    });
                  } catch (e) {
                    debugPrint('Error: $e');
                  }
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              queryText,
              style: const TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
