import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:learnd/models/models.dart';
import 'package:learnd/repositories/repositories.dart';
import 'package:meta/meta.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final LanguageRepository _languageRepository;
  SearchCubit({@required LanguageRepository languageRepository})
      : _languageRepository = languageRepository,
        super(SearchState.initial());
  void searchUsers(String query) async {
    emit(state.copyWith(status: SearchStatus.loading));
    try {
      final languages = await _languageRepository.searchLanguages(query: query);
      emit(state.copyWith(languages: languages, status: SearchStatus.loaded));
    } catch (err) {
      state.copyWith(
        status: SearchStatus.error,
        failure: Failure(message: 'Something went wrong. Please try again.'),
      );
    }
  }



  void clearSearch() {
    emit(state.copyWith(languages: [], status: SearchStatus.initial));
  }
}
