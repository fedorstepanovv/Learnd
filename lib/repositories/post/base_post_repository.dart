import 'package:learnd/models/models.dart';

abstract class BasePostRepository {
  Future<void> createMeeting({Meeting meeting});
  Stream<List<Future<Meeting>>> getUserMeetings({String userId});
  Future<List<Meeting>> getUserMeetingsFeed({String userId});
  void deleteUserMeeting({String userId});
}
