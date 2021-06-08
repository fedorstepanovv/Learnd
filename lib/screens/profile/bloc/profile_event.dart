part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class ProfileLoadUser extends ProfileEvent {
  final String userId;
  const ProfileLoadUser({@required this.userId});

  @override
  List<Object> get props => [userId];
}

class ProfileUpdateMeetings extends ProfileEvent {
  final List<Meeting> meetings;

  const ProfileUpdateMeetings({@required this.meetings});

  @override
  List<Object> get props => [meetings];
}

class ProfileDeletedMeeting extends ProfileEvent {
  final String userId;
  final String meetingId;

  const ProfileDeletedMeeting({@required this.userId, @required this.meetingId});
  @override
  List<Object> get props => [userId,meetingId];
}
