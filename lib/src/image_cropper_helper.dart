// import 'dart:io';
// import 'package:image_cropper/image_cropper.dart';

// class ImageCropperHelper {
//   /// image cropper function which required imagepath and return cropped file.
//   ///
//   ///
//   ///
//   ///
//   ///
//   ///
//   ///
//   // ignore: comment_references
//   /// To use In [Android] add this code in `` android/app/src/main/AndroidManifest.xml ``
//   ///
//   /// ```
//   /// <activity
//   /// android:name="com.yalantis.ucrop.UCropActivity"
//   /// android:screenOrientation="portrait"
//   /// android:theme="@style/Theme.AppCompat.Light.NoActionBar"/>
//   /// ```
//   ///
//   // ignore: comment_references
//   /// No configuration required in [iOS]

//   static Future<File?> cropImage({
//     required String imagePath,
//     ImageCompressFormat? compressFormat,
//     List<PlatformUiSettings>? uiSetting,
//     CropAspectRatio? aspectRatio,
//     int? compressQuality,
//     int? maxHeight,
//     int? maxWidth,
//   }) async {
//     final croppedFile = await ImageCropper().cropImage(
//       sourcePath: imagePath,
//       uiSettings: uiSetting,
//       compressFormat: compressFormat ?? ImageCompressFormat.jpg,
//       compressQuality: compressQuality ?? 90,
//       aspectRatio: aspectRatio,
//       maxHeight: maxHeight,
//       maxWidth: maxWidth,
//     );

//     return croppedFile != null ? File(croppedFile.path) : null;
//   }
// }
