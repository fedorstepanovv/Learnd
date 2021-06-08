import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:learnd/blocs/auth/auth_bloc.dart';
import 'package:learnd/exceptions/exceptions.dart';
import 'package:learnd/models/failure.dart';
import 'package:learnd/models/models.dart';
import 'package:learnd/repositories/repositories.dart';
import 'package:learnd/repositories/user/user_repository.dart';
import 'package:learnd/screens/language_category/bloc/language_bloc.dart';

part 'meeting_detail_event.dart';
part 'meeting_detail_state.dart';

class MeetingDetailBloc extends Bloc<MeetingDetailEvent, MeetingDetailState> {
  final UserRepository _userRepository;
  MeetingDetailBloc({
    @required UserRepository userRepository,
    @required AuthBloc authBloc,
  })  : _userRepository = userRepository,
        super(MeetingDetailState.initial());

  @override
  Stream<MeetingDetailState> mapEventToState(
    MeetingDetailEvent event,
  ) async* {
    if (event is MeetingDetailDecrementedCoins) {
      yield* _mapMeetingDetailDecrementedToState(event);
    } else if (event is MeetingDetailIncrementedCoins) {
      yield* _mapMeetingDetailIncrementedToState(event);
    } else if (event is MeetingDetailGotCoins) {
      yield* _mapMeetingDetailGotCoinsToState(event);
    }
  }

  Stream<MeetingDetailState> _mapMeetingDetailDecrementedToState(
    MeetingDetailDecrementedCoins event,
  ) async* {
    try {
      yield (state.copyWith(status: MeetingDetailStatus.loading));
      _userRepository.decrementCoins(userId: event.userId);
      yield (state.copyWith(status: MeetingDetailStatus.loaded));
    } catch (e) {
      yield (state.copyWith(
          status: MeetingDetailStatus.error,
          failure: Failure(message: "Problem with decrementing coins")));
    }
  }

  Stream<MeetingDetailState> _mapMeetingDetailIncrementedToState(
    MeetingDetailIncrementedCoins event,
  ) async* {
    try {
      yield (state.copyWith(status: MeetingDetailStatus.loading));
      _userRepository.incrementCoins(userId: event.authorUserId);
      yield (state.copyWith(status: MeetingDetailStatus.loaded));
    } catch (e) {
      yield (state.copyWith(
          status: MeetingDetailStatus.error,
          failure: Failure(message: "Problem with incrementing coins")));
    }
  }

  Stream<MeetingDetailState> _mapMeetingDetailGotCoinsToState(
    MeetingDetailGotCoins event,
  ) async* {
    try {
      yield (state.copyWith(status: MeetingDetailStatus.loading));
      final userBalance = await _userRepository.getBalance(userId: event.userId);
      yield (state.copyWith(status: MeetingDetailStatus.loaded,coins: userBalance));
    } catch (e) {
      yield (state.copyWith(
          status: MeetingDetailStatus.error,
          failure: Failure(message: "Problem with incrementing coins")));
    }
  }
}
