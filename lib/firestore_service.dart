import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<DocumentSnapshot> getDocumentStream(String documentId) {
    return _db.collection('csc_pages').doc(documentId).snapshots();
  }
}
