import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String username;
  final String email;
  final String bio;
  final String profileImageUrl;
  final int coins;
  const User(
      {this.id, this.username, this.email, this.bio, this.profileImageUrl,this.coins});

  static const empty =
      User(id: '', username: '', email: '', bio: '', profileImageUrl: '',coins: 0);

  @override
  List<Object> get props => [id, username, email, bio, profileImageUrl,coins];

  User copyWith({
    String id,
    String username,
    String email,
    String bio,
    String profileImageUrl,
    int coins
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      bio: bio ?? this.bio,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      coins: coins ?? this.coins
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'username': username,
      'email': email,
      'bio': bio,
      'profileImageUrl': profileImageUrl,
      'coins': coins
    };
  }

  factory User.fromDocument(DocumentSnapshot doc) {
    if (doc == null) return null;
    final data = doc.data();
    return User(
      id: doc.id,
      username: data['username'] ?? '',
      email: data['email'] ?? '',
      bio: data['bio'] ?? '',
      profileImageUrl: data['profileImageUrl'] ?? '',
      coins: data['coins'] ?? 0,
    );
  }
}
