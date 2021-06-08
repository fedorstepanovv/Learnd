import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:learnd/blocs/blocs.dart';
import 'package:learnd/models/failure.dart';
import 'package:learnd/models/models.dart';
import 'package:learnd/repositories/repositories.dart';
import 'package:meta/meta.dart';

part 'upload_post_state.dart';

class UploadPostCubit extends Cubit<UploadPostState> {
  final PostRepository _postRepository;
  final AuthBloc _authBloc;
  UploadPostCubit({
    @required PostRepository postRepository,
    @required StorageRepository storageRepository,
    @required AuthBloc authBloc,
  })  : _postRepository = postRepository,
        _authBloc = authBloc,
        super(UploadPostState.initia());
  void titleChanged(String title) {
    emit(state.copyWith(title: title, status: UploadPostStatus.initial));
  }

  void descriptionChanged(String description) {
    emit(state.copyWith(
        description: description, status: UploadPostStatus.initial));
  }
  void contactInfoChanged(String contactInfo) {
    emit(state.copyWith(
        contactInfo: contactInfo, status: UploadPostStatus.initial));
  }

  String dropdownChanged(String language) {
    emit(state.copyWith(
      language: language,
      status: UploadPostStatus.initial,
    ));
    return language;
  }

  void uploadMeeting() async {
    emit(state.copyWith(status: UploadPostStatus.initial));
    try {
      final author = User.empty.copyWith(id: _authBloc.state.user.uid);
      final meeting = Meeting(
          userId: _authBloc.state.user.uid,
          author: author,
          title: state.title,
          caption: state.description,
          date: DateTime.now(),
          id: state.id,
          contactInfo: state.contactInfo,
          language: state.language);
      await _postRepository.createMeeting(meeting: meeting);
      emit(state.copyWith(status: UploadPostStatus.loaded));
    } catch (e) {
      emit(state.copyWith(
          status: UploadPostStatus.error,
          failure: Failure(message: "We couldnt upload your post.")));
    }
  }

  void reset() {
    emit(UploadPostState.initia());
  }
}
