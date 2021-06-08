import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:learnd/blocs/blocs.dart';
import 'package:learnd/config/color_pallete.dart';
import 'package:learnd/repositories/repositories.dart';
import 'package:learnd/screens/profile/bloc/profile_bloc.dart';
import 'package:learnd/screens/profile/widgets/widgets.dart';
import 'package:learnd/widgets/widgets.dart';

class ProfileScreenArgs {
  final String userId;

  const ProfileScreenArgs({@required this.userId});
}

class ProfileScreen extends StatefulWidget {
  static const String routeName = '/profile';
  static Route route({@required ProfileScreenArgs args}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => BlocProvider<ProfileBloc>(
        create: (_) => ProfileBloc(
          postRepository: context.read<PostRepository>(),
          userRepository: context.read<UserRepository>(),
          authBloc: context.read<AuthBloc>(),
        )..add(ProfileLoadUser(userId: args.userId)),
        child: ProfileScreen(),
      ),
    );
  }

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state.status == ProfileStatus.error) {
          showDialog(
            context: context,
            builder: (context) => ErrorDialog(content: state.failure.message),
          );
        }
        if (state.status == ProfileStatus.deleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Your post was deleted'),
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(body: _buildBody(state));
      },
    );
  }

  Widget _buildBody(ProfileState state) {
    switch (state.status) {
      case ProfileStatus.loading:
        return Center(child: CircularProgressIndicator());
      case ProfileStatus.initial:
        return state.isCurrentUser
            ? Center(child: Text("You have not assigned any meetings"))
            : Center(
                child: Text("This user doesnt have any meetings"),
              );
      default:
        return RefreshIndicator(
          onRefresh: () async {
            context
                .read<ProfileBloc>()
                .add(ProfileLoadUser(userId: state.user.id));
            return true;
          },
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.only(right: 26,left:26, top: 80,bottom: 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          UserProfileImage(
                            radius: 40,
                            profileImageUrl: state.user.profileImageUrl,
                          ),
                          UserProfileStats(
                            username: state.user.username,
                            isCurrentUser: state.isCurrentUser,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Text("Bio",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600,color: Colors.white)),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        state.user.bio,
                        style: TextStyle(fontSize: 16,color: ColorPallete.lightButtonColor),
                      ),
                      // const SizedBox(
                      //   height: 20,
                      // ),
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                              color: ColorPallete.darkTextColor,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 32.0, vertical: 8),
                                child: Text(
                                  "Balance: ${state.user.coins} coins",
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,color: Colors.white),
                                ),
                              )),
                        ),
                      ),
                      SizedBox(height: 20,),
                      Text(
                        "My Meetings",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600,color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final meeting = state.meetings[index];
                    if (state.isCurrentUser) {
                      return Slidable(
                        direction: Axis.horizontal,
                        actionPane: SlidableDrawerActionPane(),
                        child: MeetingCard(
                            meeting: meeting,
                            onTap: () {
                              //   Navigator.of(context)
                              //       .pushNamed(MeetingDetailScreen.routeName,
                              //           arguments: MeetingDetailsArgs(
                              //             isCurrentUser: state.isCurrentUser,
                              //             meeting: meeting,
                              //           ));
                              // },
                            }),
                        secondaryActions: [
                          IconSlideAction(
                            caption: 'Delete',
                            color: Colors.red,
                            icon: Icons.delete,
                            onTap: () => context.read<ProfileBloc>().add(
                                ProfileDeletedMeeting(
                                    meetingId: meeting.id,
                                    userId: state.user.id)),
                          ),
                        ],
                      );
                    } else {
                      return MeetingCard(
                        meeting: meeting,
                        onTap: () {
                          // Navigator.of(context)
                          //     .pushNamed(MeetingDetailScreen.routeName,
                          //         arguments: MeetingDetailsArgs(
                          //           isCurrentUser: state.isCurrentUser,
                          //           meeting: meeting,
                          //         ));
                        },
                      );
                    }
                  },
                  childCount: state.meetings.length,
                ),
              ),
            ],
          ),
        );
    }
  }
}
