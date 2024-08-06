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
        future: futureBibles,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final bibles = snapshot.data!;
            
            // Group Bibles by language
            final Map<String, List<dynamic>> groupedBibles = {};
            for (var bible in bibles) {
              final language = bible['language']['name'] as String;
              if (!groupedBibles.containsKey(language)) {
                groupedBibles[language] = [];
              }
              groupedBibles[language]!.add(bible);
            }

            // Create a list of sections with headers and items
            final sections = <Widget>[];
            groupedBibles.forEach((language, bibles) {
              sections.add(
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    language,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ),
              );
              sections.addAll(
                bibles.map((bible) {
                  return ListTile(
                    title: Text(bible['name']),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BooksScreen(bibleID: bible['id']),
                        ),
                      );
                    },
                  );
                }).toList(),
              );
            });

            return ListView(
              children: sections,
            );
          }
        },
      ),
    );
  }
}
