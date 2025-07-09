import 'package:example/views/example_view.dart';
import 'package:flutter/material.dart';
import 'package:master_utility/master_utility.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferenceHelper.init(encryptionKey: "encryptionKey");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MasterUtilityMaterialApp(
      title: 'Example App',
      home: const MasterUtilityScreen(),
    );
  }
}
