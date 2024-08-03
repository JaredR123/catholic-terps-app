import 'package:flutter/material.dart';
import 'api_connector.dart';
import 'verses_screen.dart';

class ChaptersScreen extends StatelessWidget {
  final String bibleID;
  final String bookID;
  final BibleAPIService service = BibleAPIService();

  ChaptersScreen({required this.bibleID, required this.bookID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chapters')),
      body: FutureBuilder<List<dynamic>>(
        future: service.fetchChapters(bibleID, bookID),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final chapters = snapshot.data!;
            return ListView.builder(
              itemCount: chapters.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Chapter ${chapters[index]['number']}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VersesScreen(
                          bibleID: bibleID,
                          chapterID: chapters[index]['id'],
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
