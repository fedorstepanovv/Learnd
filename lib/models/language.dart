import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Language extends Equatable {
  final String language;
  final String id;
  const Language({this.language,this.id});

  @override
  List<Object> get props => [language,id];

  Language copyWith({
    String language,
  }) {
    return Language(
      language: language ?? this.language,
    );
  }

  Map<String, dynamic> toDocument() {
    return {'language': language,'id':id};
  }

  factory Language.fromDocument(DocumentSnapshot doc) {
    if (doc == null) return null;
    final data = doc.data();
    return Language(language: data['language'],id: data['id']);
  }
}
