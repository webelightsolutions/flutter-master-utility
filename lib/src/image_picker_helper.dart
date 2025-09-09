// ignore_for_file: comment_references

// Dart imports:
import 'dart:io';

// Package imports:
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
// Project imports:
import 'package:master_utility/src/dialog_helper.dart';
import 'package:master_utility/src/log/log.dart';

enum PickerActionType {
  camera,
  gallery,
  video,
  cameraVideo,
  document,
}

/// To use In [IOS] add this code in `` project_directory/ios/Runner/info.plist ``
///
///``use``
///```
///final result = await ImagePickerHelper.openImagePicker();
///```
/// ```
/// <key>NSCameraUsageDescription</key>
/// <string>Upload image from camera for screen background \\ OR user can add own message</string>
///	<key>NSMicrophoneUsageDescription</key>
///	<string>Post videos to profile \\ OR user can add own message</string>
///	<key>NSPhotoLibraryUsageDescription</key>
///	<string>Upload images for screen background \\ OR user can add own message</string>
/// ```
class ImagePickerHelper {
  /// MULTIMEDIA PICKER ( PHOTO, VIDEO, DOCUMENT )
  static Future<File?> multiMediaPicker() async {
    String? pickedFilePath;
    final PickerActionType? actionType =
        await DialogHelper.showActionSheet<PickerActionType>(
      actions: const [
        SheetAction(
          key: PickerActionType.camera,
          label: 'Take Photo',
        ),
        SheetAction(
          key: PickerActionType.gallery,
          label: 'Photo from Gallery',
        ),
        SheetAction(
          key: PickerActionType.cameraVideo,
          label: 'Take a Video',
        ),
        SheetAction(
          key: PickerActionType.video,
          label: 'Video from Gallery',
        ),
        SheetAction(
          key: PickerActionType.document,
          label: 'Document',
        ),
      ],
    );
    pickedFilePath = await _imagePickerSwitch(actionType: actionType);

    LogHelper.logSuccess(" File path is : $pickedFilePath");
    return pickedFilePath != null ? File(pickedFilePath) : null;
  }

  static Future<List<XFile>> pickMultiImage(
      {int? imageQuality,
      double? maxImageHeight,
      double? maxImageWidth}) async {
    final ImagePicker picker = ImagePicker();
    Future<List<XFile>> imageList = picker.pickMultiImage(
      imageQuality: imageQuality,
      maxHeight: maxImageHeight,
      maxWidth: maxImageWidth,
    );
    LogHelper.logSuccess('Multi video : $imageList');
    return imageList;
  }

  static Future<FilePickerResult?> pickMultiVideo() async {
    final picker = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.video,
    );
    LogHelper.logSuccess('Multi Image List : $picker');
    return picker;
  }

  static Future<File?> customMediaPicker({
    required PickerActionType pickerActionType,
    double? maxImageHeight,
    double? maxImageWidth,
    CameraDevice preferredCameraDevice = CameraDevice.rear,

    ///The allowedExtensions works only when pickerActionType type is PickerActionType.document
    List<String>? allowedExtensions,
    FileType? type,
    bool? allowMultiple,

    ///The imageQuality argument modifies the quality of the image, ranging from 0-100 where 100 is the original/max quality.
    int? imageQuality,
  }) async {
    String? pickedFilePath = await _imagePickerSwitch(
      actionType: pickerActionType,
      type: type,
      imageQuality: imageQuality,
      maxImageHeight: maxImageHeight,
      maxImageWidth: maxImageHeight,
      preferredCameraDevice: preferredCameraDevice,
      allowedExtensions: allowedExtensions,
      allowMultiple: allowMultiple,
    );

    LogHelper.logSuccess(" File path is : $pickedFilePath");
    return pickedFilePath != null ? File(pickedFilePath) : null;
  }

  static Future<String?>? _imagePickerSwitch(
      {PickerActionType? actionType,
      int? imageQuality,
      Duration? maxVideoDuration,
      double? maxImageHeight,
      double? maxImageWidth,
      CameraDevice preferredCameraDevice = CameraDevice.rear,
      List<String>? allowedExtensions,
      bool? allowMultiple,
      FileType? type}) async {
    switch (actionType) {
      case PickerActionType.camera:
        final ImagePicker picker = ImagePicker();
        final XFile? photo = await picker.pickImage(
          source: ImageSource.camera,
          imageQuality: imageQuality,
          maxHeight: maxImageHeight,
          maxWidth: maxImageWidth,
          preferredCameraDevice: preferredCameraDevice,
        );
        return photo?.path;
      case PickerActionType.gallery:
        final ImagePicker picker = ImagePicker();
        final XFile? image = await picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: imageQuality,
          maxHeight: maxImageHeight,
          maxWidth: maxImageWidth,
        );
        return image?.path; //""

      case PickerActionType.video:
        final ImagePicker picker = ImagePicker();
        final XFile? video = await picker.pickVideo(
            source: ImageSource.gallery, maxDuration: maxVideoDuration);
        return video?.path;

      case PickerActionType.cameraVideo:
        final ImagePicker picker = ImagePicker();
        final XFile? video = await picker.pickVideo(
            source: ImageSource.camera, maxDuration: maxVideoDuration);
        return video?.path;

      case PickerActionType.document:
        final picker = await FilePicker.platform.pickFiles(
          allowMultiple: allowMultiple ?? false,
          type: type ?? FileType.any,
          allowedExtensions: allowedExtensions ?? ["pdf", "xlsx"],
        );
        final XFile file = XFile(picker?.files.single.path ?? "");
        return file.path;

      default:
        return null;
    }
  }

  /// Retrieves the file(s) from the underlying platform
  ///
  /// Default [type] set to [FileType.any] with [allowMultiple] set to false. Optionally, [allowedExtensions] might be provided (e.g. [pdf, svg, jpg].).
  Future<List<File?>?> documentPicker({
    FileType type = FileType.any,
    List<String>? allowedExtensions,
    bool allowMultiple = false,
  }) async {
    final picker = await FilePicker.platform.pickFiles(
      allowMultiple: allowMultiple,
      type: type,
      allowedExtensions: allowedExtensions,
    );

    final files = picker?.files.map((e) {
      if (e.path != null) {
        return File(e.path!);
      }
    }).toList();

    return files;
  }
}
