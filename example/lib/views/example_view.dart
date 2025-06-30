import 'package:example/views/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:master_utility/master_utility.dart';

/// Constants for the Master Utility screen
class _Constants {
  static const double headerHeight = 56.0;
  static const double iconSize = 48.0;
  static const double borderRadius = 24.0;
  static const double smallBorderRadius = 14.0;
  static const double spacing = 20.0;
  static const double padding = 24.0;

  // Colors
  static const Color primaryGradientStart = Color(0xFF2E429B);
  static const Color primaryGradientEnd = Color(0xFF764BA2);
  static const Color cardBackground = Colors.white;
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color borderColor = Color(0xFFE2E8F0);

  // Gradients for section headers
  static const List<Color> doneKeyboardGradient = [Color(0xFF6366F1), Color(0xFF8B5CF6)];
  static const List<Color> toastHelpersGradient = [Color(0xFFFFA726), Color(0xFFEF4444)];
  static const List<Color> multimediaPickerGradient = [Color(0xFF34D399), Color(0xFF06B6D4)];
  static const List<Color> dateTimeGradient = [Color(0xFF3B82F6), Color(0xFF6366F1)];
  static const List<Color> readMoreGradient = [Color(0xFF8B5CF6), Color(0xFFEC4899)];
  static const List<Color> dialogsGradient = [Color(0xFF06B6D4), Color(0xFF0891B2)];
  static const List<Color> networkImageGradient = [Color(0xFFFDE68A), Color(0xFFF59E42)];
}

class MasterUtilityScreen extends StatefulWidget {
  const MasterUtilityScreen({super.key});

  @override
  State<MasterUtilityScreen> createState() => _MasterUtilityScreenState();
}

class _MasterUtilityScreenState extends State<MasterUtilityScreen> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ValueNotifier<bool> _isFocusNode = ValueNotifier<bool>(false);
  final ValueNotifier<String?> _multimediaOutput = ValueNotifier<String?>(null);
  final ValueNotifier<String?> _dateTimeOutput = ValueNotifier<String?>(null);

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    _isFocusNode.dispose();
    _multimediaOutput.dispose();
    _dateTimeOutput.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(_Constants.padding),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_Constants.primaryGradientStart, _Constants.primaryGradientEnd],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 102, 118, 234).withValues(alpha: 0.2),
            blurRadius: 32,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: _Constants.headerHeight,
            height: _Constants.headerHeight,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            child: const Center(
              child: Text('🧩', style: TextStyle(fontSize: 28)),
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Master Utility',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Essential tools for developers',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(_Constants.padding),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildSectionCard(
              title: 'Done Keyboard',
              description:
                  'Use this field to show a keyboard with a \'Done\' button for better user experience and input completion.',
              icon: _buildGradientIcon(_Constants.doneKeyboardGradient, Icons.keyboard_rounded),
              content: AppTextField(
                focusNode: _focusNode,
                label: "Enter your text here...",
                showDoneKeyboard: true,
                showExtraHeight: _isFocusNode,
              ),
            ),
            const SizedBox(height: _Constants.spacing),
            _buildSectionCard(
              title: 'Toast Helpers',
              description:
                  'Show quick toast notifications for user feedback, errors, or custom messages. Supports different styles and durations.',
              icon: _buildGradientIcon(_Constants.toastHelpersGradient, Icons.notifications_rounded),
              content: _buildToastButtons(),
            ),
            const SizedBox(height: _Constants.spacing),
            _buildSectionCard(
              title: 'Multimedia Picker',
              description:
                  'Pick images or videos from the device gallery or camera. Useful for uploading and sharing multimedia content easily.',
              icon: _buildGradientIcon(_Constants.multimediaPickerGradient, Icons.perm_media_rounded),
              content: _buildGradientButton('📸 Pick Media', _pickMedia),
            ),
            const SizedBox(height: _Constants.spacing),
            _buildSectionCard(
              title: 'DateTime Extension',
              description:
                  'Format and display date and time in various styles using helpful extensions for better readability and presentation.',
              icon: _buildGradientIcon(_Constants.dateTimeGradient, Icons.access_time_rounded),
              content: _buildSecondaryButton('🕐 Show Time', _showTime),
            ),
            const SizedBox(height: _Constants.spacing),
            _buildSectionCard(
              title: 'Read More Text',
              description:
                  'Display long text with a \'Read More\' option. Expand or collapse content for a cleaner and more concise UI.',
              icon: _buildGradientIcon(_Constants.readMoreGradient, Icons.subject_rounded),
              content: _buildReadMoreContent(),
            ),
            const SizedBox(height: _Constants.spacing),
            _buildSectionCard(
              title: 'Dialogs & Sheets',
              description:
                  'Show dialogs and action sheets for user confirmations, alerts, or choices. Enhance interaction and user guidance.',
              icon: _buildGradientIcon(_Constants.dialogsGradient, Icons.chat_bubble_outline_rounded),
              content: _buildDialogButtons(),
            ),
            const SizedBox(height: _Constants.spacing),
            _buildSectionCard(
              title: 'Network Image with Caching',
              description:
                  'Display images from the internet with caching support. Handles loading, errors, and improves performance for repeated views.',
              icon: _buildGradientIcon(_Constants.networkImageGradient, Icons.image_rounded),
              content: _buildNetworkImage(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required String description,
    required Widget icon,
    required Widget content,
  }) {
    return Container(
      padding: const EdgeInsets.all(_Constants.padding),
      decoration: BoxDecoration(
        color: _Constants.cardBackground,
        borderRadius: BorderRadius.circular(_Constants.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 24,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: _Constants.borderColor.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: _Constants.iconSize,
                height: _Constants.iconSize,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(_Constants.smallBorderRadius),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: icon,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: _Constants.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              color: _Constants.textSecondary,
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          content,
        ],
      ),
    );
  }

  Widget _buildGradientIcon(List<Color> colors, IconData icon) {
    return Container(
      width: _Constants.iconSize,
      height: _Constants.iconSize,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
        borderRadius: BorderRadius.circular(_Constants.smallBorderRadius),
      ),
      child: Center(
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }

  Widget _buildToastButtons() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _buildToastButton(
          '🔔',
          'Default',
          () => ToastHelper.showToast(message: "Default toast message"),
          isDefault: true,
        ),
        _buildToastButton(
          '⚠️',
          'Error',
          () => ToastHelper.errorToast(message: "Error toast message"),
          isError: true,
        ),
        _buildToastButton(
          '⭐',
          'Custom',
          () => ToastHelper.showCustomToast(
            message: "Custom Toast",
            backgroundColor: Colors.amberAccent,
            fontSize: 20,
            gravity: ToastGravity.BOTTOM,
            textColor: Colors.black,
            toastLength: Toast.LENGTH_LONG,
          ),
          isCustom: true,
        ),
      ],
    );
  }

  Widget _buildToastButton(
    String emoji,
    String label,
    VoidCallback onTap, {
    bool isDefault = false,
    bool isError = false,
    bool isCustom = false,
  }) {
    Color backgroundColor;
    Color textColor;
    Border? border;

    if (isError) {
      backgroundColor = const Color(0xFFFEF2F2);
      textColor = const Color(0xFFDC2626);
      border = Border.all(color: const Color(0xFFFECACA));
    } else if (isCustom) {
      backgroundColor = const Color.fromARGB(255, 156, 247, 211);
      textColor = Colors.white;
    } else {
      backgroundColor = const Color(0xFFF1F5F9);
      textColor = const Color(0xFF475569);
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: backgroundColor,
          gradient: isCustom
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF8B5CF6), Color(0xFF3B82F6)],
                )
              : null,
          borderRadius: BorderRadius.circular(12),
          border: border,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGradientButton(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
          ),
          borderRadius: BorderRadius.circular(_Constants.smallBorderRadius),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6366F1).withValues(alpha: 0.3),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSecondaryButton(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          border: Border.all(color: const Color(0xFFE2E8F0), width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF475569),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReadMoreContent() {
    return const ReadMoreTextHelper(
      "Flutter is Google's mobile UI open source framework to build high-quality native (super fast) interfaces for iOS and Android apps with the unified codebase.",
      trimLines: 2,
      colorClickableText: Color(0xFF8B5CF6),
      trimMode: TrimMode.Line,
      trimCollapsedText: 'Show more',
      trimExpandedText: 'Show less',
      moreStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Color(0xFF8B5CF6),
      ),
      lessStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Color(0xFF8B5CF6),
      ),
    );
  }

  Widget _buildDialogButtons() {
    return Row(
      children: [
        Expanded(
          child: _buildToastButton('⚠️', 'Alert Dialog', _showAlertDialog, isError: true),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSecondaryButton('↗️ Action Sheet', _showActionSheet),
        ),
      ],
    );
  }

  Widget _buildNetworkImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        height: 180,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Image.network(
          "https://images.unsplash.com/photo-1500622944204-b135684e99fd?q=80&w=2061&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              color: const Color(0xFFF1F5F9),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF6366F1),
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: const Color(0xFFF1F5F9),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 48, color: Color(0xFF64748B)),
                    SizedBox(height: 8),
                    Text('Failed to load image', style: TextStyle(color: Color(0xFF64748B))),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _pickMedia() async {
    final fileResult = await ImagePickerHelper.multiMediaPicker();
    LogHelper.logInfo("result $fileResult");
    _multimediaOutput.value = "Selected: $fileResult";
    ToastHelper.showCustomToast(
      message: "🖼️ Selected: $fileResult",
      backgroundColor: const Color(0xFF10B981),
      fontSize: 14,
      gravity: ToastGravity.BOTTOM,
      textColor: Colors.white,
      toastLength: Toast.LENGTH_LONG,
    );
  }

  void _showTime() {
    final time = DateTime.now().toCustomFormatter(formatter: DateTimeFormatter.HOUR_MINUTE);
    LogHelper.logInfo("DateTime $time");
    _dateTimeOutput.value = "Current time: $time";
    ToastHelper.showCustomToast(
      message: "🕐 Current time: $time",
      backgroundColor: const Color(0xFF3B82F6),
      fontSize: 16,
      gravity: ToastGravity.BOTTOM,
      textColor: Colors.white,
      toastLength: Toast.LENGTH_LONG,
    );
  }

  void _showAlertDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Alert Dialog'),
        content: const Text('This is an example alert dialog with modern styling.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6366F1),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showActionSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Action Sheet',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete', style: TextStyle(color: Colors.red)),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
