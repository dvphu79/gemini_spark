import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'src/chat_screen.dart';

Future<void> main() async {
  // Ensure that widgets are initialized
  WidgetsFlutterBinding.ensureInitialized();
  // Load the .env file
  await dotenv.load(fileName: ".env");
  // Run the app
  runApp(const ProviderScope(child: GeminiSparkApp()));
}

class GeminiSparkApp extends StatelessWidget {
  const GeminiSparkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gemini Spark',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ChatScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
