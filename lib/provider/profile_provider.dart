import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:expense_tracker/services/profile_service.dart';
import 'package:flutter/cupertino.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileService _profileService = ProfileService();

  File? _selectedImage;

  File? get selectedImage => _selectedImage;

  bool _isUploading = false;

  bool get isLoading => _isUploading;

  Future<void> pickProfileImage() async {
    final picker = ImagePicker();

    final XFile? image = await picker.pickImage(source: ImageSource.gallery,
    );
    if(image == null) return;

    _selectedImage = File(image.path);

    notifyListeners();
  }

  Future<void> uploadProfileImage(String userID) async {
    if(_selectedImage == null) return;

    _isUploading = true;
    notifyListeners();

    await _profileService.uploadProfilePicture(userId: userID, image: _selectedImage!);

    _isUploading = false;
    notifyListeners();
  }
}