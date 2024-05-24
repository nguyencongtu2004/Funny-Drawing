import 'package:draw_and_guess_promax/model/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class UserNotifier extends StateNotifier<User> {
  UserNotifier() : super(User(id: uuid.v4(), name: '', avatarIndex: 0));

  void updateUser({required String name, required int avatarIndex}) {
    state = User(id: state.id, name: name, avatarIndex: avatarIndex);
    //print('UserNotifier: ${state.name}');
  }
}

// Tạo một StateNotifierProvider để cung cấp UserNotifier cho các widget khác
final userProvider = StateNotifierProvider<UserNotifier, User>((ref) {
  return UserNotifier();
});
