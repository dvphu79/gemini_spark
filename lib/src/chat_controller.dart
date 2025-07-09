import 'dart:typed_data';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import 'chat_state.dart';

// The API key is now loaded from the .env file.

class ChatControllerNotifier extends StateNotifier<ChatState> {
  ChatControllerNotifier() : super(ChatState());

  final ImagePicker _picker = ImagePicker();
  GenerativeModel? _model;

  void _initializeModel() {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      state = state.copyWith(
        answer:
            "Error: API Key not set. Please add your Gemini API key in the .env file.",
        isLoading: false,
      );
      return;
    }
    _model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
  }

  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        // Clear previous answer when a new image is picked
        state = state.copyWith(imageFile: image, answer: '');
      }
    } catch (e) {
      state = state.copyWith(answer: 'Failed to pick image: $e');
    }
  }

  Future<void> generateAnswer(String prompt) async {
    if (state.imageFile == null) {
      state = state.copyWith(answer: 'Please select an image first.');
      return;
    }
    if (prompt.isEmpty) {
      state = state.copyWith(answer: 'Please enter a prompt.');
      return;
    }

    state = state.copyWith(isLoading: true, answer: '');

    _initializeModel();
    if (_model == null) return;

    try {
      final Uint8List imageBytes = await state.imageFile!.readAsBytes();
      final imagePart = DataPart('image/jpeg', imageBytes);

      final content = [
        Content.multi([TextPart(prompt), imagePart]),
      ];

      final response = await _model!.generateContent(content);

      state = state.copyWith(answer: response.text, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        answer: 'Failed to generate answer: ',
        isLoading: false,
      );
    }
  }
}

final chatControllerProvider =
    StateNotifierProvider<ChatControllerNotifier, ChatState>(
      (ref) => ChatControllerNotifier(),
    );
