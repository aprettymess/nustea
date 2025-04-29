import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nustea/controller/auth_controller.dart';
import 'package:routemaster/routemaster.dart';

class CreateCommunityScreen extends ConsumerStatefulWidget {
  const CreateCommunityScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateCommunityScreenState();
}

class _CreateCommunityScreenState extends ConsumerState<CreateCommunityScreen>
    with TickerProviderStateMixin {
  final communityNameController = TextEditingController();

  late final AnimationController _menuController;
  bool _menuVisible = false;

  @override
  void initState() {
    super.initState();
    _menuController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    communityNameController.dispose();
    _menuController.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    setState(() {
      _menuVisible = !_menuVisible;
      _menuVisible ? _menuController.forward() : _menuController.reverse();
    });
  }

  void _navigateToHome() {
    _toggleMenu();
    Routemaster.of(context).push('/');
  }

  void _navigateToCommunities() {
    _toggleMenu();
    Routemaster.of(context).push('/create-community');
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
                title: const Text('Create a Community'),
                leading: IconButton(
                  icon: AnimatedIcon(
                    icon: AnimatedIcons.menu_close,
                    progress: _menuController,
                  ),
                  onPressed: _toggleMenu,
                ),
                actions: [
                  Hero(
                    tag: 'profile-pic',
                    child: GestureDetector(
                      onTap: () => Routemaster.of(context).push('/profile'),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(user!.profilePic),
                      ),
                    ),
                  ),
                ],
              ),
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
                          // Add your create logic here
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
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Side Menu
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
                      leading: const Icon(Icons.group, color: Colors.white),
                      title: const Text('Communities',
                          style: TextStyle(color: Colors.white)),
                      onTap: _navigateToCommunities,
                    ),
                    ListTile(
                      leading: const Icon(Icons.home, color: Colors.white),
                      title: const Text('Home',
                          style: TextStyle(color: Colors.white)),
                      onTap: _navigateToHome,
                    ),
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
