import 'dart:io';

abstract class BaseStorageRepository {
  Future<String> uploadProfileImage({String url, File image});
}