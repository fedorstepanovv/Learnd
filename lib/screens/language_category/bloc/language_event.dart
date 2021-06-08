part of 'language_bloc.dart';

abstract class LanguageEvent extends Equatable {
  const LanguageEvent();

  @override
  List<Object> get props => [];
}

class LanguageQueryChanged extends LanguageEvent {
  final String query;

  LanguageQueryChanged({@required this.query});
  @override
  List<Object> get props => [query];
}

class LanguageToggledMeetingViem extends LanguageEvent {
  final bool isMeetingViem;

  LanguageToggledMeetingViem({@required this.isMeetingViem});
  @override
  List<Object> get props => [isMeetingViem];
}

class LanguageMeetingsLoaded extends LanguageEvent {
  final List<Meeting> meetings;

  LanguageMeetingsLoaded({@required this.meetings});
  @override
  List<Object> get props => [meetings];
}
