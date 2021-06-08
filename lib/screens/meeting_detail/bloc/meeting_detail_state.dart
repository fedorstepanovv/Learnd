part of 'meeting_detail_bloc.dart';

enum MeetingDetailStatus { initial, loading, loaded, error }

class MeetingDetailState extends Equatable {
  final String userId;
  final MeetingDetailStatus status;
  final int coins;
  final Failure failure;
  const MeetingDetailState(
      {@required this.userId,
      @required this.status,
      @required this.coins,
      @required this.failure});

  @override
  List<Object> get props => [userId, status];

  factory MeetingDetailState.initial() {
    return MeetingDetailState(
        userId: '',
        status: MeetingDetailStatus.initial,
        coins: 0,
        failure: Failure());
  }
  MeetingDetailState copyWith(
      {String userId, MeetingDetailStatus status, int coins, Failure failure}) {
    return MeetingDetailState(
        userId: userId ?? this.userId,
        status: status ?? this.status,
        failure: failure ?? this.failure,
        coins: coins ?? this.coins);
  }
}
