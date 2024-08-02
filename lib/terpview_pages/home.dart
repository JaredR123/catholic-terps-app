import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CatholicTerpsHome extends StatefulWidget {
  const CatholicTerpsHome({super.key});

  @override
  State<CatholicTerpsHome> createState() => _CatholicTerpsHomeState();
}

class _CatholicTerpsHomeState extends State<CatholicTerpsHome> {
  int _currentIndex = 0;
  bool _isHoldingMT = false;
  bool _isHoldingGI = false;
  bool _isHoldingWTG = false;
  bool _isHoldingCU = false;
  final CarouselController _carouselController = CarouselController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, String>> _imgList = [];
  List<Map<String, String>> _eventList = [];

  Future<void> _fetchDocumentContent() async {
    final docIds = ['h2-0', 'h2-1', 'h2-2', 'h2-3', 'h2-4'];
    final eventIds = ['h2-6', 'h2-7'];
    final List<Map<String, String>> items = [];
    final List<Map<String, String>> events = [];

    for (String docId in docIds) {
      try {
        DocumentSnapshot docSnapshot =
            await _firestore.collection('csc_home').doc(docId).get();

        if (docSnapshot.exists) {
          Map<String, dynamic>? data =
              docSnapshot.data() as Map<String, dynamic>?;
          String content = data != null && data.containsKey('content')
              ? data['content'] as String
              : 'No data found';
          content = content.trim();
          items.add({
            'image':
                'assets/images/csc_home_img-${docIds.indexOf(docId) + 16}.jpg',
            'text': content,
          });
        } else {
          items.add({
            'image':
                'assets/images/csc_home_img-${docIds.indexOf(docId) + 16}.jpg',
            'text': 'Document does not exist',
          });
        }
      } catch (e) {
        items.add({
          'image':
              'assets/images/csc_home_img-${docIds.indexOf(docId) + 16}.jpg',
          'text': 'Error fetching document: $e',
        });
      }
    }

      for (String event in eventIds) {
        try {
          DocumentSnapshot docSnapshot =
              await _firestore.collection('csc_home').doc(event).get();

          if (docSnapshot.exists) {
            Map<String, dynamic>? data =
                docSnapshot.data() as Map<String, dynamic>?;
            String content = data != null && data.containsKey('content')
                ? data['content'] as String
                : 'No data found';
            content = content.trim();
            events.add({
              'image':
                  'assets/images/csc_home_img-${eventIds.indexOf(event) + 25}.jpg',
              'text': content,
            });
          } else {
            events.add({
              'image':
                  'assets/images/csc_home_img-${eventIds.indexOf(event) + 25}.jpg',
              'text': 'Document does not exist',
            });
          }
        } catch (e) {
          events.add({
            'image':
                'assets/images/csc_home_img-${eventIds.indexOf(event) + 25}.jpg',
            'text': 'Error fetching document: $e',
          });
        }

    }

    setState(() {
      _imgList = items;
      _eventList = events;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchDocumentContent(); // Fetch data when the widget is initialized
  }

  void _navigatePage(BuildContext context, String text) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetailPage(text: text)),
    );
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    body: _imgList.isEmpty
        ? Center(child: CircularProgressIndicator())
        : Container(
            color: Colors.white, // Ensure the main content container has a black background
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  CarouselSlider(
                    carouselController: _carouselController,
                    options: CarouselOptions(
                      height: 400,
                      autoPlay: true,
                      enlargeCenterPage: true,
                      aspectRatio: 16 / 9,
                      viewportFraction: 0.8,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                    ),
                    items: _imgList.map((entry) {
                      return Builder(
                        builder: (BuildContext context) {
                          return GestureDetector(
                            onTap: () => _navigatePage(context, entry['text']!),
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 5.0),
                              child: Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: _currentIndex == _imgList.indexOf(entry)
                                              ? Colors.black.withOpacity(0.4)
                                              : Colors.black.withOpacity(0.2),
                                          spreadRadius: 2,
                                          blurRadius: 10,
                                          offset: Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15.0),
                                      child: Image.asset(
                                        entry['image']!,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                      ),
                                    ),
                                  ),
                                  if (_currentIndex != _imgList.indexOf(entry))
                                    Positioned.fill(
                                      child: Container(
                                        color: Colors.black.withOpacity(0.3),
                                      ),
                                    ),
                                  Positioned(
                                    bottom: 35,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.yellow.withOpacity(0.8),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.4),
                                            spreadRadius: 3,
                                            blurRadius: 8,
                                            offset: Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        entry['text']!.toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _imgList.asMap().entries.map((entry) {
                      return GestureDetector(
                        onTap: () => _carouselController.jumpToPage(entry.key),
                        child: Container(
                          width: 12.0,
                          height: 12.0,
                          margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: (_currentIndex == entry.key
                                ? Colors.blue
                                : Colors.blue.withOpacity(0.4)),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTapDown: (_) {
                      setState(() {
                        _isHoldingMT = true;
                      });
                    },
                    onTapUp: (_) {
                      setState(() {
                        _isHoldingMT = false;
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetailPage(text: "Mass Times")), // Navigate to NewPage
                      );
                    },
                    onPanEnd: (_) {
                      setState(() {
                        _isHoldingMT = false;
                      });
                    },
                    onPanCancel: () {
                      setState(() {
                        _isHoldingMT = false;
                      });
                    },
                    child: Container(
                      width: 500,
                      height: 200,
                      child: Stack(
                        fit: StackFit.expand,
                        children: <Widget>[
                          if (_isHoldingMT)
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.4),
                                    spreadRadius: 3,
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                            ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              image: DecorationImage(
                                image: AssetImage("assets/images/csc_home_img-21.jpg"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          if (!_isHoldingMT)
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                color: Colors.red.withOpacity(0.5),
                              ),
                            ),
                          if (!_isHoldingMT)
                            Center(
                              child: Text(
                                "MASS TIMES",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTapDown: (_) {
                      setState(() {
                        _isHoldingGI = true;
                      });
                    },
                    onTapUp: (_) {
                      setState(() {
                        _isHoldingGI = false;
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetailPage(text: "Mass Times")), // Navigate to NewPage
                      );
                    },
                    onPanEnd: (_) {
                      setState(() {
                        _isHoldingGI = false;
                      });
                    },
                    onPanCancel: () {
                      setState(() {
                        _isHoldingGI = false;
                      });
                    },
                    child: Container(
                      width: 500,
                      height: 200,
                      child: Stack(
                        fit: StackFit.expand,
                        children: <Widget>[
                          if (_isHoldingGI)
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.4),
                                    spreadRadius: 3,
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                            ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              image: DecorationImage(
                                image: AssetImage("assets/images/csc_home_img-22.jpg"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          if (!_isHoldingGI)
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                color: Colors.red.withOpacity(0.5),
                              ),
                            ),
                          if (!_isHoldingGI)
                            Center(
                              child: Text(
                                "GET INVOLVED",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTapDown: (_) {
                      setState(() {
                        _isHoldingWTG = true;
                      });
                    },
                    onTapUp: (_) {
                      setState(() {
                        _isHoldingWTG = false;
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetailPage(text: "Mass Times")), // Navigate to NewPage
                      );
                    },
                    onPanEnd: (_) {
                      setState(() {
                        _isHoldingWTG = false;
                      });
                    },
                    onPanCancel: () {
                      setState(() {
                        _isHoldingWTG = false;
                      });
                    },
                    child: Container(
                      width: 500,
                      height: 200,
                      child: Stack(
                        fit: StackFit.expand,
                        children: <Widget>[
                          if (_isHoldingWTG)
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.4),
                                    spreadRadius: 3,
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                            ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              image: DecorationImage(
                                image: AssetImage("assets/images/csc_home_img-24.jpg"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          if (!_isHoldingWTG)
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                color: Colors.red.withOpacity(0.5),
                              ),
                            ),
                          if (!_isHoldingWTG)
                            Center(
                              child: Text(
                                "WAYS TO GIVE",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTapDown: (_) {
                      setState(() {
                        _isHoldingCU = true;
                      });
                    },
                    onTapUp: (_) {
                      setState(() {
                        _isHoldingCU = false;
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetailPage(text: "Mass Times")), // Navigate to NewPage
                      );
                    },
                    onPanEnd: (_) {
                      setState(() {
                        _isHoldingCU = false;
                      });
                    },
                    onPanCancel: () {
                      setState(() {
                        _isHoldingCU = false;
                      });
                    },
                    child: Container(
                      width: 500,
                      height: 200,
                      child: Stack(
                        fit: StackFit.expand,
                        children: <Widget>[
                          if (_isHoldingCU)
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.4),
                                    spreadRadius: 3,
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                            ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              image: DecorationImage(
                                image: AssetImage("assets/images/csc_home_img-23.jpg"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          if (!_isHoldingCU)
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                color: Colors.red.withOpacity(0.5),
                              ),
                            ),
                          if (!_isHoldingCU)
                            Center(
                              child: Text(
                                "CONTACT US",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _eventList.map((event) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            children: [
                              Container(
                                width: 300,
                                height: 200,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(event['image']!),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Container(
                                width: 300,
                                child: Text(
                                  event['text']!,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,// Ensure text color contrasts with black background
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
  );
}
}

class DetailPage extends StatefulWidget {
  final String text;

  DetailPage({required this.text});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Page'),
      ),
      body: Text(
        widget.text,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }
}
