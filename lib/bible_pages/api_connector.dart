import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;

class BibleAPIService {
  final String initialURL = 'https://api.scripture.api.bible/v1/bibles';
  final String apiKey = '95634d44ab0be1979002b4db3fb3e421';

  String formatText(String text) {
  // Remove extraneous paragraph tags
  text = text.replaceAll('¶', '').trim();
  
  // Add a new line before chapter numbers that are immediately preceded by a letter
  String indentedText = text.replaceAllMapped(
    RegExp(r'(?<=[a-zA-Z])(\d+)'),
    (match) => '\n\n${match.group(0)}',
  );

  // Add two spaces after every chapter number
  String formattedText = indentedText.replaceAllMapped(
    RegExp(r'(\d+)'),
    (match) => '${match.group(0)}  ',
  );

  return formattedText;
}

  Future<List<dynamic>> fetchBibles() async {
    final response = await http.get(
      Uri.parse('$initialURL'),
      headers: {'api-key': apiKey},
    );
    if (response.statusCode == 200) {
      final List<dynamic> bibles = jsonDecode(response.body)['data'];

      bibles.sort((a, b) {
        // Alphabetical sort by Language, making sure English comes first
        if (a['language']['name'] == 'English') return -1;
        if (b['language']['name'] == 'English') return 1;
        return (a['language']['name'] as String).compareTo(b['language']['name'] as String);
      });

      return bibles;
    } else {
      throw Exception('Failed to load Bibles');
    }
  }

  Future<List<dynamic>> fetchBooks(String bibleID) async {
    final response = await http.get(
      Uri.parse('$initialURL/$bibleID/books'),
      headers: {'api-key': apiKey},
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'];
    } else {
      throw Exception('Failed to load books');
    }
  }

  Future<List<dynamic>> fetchChapters(String bibleID, String bookID) async {
    final response = await http.get(
      Uri.parse('$initialURL/$bibleID/books/$bookID/chapters'),
      headers: {'api-key': apiKey},
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'];
    } else {
      throw Exception('Failed to load chapters');
    }
  }

  Future<List<dynamic>> fetchVerses(String bibleID, String chapterID) async {
    final response = await http.get(
      Uri.parse('$initialURL/$bibleID/chapters/$chapterID/verses'),
      headers: {'api-key': apiKey},
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'];
    } else {
      throw Exception('Failed to load verses');
    }
  }

  Future<String> fetchVerseContent(String bibleID, String verseID) async {
    final response = await http.get(
      Uri.parse('$initialURL/$bibleID/verses/$verseID'),
      headers: {
        'api-key': apiKey,
        'Accept': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final htmlContent = data['data']?['content'] ?? '';
      final doc = parse(htmlContent);
      final text = doc.body?.text ?? 'Verse content not available';
      final cleanedText = formatText(text);
      return cleanedText;
    } else {
      throw Exception('Failed to load verse content');
    }
  }
}