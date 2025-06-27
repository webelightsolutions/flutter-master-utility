import 'package:example/views/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:master_utility/master_utility.dart';

class ExampleView extends StatefulWidget {
  const ExampleView({super.key});

  @override
  State<ExampleView> createState() => _ExampleViewState();
}

class _ExampleViewState extends State<ExampleView> {
  final FocusNode focusNode = FocusNode();
  final ValueNotifier<bool> isFocusNode = ValueNotifier<bool>(false);

  final ValueNotifier<String?> multimediaOutput = ValueNotifier<String?>(null);
  final ValueNotifier<String?> dateTimeOutput = ValueNotifier<String?>(null);

  @override
  void initState() {
    super.initState();
    focusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    if (mounted) {
      isFocusNode.value = focusNode.hasFocus;
    }
  }

  @override
  void dispose() {
    focusNode.unfocus();
    focusNode.removeListener(_handleFocusChange);
    focusNode.dispose();
    isFocusNode.dispose();
    multimediaOutput.dispose();
    dateTimeOutput.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: const Color(0xFFF3F6FB),
      body: Stack(
        children: [
          Container(
            color: const Color(0xFFF3F6FB),
          ),
          ValueListenableBuilder(
            valueListenable: isFocusNode,
            builder: (context, isFocus, child) {
              return ListView(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                children: [
                  // Custom header
                  SafeArea(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      decoration: BoxDecoration(
                        color: const Color(0xFF185a9d),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.7),
                            blurRadius: 14,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.extension, color: Colors.white, size: 28),
                          SizedBox(width: 10),
                          AutoText(
                            text: "Master Utility Example",
                            maxFontSize: 22,
                            minFontSize: 14,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  _sectionHeader(Icons.keyboard, "Done Keyboard"),
                  _card(
                    note:
                        "note: Use this field to show a keyboard with a 'Done' button for better user experience and input completion.",
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppTextField(
                          focusNode: focusNode,
                          label: "TextField with Done Keyboard",
                          showDoneKeyboard: true,
                          showExtraHeight: isFocusNode,
                        ),
                      ],
                    ),
                  ),
                  _divider(),

                  _sectionHeader(Icons.notifications, "Toast Helpers"),
                  _card(
                    note:
                        "note: Show quick toast notifications for user feedback, errors, or custom messages. Supports different styles and durations.",
                    child: Wrap(
                      spacing: 7,
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(Icons.notifications),
                          label: const Text("Default"),
                          onPressed: () {
                            DoubleClickReduntHelper.handleDoubleClick();
                            ToastHelper.showToast(message: "Default Toast");
                          },
                        ),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.error, color: Color.fromARGB(255, 158, 9, 9)),
                          label: const Text("Error"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFEBEE),
                            foregroundColor: const Color(0xFFD32F2F),
                          ),
                          onPressed: () {
                            DoubleClickReduntHelper.handleDoubleClick();
                            ToastHelper.errorToast(message: "Error Toast");
                          },
                        ),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.star, color: Color.fromARGB(255, 172, 131, 6)),
                          label: const Text("Custom"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFF9C4),
                            foregroundColor: const Color.fromARGB(255, 172, 131, 6),
                          ),
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
                        ),
                      ],
                    ),
                  ),
                  _divider(),

                  _sectionHeader(Icons.photo_library, "Multimedia Picker"),
                  _card(
                    note:
                        "note: Pick images or videos from the device gallery or camera. Useful for uploading and sharing multimedia content easily.",
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.photo_library),
                            label: const Text("Pick Media"),
                            onPressed: () async {
                              final fileResult = await ImagePickerHelper.multiMediaPicker();
                              LogHelper.logInfo("result $fileResult");
                              multimediaOutput.value = "output: $fileResult";
                            },
                          ),
                        ),
                        ValueListenableBuilder<String?>(
                          valueListenable: multimediaOutput,
                          builder: (context, value, _) {
                            if (value == null) return const SizedBox.shrink();
                            return Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  value,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.indigo,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  _divider(),

                  _sectionHeader(Icons.access_time, "DateTime Extension"),
                  _card(
                    note:
                        "note: Format and display date and time in various styles using helpful extensions for better readability and presentation.",
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.access_time),
                            label: const Text("Show Time"),
                            onPressed: () {
                              final time = DateTime.now().toCustomFormatter(formatter: DateTimeFormatter.HOUR_MINUTE);
                              LogHelper.logInfo("DateTime $time");
                              dateTimeOutput.value = "output: $time";
                            },
                          ),
                        ),
                        ValueListenableBuilder<String?>(
                          valueListenable: dateTimeOutput,
                          builder: (context, value, _) {
                            if (value == null) return const SizedBox.shrink();
                            return Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  value,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.indigo,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  _divider(),

                  _sectionHeader(Icons.read_more, "Read More Text"),
                  _card(
                    note:
                        "note: Display long text with a 'Read More' option. Expand or collapse content for a cleaner and concise UI.",
                    child: const ReadMoreTextHelper(
                      'Flutter is Google’s mobile UI open source framework to build high-quality native (super fast) interfaces for iOS and Android apps with the unified codebase.',
                      trimLines: 2,
                      colorClickableText: Colors.blue,
                      trimMode: TrimMode.Line,
                      trimCollapsedText: 'Show more',
                      trimExpandedText: 'Show less',
                      moreStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                  _divider(),

                  _sectionHeader(Icons.chat_bubble_outline, "Dialogs & Sheets"),
                  _card(
                    note:
                        "note: Show dialogs and action sheets for user confirmations, alerts, or choices. Enhance interaction and user guidance.",
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(Icons.warning_amber_rounded),
                          label: const Text("Alert Dialog"),
                          onPressed: () {
                            _showDialogBox();
                          },
                        ),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.arrow_upward),
                          label: const Text("Action Sheet"),
                          onPressed: () async {
                            await DialogHelper.showActionSheet<PickerActionType>(
                              actions: const [
                                SheetAction(key: PickerActionType.camera, label: "Camera"),
                                SheetAction(key: PickerActionType.gallery, label: "Gallery"),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  _divider(),

                  _sectionHeader(Icons.image, "Network Image with Caching"),
                  _card(
                    note:
                        "note: Display images from the internet with caching support. Handles loading, errors, and improves performance for repeated views.",
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: AppNetworkImage(
                        url:
                            "https://images.unsplash.com/photo-1500622944204-b135684e99fd?q=80&w=2061&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                        errorWidget: (p0, p1, p2) => const Icon(Icons.error),
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  if (isFocus) const SizedBox(height: 60),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 2, top: 10),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFe3eafc), // pale indigo for subtle contrast
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(6),
            child: Icon(icon, color: const Color(0xFF185a9d), size: 20),
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF185a9d),
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  // Update _card to accept a note parameter and display it
  Widget _card({required Widget child, required String note}) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      shadowColor: const Color(0xFF185a9d).withValues(alpha: 0.10),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }

  Widget _divider() => const Divider(
        height: 28,
        thickness: 1,
        color: Color(0xFFd1d9e6), // subtle divider
        indent: 2,
        endIndent: 2,
      );

  void _showDialogBox() {
    DialogHelper.showCustomAlertDialog(
      barrierDismissible: false,
      builder: (BuildContext context, Widget? widget) {
        return PopScope(
          onPopInvokedWithResult: (didPop, result) => false,
          child: AlertDialog(
            title: const Text("Title goes here"),
            content: const Text("Content goes here..."),
            actions: [
              ElevatedButton(
                onPressed: () {
                  NavigationHelper.navigatePop();
                },
                child: const Text("Okay"),
              )
            ],
          ),
        );
      },
    );
  }
}
