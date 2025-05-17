import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nustea/models/user_model.dart';
import 'package:routemaster/routemaster.dart';
import '../../../core/common/side_menu.dart';

final userProvider = StateProvider<UserModel?>((ref) => null);

class CreateCommunityScreen extends ConsumerStatefulWidget {
  const CreateCommunityScreen({super.key});

  @override
  ConsumerState<CreateCommunityScreen> createState() =>
      _CreateCommunityScreenState();
}

class _CreateCommunityScreenState extends ConsumerState<CreateCommunityScreen>
    with TickerProviderStateMixin {
  final TextEditingController communityNameController = TextEditingController();

  late final AnimationController _iconController;
  late final Animation<double> _iconAnimation;
  late final AnimationController _morphController;

  bool _menuVisible = false;
  int _beatCount = 0;

  @override
  void initState() {
    super.initState();
    // Bounce animation: 4 beats
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
          _beatCount++;
          if (_beatCount < 4) _iconController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          if (_beatCount < 4) _iconController.forward();
        }
      })
      ..forward();

    // Drawer morph animation
    _morphController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..reset();
  }

  @override
  void dispose() {
    communityNameController.dispose();
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
                title: const Text('Create a Community'),
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
                actions: [
                  // Safely handle null user:
                  if (user != null && user.profilePic.isNotEmpty) ...[
                    Hero(
                      tag: 'profile-pic',
                      child: GestureDetector(
                        onTap: () => Routemaster.of(context).push('/profile'),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(user.profilePic),
                        ),
                      ),
                    ),
                  ] else ...[
                    Hero(
                      tag: 'profile-pic',
                      child: GestureDetector(
                        onTap: () => Routemaster.of(context).push('/profile'),
                        child: CircleAvatar(
                          backgroundColor: Colors.grey[300],
                          child: const Icon(Icons.person, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(width: 12),
                ],
              ),

              // Body
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Community name',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: communityNameController,
                        decoration: const InputDecoration(
                          hintText: 'n/community_name',
                          filled: true,
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.all(18.0),
                        ),
                        maxLength: 21,
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () {
                          // TODO: create community logic
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          'Create Community',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Side Menu (refactored)
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
