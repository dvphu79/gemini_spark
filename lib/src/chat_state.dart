import 'package:image_picker/image_picker.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_state.freezed.dart';

@freezed
class ChatState with _$ChatState {
  const factory ChatState({
    XFile? imageFile,
    String? answer,
    @Default(false) bool isLoading,
  }) = _ChatState;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
