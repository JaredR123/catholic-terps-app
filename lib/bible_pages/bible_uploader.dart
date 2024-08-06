// ! Deprecated File, DO NOT TOUCH !

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

Future<List<Map<String, dynamic>>> fetchBooks(String bibleID) async {
  final url = 'https://api.bible/v1/bibles/$bibleID/books';
  final String apiKey = '95634d44ab0be1979002b4db3fb3e421';
  final response = await http.get(
    Uri.parse(url),
    headers: {
      'api-key': apiKey,
    },
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final books = List<Map<String, dynamic>>.from(data['data']);
    return books;
  } else {
    throw Exception('Failed to load books');
  }
}

Future<List<Map<String, dynamic>>> fetchChapters(String bibleID, String bookID) async {
  final url = 'https://api.bible/v1/bibles/$bibleID/books/$bookID/chapters';
  final String apiKey = '95634d44ab0be1979002b4db3fb3e421';
  final response = await http.get(
    Uri.parse(url),
    headers: {
      'api-key': apiKey,
    },
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final chapters = List<Map<String, dynamic>>.from(data['data']);
    return chapters;
  } else {
    throw Exception('Failed to load chapters');
  }
}

Future<Map<String, dynamic>> fetchChapter(String bibleID, String bookID, String chapterID, {int startVerse = 1, int endVerse = 500}) async {
  final url = 'https://api.bible/v1/bibles/$bibleID/books/$bookID/chapters/$chapterID/verses?start=$startVerse&end=$endVerse';
  final String apiKey = '95634d44ab0be1979002b4db3fb3e421';
  final response = await http.get(
    Uri.parse(url),
    headers: {
      'api-key': apiKey,
    },
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load chapter');
  }
}

Future<void> storeChapterInFirestore(String bibleVersion, String bookID, String chapterID, Map<String, dynamic> chapterData) async {
  final firestore = FirebaseFirestore.instance;
  final chapterRef = firestore
      .collection(bibleVersion)
      .doc(bookID)
      .collection('chapters')
      .doc(chapterID);

  final verses = chapterData['verses'] as List;

  for (var verse in verses) {
    await chapterRef
        .collection('verses')
        .doc(verse['id'])
        .set({
          'text': verse['content'],
          'verseId': verse['id'],
          'chapterId': chapterID,
          'bookId': bookID,
        });
  }
}

Future<void> delay(int seconds) async {
  await Future.delayed(Duration(seconds: seconds));
}

Future<void> storeEntireBibleInFirestore(String bibleID, String bibleVersion) async {
  final books = await fetchBooks(bibleID);  // Fetch all books in the Bible
  for (var book in books) {
    final chapters = await fetchChapters(bibleID, book['id']);  // Fetch chapters for each book
    for (var chapter in chapters) {
      int verseStart = 1;
      int verseEnd = 500;
      bool hasMoreVerses = true;

      while (hasMoreVerses) {
        final chapterData = await fetchChapter(bibleID, book['id'], chapter['id'], startVerse: verseStart, endVerse: verseEnd);
        await storeChapterInFirestore(bibleVersion, book['id'], chapter['id'], chapterData);
        await delay(1);

        // Check if there are more verses to fetch
        if (chapterData['verses'].length < 500) {
          hasMoreVerses = false;
        } else {
          verseStart = verseEnd + 1;
          verseEnd += 500;
        }
      }
    }
  }
}

Future<void> fetchAndStoreBibleDetails(String bibleID) async {
  final url = 'https://api.bible/v1/bibles/$bibleID';
  final String apiKey = '95634d44ab0be1979002b4db3fb3e421';
  final response = await http.get(
    Uri.parse(url),
    headers: {
      'api-key': apiKey,
    },
  );

  if (response.statusCode == 200) {
    final bibleDetails = jsonDecode(response.body)['data'];
    final firestore = FirebaseFirestore.instance;

    await firestore.collection('bibles').doc(bibleID).set({
      'id': bibleDetails['id'],
      'abbreviation': bibleDetails['abbreviation'],
      'name': bibleDetails['name'],
      'language': bibleDetails['language']['name'],
      'languageId': bibleDetails['language']['id'],
      'script': bibleDetails['language']['script'],
      'direction': bibleDetails['language']['direction'],
      'copyright': bibleDetails['copyright'],
    });

    print('Bible details stored successfully in Firestore!');
  } else {
    throw Exception('Failed to load Bible details');
  }
}

Future<void> uploadBible() async {
  await Firebase.initializeApp();

  String bibleID = 'de4e12af7f28f599-02';
  String bibleVersion = 'KJV';

  try {
    await storeEntireBibleInFirestore(bibleID, bibleVersion);
    print('Bible stored in Firestore!');
    await fetchAndStoreBibleDetails(bibleID);
  } catch (e) {
    print('Error: $e');
  }
}