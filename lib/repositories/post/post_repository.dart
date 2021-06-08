import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:learnd/config/paths.dart';
import 'package:learnd/models/meeting.dart';
import 'package:learnd/repositories/post/base_post_repository.dart';
import 'package:meta/meta.dart';

class PostRepository extends BasePostRepository {
  final FirebaseFirestore _firebaseFirestore;

  PostRepository({FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Future<void> createMeeting({@required Meeting meeting}) async {
    await _firebaseFirestore
        .collection(Paths.meetings)
        .add(meeting.toDocument());
  }


  @override
  Stream<List<Future<Meeting>>> getUserMeetings({@required String userId}) {
    final authorRef = _firebaseFirestore.collection(Paths.users).doc(userId);
    return _firebaseFirestore
        .collection(Paths.meetings)
        .where('author', isEqualTo: authorRef)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snap) =>
            snap.docs.map((doc) => Meeting.fromDocument(doc)).toList());
  }



 

  @override
  Future<List<Meeting>> getUserMeetingsFeed({@required String userId}) async {
    final meetingsSnap = await _firebaseFirestore
        .collection(Paths.meetings)
        .orderBy('date', descending: true)
        .get();
    final meetings = Future.wait(
        meetingsSnap.docs.map((doc) => Meeting.fromDocument(doc)).toList());
    return meetings;
  }

  @override
  void deleteUserMeeting({@required String userId,@required String postId}) {
   final meetingRef = _firebaseFirestore.collection(Paths.meetings).doc(postId);
   meetingRef.delete();
  }
}
