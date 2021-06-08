part of 'upload_post_cubit.dart';

enum UploadPostStatus { initial, loading, loaded, error }

class UploadPostState extends Equatable {
  final String title;
  final String description;
  final String contactInfo;

  final String language;
  final UploadPostStatus status;
  final Failure failure;
  final String link;
  final String countOfPeople;
  final String id;
  const UploadPostState({
    @required this.title,
    @required this.description,
    @required this.language,
    @required this.status,
    @required this.failure,
    @required this.link,
    @required this.countOfPeople,
    @required this.id,
    @required this.contactInfo,
  });

  @override
  List<Object> get props =>
      [title, description, language, status, failure, id, contactInfo];

  factory UploadPostState.initia() {
    return UploadPostState(
        link: '',
        countOfPeople: '',
        description: '',
        title: '',
        id: '',
        failure: Failure(),
        status: UploadPostStatus.initial,
        contactInfo: '',
        language: '');
  }

  UploadPostState copyWith({
    String link,
    String counfOfPeople,
    String title,
    String description,
    String chosenValue,
    String language,
    UploadPostStatus status,
    Failure failure,
    String id,
    String contactInfo,
  }) {
    return UploadPostState(
      link: link ?? this.link,
      countOfPeople: countOfPeople ?? this.countOfPeople,
      title: title ?? this.title,
      description: description ?? this.description,
      language: language ?? this.language,
      status: status ?? this.status,
      failure: failure ?? this.failure,
      id: id ?? this.id,
      contactInfo: contactInfo ?? this.contactInfo,
    );
  }
}
