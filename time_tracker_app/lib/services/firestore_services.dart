import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreServices {
  FireStoreServices._();
  static final instance = FireStoreServices._();
  Future<void> setData(
      {required String path, required Map<String, dynamic> data}) async {
    final refrence = FirebaseFirestore.instance.doc(path);
    print('$path:$data');
    await refrence.set(data);
  }

  Future<void> deleteData({required String path}) async {
    final refrence = FirebaseFirestore.instance.doc(path);
    await refrence.delete();
  }

  Stream<List<T>> collectionStream<T>({
    required String path,
    required T builder(Map<String, dynamic> data, String documentId),
  }) {
    final refrence = FirebaseFirestore.instance.collection(path);
    final snapshots = refrence.snapshots();
    return snapshots.map((snapshot) => snapshot.docs
        .map((snapshot) => builder(snapshot.data(), snapshot.id))
        .toList());
  }
}
