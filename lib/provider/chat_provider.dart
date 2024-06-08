import 'package:draw_and_guess_promax/data/word_to_guess.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../firebase.dart';

class ChatNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  ChatNotifier() : super([]);

  void updateChat(List<Map<String, dynamic>> chat) {
    print(chat);
    chat.sort((a, b) => a['timestamp'].compareTo(b['timestamp']));
    state = chat;
  }

  void addMessage(String id, String message, String name, String roomId) {
    final newChat = {
      "id": id,
      "userName": name,
      "message": message,
      "timestamp": DateTime.now().millisecondsSinceEpoch,
    };
    print("Chat: " + message);
    final chatRef = database.child('/chat/$roomId');
    chatRef.push().set(newChat);
  }

  String checkGuess(String guess, String roomId) {
    final words =
        allWords.firstWhere((element) => element[guess] != null).values.first;
    guess = guess.trim().toLowerCase();
    final message = state.last['message'].trim().toLowerCase();
    final name = state.last['userName'];
    // Kiểm tra từ đúng
    if (guess == message) {
      return state.last['id'];
    }
    // Chấp nhận từ thay thế
    for (final word in words) {
      if (word.trim().toLowerCase() == guess) {
        return state.last['id'];
      }
    }
    return "";
  }

  void clearChat() {
    state = [];
  }
}

final chatProvider =
    StateNotifierProvider<ChatNotifier, List<Map<String, dynamic>>>((ref) {
  return ChatNotifier();
});
