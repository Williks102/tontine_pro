import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProfilePhotoSection extends StatefulWidget {
  final XFile? capturedImage;
  final Function(XFile?) onImageCaptured;

  const ProfilePhotoSection({
    super.key,
    this.capturedImage,
    required this.onImageCaptured,
  });

  @override
  State<ProfilePhotoSection> createState() => _ProfilePhotoSectionState();
}

class _ProfilePhotoSectionState extends State<ProfilePhotoSection> {
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  bool _isCameraInitialized = false;
  bool _showCameraPreview = false;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<bool> _requestCameraPermission() async {
    if (kIsWeb) return true;
    return (await Permission.camera.request()).isGranted;
  }

  Future<void> _initializeCamera() async {
    try {
      if (!await _requestCameraPermission()) return;

      _cameras = await availableCameras();
      if (_cameras.isEmpty) return;

      final camera = kIsWeb
          ? _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.front,
              orElse: () => _cameras.first)
          : _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.back,
              orElse: () => _cameras.first);

      _cameraController = CameraController(
          camera, kIsWeb ? ResolutionPreset.medium : ResolutionPreset.high);

      await _cameraController!.initialize();
      await _applySettings();

      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('Camera initialization error: \$e');
    }
  }

  Future<void> _applySettings() async {
    if (_cameraController == null) return;

    try {
      await _cameraController!.setFocusMode(FocusMode.auto);
    } catch (e) {
      debugPrint('Focus mode error: \$e');
    }

    if (!kIsWeb) {
      try {
        await _cameraController!.setFlashMode(FlashMode.auto);
      } catch (e) {
        debugPrint('Flash mode error: \$e');
      }
    }
  }

  Future<void> _capturePhoto() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized)
      return;

    try {
      final XFile photo = await _cameraController!.takePicture();
      widget.onImageCaptured(photo);
      setState(() {
        _showCameraPreview = false;
      });
    } catch (e) {
      debugPrint('Photo capture error: \$e');
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        widget.onImageCaptured(image);
      }
    } catch (e) {
      debugPrint('Gallery pick error: \$e');
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(4.w)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 1.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2.w),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Choisir une photo de profil',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'camera_alt',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              title: Text('Prendre une photo'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _showCameraPreview = true;
                });
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'photo_library',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              title: Text('Choisir depuis la galerie'),
              onTap: () {
                Navigator.pop(context);
                _pickFromGallery();
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_showCameraPreview &&
        _isCameraInitialized &&
        _cameraController != null) {
      return Container(
        height: 60.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3.w),
          color: Colors.black,
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(3.w),
              child: CameraPreview(_cameraController!),
            ),
            Positioned(
              top: 2.h,
              left: 4.w,
              child: IconButton(
                onPressed: () {
                  setState(() {
                    _showCameraPreview = false;
                  });
                },
                icon: CustomIconWidget(
                  iconName: 'close',
                  color: Colors.white,
                  size: 6.w,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.black.withValues(alpha: 0.5),
                ),
              ),
            ),
            Positioned(
              bottom: 4.h,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: _capturePhoto,
                  child: Container(
                    width: 18.w,
                    height: 18.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        width: 1.w,
                      ),
                    ),
                    child: Center(
                      child: CustomIconWidget(
                        iconName: 'camera_alt',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 8.w,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Photo de profil',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
          ),
          SizedBox(height: 2.h),
          Center(
            child: GestureDetector(
              onTap: _showImageSourceDialog,
              child: Container(
                width: 30.w,
                height: 30.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.lightTheme.colorScheme.primaryContainer,
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    width: 0.5.w,
                  ),
                ),
                child: widget.capturedImage != null
                    ? ClipOval(
                        child: kIsWeb
                            ? Image.network(
                                widget.capturedImage!.path,
                                fit: BoxFit.cover,
                                width: 30.w,
                                height: 30.w,
                              )
                            : CustomImageWidget(
                                imageUrl: widget.capturedImage!.path,
                                width: 30.w,
                                height: 30.w,
                                fit: BoxFit.cover,
                              ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: 'add_a_photo',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 8.w,
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            'Ajouter\nune photo',
                            textAlign: TextAlign.center,
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
          if (widget.capturedImage != null) ...[
            SizedBox(height: 2.h),
            Center(
              child: TextButton.icon(
                onPressed: _showImageSourceDialog,
                icon: CustomIconWidget(
                  iconName: 'edit',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 4.w,
                ),
                label: Text('Modifier la photo'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
