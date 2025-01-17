import 'dart:async';
import 'dart:html' as html;
import 'dart:convert';

class CloudinaryService {
  
  final String cloudinaryUrl = 'https://api.cloudinary.com/v1_1/disfofeam/image/upload';
  final String cloudinaryUploadPreset = 'notificationImage';

  Future<String> uploadImage() async {

    final html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.accept = 'image/*';
    uploadInput.click();


    final completer = Completer<String>();

    uploadInput.onChange.listen((e) async {
      final files = uploadInput.files;
      if (files == null || files.isEmpty) {
        completer.completeError('No file selected');
        return;
      }

      final file = files[0];
      final formData = html.FormData();

      formData.appendBlob('file', file, file.name);
      formData.append('upload_preset', cloudinaryUploadPreset);

      try {
        final request = await html.HttpRequest.request(
          cloudinaryUrl,
          method: 'POST',
          sendData: formData,
        );

        if (request.status == 200) {
          final responseBody = jsonDecode(request.responseText!);
          final imageUrl = responseBody['secure_url']; 
          print('Image URL: $imageUrl');
          completer.complete(imageUrl);
        } else {
          completer.completeError('Failed to upload image: ${request.statusText}');
        }
      } catch (error) {
        completer.completeError('Error uploading image: $error');
      }
    });

    return completer.future;
  }
}
