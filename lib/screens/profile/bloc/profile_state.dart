part of 'profile_bloc.dart';

enum ProfileStatus { initial, loading, loaded, error, deleted }
class ProfileState extends Equatable {
  final User user;
  final List<Meeting> meetings;
  final bool isCurrentUser;
  final ProfileStatus status;
  final Failure failure;
  const ProfileState({
    @required this.meetings,
    @required this.user,
    @required this.isCurrentUser,
    @required this.status,
    @required this.failure,

  });
   factory ProfileState.initial() {
    return ProfileState(
      user: User.empty,
      meetings: [],
      isCurrentUser: false,
      status: ProfileStatus.initial,
      failure: Failure(),
    );
  }
  @override
  List<Object> get props => [user,isCurrentUser,status,failure,meetings];

  

  ProfileState copyWith({
    User user,
    bool isCurrentUser,
    List<Meeting> meetings,
    ProfileStatus status,
    Failure failure,
  }) {
    return ProfileState(
      meetings: meetings ?? this.meetings,
      user: user ?? this.user,
      isCurrentUser: isCurrentUser ?? this.isCurrentUser,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}

