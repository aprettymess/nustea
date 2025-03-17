import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nustea/models/user_model.dart';

final userProvider = StateProvider<UserModel?>((ref) => null);

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
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[300],
                      child: const Icon(Icons.person,
                          size: 50, color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Guest User',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    const Text('Please log in to see your profile.'),
                  ],
                ),
              ),
            ),
    );
  }
}
