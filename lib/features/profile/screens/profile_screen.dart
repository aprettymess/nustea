// features/home/profile/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nustea/models/user_model.dart';
import 'package:routemaster/routemaster.dart';

final userProvider = StateProvider<UserModel?>((ref) => null);

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _morphController;
  bool _menuVisible = false;

  @override
  void initState() {
    super.initState();
    _morphController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  void _toggleMenu() {
    setState(() {
      _menuVisible = !_menuVisible;
      _menuVisible ? _morphController.forward() : _morphController.reverse();
    });
  }

  void _navigateHome() {
    _toggleMenu();
    Routemaster.of(context).push('/');
  }

  void _navigateCreateCommunities() {
    _toggleMenu();
    Routemaster.of(context).push('/create-community');
  }

  @override
  void dispose() {
    _morphController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              AppBar(
                title: const Text('Profile'),
                leading: IconButton(
                  icon: AnimatedIcon(
                    icon: AnimatedIcons.menu_close,
                    progress: _morphController,
                  ),
                  onPressed: _toggleMenu,
                ),
              ),
              Expanded(
                child: user != null
                    ? Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Hero(
                              tag: 'profile-pic',
                              child: CircleAvatar(
                                radius: 50,
                                backgroundImage: NetworkImage(user.profilePic),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              user.name,
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
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
                              Hero(
                                tag: 'profile-pic',
                                child: CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Colors.grey[300],
                                  child: const Icon(Icons.person,
                                      size: 50, color: Colors.white),
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'Guest User',
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              const Text('Please log in to see your profile.'),
                            ],
                          ),
                        ),
                      ),
              ),
            ],
          ),

          // Custom Side Menu
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            top: kToolbarHeight,
            left: _menuVisible ? 0 : -screenWidth * 0.6,
            child: Container(
              width: screenWidth * 0.6,
              height: MediaQuery.of(context).size.height - kToolbarHeight,
              color: Colors.grey.shade900,
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.home, color: Colors.white),
                      title: const Text('Home',
                          style: TextStyle(color: Colors.white)),
                      onTap: _navigateHome,
                    ),
                    ListTile(
                      leading: const Icon(Icons.group, color: Colors.white),
                      title: const Text('Communities',
                          style: TextStyle(color: Colors.white)),
                      onTap: _navigateCreateCommunities,
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
