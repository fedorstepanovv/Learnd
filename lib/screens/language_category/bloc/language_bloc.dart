import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:learnd/blocs/auth/auth_bloc.dart';
import 'package:learnd/models/failure.dart';
import 'package:learnd/models/models.dart';
import 'package:learnd/repositories/repositories.dart';
import 'package:meta/meta.dart';

part 'language_event.dart';
part 'language_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  final LanguageRepository _languageRepository;
  final AuthBloc _authBloc;
  LanguageBloc(
      {@required LanguageRepository languageRepository,
      @required AuthBloc authBloc})
      : _languageRepository = languageRepository,
        _authBloc = authBloc,
        super(LanguageState.initial());
  StreamSubscription<List<Future<Meeting>>> _meetingsSubscription;

  @override
  Future<void> close() {
    _meetingsSubscription?.cancel();
    return super.close();
  }

  @override
  Stream<LanguageState> mapEventToState(
    LanguageEvent event,
  ) async* {
    if (event is LanguageQueryChanged) {
      yield* _mapLanguageQueryChangedToState(event);
    } else if (event is LanguageMeetingsLoaded) {
      yield* _mapLanguageMeetingLoadedToState(event);
    } else if (event is LanguageToggledMeetingViem) {
      yield* _mapLanguageToggledMeetingViemToState(event);
    }
  }

  Stream<LanguageState> _mapLanguageQueryChangedToState(
      LanguageQueryChanged event) async* {
    yield state.copyWith(status: LanguageStatus.loading);
    try {
      final query = state.copyWith(query: event.query);
      _meetingsSubscription?.cancel();
      _meetingsSubscription = _languageRepository
          .getUserMeetingsByQuery(query: query.query, userId: _authBloc.state.user.uid)
          .listen((meetings) async {
        final allMeetings = await Future.wait(meetings);
        add(LanguageMeetingsLoaded(meetings: allMeetings));
      });

      yield (state.copyWith(status: LanguageStatus.loaded));
    } catch (e) {
      yield (state.copyWith(
          failure: Failure(message: "We couldnt find info by this query"),
          status: LanguageStatus.error));
    }
  }

  Stream<LanguageState> _mapLanguageMeetingLoadedToState(
      LanguageMeetingsLoaded event) async* {
    yield state.copyWith(meetings: event.meetings);
  }

  Stream<LanguageState> _mapLanguageToggledMeetingViemToState(
      LanguageToggledMeetingViem event) async* {
    yield state.copyWith(isMeetingViem: event.isMeetingViem);
  }
}
