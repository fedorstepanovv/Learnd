import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:learnd/blocs/auth/auth_bloc.dart';
import 'package:learnd/models/models.dart';
import 'package:learnd/repositories/repositories.dart';
import 'package:meta/meta.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository _userRepository;
  final AuthBloc _authBloc;
  final PostRepository _postRepository;

  StreamSubscription<List<Future<Meeting>>> _meetingsSubscription;
  ProfileBloc(
      {@required UserRepository userRepository,
      @required AuthBloc authBloc,
      @required PostRepository postRepository})
      : _userRepository = userRepository,
        _authBloc = authBloc,
        _postRepository = postRepository,
        super(ProfileState.initial());

  @override
  Stream<ProfileState> mapEventToState(
    ProfileEvent event,
  ) async* {
    if (event is ProfileLoadUser) {
      yield* _mapProfileLoadUserToState(event);
    } else if (event is ProfileUpdateMeetings) {
      yield* _mapProfileUpdateMeetingsToState(event);
    } else if(event is ProfileDeletedMeeting) {
      yield* _mapProfileDeletedMeetingToState(event);
    }
  }

  @override
  Future<void> close() {
    _meetingsSubscription.cancel();
    return super.close();
  }

  Stream<ProfileState> _mapProfileLoadUserToState(
      ProfileLoadUser event) async* {
    yield state.copyWith(status: ProfileStatus.loading);

    try {
      final user = await _userRepository.getUserWithId(userId: event.userId);
      //check whether the user is current user
      final isCurrentUser = _authBloc.state.user.uid == event.userId;
      _meetingsSubscription?.cancel();
      _meetingsSubscription = _postRepository
          .getUserMeetings(userId: event.userId)
          .listen((meetings) async {
        final allMeetings = await Future.wait(meetings);
        add(ProfileUpdateMeetings(meetings: allMeetings));
      });
      yield state.copyWith(
          user: user,
          isCurrentUser: isCurrentUser,
          status: ProfileStatus.loaded);
    } catch (e) {
      yield state.copyWith(
          status: ProfileStatus.error,
          failure: Failure(message: "We couldnt load your profile. Sorry"));
    }
  }

  Stream<ProfileState> _mapProfileUpdateMeetingsToState(
    ProfileUpdateMeetings event,
  ) async* {
    yield state.copyWith(meetings: event.meetings);
  }

  Stream<ProfileState> _mapProfileDeletedMeetingToState(
    ProfileDeletedMeeting event,
  ) async* {
    try {
      yield state.copyWith(status: ProfileStatus.loading);
      _postRepository.deleteUserMeeting(
          userId: event.userId, postId: event.meetingId);
      yield state.copyWith(status: ProfileStatus.deleted);
    } catch (e) {
      yield (state.copyWith(
          status: ProfileStatus.error,
          failure: Failure(message: "We couldnt delete your meeting")));
    }
  }
}
