import 'package:flutter/material.dart';
import 'api_connector.dart';
import 'books_screen.dart';

class BiblesScreen extends StatefulWidget {
  const BiblesScreen({super.key});

  @override
  State<BiblesScreen> createState() => _BiblesScreenState();
}

class _BiblesScreenState extends State<BiblesScreen> {
  final BibleAPIService service = BibleAPIService();
  Future<List<dynamic>>? futureBibles;

  @override
  void initState() {
    super.initState();
    futureBibles = service.fetchBibles();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bibles')),
      body: FutureBuilder<List<dynamic>>(
        future: service.fetchBibles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final bibles = snapshot.data!;
            return ListView.builder(
              itemCount: bibles.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(bibles[index]['name']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BooksScreen(bibleID: bibles[index]['id']),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
