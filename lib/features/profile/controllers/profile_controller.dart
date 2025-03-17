import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nustea/models/user_model.dart';

class ProfileController extends StateNotifier<UserModel?> {
  ProfileController() : super(null);

  // Example: method to update the user profile data
  void updateUser(UserModel user) {
    state = user;
  }

  // ...additional business logic as needed...
}

final profileControllerProvider =
    StateNotifierProvider<ProfileController, UserModel?>(
  (ref) => ProfileController(),
);
