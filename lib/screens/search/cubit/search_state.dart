part of 'search_cubit.dart';

enum SearchStatus { initial, loading, loaded, error, }

class SearchState extends Equatable {
  final List<Language> languages;
  final SearchStatus status;
  final Failure failure;
  const SearchState(
      {@required this.languages,
      @required this.status,
      @required this.failure,
     });
  factory SearchState.initial() {
    return SearchState(
      languages: [],
      status: SearchStatus.initial,
      failure: Failure(),
    );
  }
  @override
  List<Object> get props => [languages, status, failure, ];
  SearchState copyWith(
      {List<Language> languages,
      SearchStatus status,
      Failure failure,
      }) {
    return SearchState(
      languages: languages ?? this.languages,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
