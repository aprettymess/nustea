import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nustea/controller/auth_controller.dart';
import 'package:routemaster/routemaster.dart';

class PostItem {
  PostItem(
      {required this.id,
      required this.author,
      required this.content,
      this.liked = false});
  final int id;
  final String author;
  final String content;
  bool liked;
}

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin {
  late final List<PostItem> _posts;
  late final List<AnimationController> _controllers;
  late final List<Animation<Offset>> _animations;

  late final AnimationController _menuController;
  bool _menuVisible = false;

  @override
  void initState() {
    super.initState();

    _menuController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _posts = List.generate(
        5,
        (i) => PostItem(
            id: i,
            author: 'User ${i + 1}',
            content: 'This is post number ${i + 1} in the NUSTea feed!'));

    _controllers = List.generate(
        _posts.length,
        (i) => AnimationController(
            vsync: this, duration: const Duration(milliseconds: 400)));

    _animations = _controllers
        .map((ctrl) =>
            Tween<Offset>(begin: const Offset(0, 0.25), end: Offset.zero)
                .animate(CurvedAnimation(parent: ctrl, curve: Curves.easeOut)))
        .toList();

    for (var i = 0; i < _controllers.length; i++) {
      Future.delayed(
          Duration(milliseconds: 100 * i), () => _controllers[i].forward());
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) c.dispose();
    _menuController.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    setState(() {
      _menuVisible = !_menuVisible;
      _menuVisible ? _menuController.forward() : _menuController.reverse();
    });
  }

  void _navigateCreateCommunities() {
    _toggleMenu();
    Routemaster.of(context).push('/create-community');
  }

  Future<void> _refreshFeed() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _posts.shuffle());
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
                title: const Text('NUSTea Feed'),
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
                child: RefreshIndicator(
                  onRefresh: _refreshFeed,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: _posts.length,
                    itemBuilder: (context, index) {
                      final post = _posts[index];
                      return SlideTransition(
                        position: _animations[index],
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: post.liked
                                  ? Colors.pink.shade200
                                  : Colors.white,
                              width: 2,
                            ),
                          ),
                          child: ListTile(
                            title: Text(
                              post.author,
                              style: TextStyle(
                                  color: post.liked
                                      ? Colors.pink.shade200
                                      : Colors.white),
                            ),
                            subtitle: Text(
                              post.content,
                              style: TextStyle(
                                  color: post.liked
                                      ? Colors.pink.shade200
                                      : Colors.white),
                            ),
                            trailing: GestureDetector(
                              onTap: () =>
                                  setState(() => post.liked = !post.liked),
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                transitionBuilder: (child, anim) =>
                                    ScaleTransition(scale: anim, child: child),
                                child: Icon(
                                  post.liked
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  key: ValueKey(post.liked),
                                  color: post.liked ? Colors.red : Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
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
                      leading: const Icon(Icons.group, color: Colors.white),
                      title: const Text('Communities',
                          style: TextStyle(color: Colors.white)),
                      onTap: _navigateCreateCommunities,
                    ),
                    ListTile(
                      leading: const Icon(Icons.home, color: Colors.white),
                      title: const Text('Home',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Floating Action Button
          Positioned(
            bottom: 16,
            right: 16,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0, end: 1).animate(
                CurvedAnimation(
                    parent: _controllers.first, curve: Curves.elasticOut),
              ),
              child: FloatingActionButton(
                onPressed: () => Routemaster.of(context).push('/create-post'),
                child: const Icon(Icons.add),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
