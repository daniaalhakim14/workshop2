import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import '../configure_API.dart';
class AccountViewModel extends ChangeNotifier {
  Uint8List? _avatarBytes;
  bool _isLoading = false;

  Uint8List? get avatarBytes => _avatarBytes;
  bool get isLoading => _isLoading;

  Future<void> loadAvatar(String userId) async {
    if (_isLoading) return;
    _setLoading(true);

    try {
      await fetchAvatar(userId);
    } catch (e) {
      debugPrint('Error loading avatar: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchAvatar(String userId) async {
    final uri = Uri.parse('${AppConfig.baseUrl}/profile/get-profile-image/$userId');
    try {
      debugPrint('Fetching avatar for userId: $userId');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        _avatarBytes = response.bodyBytes;
        debugPrint('Fetched avatar successfully');
      } else {
        debugPrint('Failed to fetch avatar: ${response.statusCode}, Body: ${response.body}');
        _avatarBytes = null;
      }
    } catch (e) {
      debugPrint('Error fetching avatar: $e');
      _avatarBytes = null;
    }
    notifyListeners();
  }

  Future<void> uploadAvatar(File avatar, String userId) async {
    if (!await avatar.exists()) {
      debugPrint('Invalid file: ${avatar.path}');
      return;
    }

    debugPrint('Uploading avatar for userId: $userId');
    debugPrint('File path: ${avatar.path}');

    final uri = Uri.parse('${AppConfig.baseUrl}/profile/update-profile-image/$userId');
    final request = http.MultipartRequest('POST', uri);

    try {
      request.files.add(await http.MultipartFile.fromPath('personalImage', avatar.path));
      final response = await request.send();

      debugPrint('Upload response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        debugPrint('Avatar uploaded successfully');
        await fetchAvatar(userId);
      } else {
        final responseBody = await response.stream.bytesToString();
        debugPrint('Failed to upload avatar: $responseBody');
      }
    } catch (e) {
      debugPrint('Error uploading avatar: $e');
    }
  }

  void clearAvatar() {
    _avatarBytes = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    if (_isLoading != value) {
      _isLoading = value;
      notifyListeners();
    }
  }
}
