import 'package:flutter/material.dart';
import 'home.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  String url = '';
  var data;
  final primaryColor = Colors.black; // AppBar color

  int _selectedIndex = 0;
  int _selectedSubIndex = -1;
  bool _isSubMenuOpen = false;
  List<Widget> _drawerOptions = [];

  static const TextStyle optionStyle = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
  );

  static final List<Widget> _widgetOptions = <Widget>[
    Padding(
      padding: const EdgeInsets.all(10.0),
      child: CatholicTerpsHome(),
      // child: SearchTextField(),
    ),
    const Text(
      'Index 1: ABOUT US',
      style: optionStyle,
    ),
    const Text(
      'Index 2: GET INVOLVED',
      style: optionStyle,
    ),
    const Text(
      'Index 3: CALENDAR',
      style: optionStyle,
    ),
    const Text(
      'Index 4: WAYS TO GIVE',
      style: optionStyle,
    ),
    const Text(
      'Index 5: ALUMNI',
      style: optionStyle,
    ),
    const Text(
      'Index 6: CAMPAIGN',
      style: optionStyle,
    ),
  ];

  void _onTapped(int idx) {
    setState(() {
      _selectedIndex = idx;
      _selectedSubIndex = -1; // Resets subindex
      _updateDrawerOptions(idx);
      
      if (idx == 0) {
        Navigator.pop(context); // Close the main drawer
      } else {
        _isSubMenuOpen = true; // Flag for sub menu being open
        _scaffoldKey.currentState?.openDrawer();
      }
      /*
      Future.delayed(Duration(milliseconds: 50), () {
        _scaffoldKey.currentState?.openDrawer(); // Open the drawer with new options
      });
      */
    });
  }

  void _onSubTapped(int subIdx, Widget page) {
    setState(() {
      _selectedSubIndex = subIdx;
      _isSubMenuOpen = false; // Close the submenu
      Navigator.pop(context); // Close submenu drawer
    });
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  void _openSubDrawer(int parentIdx, List<Widget> subDrawerOptions) {
  setState(() {
    _drawerOptions = [
      DrawerHeader(
        decoration: BoxDecoration(
          color: Colors.transparent,
        ),
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                setState(() {
                  _updateDrawerOptions(parentIdx);
                  _scaffoldKey.currentState?.openDrawer(); // Reopen main drawer
                });
              },
            ),
          ],
        ),
      ),
      ...subDrawerOptions
    ];
    _isSubMenuOpen = true;
    _scaffoldKey.currentState?.openDrawer();
  });
}

  void _updateDrawerOptions(int idx) {
    switch (idx) {
      case 1:
        _drawerOptions = [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.transparent,
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    setState(() {
                      _isSubMenuOpen = false;
                      _scaffoldKey.currentState?.openDrawer(); // Reopen main drawer
                    });
                  },
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('ABOUT US/FIND US'),
            selected: _selectedSubIndex == 0,
            onTap: () => _onSubTapped(0, const SecondPage(title: 'Meet the Staff')),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('MASS/SACRAMENT TIMES'),
            selected: _selectedSubIndex == 1,
            onTap: () => _onSubTapped(1, const SecondPage(title: 'Meet the Parents')),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('MEET THE STAFF'),
            selected: _selectedSubIndex == 2,
            onTap: () => _onSubTapped(2, const SecondPage(title: 'Meet the Parents')),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('OUR HISTORY'),
            selected: _selectedSubIndex == 3,
            onTap: () => _onSubTapped(3, const SecondPage(title: 'Meet the Parents')),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('CSC CHAPLAINS'),
            selected: _selectedSubIndex == 4,
            onTap: () => _onSubTapped(4, const SecondPage(title: 'Meet the Parents')),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('CATHOLIC RESOURCES'),
            selected: _selectedSubIndex == 5,
            onTap: () => _onSubTapped(5, const SecondPage(title: 'Meet the Parents')),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('BLOG'),
            selected: _selectedSubIndex == 6,
            onTap: () => _onSubTapped(6, const SecondPage(title: 'Meet the Parents')),
          ),
        ];
        break;
      case 2:
        _drawerOptions = [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.transparent,
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    setState(() {
                      _isSubMenuOpen = false;
                      _scaffoldKey.currentState?.openDrawer(); // Reopen main drawer
                    });
                  },
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('REGISTER'),
            selected: _selectedSubIndex == 0,
            onTap: () => _onSubTapped(0, const SecondPage(title: 'Option 1')),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('SOCIAL'),
            selected: _selectedSubIndex == 1,
            onTap: () => _openSubDrawer(
              2,
              [
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('SOCIAL EVENTS'),
                  selected: _selectedSubIndex == 0,
                  onTap: () => _onSubTapped(0, const SecondPage(title: 'Meet the Parents')),
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('MEN\'S MINISTRY'),
                  selected: _selectedSubIndex == 1,
                  onTap: () => _onSubTapped(1, const SecondPage(title: 'Meet the Parents')),
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('KNIGHTS OF COLUMBUS'),
                  selected: _selectedSubIndex == 2,
                  onTap: () => _onSubTapped(2, const SecondPage(title: 'Meet the Parents')),
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('WOMEN\'S MINISTRY'),
                  selected: _selectedSubIndex == 3,
                  onTap: () => _onSubTapped(3, const SecondPage(title: 'Meet the Parents')),
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('MULTICULTURAL OUTREACH'),
                  selected: _selectedSubIndex == 4,
                  onTap: () => _onSubTapped(4, const SecondPage(title: 'Meet the Parents')),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('SPIRITUAL'),
            selected: _selectedSubIndex == 2,
            onTap: () => _openSubDrawer(
              2,
              [
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('BIBLE STUDY'),
                  selected: _selectedSubIndex == 0,
                  onTap: () => _onSubTapped(0, const SecondPage(title: 'Meet the Parents')),
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('RETREATS'),
                  selected: _selectedSubIndex == 1,
                  onTap: () => _onSubTapped(1, const SecondPage(title: 'Meet the Parents')),
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('SACRAMENTS CLASS/OCIA'),
                  selected: _selectedSubIndex == 2,
                  onTap: () => _onSubTapped(2, const SecondPage(title: 'Meet the Parents')),
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('VOCATION DISCERNMENT'),
                  selected: _selectedSubIndex == 3,
                  onTap: () => _onSubTapped(3, const SecondPage(title: 'Meet the Parents')),
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('EUCHARISTIC ADORATION'),
                  selected: _selectedSubIndex == 4,
                  onTap: () => _onSubTapped(4, const SecondPage(title: 'Meet the Parents')),
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('SPIRITUAL DIRECTION'),
                  selected: _selectedSubIndex == 5,
                  onTap: () => _onSubTapped(5, const SecondPage(title: 'Meet the Parents')),
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('THEOLOGY 101'),
                  selected: _selectedSubIndex == 6,
                  onTap: () => _onSubTapped(6, const SecondPage(title: 'Meet the Parents')),
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('GRAD GROUP'),
                  selected: _selectedSubIndex == 7,
                  onTap: () => _onSubTapped(7, const SecondPage(title: 'Meet the Parents')),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('SERVICE'),
            selected: _selectedSubIndex == 3,
            onTap: () => _openSubDrawer(
              2,
              [
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('COMMUNITY SERVICE'),
                  selected: _selectedSubIndex == 0,
                  onTap: () => _onSubTapped(0, const SecondPage(title: 'Meet the Parents')),
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('PRO-LIFE'),
                  selected: _selectedSubIndex == 1,
                  onTap: () => _onSubTapped(1, const SecondPage(title: 'Meet the Parents')),
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('INTERFAITH'),
                  selected: _selectedSubIndex == 2,
                  onTap: () => _onSubTapped(2, const SecondPage(title: 'Meet the Parents')),
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('STEWARDSHIP'),
                  selected: _selectedSubIndex == 3,
                  onTap: () => _onSubTapped(3, const SecondPage(title: 'Meet the Parents')),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('LITURGY'),
            selected: _selectedSubIndex == 4,
            onTap: () => _openSubDrawer(
              2,
              [
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('ALTARSERVER'),
                  selected: _selectedSubIndex == 0,
                  onTap: () => _onSubTapped(0, const SecondPage(title: 'Meet the Parents')),
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('EXTRAORDINARY MINISTER OF HOLY COMMUNION'),
                  selected: _selectedSubIndex == 1,
                  onTap: () => _onSubTapped(1, const SecondPage(title: 'Meet the Parents')),
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('GREETERS'),
                  selected: _selectedSubIndex == 2,
                  onTap: () => _onSubTapped(2, const SecondPage(title: 'Meet the Parents')),
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('LECTOR'),
                  selected: _selectedSubIndex == 3,
                  onTap: () => _onSubTapped(3, const SecondPage(title: 'Meet the Parents')),
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('MUSIC MINISTRY'),
                  selected: _selectedSubIndex == 4,
                  onTap: () => _onSubTapped(4, const SecondPage(title: 'Meet the Parents')),
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('LITURGY SCHEDULE'),
                  selected: _selectedSubIndex == 5,
                  onTap: () => _onSubTapped(5, const SecondPage(title: 'Meet the Parents')),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('FACULTY/STAFF'),
            selected: _selectedSubIndex == 5,
            onTap: () => _onSubTapped(5, const SecondPage(title: 'Meet the Parents')),
          ),
        ];
      case 5:
        _drawerOptions = [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.transparent,
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    setState(() {
                      _isSubMenuOpen = false;
                      _scaffoldKey.currentState?.openDrawer(); // Reopen main drawer
                    });
                  },
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('EMAIL LIST'),
            selected: _selectedSubIndex == 0,
            onTap: () => _onSubTapped(0, const SecondPage(title: 'Option 1')),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('ALUMNI EVENTS'),
            selected: _selectedSubIndex == 1,
            onTap: () => _openSubDrawer(
              5,
              [
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('CATHOLIC TERPS ON TOUR'),
                  selected: _selectedSubIndex == 0,
                  onTap: () => _onSubTapped(0, const SecondPage(title: 'Meet the Parents')),
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('UPCOMING ALUMNI EVENTS'),
                  selected: _selectedSubIndex == 1,
                  onTap: () => _onSubTapped(1, const SecondPage(title: 'Meet the Parents')),
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('PAST ALUMNI EVENTS'),
                  selected: _selectedSubIndex == 2,
                  onTap: () => _onSubTapped(2, const SecondPage(title: 'Meet the Parents')),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('WHERE ARE THEY NOW?'),
            selected: _selectedSubIndex == 2,
            onTap: () => _onSubTapped(2, const SecondPage(title: 'Option 1')),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('GIVE BACK'),
            selected: _selectedSubIndex == 3,
            onTap: () => _onSubTapped(3, const SecondPage(title: 'Option 1')),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('SENIORS'),
            selected: _selectedSubIndex == 4,
            onTap: () => _onSubTapped(4, const SecondPage(title: 'Option 1')),
          ),
        ];
        break;
      default:
        _drawerOptions = [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.transparent,
            ),
            child: Text('Drawer Header'),
          ),
          ListTile(
            title: const Text('HOME'),
            selected: _selectedIndex == 0,
            onTap: () => _onTapped(0),
          ),
          ListTile(
            title: const Text('ABOUT US'),
            selected: _selectedIndex == 1,
            onTap: () => _onTapped(1),
          ),
          ListTile(
            title: const Text('GET INVOLVED'),
            selected: _selectedIndex == 2,
            onTap: () => _onTapped(2),
          ),
          ListTile(
            title: const Text('CALENDAR'),
            selected: _selectedIndex == 3,
            onTap: () => _onTapped(3),
          ),
          ListTile(
            title: const Text('WAYS TO GIVE'),
            selected: _selectedIndex == 4,
            onTap: () => _onTapped(4),
          ),
          ListTile(
            title: const Text('ALUMNI'),
            selected: _selectedIndex == 5,
            onTap: () => _onTapped(5),
          ),
          ListTile(
            title: const Text('CAMPAIGN'),
            selected: _selectedIndex == 6,
            onTap: () => _onTapped(6),
          ),
        ];
    }
  }

/*
  void _closeSubMenu() {
    setState(() {
      _isSubMenuOpen = false;
      _scaffoldKey.currentState?.openDrawer();
    });
  }
*/

/*
  void _toggleEndDrawer() {
    if (Scaffold.of(context).isEndDrawerOpen) {
      Navigator.of(context).pop();
    } else {
      Scaffold.of(context).openEndDrawer();
    }
  }
*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0), 
                  child: Text(
                    widget.title,
                    style: TextStyle(color: Colors.red),
                    ),
                ),
                Image.asset(
                 "assets/images/Cath-Terps-Logo21.png",
                  fit: BoxFit.contain,
                  height: 32,
                ),
              ],
            ),
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
      ),
      body: Center(
        child: _widgetOptions[_selectedIndex],
      ),
      drawer: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.transparent,
        ),
        child: TapRegion(
          onTapOutside: (tap) {
            setState(() {
              Navigator.pop(context);
              _isSubMenuOpen = false; // Close sub menu
              _selectedSubIndex = -1; // Reset subindex
            });
          },
          child: Drawer(
            elevation: 0, // Makes transparent layer totally invisible
            child: Container(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: CustomPaint(
                painter: DrawerPainter(color: Colors.white),
                child: ListView(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  children: _isSubMenuOpen
                    ? _drawerOptions
                    : [
                    /*
                    Leave the option for a drawer header
                    */
                      const DrawerHeader(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                        ),
                        child: Text('Drawer Header'),
                      ),
                      ListTile(
                        title: const Text('HOME'),
                        selected: _selectedIndex == 0,
                        onTap: () => _onTapped(0),
                      ),
                      ListTile(
                        title: const Text('ABOUT US'),
                        selected: _selectedIndex == 1,
                        onTap: () => _onTapped(1),
                      ),
                      ListTile(
                        title: const Text('GET INVOLVED'),
                        selected: _selectedIndex == 2,
                        onTap: () => _onTapped(2),
                      ),
                      ListTile(
                        title: const Text('CALENDAR'),
                        selected: _selectedIndex == 3,
                        onTap: () => _onTapped(3),
                      ),
                      ListTile(
                        title: const Text('WAYS TO GIVE'),
                        selected: _selectedIndex == 4,
                        onTap: () => _onTapped(4),
                      ),
                      ListTile(
                        title: const Text('ALUMNI'),
                        selected: _selectedIndex == 5,
                        onTap: () => _onTapped(5),
                      ),
                      ListTile(
                        title: const Text('CAMPAIGN'),
                        selected: _selectedIndex == 6,
                        onTap: () => _onTapped(6),
                      ),
                    ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Class to draw custom shape of option drawer
class DrawerPainter extends CustomPainter {
  final Color color;
  DrawerPainter({this.color = Colors.black});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.fill;
    canvas.drawPath(getShapePath(size.width, size.height), paint);
  }

  Path getShapePath(double x, double y) {
    return Path()
      ..moveTo(0, 0)
      ..lineTo(x / 2, 0)
      ..quadraticBezierTo(x, y / 2, x / 2, y)
      ..lineTo(0, y);
  }

  @override
  bool shouldRepaint(DrawerPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

class SecondPage extends StatelessWidget {
  const SecondPage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Return to Home Page'),
        ),
      ),
    );
  }
}