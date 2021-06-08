import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learnd/blocs/blocs.dart';
import 'package:learnd/config/color_pallete.dart';
import 'package:learnd/models/models.dart';
import 'package:learnd/repositories/repositories.dart';
import 'package:learnd/screens/screens.dart';
import 'package:learnd/widgets/widgets.dart';

import 'bloc/language_bloc.dart';

class LanguageScreenArgs {
  final String language;
  LanguageScreenArgs({
    @required this.language,
  });
}

class LanguageScreen extends StatefulWidget {
  static const routeName = '/languageScreen';
  final String args;
  const LanguageScreen({
    Key key,
    @required this.args,
  }) : super(key: key);
  static Route route({@required LanguageScreenArgs args}) {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (context) => BlocProvider<LanguageBloc>(
              create: (_) => LanguageBloc(
                authBloc: context.read<AuthBloc>(),
                languageRepository: context.read<LanguageRepository>(),
              )..add(LanguageQueryChanged(query: args.language)),
              child: LanguageScreen(
                args: args.language,
              ),
            ));
  }

  @override
  _LanguageScreenState createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return BlocConsumer<LanguageBloc, LanguageState>(
      listener: (context, state) {
        if (state.status == LanguageStatus.error) {
          return showDialog(
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
              title: Text("Last published on ${widget.args}"),
            ),
            body: _buildBody(state));
      },
    );
  }

  Widget _buildBody(LanguageState state) {
    switch (state.status) {
      case LanguageStatus.loading:
        return Center(child: CircularProgressIndicator());
      case LanguageStatus.initial:
        return Text("We dont have this language");
      default:
        return CustomScrollView(slivers: [
          
          SliverList(
              delegate: SliverChildBuilderDelegate(
            (context, index) {
              final meeting = state.meetings[index];
              return MeetingCard(
                onTap: () {
                  Navigator.of(context).pushNamed(MeetingDetailScreen.routeName,
                      arguments: MeetingDetailsArgs(
                        isCurrentUser: false,
                        meeting: meeting,
                      ));
                },
                meeting: meeting,
              );
            },
            childCount: state.meetings.length,
          ))
        ]);
    }
  }
}
