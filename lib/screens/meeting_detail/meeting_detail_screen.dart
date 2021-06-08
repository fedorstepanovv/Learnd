import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learnd/blocs/blocs.dart';
import 'package:learnd/config/color_pallete.dart';
import 'package:learnd/models/models.dart';
import 'package:learnd/repositories/repositories.dart';
import 'package:learnd/repositories/user/user_repository.dart';
import 'package:learnd/screens/screens.dart';
import 'package:learnd/widgets/widgets.dart';

import 'bloc/meeting_detail_bloc.dart';

class MeetingDetailsArgs {
  final Meeting meeting;
  final bool isCurrentUser;
  MeetingDetailsArgs({
    @required this.meeting,
    @required this.isCurrentUser,
  });
}

class MeetingDetailScreen extends StatelessWidget {
  static const routeName = '/meetingDetailScreen';
  final Meeting meeting;
  final bool isCurrentUser;
  const MeetingDetailScreen({
    Key key,
    @required this.meeting,
    @required this.isCurrentUser,
  }) : super(key: key);

  static Route route({@required MeetingDetailsArgs args}) {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (context) => BlocProvider<MeetingDetailBloc>(
              create: (_) => MeetingDetailBloc(
                  authBloc: context.read<AuthBloc>(),
                  userRepository: context.read<UserRepository>())
                ..add(MeetingDetailGotCoins(
                    userId: context.read<AuthBloc>().state.user.uid)),
              child: MeetingDetailScreen(
                isCurrentUser: args.isCurrentUser,
                meeting: args.meeting,
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MeetingDetailBloc, MeetingDetailState>(
      listener: (context, state) {
        if (state.status == MeetingDetailStatus.error) {
          showDialog(
              context: context,
              builder: (context) => ErrorDialog(
                    content: state.failure.message,
                  ));
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: ColorPallete.backgroundColor,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26.0, vertical: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  meeting.title,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 26,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          WidgetSpan(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 2.0),
                              child: Icon(
                                Icons.account_circle,
                                size: 16,
                              ),
                            ),
                          ),
                          TextSpan(
                              text: meeting.author.username,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  letterSpacing: 0.5)),
                        ],
                      ),
                    ),
                    Text(
                      meeting.language,
                      style: TextStyle(
                        color: ColorPallete.darkGreyColor,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 24,
                ),
                
                state.coins <= 0
                    ? ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color(0xffE4E4E4)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(17),
                            ),
                          ),
                        ),
                        onPressed: () {},
                        child: const Text(
                          "You dont have enough money",
                          style: TextStyle(color: Colors.black),
                        ),
                      )
                    : ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color(0xffE4E4E4)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(17),
                            ),
                          ),
                        ),
                        onPressed: () {
                          context.read<MeetingDetailBloc>()
                            ..add(MeetingDetailDecrementedCoins(
                              userId: context.read<AuthBloc>().state.user.uid,
                            ))
                            ..add(MeetingDetailIncrementedCoins(
                                authorUserId: meeting.userId));
                          Navigator.of(context).pushReplacementNamed(
                              ContactScreen.routeName,
                              arguments: ContactScreenArgs(
                                  contactInfo: meeting.contactInfo));
                        },
                        child: const Text(
                          "2 coins for conversation",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                const SizedBox(
                  height: 24,
                ),
                Text(
                  "Description",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600,color: ColorPallete.lightTextColor),
                ),
                const SizedBox(height: 12,),
                Text(meeting.caption, style: const TextStyle(fontSize: 15,color: ColorPallete.lightTextColor)),
              ],
            ),
          ),
        );
      },
    );
  }
}
