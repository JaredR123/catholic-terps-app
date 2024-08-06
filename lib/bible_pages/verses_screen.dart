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
    final verseIds = verses.map((verse) => verse['id'] as String).toList();

    // Use Future.wait to fetch all verse contents concurrently
    final verseContents = await Future.wait(
      verseIds.map((id) => service.fetchVerseContent(widget.bibleID, id))
    );

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