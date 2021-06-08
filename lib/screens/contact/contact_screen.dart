import 'package:flutter/material.dart';
import 'package:learnd/widgets/widgets.dart';

class ContactScreenArgs {
  final String contactInfo;

  ContactScreenArgs({@required this.contactInfo});
}

class ContactScreen extends StatelessWidget {
  static const routeName = '/contactScreen';
  final String contactInfo;

  const ContactScreen({Key key, @required this.contactInfo}) : super(key: key);
  static Route route({@required ContactScreenArgs args}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => ContactScreen(
        contactInfo: args.contactInfo,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal:26.0,vertical: 80),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                    child: SelectableText(
                  "Telegram id: $contactInfo",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                )),
                const SizedBox(height: 15,),
                MainButton(
                  text: "Got It",
                  onTap: () => Navigator.of(context).pop(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
