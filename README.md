# Master Utility Package

A package that enables you to use a comprehensive set of utilities in a single package with customization. It includes features like Done Keyboard View For Android and IOS, Size Helper, Navigation Helper, Image Picker Helper, Date Time Helper, Auto Size Text Helper, Toast Helper, Email Dispose, Log Helper, Dialog Helper, Cache Network Image Helper, Validation Helper, Api Helper, Shared Preference Helper,image cropper helper, Debounce helper, Read more Text Helper, duble click redundant Helper and Permission handler with custom type Helper.

![](https://i.ibb.co/GQZ9z0kh/2025-07-02-12-55-52-ezgif-com-video-to-gif-converter.gif)

## **Support**

    - Android
    - iOS

### How to add this package to your project add this dependencies inside your pubspec.yaml file

    dependencies:
       master_utility :

## Import Package

> import 'package:master_utility/master_utility.dart';

## Uses

> For use this package

    MasterUtilityMaterialApp()
    Use this as a MaterialApp();

### This package contains the below points as of now. We can improve and add new points as per requirements in the future

## Done Keyboard View For Android and IOS

    You need to add the below line into FocusNode, which you can manage with Custom Text Filed. You have the option to hide the done keyboard, and you can enable the previous and next buttons to focus on the next and previous fields.

---

    focusNode: showDoneKeyboard
      ? (focusNode..addListener(() {
            final hasFocus = focusNode.hasFocus;
            if (hasFocus) {
            KeyboardOverlay.showOverlay(
                context: context,
                isNextButton: isNextButton,
                isPrevious: isPrevious,
                isShowButton: (isNextButton || isPrevious),
                  );
                } else {
                  KeyboardOverlay.removeOverlay();
                }
              })
      ): focusNode,

---

    AppTextField(
        focusNode: focusNode,
        label: "TextField to View Done Keyboard",
        showDoneKeyboard: true, // by default done view is false
    ),

![](https://i.ibb.co/spLdc4YM/image-1.png)

## **Navigation helper**

    NavigationHelper.navigatePop();

    NavigationHelper.navigatePush(route: routeName());

    NavigationHelper.navigatePushReplacement(route: routeName());

    NavigationHelper.navigatePushRemoveUntil(route: routeName());

![](https://i.ibb.co/y6R5d4B/Screenshot-2023-12-21-at-6-45-05-PM.png)

## **Sizer helper**

> add below line inside your first widget build method

    SizeHelper.setMediaQuerySize();

    Container(
        width: 0.03.w,    //It will take a 30% of screen width
        height:0.03.h,     //It will take a 30% of screen height
    ),

    Padding(
        padding: EdgeInsets.symmetric(vertical: 0.05.h, horizontal: 0.05.w),
        child: Container(),
    );

    Text('Sizer Helper',style: TextStyle(fontSize: 5.5.fs));

## **Image picker helper**

> To use In [IOS] add this code in project_directory/ios/Runner/info.plist

    `<key>`NSCameraUsageDescription `</key>`
        `<string>`Upload image from camera for screen background `</string>`
        `<key>`NSMicrophoneUsageDescription `</key>`
        `<string>`Post videos to profile `</string>`
        `<key>`NSPhotoLibraryUsageDescription `</key>`
        `<string>`Upload images for screen background `</string>`

- Multimedia picker

  - Take Photo
  - Photo from Gallery
  - Take a Video
  - Video from Gallery
  - Document

    final result = await ImagePickerHelper.multiMediaPicker();
- Custom media picker

  final result =  await ImagePickerHelper.customMediaPicker(
  pickerActionType:PickerActionType.camera);

  use below enum for custom media picker
  PickerActionType.camera
  PickerActionType.gallery,
  PickerActionType.video,
  PickerActionType.cameraVideo,
  PickerActionType.document,

![](https://i.ibb.co/VYcK9vpc/image-1.png)

## Date time helper

> we have extension for on dateTime.

    DateTime.now().toCustomFormatter(formatter:DateTimeFormatter.HOUR_MINUTE)

![](https://i.ibb.co/P6Bwp4B/Screenshot-2023-12-21-at-6-29-25-PM.png)

## Auto size text helper

    Widget AutoText AutoText({
        Key? key,
        Key? textKey,
        TextStyle? style,
        StrutStyle? strutStyle,
        double? minFontSize,
        double? maxFontSize,
        List`<double>`? presetFontSizes,
        AutoSizeGroup? group,
        TextAlign? textAlign,
        TextDirection? textDirection,
        Locale? locale,
        bool? softWrap,
        bool wrapWords = true,
        TextOverflow? overflow,
        Widget? overflowReplacement,
        double? textScaleFactor,
        int? maxLines,
        String? semanticsLabel,
        required String text,
        TextSpan? textSpan,
    })

## Toast helper

    Method : 1

    showToast({required String message})

    Method : 2

    void showCustomToast({
            required String message,
            Color? backgroundColor,
            Color? textColor,
            double? fontSize,
            ToastGravity? gravity,
        })

![](https://i.ibb.co/N6b9SRJ8/Mac-Book-Pro-16-1.png)

## Email Dispose helper

    void getEmailDisposeHelper() async {
        final EmailDisposerResModel? result = await EmailDisposeHelper.emailDisposerChecker(email: “fredrik.eilesartsen@yopmail.com”);
        LogHelper.logInfo(“Is Email Disposable? : ${result?.disposable}“);
    }

## Log helper

    LogHelper.logInfo("add log here");

    LogHelper.logSuccess("add log here");

    LogHelper.logWarning("add log here");

    LogHelper.logError("add log here");

![](https://i.ibb.co/cwX262Y/Screenshot-2023-12-21-at-6-25-43-PM.png)

## Dialog Helper

Show Action Sheet

    final PickerActionType? actionType = await DialogHelper.showActionSheet`<PickerActionType>`(
        actions: const [
            SheetAction(key: PickerActionType.camera, label: AppStrings.camera),
            SheetAction(key: PickerActionType.gallery, label: AppStrings.gallery),
        ],
    );

![](https://i.ibb.co/Y4M0RgNW/image-1.png)

Show Dialog

    void _showDialogBox() {
        return DialogHelper.showCustomAlertDialog(
           barrierDismissible: false,
           builder: (BuildContext context, widget) {
           return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              title: const Text(AppStrings.noInternet),
              content: const Text(AppStrings.checkYourInternet),
              contentPadding: EdgeInsets.all(AppPadding.p15),
              titlePadding: EdgeInsets.all(AppPadding.p15),
              actions: [
                AppButton(
                  width: AppWidth.w140,
                  title: AppStrings.tryAgain,
                )
               ],
              ),
             );
        });
    }

![](https://i.ibb.co/ZRBG65gx/image-1.png)

## Cache network Image Helper

    AppNetworkImage(
        url: imageUrl,
        errorWidget: (p0, p1, p2) =>
            Icon(Icons.error),
    ),

## Validation helper

    validator: (v) => ValidationHelper.validateEmail(v),

## Api Helper

First of all, you want to add the below line to the main method.

    dioClient.setConfiguration(APIEndpoints.baseUrl);

FOR GET API CALL

    Future`<void>` getApiCall() async {
        final request = APIRequest(
            url: url,
            methodType: MethodType.GET,
        );

    final response =
            await APIService().GetApiResponse(request, apiResponse: (dynamic data) {
            return Data.fromJson(data);
        });
        if (response.hasError) {
            ToastHelper.showCustomToast(
            backgroundColor: Colors.red,
            message: response.message.toString());
        } else {
            _newData = response.data;
        }
    }

FOR POST API CALL

    final request = APIRequest(
       url: url,
       methodType: MethodType.POST,
       params: reqParam,
    );

FOR PUT API CALL

    final request = APIRequest(
       url: url,
       methodType: MethodType.PUT,
       params: reqParam,
    );

FOR DELETE API CALL

    final request = APIRequest(
       url: url,
       methodType: MethodType.DELETE,
    );

## Shared Preference Helper

First of all, you want to add the below line to the main method.

**Parameters:**

* `encryptionKey`: A required string parameter used as the key(32 character) for encrypting and decrypting stored data.

  await PreferenceHelper.init(encryptionKey: 'your-encryption-key');

This initialization method must be called before any other methods in the PreferenceHelper class to ensure that the shared preferences instance and encryption key are properly set.

For String SET and GET

    await PreferenceHelper().setStringPrefValue(key: key, value: value);

    String getValue = await PreferenceHelper().getStringPrefValue(key: key);

For bool SET and GET

    await PreferenceHelper().setBoolPrefValue(key: key, value: value);

    bool getValue = await PreferenceHelper().getBoolPrefValue(key: key);

For int SET and GET

    await PreferenceHelper().setIntPrefValue(key: key, value: value);

    int getValue = await PreferenceHelper().getIntPrefValue(key: key);

For double SET and GET

    await PreferenceHelper().setDoublePrefValue(key: key, value: value);

    double getValue = await PreferenceHelper().getDoublePrefValue(key: key);

For remove single value and clear all from Shared Preference

    await PreferenceHelper().removePrefValue(key: key);

    String getValue = await PreferenceHelper().clearAll();

**Note** : `Use PreferenceHelper instead of PreferenceServiceHelper`

## image cropper Helper

    croppedImage = await ImageCropperHelper.cropImage(imagePath: fileResult.path);

    LogHelper.logInfo("croppedImage result $croppedImage");

![](https://i.ibb.co/Y7Yw0DX/Screenshot-2024-01-10-15-56-08-77-082aea295e0e2b19157fadadca43d2cc.jpg)

## Read more and less more text Helper

    ReadMoreTextHelper(
        'Flutter is Google’s mobile UI open source framework to build high-quality native (super fast) interfaces for iOS and Android apps with the unified codebase.',
        trimLines: 2,
        colorClickableText: Colors.blue,
        trimMode: TrimMode.Line,
        trimCollapsedText: 'Show more',
        trimExpandedText: 'Show less',
        moreStyle: TextStyle(
        fontSize: 14, fontWeight: FontWeight.bold),
    ),

![](https://i.ibb.co/svvDvrzG/Mac-Book-Pro-16-1.png)

## Debounce Timer with milliseconds option Helper

    final debouncer = DebouncerHelper();

    debouncer.run(() {
        /// add your code here
    });

## double clicked redundant Helper

    ElevatedButton(
        onPressed: () {
            DoubleClickReduntHelper.handleDoubleClick();
            ToastHelper.showToast(message: "Default Toast");
        },
        child: const Text("Show Default Toast"),
    )

## Permission Handler Helper

    PermissionHandlerService.handlePermissions(
        type: PermissionType.PHOTO,

    /// You can pass custom Dialog
        permissionDeniedDialog: () {
           return showDialog(
                context: context,
                builder: (context) {
                 return const AlertDialog(title: Text("Custom Dialog"));
                            },
                        );
                    },
            callBack: () async {
                 final fileResult = await ImagePickerHelper.customMediaPicker(
                                    pickerActionType: PickerActionType.gallery,
                                  );
                LogHelper.logInfo("result $fileResult");
                if (fileResult != null) {
                    croppedImage.value =await ImageCropperHelper.cropImage(imagePath: fileResult.path);

    LogHelper.logInfo("croppedImage result $croppedImage");
                                  }
                },
        )

![](https://i.ibb.co/chwbFyDM/image-2.png)

![img](https://i.ibb.co/Nnj4wtj7/2025-07-02-12-48-27-ezgif-com-video-to-gif-converter.gif)


## Using the Encryption Extension

This extension provides tools to encrypt map data using RSA and AES encryption algorithms. Below is a quick guide on how to utilize this functionality in your project:

1. **Load the Public Key:**
   Ensure you load the public key before using the encryption methods. Call `EncryptionService.loadPublicKey()` to load the key from preferences.
2. **Encrypt Data:**
   Extend a `Map` object with the `MapEncryption` extension and call the `encrypted()` method to encrypt its contents. This method generates a random secret key and IV, encrypts the map data with AES, and then encrypts the secret key with RSA.
3. **Access Encrypted Data:**
   The `encrypted()` method returns a map containing:
   * `encryptedData`: The AES-encrypted map data in base64 format.
   * `encryptedKey`: The RSA-encrypted secret key in base64 format.
   * `iv`: The IV used for AES encryption in base64 format.

Example usage:

> await EncryptionService.loadPublicKey();
> Map<String, dynamic> myMap = {'key': 'value'};
> Map<String, dynamic> encryptedMap = myMap.encrypted();
> print(encryptedMap);

By following these steps, you can securely encrypt your map data using the provided extension.

# API Service Documentation

## Overview
This document provides details on the `getResponseWithMapper` function, which is responsible for handling API requests and responses efficiently using the `Dio` package in Flutter. It also includes examples of how to fetch user data using this API service.

## `getResponseWithMapper<T>`

### Description
The `getResponseWithMapper` function handles API requests and responses while supporting JSON mapping for both objects and lists.

### Function Signature
```dart
Future<Either<ApiException, APIResponse<T>>> getResponseWithMapper<T>(
    APIRequest request, {
    FormData? formData,
    final JsonMapper<T>? jsonMapper,
    final ListJsonMapper<T>? listJsonMapper,
  })
```

### Parameters
- `request`: The API request containing the endpoint URL, method type, and other configurations.
- `formData` (optional): Form data for requests requiring file uploads.
- `jsonMapper` (optional): A function that maps a JSON object to a model class.
- `listJsonMapper` (optional): A function that maps a JSON array to a list of model objects.

### Behavior
- Ensures that only one of `jsonMapper` or `listJsonMapper` is provided.
- Maps response data to the corresponding model if a mapper function is provided.
- Handles Dio errors (`DioException`) and general exceptions.

### Error Handling
- If a `DioException` is thrown, a detailed `ApiException` is returned.
- If an unknown error occurs, a generic error message is returned.

### Example Usage
#### Fetching a List of Users
```dart
Future<void> getUsers() async {
  final request = APIRequest(
    url: '/users',
    methodType: MethodType.GET,
  );
  final response = await APIService().getResponseWithMapper<List<UserModel>>(
    request,
    listJsonMapper: UserModel.fromList,
  );
  response.fold(
    (l) => //Exception
    (r) => //List<UserModel>
  );
}
```

#### Fetching a Single User
```dart
Future<void> getUser1() async {
  final request = APIRequest(
    url: '/users/1',
    methodType: MethodType.GET,
  );
  final response = await APIService().getResponseWithMapper<UserModel>(
    request,
    jsonMapper: UserModel.fromJson,
  );
  response.fold(
    (l) => //Exception,
    (r) => //UserModel,
  );
}
```

## Notes
- Always ensure that either `jsonMapper` or `listJsonMapper` is passed, but not both.
- The function is designed to handle different API response types efficiently.
- Proper error handling is included for a seamless user experience.

This function provides a robust and scalable approach to handling API calls in a Flutter application.



# LOGARTE

## Overview
`Logarte` is a powerful in-app console for Flutter that lets you monitor `app logs`, inspect `network calls`, and easily share debug info. Boost your development workflow with real-time insights, exportable logs, and seamless team collaboration.

Please check [Logarte](https://pub.dev/packages/logarte) for more details  

## Configurations
```
dioClient.setConfiguration(AppEnv.baseUrl, logarteClient: logarte);


// enableFileLogger is mandatory to store logs in file

await LogHelper.setConfigurations(logarteClient: logarte, enableFileLogger: true);


// It will return logs file

final file = await LogHelper.getLogsFile();
```