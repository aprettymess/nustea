// Updated profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nustea/models/user_model.dart';
import '../../../core/common/side_menu.dart';

final userProvider = StateProvider<UserModel?>((ref) => null);

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen>
    with TickerProviderStateMixin {
  late final AnimationController _iconController;
  late final Animation<double> _iconAnimation;
  late final AnimationController _morphController;

  bool _menuVisible = false;
  int _beatCountProfile = 0;

  @override
  void initState() {
    super.initState();

    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _iconAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _iconController, curve: Curves.easeInOut),
    );
    _iconController
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _beatCountProfile++;
          if (_beatCountProfile < 4) {
            _iconController.reverse();
          }
        } else if (status == AnimationStatus.dismissed) {
          if (_beatCountProfile < 4) {
            _iconController.forward();
          }
        }
      })
      ..forward();

    _morphController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..reset();
  }

  @override
  void dispose() {
    _iconController.dispose();
    _morphController.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    setState(() => _menuVisible = !_menuVisible);
    _menuVisible ? _morphController.forward() : _morphController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              AppBar(
                title: const Text('Profile'),
                leading: ScaleTransition(
                  scale: _iconAnimation,
                  child: IconButton(
                    icon: AnimatedIcon(
                      icon: AnimatedIcons.menu_close,
                      progress: _morphController,
                    ),
                    onPressed: _toggleMenu,
                  ),
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
          SideMenu(
            menuVisible: _menuVisible,
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            animationController: _morphController,
            isHomeFirst: false,
          ),
        ],
      ),
    );
  }
}
