part of 'language_bloc.dart';

enum LanguageStatus { initial, loading, loaded, error }

class LanguageState extends Equatable {
  final String query;
  final bool isMeetingViem;
  final LanguageStatus status;
  final Failure failure;
  final List<Meeting> meetings;
  const LanguageState({
    @required this.meetings,
    @required this.query,
    @required this.isMeetingViem,
    @required this.status,
    @required this.failure,
  });

  factory LanguageState.initial() {
    return LanguageState(
      query: '',
      status: LanguageStatus.initial,
      isMeetingViem: true,
      failure: Failure(),
      meetings: [],
    );
  }

  @override
  List<Object> get props =>
      [query, status, failure, meetings, isMeetingViem];

  LanguageState copyWith({
    String query,
    bool isMeetingViem,
    LanguageStatus status,
    Failure failure,
    List<Meeting> meetings,
  }) {
    return LanguageState(
      query: query ?? this.query,
      isMeetingViem: isMeetingViem ?? this.isMeetingViem,
      status: status ?? this.status,
      failure: failure ?? this.failure,
      meetings: meetings ?? this.meetings,
    );
  }
}
