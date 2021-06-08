import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'package:learnd/config/paths.dart';
import 'package:learnd/models/models.dart';
import 'package:learnd/models/user.dart';

class Meeting extends Equatable {
  final String title;
  final String id;
  final String userId;
  final String contactInfo;

  final User author;
  final String language;
  final String caption;
  final DateTime date;
  const Meeting({
    @required this.id,
    @required this.userId,
    @required this.title,
    @required this.author,
    @required this.language,
    @required this.caption,
    @required this.date,
    @required this.contactInfo,
  });

  @override
  List<Object> get props => [id, author, language, caption, date, contactInfo];

  Map<String, dynamic> toDocument() {
    return {
      'title': title,
      'author':
          FirebaseFirestore.instance.collection(Paths.users).doc(author.id),
      'language': language,
      'caption': caption,
      'date': Timestamp.fromDate(date),
      'userId': userId,
      'contactInfo' : contactInfo
    };
  }

  static Future<Meeting> fromDocument(DocumentSnapshot doc) async {
    if (doc == null) return null;
    final data = doc.data();
    final authorRef = data['author'] as DocumentReference;
    if (authorRef != null) {
      final authorDoc = await authorRef.get();
      if (authorDoc.exists) {
        return Meeting(
            title: data['title'] ?? '',
            author: User.fromDocument(authorDoc),
            caption: data['caption'] ?? '',
            language: data['language'] ?? '',
            date: (data['date'] as Timestamp)?.toDate(),
            userId: data['userId'] ?? '',
            contactInfo: data['contactInfo'] ?? '',
            id: doc.id);
      }
    }
    return null;
  }

  Meeting copyWith(
      {String title,
      String id,
      User author,
      String language,
      String caption,
      DateTime date,
      String userId,
      String contactInfo}) {
    return Meeting(
      title: title ?? this.title,
      id: id ?? this.id,
      author: author ?? this.author,
      language: language ?? this.language,
      caption: caption ?? this.caption,
      date: date ?? this.date,
      userId: userId ?? this.userId,
      contactInfo: contactInfo ?? this.contactInfo,
    );
  }
}
