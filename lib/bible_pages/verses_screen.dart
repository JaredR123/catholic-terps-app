import 'package:flutter/material.dart';
import 'api_connector.dart';

class VersesScreen extends StatefulWidget {
  final String bibleID;
  final String chapterID;
  VersesScreen({required this.bibleID, required this.chapterID});

  @override
  State<VersesScreen> createState() => _VersesScreenState();
}

class _VersesScreenState extends State<VersesScreen> {
  final BibleAPIService service = BibleAPIService();

  Future<List<String>> fetchAllVerses() async {
    final verses = await service.fetchVerses(widget.bibleID, widget.chapterID);
    List<String> verseContents = [];

    for (var verse in verses) {
      final content = await service.fetchVerseContent(widget.bibleID, verse['id']);
      verseContents.add(content);
    }

    return verseContents;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Verses')),
      body: FutureBuilder<List<String>>(
        future: fetchAllVerses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final versesContent = snapshot.data!;
            return ListView.builder(
              itemCount: versesContent.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(versesContent[index]),
                );
              }
            );
          }
        }
      )
    );
  }
}