import 'package:example/views/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:master_utility/master_utility.dart';

class ExampleView extends StatelessWidget {
  final FocusNode focusNode = FocusNode();
  ExampleView({super.key});

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
          child: Column(
            children: [
              AppTextField(
                focusNode: focusNode,
                label: "TextField to View Done Keyboard",
                showDoneKeyboard: true, // by default done view is false
                isNextButton: true,
              ),
              ElevatedButton(
                onPressed: () {
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
                  await DialogHelper.showActionSheet<PickerActionType>(
                    actions: const [
                      SheetAction(key: PickerActionType.camera, label: "Camera"),
                      SheetAction(key: PickerActionType.gallery, label: "Galley"),
                    ],
                  );
                },
                child: const Text("Show Action Bottom Sheet"),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 30.0),
                child: AppNetworkImage(
                  url:
                      "https://images.unsplash.com/photo-1500622944204-b135684e99fd?q=80&w=2061&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                  errorWidget: (p0, p1, p2) => const Icon(Icons.error),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  await PreferenceServiceHelper().setStringPrefValue(key: "setString", value: "showData");
                },
                child: const Text("Set Value in Shared Preference"),
              ),
              ElevatedButton(
                onPressed: () async {
                  String getValue = await PreferenceServiceHelper().getStringPrefValue(key: "setString");
                  LogHelper.logInfo("getValue $getValue");
                },
                child: const Text("Get Value in Shared Preference"),
              ),
              ElevatedButton(
                onPressed: () async {
                  bool isRemoved = await PreferenceServiceHelper().removePrefValue(key: "setString");
                  LogHelper.logInfo("isRemoved $isRemoved");
                },
                child: const Text("remove Value in Shared Preference"),
              ),
              ElevatedButton(
                onPressed: () async {
                  final fileResult = await ImagePickerHelper.multiMediaPicker();
                  LogHelper.logInfo("result $fileResult");
                },
                child: const Text("Multimedia Picker"),
              ),
              ElevatedButton(
                onPressed: () {
                  final time = DateTime.now().toCustomFormatter(formatter: DateTimeFormatter.HOUR_MINUTE);
                  LogHelper.logInfo("DateTime $time");
                },
                child: const Text("DateTime Extesion"),
              ),
            ],
          ),
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
