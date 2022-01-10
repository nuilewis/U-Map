import 'package:cloud_firestore/cloud_firestore.dart';

class SearchService {
  searchByName({required String searchField, required String category}) {
    return FirebaseFirestore.instance
        .collection("umap_bamenda")
        .doc("umap_uba")
        .collection(category)
        .where('searchKey',
            isEqualTo: searchField.substring(0, 1).toUpperCase())
        .get();
  }
}
