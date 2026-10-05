import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  /// Picks an image from the gallery and returns the File
  Future<File?> pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80, // Compress slightly
      );
      if (pickedFile != null) {
        return File(pickedFile.path);
      }
    } catch (e) {
      print('Error picking image: $e');
    }
    return null;
  }

  /// Uploads an image file to the specified path in Firebase Storage
  /// Returns the download URL if successful, otherwise null
  Future<String?> uploadImage(File imageFile, String folderPath) async {
    try {
      final String fileName = const Uuid().v4();
      final Reference ref = _storage.ref().child('$folderPath/$fileName.jpg');
      
      final UploadTask uploadTask = ref.putFile(imageFile);
      final TaskSnapshot snapshot = await uploadTask;
      
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  /// Convenience method to pick and upload a profile picture
  Future<String?> pickAndUploadProfilePicture(String userId) async {
    final File? imageFile = await pickImage();
    if (imageFile == null) return null;

    return await uploadImage(imageFile, 'avatars/$userId');
  }
}
