import 'dart:io';

import 'package:example/views/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:master_utility/master_utility.dart';

class ExampleView extends StatelessWidget {
  final FocusNode focusNode = FocusNode();
  final ValueNotifier<bool> isFocusNode = ValueNotifier<bool>(false);
  final ScrollController scrollController = ScrollController();
  ExampleView({super.key});
  final ValueNotifier<File?> croppedImage = ValueNotifier<File>(File(''));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade100,
      appBar: AppBar(
        title: const AutoText(
          text: "AppBar Title with auto text",
          maxFontSize: 20,
          minFontSize: 12,
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          controller: scrollController,
          child: ValueListenableBuilder(
              valueListenable: croppedImage,
              builder: (context, value, child) {
                return ValueListenableBuilder(
                    valueListenable: isFocusNode,
                    builder: (context, value, child) {
                      return Column(
                        children: [
                          AppTextField(
                            focusNode: focusNode,
                            label: "TextField to View Done Keyboard",
                            showDoneKeyboard:
                                true, // by default done view is false
                            showExtraHeight: isFocusNode,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              DoubleClickReduntHelper.handleDoubleClick();
                              ToastHelper.showToast(message: "Default Toast");
                            },
                            child: const Text("Show Default Toast"),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              ToastHelper.showCustomToast(
                                message: "Custom Toast",
                                backgroundColor: Colors.amberAccent,
                                fontSize: 20,
                                gravity: ToastGravity.BOTTOM,
                                textColor: Colors.black,
                                toastLength: Toast.LENGTH_LONG,
                              );
                            },
                            child: const Text("Show Custom Toast"),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              LogHelper.logInfo("Log Info");
                              LogHelper.logSuccess("Log Success");
                              LogHelper.logWarning("Log Warning");
                              LogHelper.logError("Log Error");
                            },
                            child: const Text("Show Log"),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _showDialogBox();
                            },
                            child: const Text("Show Custom Alert Dialog"),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              await DialogHelper.showActionSheet<
                                  PickerActionType>(
                                actions: const [
                                  SheetAction(
                                      key: PickerActionType.camera,
                                      label: "Camera"),
                                  SheetAction(
                                      key: PickerActionType.gallery,
                                      label: "Galley"),
                                ],
                              );
                            },
                            child: const Text("Show Action Bottom Sheet"),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40.0, vertical: 30.0),
                            child: AppNetworkImage(
                              url:
                                  "https://images.unsplash.com/photo-1500622944204-b135684e99fd?q=80&w=2061&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                              errorWidget: (p0, p1, p2) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              PreferenceServiceHelper()
                              .setStringPrefValue(
                                key: "setString", value: "showData");
                            },
                            child: const Text("Set Value in Shared Preference"),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              String getValue = PreferenceServiceHelper()
                              .getStringPrefValue(key: "setString");
                              LogHelper.logInfo("getValue $getValue");
                            },
                            child: const Text("Get Value in Shared Preference"),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              bool isRemoved = await PreferenceServiceHelper()
                                  .removePrefValue(key: "setString");
                              LogHelper.logInfo("isRemoved $isRemoved");
                            },
                            child:
                                const Text("remove Value in Shared Preference"),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              final fileResult =
                                  await ImagePickerHelper.multiMediaPicker();
                              LogHelper.logInfo("result $fileResult");
                            },
                            child: const Text("Multimedia Picker"),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              final time = DateTime.now().toCustomFormatter(
                                  formatter: DateTimeFormatter.HOUR_MINUTE);
                              LogHelper.logInfo("DateTime $time");
                            },
                            child: const Text("DateTime Extesion"),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              PermissionHandlerService.handlePermissions(
                                type: PermissionType.PHOTO,

                                /// You can pass custom Dialog
                                permissionDeniedDialog: () {
                                  return showDialog(
                                    context: context,
                                    builder: (context) {
                                      return const AlertDialog(
                                        title: Text("Custom Dialog"),
                                      );
                                    },
                                  );
                                },
                                callBack: () async {
                                  final fileResult =
                                      await ImagePickerHelper.customMediaPicker(
                                    pickerActionType: PickerActionType.gallery,
                                  );
                                  LogHelper.logInfo("result $fileResult");
                                  if (fileResult != null) {
                                    croppedImage.value =
                                        await ImageCropperHelper.cropImage(
                                      imagePath: fileResult.path,
                                    );

                                    LogHelper.logInfo(
                                        "croppedImage result $croppedImage");
                                  }
                                },
                              );
                            },
                            child: const Text("Image Cropper"),
                          ),
                          const SizedBox(height: 20.0),
                          const Padding(
                            padding: EdgeInsets.all(20.0),
                            child: ReadMoreTextHelper(
                              'Flutter is Google’s mobile UI open source framework to build high-quality native (super fast) interfaces for iOS and Android apps with the unified codebase.',
                              trimLines: 2,
                              colorClickableText: Colors.blue,
                              trimMode: TrimMode.Line,
                              trimCollapsedText: 'Show more',
                              trimExpandedText: 'Show less',
                              moreStyle: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          if (croppedImage.value?.path.isNotEmpty ?? false)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40.0, vertical: 30.0),
                              child: Image.file(croppedImage.value ?? File('')),
                            ),
                          if (isFocusNode.value) const SizedBox(height: 60),
                        ],
                      );
                    });
              }),
        ),
      ),
    );
  }

  void _showDialogBox() {
    return DialogHelper.showCustomAlertDialog(
      barrierDismissible: false,
      builder: (BuildContext context, widget) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: const Text("Title"),
            content: const Text("content"),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    NavigationHelper.navigatePop();
                  },
                  child: const Text("OKAY"))
            ],
          ),
        );
      },
    );
  }
}
