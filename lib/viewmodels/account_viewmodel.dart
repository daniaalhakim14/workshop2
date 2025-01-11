import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class AccountViewModel extends ChangeNotifier {
  Uint8List? _avatarBytes;

  Uint8List? get avatarBytes => _avatarBytes;

  Future<void> loadAvatar(String userId) async {
    _avatarBytes = null;
    notifyListeners();

    try {
      await fetchAvatar(userId);
    } catch (e) {
      debugPrint('Error loading avatar: $e');
    }
  }

  Future<void> fetchAvatar(String userId) async {
    final uri = Uri.parse('http://192.168.0.6:3000/api/get-profile-image/$userId');
    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        _avatarBytes = response.bodyBytes;
        debugPrint('Fetched avatar from server');
      } else {
        debugPrint('Failed to fetch avatar: ${response.body}');
        _avatarBytes = null;
      }
    } catch (e) {
      debugPrint('Error fetching avatar: $e');
      _avatarBytes = null;
    }
    notifyListeners();
  }

  Future<void> uploadAvatar(File avatar, String userId) async {
    final uri = Uri.parse('http://192.168.0.6:3000/api/update-profile-image/$userId');
    final request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath('personalImage', avatar.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      debugPrint('Avatar uploaded successfully');

      await fetchAvatar(userId);
    } else {
      final responseBody = await response.stream.bytesToString();
      debugPrint('Failed to upload avatar: $responseBody');
    }
  }

  void clearAvatar() {
    _avatarBytes = null;
    notifyListeners();
  }
}
