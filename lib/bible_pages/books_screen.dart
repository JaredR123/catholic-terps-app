import 'package:flutter/material.dart';
import 'api_connector.dart';
import 'chapters_screen.dart';

class BooksScreen extends StatelessWidget {
  final String bibleID;
  final BibleAPIService service = BibleAPIService();

  BooksScreen({required this.bibleID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Books')),
      body: FutureBuilder<List<dynamic>>(
        future: service.fetchBooks(bibleID),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final books = snapshot.data!;
            return ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(books[index]['name']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChaptersScreen(
                          bibleID: bibleID,
                          bookID: books[index]['id'],
                        ),
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
