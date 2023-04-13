import 'package:time_tracker_app/app/home/models/jobs.dart';
import 'package:time_tracker_app/services/api_path.dart';
import 'package:time_tracker_app/services/firestore_services.dart';

abstract class Database {
  Future<void> setJob(Job job);
  Stream<List<Job>> jobsStream();
  Future<void> deleteJob(Job job);
}

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabse implements Database {
  FirestoreDatabse({required this.uid});
  final String uid;
  final _services = FireStoreServices.instance;
  @override
  Future<void> setJob(Job job) async => await _services.setData(
      path: APIPath.job(uid, job.id), data: job.toMap());
  @override
  Future<void> deleteJob(Job job) async => await _services.deleteData(
        path: APIPath.job(uid, job.id),
      );
  @override
  Stream<List<Job>> jobsStream() => _services.collectionStream(
      path: APIPath.jobs(uid),
      builder: (data, documentId) => Job.fromMap(data, documentId));
}
