import 'package:flutter/material.dart';
import 'package:learnd/config/color_pallete.dart';
import 'package:learnd/models/models.dart';
import 'package:learnd/extensions/extensions.dart';

class MeetingCard extends StatelessWidget {
  final Meeting meeting;
  final Function onTap;
  const MeetingCard({
    Key key,
    @required this.meeting,
    this.onTap,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 26.0, vertical: 20),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                meeting.title,
                
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: ColorPallete.lightTextColor),
                maxLines: 1,
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    meeting.author.username + " | " + meeting.date.timeAgo(),
                    style: const TextStyle(fontSize: 14, color: ColorPallete.lightGreyColor),
                  ),
                  Text(meeting.language,style: const TextStyle(fontSize: 14,color: ColorPallete.darkGreyColor),)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
