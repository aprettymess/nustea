import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nustea/models/user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';

final userProvider = Provider<UserModel?>((ref) {
  final googleUser = GoogleSignIn().currentUser;
  return googleUser != null
      ? UserModel(
          name: googleUser.displayName ?? 'Guest',
          profilePic: googleUser.photoUrl ?? '',
          banner: '',
          uid: googleUser.id,
          isAuthenticated: true,
          tc: 0,
          medals: [],
        )
      : null;
});

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final UserModel? user = ref.watch(userProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: user != null
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(user.profilePic),
                  ),
                  const SizedBox(height: 20),
                  Text(user.name,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  // ...additional user info as needed...
                ],
              ),
            )
          : const Center(child: Text('User data not available')),
    );
  }
}
