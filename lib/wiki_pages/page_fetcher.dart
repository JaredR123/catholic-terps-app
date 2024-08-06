import 'package:cloud_firestore/cloud_firestore.dart';

Future<String?> fetchPageContent(String title) async {
  try {
    final query = await FirebaseFirestore.instance
      .collection('wiki_pages')
      .doc(title)
      .get();

    if (!query.exists) {
      return null;
    }

    print(query);
    return query['content'] as String?;
  } catch (e) {
    print('Error fetching content: $e');
    return null;
  }
}

Future<String?> fetchChunksContent(String title) async {
  try {
    final query = await FirebaseFirestore.instance
      .collection('wiki_pages')
      .where('title', isEqualTo: title)
      .get();

    if (query.docs.isEmpty) {
      return null;
    }

    final chunks = query.docs
      .where((doc) => doc.id.contains('_part_'))
      .toList()
      .map((doc) => doc['content'] as String)
      .toList();

    return chunks.join('');
  } catch (e) {
    print('Error fetching page: $e');
    return null;
  }
}