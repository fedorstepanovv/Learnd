import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:learnd/config/paths.dart';
import 'package:learnd/models/models.dart';
import 'package:learnd/repositories/languages/base_language_repository.dart';
import 'package:meta/meta.dart';

class LanguageRepository extends BaseLanguageRepository {
  FirebaseFirestore _firebaseFirestore;

  LanguageRepository({FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Future<List<Language>> searchLanguages({@required String query}) async {
    final languageSnap = await _firebaseFirestore
        .collection(Paths.languages)
        .where('language', isEqualTo: query)
        .get();
    return languageSnap.docs.map((doc) => Language.fromDocument(doc)).toList();
  }

  @override
  Stream<List<Future<Meeting>>> getUserMeetingsByQuery(
      {@required String query, @required String userId}) {
    return _firebaseFirestore
        .collection(Paths.meetings)
        .where('language', isEqualTo: query)
        .where('userId', isNotEqualTo: userId)
        .snapshots()
        .map((snap) =>
            snap.docs.map((doc) => Meeting.fromDocument(doc)).toList());
  }

  @override
  Future<List<Language>> getAllLanguages() async {
    final languagesSnap =
        await _firebaseFirestore.collection(Paths.languages).get();
    return languagesSnap.docs.map((doc) => Language.fromDocument(doc)).toList();
  }
}
