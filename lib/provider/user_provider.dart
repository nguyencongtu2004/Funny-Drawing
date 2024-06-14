import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../model/user.dart';

const uuid = Uuid();

class UserNotifier extends StateNotifier<User> {
  UserNotifier() : super(User(id: 'no-id', name: '', avatarIndex: 0));

  void updateUser(
      {required String id, required String name, required int avatarIndex}) {
    state = User(id: id, name: name, avatarIndex: avatarIndex);
  }
}

// Tạo một StateNotifierProvider để cung cấp UserNotifier cho các widget khác
final userProvider = StateNotifierProvider<UserNotifier, User>((ref) {
  return UserNotifier();
});