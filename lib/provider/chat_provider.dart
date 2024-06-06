import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../firebase.dart';

class ChatNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  ChatNotifier() : super([]);

  void updateChat(List<Map<String, dynamic>> chat) {
    print(chat);
    chat.sort((a, b) => a['timestamp'].compareTo(b['timestamp']));
    state = chat;
  }

  void addMessage(String message, String name, String roomId) {
    final newChat = {
      "userName": name,
      "message": message,
      "timestamp": DateTime.now().millisecondsSinceEpoch,
    };

    final chatRef = database.child('/chat/$roomId');
    chatRef.push().set(newChat);
  }

  bool checkGuess(String guess, String roomId) {
    guess = guess.trim().toLowerCase();
    final message = state.last['message'].trim().toLowerCase();
    final name = state.last['userName'];
    if (guess == message) {
      return true;
    }
    return false;
  }

  void clearChat() {
    state = [];
  }
}

final chatProvider =
    StateNotifierProvider<ChatNotifier, List<Map<String, dynamic>>>((ref) {
  return ChatNotifier();
});
