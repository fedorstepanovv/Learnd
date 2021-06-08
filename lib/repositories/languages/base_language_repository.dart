import 'package:learnd/models/models.dart';

abstract class BaseLanguageRepository {
  Future<List<Language>> searchLanguages({String query});
  Stream<List<Future<Meeting>>> getUserMeetingsByQuery({String query});
  Future<List<Language>> getAllLanguages();
}
