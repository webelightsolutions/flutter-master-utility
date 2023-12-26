# Master Utility Package

A package that enables you to use a comprehensive set of utilities in a single package with customization. It includes features like Done Keyboard View For Android and IOS, Size Helper, Navigation Helper, Image Picker Helper, Date Time Helper, Auto Size Text Helper, Toast Helper, Email Dispose, Log Helper, Dialog Helper, Cache Network Image Helper, Validation Helper, Api Helper, and Shared Preference Helper.

![](https://i.ibb.co/f427WkD/ezgif-com-video-to-gif-converted.gif)

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

----

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

----

    AppTextField(
        focusNode: focusNode,
        label: "TextField to View Done Keyboard",
        showDoneKeyboard: true, // by default done view is false
    ),

![](https://i.ibb.co/W6CsKK4/Simulator-Screenshot-i-Phone-12-Pro-2023-12-26-at-14-09-03.png)

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

        <key>NSCameraUsageDescription</key>
        <string>Upload image from camera for screen background</string>
        <key>NSMicrophoneUsageDescription</key>
        <string>Post videos to profile</string>
        <key>NSPhotoLibraryUsageDescription</key>
        <string>Upload images for screen background</string>

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

![](https://i.ibb.co/pdmbmZT/Screenshot-2023-12-21-18-26-18-22-082aea295e0e2b19157fadadca43d2cc.jpg)

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
        List<double>? presetFontSizes,
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

![](https://i.ibb.co/fFhtT2b/Screenshot-2023-12-21-18-25-27-04-082aea295e0e2b19157fadadca43d2cc.jpg) 
![](https://i.ibb.co/ZBJWN4W/Screenshot-2023-12-21-18-25-32-36-082aea295e0e2b19157fadadca43d2cc.jpg)

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

    final PickerActionType? actionType = await DialogHelper.showActionSheet<PickerActionType>(
        actions: const [
            SheetAction(key: PickerActionType.camera, label: AppStrings.camera),
            SheetAction(key: PickerActionType.gallery, label: AppStrings.gallery),
        ],
    );

![](https://i.ibb.co/jMWr4rc/Screenshot-2023-12-21-18-25-52-75-082aea295e0e2b19157fadadca43d2cc.jpg)

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

![](https://i.ibb.co/Bfgjjxk/Screenshot-2023-12-21-18-25-47-53-082aea295e0e2b19157fadadca43d2cc.jpg)

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

    Future<void> getApiCall() async {
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

    await PreferenceServiceHelper.init();

For String SET and GET

    await PreferenceServiceHelper().setStringPrefValue(key: key, value: value);

    String getValue = await PreferenceServiceHelper().getStringPrefValue(key: key);

For bool SET and GET

    await PreferenceServiceHelper().setBoolPrefValue(key: key, value: value);

    bool getValue = await PreferenceServiceHelper().getBoolPrefValue(key: key);

For int SET and GET

    await PreferenceServiceHelper().setIntPrefValue(key: key, value: value);

    int getValue = await PreferenceServiceHelper().getIntPrefValue(key: key);

For double SET and GET

    await PreferenceServiceHelper().setDoublePrefValue(key: key, value: value);

    double getValue = await PreferenceServiceHelper().getDoublePrefValue(key: key);

For remove single value and clear all from Shared Preference

    await PreferenceServiceHelper().removePrefValue(key: key);

    String getValue = await PreferenceServiceHelper().clearAll();
