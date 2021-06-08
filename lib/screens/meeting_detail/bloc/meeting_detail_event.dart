part of 'meeting_detail_bloc.dart';

abstract class MeetingDetailEvent extends Equatable {
  const MeetingDetailEvent();

  @override
  List<Object> get props => [];
}

class MeetingDetailIncrementedCoins extends MeetingDetailEvent {
  final String authorUserId;
  MeetingDetailIncrementedCoins({@required this.authorUserId});
}

class MeetingDetailDecrementedCoins extends MeetingDetailEvent {
  final String userId;
  MeetingDetailDecrementedCoins({
    @required this.userId,
  });
}

class MeetingDetailGotCoins extends MeetingDetailEvent {
  final String userId;
  MeetingDetailGotCoins({
    @required this.userId,
  });
}
