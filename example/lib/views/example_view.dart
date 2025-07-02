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
  static const List<Color> doneKeyboardGradient = [
    Color(0xFF6366F1),
    Color(0xFF8B5CF6)
  ];
  static const List<Color> toastHelpersGradient = [
    Color(0xFFFFA726),
    Color(0xFFEF4444)
  ];
  static const List<Color> multimediaPickerGradient = [
    Color(0xFF34D399),
    Color(0xFF06B6D4)
  ];
  static const List<Color> dateTimeGradient = [
    Color(0xFF3B82F6),
    Color(0xFF6366F1)
  ];
  static const List<Color> readMoreGradient = [
    Color(0xFF8B5CF6),
    Color(0xFFEC4899)
  ];
  static const List<Color> dialogsGradient = [
    Color(0xFF06B6D4),
    Color(0xFF0891B2)
  ];
  static const List<Color> networkImageGradient = [
    Color(0xFFFDE68A),
    Color(0xFFF59E42)
  ];
  static const List<Color> preferenceHelperGradient = [
    Color(0xFF10B981),
    Color(0xFF059669)
  ];
  static const List<Color> apiHelperGradient = [
    Color(0xFF8B5CF6),
    Color(0xFF3B82F6)
  ];
  static const List<Color> permissionHelperGradient = [
    Color(0xFFF97316),
    Color(0xFFDC2626)
  ];
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 16 : _Constants.padding),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _Constants.primaryGradientStart,
            _Constants.primaryGradientEnd
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color:
                const Color.fromARGB(255, 102, 118, 234).withValues(alpha: 0.2),
            blurRadius: 32,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: isSmallScreen ? 44 : _Constants.headerHeight,
            height: isSmallScreen ? 44 : _Constants.headerHeight,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            child: Center(
              child: Text('🧩',
                  style: TextStyle(fontSize: isSmallScreen ? 24 : 28)),
            ),
          ),
          SizedBox(width: isSmallScreen ? 12 : 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Master Utility',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 20 : 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: isSmallScreen ? 2 : 4),
                Text(
                  'Essential tools for developers',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 12 : 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    return Padding(
      padding: EdgeInsets.all(isSmallScreen ? 16 : _Constants.padding),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildSectionCard(
              title: 'Done Keyboard',
              description:
                  'Use this field to show a keyboard with a \'Done\' button for better user experience and input completion.',
              icon: _buildGradientIcon(
                  _Constants.doneKeyboardGradient, Icons.keyboard_rounded),
              content: AppTextField(
                focusNode: _focusNode,
                label: "Enter your text here...",
                showDoneKeyboard: true,
                showExtraHeight: _isFocusNode,
              ),
            ),
            SizedBox(height: isSmallScreen ? 16 : _Constants.spacing),
            _buildSectionCard(
              title: 'Toast Helpers',
              description:
                  'Show quick toast notifications for user feedback, errors, or custom messages. Supports different styles and durations.',
              icon: _buildGradientIcon(
                  _Constants.toastHelpersGradient, Icons.notifications_rounded),
              content: _buildToastButtons(),
            ),
            SizedBox(height: isSmallScreen ? 16 : _Constants.spacing),
            _buildSectionCard(
              title: 'Multimedia Picker',
              description:
                  'Pick images or videos from the device gallery or camera. Useful for uploading and sharing multimedia content easily.',
              icon: _buildGradientIcon(_Constants.multimediaPickerGradient,
                  Icons.perm_media_rounded),
              content: _buildGradientButton('📸 Pick Media', _pickMedia),
            ),
            SizedBox(height: isSmallScreen ? 16 : _Constants.spacing),
            _buildSectionCard(
              title: 'DateTime Extension',
              description:
                  'Format and display date and time in various styles using helpful extensions for better readability and presentation.',
              icon: _buildGradientIcon(
                  _Constants.dateTimeGradient, Icons.access_time_rounded),
              content: _buildSecondaryButton('🕐 Show Time', _showTime),
            ),
            SizedBox(height: isSmallScreen ? 16 : _Constants.spacing),
            _buildSectionCard(
              title: 'Read More Text',
              description:
                  'Display long text with a \'Read More\' option. Expand or collapse content for a cleaner and more concise UI.',
              icon: _buildGradientIcon(
                  _Constants.readMoreGradient, Icons.subject_rounded),
              content: _buildReadMoreContent(),
            ),
            SizedBox(height: isSmallScreen ? 16 : _Constants.spacing),
            _buildSectionCard(
              title: 'Dialogs & Sheets',
              description:
                  'Show dialogs and action sheets for user confirmations, alerts, or choices. Enhance interaction and user guidance.',
              icon: _buildGradientIcon(_Constants.dialogsGradient,
                  Icons.chat_bubble_outline_rounded),
              content: _buildDialogButtons(),
            ),
            SizedBox(height: isSmallScreen ? 16 : _Constants.spacing),
            _buildSectionCard(
              title: 'Network Image with Caching',
              description:
                  'Display images from the internet with caching support. Handles loading, errors, and improves performance for repeated views.',
              icon: _buildGradientIcon(
                  _Constants.networkImageGradient, Icons.image_rounded),
              content: _buildNetworkImage(),
            ),
            SizedBox(height: isSmallScreen ? 16 : _Constants.spacing),
            _buildSectionCard(
              title: 'Shared Preferences Helper',
              description:
                  'Store and retrieve encrypted data from device storage with type safety. All data is automatically encrypted/decrypted for security.',
              icon: _buildGradientIcon(
                  _Constants.preferenceHelperGradient, Icons.note_add_rounded),
              content: _buildPreferenceHelperContent(),
            ),
            SizedBox(height: isSmallScreen ? 16 : _Constants.spacing),
            _buildSectionCard(
              title: 'API Helper',
              description:
                  'Comprehensive HTTP client with automatic error handling, authentication, interceptors, and analytics tracking. Built on Dio with advanced features.',
              icon: _buildGradientIcon(
                  _Constants.apiHelperGradient, Icons.api_rounded),
              content: _buildApiHelperContent(),
            ),
            SizedBox(height: isSmallScreen ? 16 : _Constants.spacing),
            _buildSectionCard(
              title: 'Permission Helper',
              description:
                  'Manage permissions and request user authorization for accessing device features and resources.',
              icon: _buildGradientIcon(
                  _Constants.permissionHelperGradient, Icons.security_rounded),
              content: _buildPermissionHelperContent(),
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 16 : _Constants.padding),
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: isSmallScreen ? 40 : _Constants.iconSize,
                height: isSmallScreen ? 40 : _Constants.iconSize,
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(_Constants.smallBorderRadius),
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
              SizedBox(width: isSmallScreen ? 12 : 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: isSmallScreen ? 18 : 20,
                        fontWeight: FontWeight.w700,
                        color: _Constants.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: isSmallScreen ? 12 : 16),
          Text(
            description,
            style: TextStyle(
              fontSize: isSmallScreen ? 13 : 14,
              color: _Constants.textSecondary,
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
          ),
          SizedBox(height: isSmallScreen ? 16 : 20),
          content,
        ],
      ),
    );
  }

  Widget _buildGradientIcon(List<Color> colors, IconData icon) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    return Container(
      width: isSmallScreen ? 40 : _Constants.iconSize,
      height: isSmallScreen ? 40 : _Constants.iconSize,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
        borderRadius: BorderRadius.circular(_Constants.smallBorderRadius),
      ),
      child: Center(
        child: Icon(icon, color: Colors.white, size: isSmallScreen ? 20 : 24),
      ),
    );
  }

  Widget _buildToastButtons() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery.of(context).size.width;
        final isSmallScreen = screenWidth < 360;

        // Use Wrap for responsive layout
        return Wrap(
          spacing: isSmallScreen ? 8 : 12,
          runSpacing: isSmallScreen ? 8 : 12,
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
      },
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

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
        constraints: BoxConstraints(minWidth: isSmallScreen ? 70 : 80),
        padding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 12 : 16,
            vertical: isSmallScreen ? 10 : 12),
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
            Text(emoji, style: TextStyle(fontSize: isSmallScreen ? 12 : 14)),
            SizedBox(width: isSmallScreen ? 4 : 6),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: isSmallScreen ? 12 : 14,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGradientButton(String text, VoidCallback onTap) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 20 : 24,
            vertical: isSmallScreen ? 14 : 16),
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
            style: TextStyle(
              fontSize: isSmallScreen ? 14 : 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  Widget _buildSecondaryButton(String text, VoidCallback onTap) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 16 : 20,
            vertical: isSmallScreen ? 12 : 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          border: Border.all(color: const Color(0xFFE2E8F0), width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: isSmallScreen ? 12 : 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF475569),
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery.of(context).size.width;
        final isSmallScreen = screenWidth < 360;

        if (constraints.maxWidth < 300 || isSmallScreen) {
          return Column(
            children: [
              _buildToastButton('⚠️', 'Alert Dialog', _showAlertDialog,
                  isError: true),
              SizedBox(height: isSmallScreen ? 8 : 12),
              _buildSecondaryButton('↗️ Action Sheet', _showActionSheet),
            ],
          );
        }

        return Row(
          children: [
            Expanded(
              child: _buildToastButton('⚠️', 'Alert Dialog', _showAlertDialog,
                  isError: true),
            ),
            SizedBox(width: isSmallScreen ? 8 : 12),
            Expanded(
              child: _buildSecondaryButton('↗️ Action Sheet', _showActionSheet),
            ),
          ],
        );
      },
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
                    Icon(Icons.error_outline,
                        size: 48, color: Color(0xFF64748B)),
                    SizedBox(height: 8),
                    Text('Failed to load image',
                        style: TextStyle(color: Color(0xFF64748B))),
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
    final time = DateTime.now()
        .toCustomFormatter(formatter: DateTimeFormatter.HOUR_MINUTE);

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
        content:
            const Text('This is an example alert dialog with modern styling.'),
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
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
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

  Widget _buildPreferenceHelperContent() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoSection(
          '🔐 Key Features:',
          [
            'Automatic encryption/decryption of all data',
            'Type-safe methods (String, Int, Double, Bool)',
            'Key versioning with "v2" prefix',
            'Null-safe operations with fallbacks',
            'Cross-platform compatibility',
          ],
          const Color(0xFF10B981),
          isSmallScreen,
        ),
        SizedBox(height: isSmallScreen ? 16 : 20),
        _buildInfoSection(
          '📝 Available Methods:',
          [
            'setStringPrefValue() / getStringPrefValue()',
            'setIntPrefValue() / getIntPrefValue()',
            'setDoublePrefValue() / getDoublePrefValue()',
            'setBoolPrefValue() / getBoolPrefValue()',
            'removePrefValue() - Remove specific key',
            'clearAll() - Clear all data',
          ],
          const Color(0xFF3B82F6),
          isSmallScreen,
        ),
        SizedBox(height: isSmallScreen ? 16 : 20),
        _buildInfoSection(
          '🚀 Initialization:',
          [
            'Must call before any other methods',
            'Requires WidgetsFlutterBinding.ensureInitialized()',
            'Provide secure encryption key (16+ chars recommended)',
            'Call in main(): await PreferenceHelper.init(encryptionKey: "key")',
            'Throws error if accessed before initialization',
          ],
          const Color(0xFFEC4899),
          isSmallScreen,
        ),
        SizedBox(height: isSmallScreen ? 16 : 20),
        _buildInfoSection(
          '💡 Quick Usage:',
          [
            'Store: await PreferenceHelper.setStringPrefValue(key: "name", value: "John")',
            'Retrieve: String name = PreferenceHelper.getStringPrefValue(key: "name")',
            'Remove: await PreferenceHelper.removePrefValue(key: "name")',
            'Clear All: await PreferenceHelper.clearAll()',
          ],
          const Color(0xFFF59E0B),
          isSmallScreen,
        ),
      ],
    );
  }

  Widget _buildApiHelperContent() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoSection(
          '🚀 Key Features:',
          [
            'Built on Dio HTTP client with advanced interceptors',
            'Automatic JWT token refresh and authentication',
            'Comprehensive error handling with custom error models',
            'MixPanel analytics integration for API tracking',
            'Support for file uploads and form data',
            'Progress tracking for uploads and downloads',
            'Request cancellation with CancelToken',
            'Automatic logging and debugging tools',
          ],
          const Color(0xFF8B5CF6),
          isSmallScreen,
        ),
        SizedBox(height: isSmallScreen ? 16 : 20),
        _buildInfoSection(
          '📡 Available Methods:',
          [
            'getApiResponse() - Standard API response handling',
            'getResponseWithMapper() - Type-safe response mapping',
            'MethodType.GET, POST, PATCH, PUT, DELETE support',
            'FormData support for file uploads',
            'Query parameters and custom headers',
            'Progress callbacks for upload/download',
            'MixPanel event tracking integration',
          ],
          const Color(0xFF3B82F6),
          isSmallScreen,
        ),
        SizedBox(height: isSmallScreen ? 16 : 20),
        _buildInfoSection(
          '🔧 Configuration:',
          [
            'dioClient.setConfiguration() - Set base URL and headers',
            'setRefreshTokenConfiguration() - JWT refresh setup',
            'setIsApiLogVisible() - Enable/disable API logging',
            'Automatic authorization header injection',
            'Custom interceptors for authentication',
            'Curl logger for debugging requests',
            'HTTP formatter for request/response logging',
          ],
          const Color(0xFFEC4899),
          isSmallScreen,
        ),
        SizedBox(height: isSmallScreen ? 16 : 20),
        _buildInfoSection(
          '💡 Quick Usage:',
          [
            'Setup: dioClient.setConfiguration("https://api.example.com")',
            'GET: APIService().getApiResponse(APIRequest(url: "/users", methodType: MethodType.GET))',
            'POST: APIService().getApiResponse(APIRequest(url: "/users", methodType: MethodType.POST, params: {"name": "John"}))',
            'With Mapper: APIService().getResponseWithMapper<User>(request, jsonMapper: User.fromJson)',
            'File Upload: APIService().getApiResponse(request, formData: FormData.fromMap({"file": file}))',
          ],
          const Color(0xFFF59E0B),
          isSmallScreen,
        ),
      ],
    );
  }

  Widget _buildInfoSection(
      String title, List<String> points, Color color, bool isSmallScreen) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: isSmallScreen ? 20 : 24,
                height: isSmallScreen ? 20 : 24,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Text(
                    title[0],
                    style: TextStyle(
                      fontSize: isSmallScreen ? 10 : 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(width: isSmallScreen ? 8 : 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 16,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: isSmallScreen ? 8 : 12),
          ...points
              .map((point) => Padding(
                    padding: EdgeInsets.only(
                      left: isSmallScreen ? 16 : 20,
                      bottom: isSmallScreen ? 4 : 6,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 4,
                          height: 4,
                          margin: EdgeInsets.only(top: isSmallScreen ? 6 : 8),
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: isSmallScreen ? 8 : 12),
                        Expanded(
                          child: Text(
                            point,
                            style: TextStyle(
                              fontSize: isSmallScreen ? 12 : 14,
                              color: _Constants.textPrimary,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildPermissionHelperContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPermissionButtons(),
      ],
    );
  }

  Widget _buildPermissionButtons() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 300 || isSmallScreen) {
          return Column(
            children: [
              _buildPermissionButton(
                  '📍', 'Location Permission', _requestLocationPermission),
              SizedBox(height: isSmallScreen ? 8 : 12),
              _buildPermissionButton(
                  '📷', 'Camera Permission', _requestCameraPermission),
            ],
          );
        }

        return Row(
          children: [
            Expanded(
              child: _buildPermissionButton(
                  '📍', 'Location Permission', _requestLocationPermission),
            ),
            SizedBox(width: isSmallScreen ? 8 : 12),
            Expanded(
              child: _buildPermissionButton(
                  '📷', 'Camera Permission', _requestCameraPermission),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPermissionButton(
      String emoji, String label, VoidCallback onTap) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 16 : 20,
            vertical: isSmallScreen ? 12 : 14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 22, 173, 249),
              Color.fromARGB(255, 38, 102, 220)
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 22, 128, 249)
                  .withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: TextStyle(fontSize: isSmallScreen ? 14 : 16)),
            SizedBox(width: isSmallScreen ? 6 : 8),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: isSmallScreen ? 12 : 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _requestLocationPermission() async {
    PermissionHandlerService.handlePermissions(
      type: PermissionType.LOCATION,
      callBack: () {
        ToastHelper.showCustomToast(
          message: "📍 Location permission granted!",
          backgroundColor: const Color(0xFF10B981),
          fontSize: 14,
          gravity: ToastGravity.BOTTOM,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG,
        );
      },
      permissionDeniedDialog: () {},
    );
  }

  void _requestCameraPermission() async {
    PermissionHandlerService.handlePermissions(
      type: PermissionType.CAMERA,
      callBack: () {
        ToastHelper.showCustomToast(
          message: "📷 Camera permission granted!",
          backgroundColor: const Color(0xFF3B82F6),
          fontSize: 14,
          gravity: ToastGravity.BOTTOM,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG,
        );
      },
      permissionDeniedDialog: () {},
    );
  }
}
