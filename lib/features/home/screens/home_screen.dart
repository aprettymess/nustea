import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nustea/controller/auth_controller.dart';
import 'package:routemaster/routemaster.dart';
import '../../../core/common/side_menu.dart'; // 👈 Import the shared side menu

class PostItem {
  PostItem({
    required this.id,
    required this.author,
    required this.content,
    this.liked = false,
  });
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
  late final AnimationController _iconController;
  late final Animation<double> _iconAnimation;
  int _beatCount = 0;

  late final List<PostItem> _posts;
  late final List<AnimationController> _controllers;
  late final List<Animation<Offset>> _animations;

  late final AnimationController _menuController;
  bool _menuVisible = false;

  @override
  void initState() {
    super.initState();

    _menuVisible = false; // 👈 Ensure menu is closed when page opens

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
          if (_beatCount < 4) {
            _iconController.reverse();
          }
        } else if (status == AnimationStatus.dismissed) {
          if (_beatCount < 4) {
            _iconController.forward();
          }
        }
      })
      ..forward();

    _menuController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..reset(); // 👈 Reset menu animation

    _posts = List.generate(
      5,
      (i) => PostItem(
        id: i,
        author: 'User ${i + 1}',
        content: 'This is post number ${i + 1} in the NUSTea feed!',
      ),
    );

    _controllers = List.generate(
      _posts.length,
      (i) => AnimationController(
          vsync: this, duration: const Duration(milliseconds: 400)),
    );

    _animations = _controllers
        .map((ctrl) => Tween<Offset>(
              begin: const Offset(0, 0.25),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: ctrl, curve: Curves.easeOut)))
        .toList();

    for (var i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: 100 * i), () {
        _controllers[i].forward();
      });
    }
  }

  @override
  void dispose() {
    _iconController.dispose();
    for (final c in _controllers) {
      c.dispose();
    }
    _menuController.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    setState(() {
      _menuVisible = !_menuVisible;
      _menuVisible ? _menuController.forward() : _menuController.reverse();
    });
  }

  Future<void> _refreshFeed() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _posts.shuffle());
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
                title: const Text('NUSTea Feed'),
                leading: ScaleTransition(
                  scale: _iconAnimation,
                  child: IconButton(
                    icon: AnimatedIcon(
                      icon: AnimatedIcons.menu_close,
                      progress: _menuController,
                    ),
                    onPressed: _toggleMenu,
                  ),
                ),
                actions: [
                  GestureDetector(
                    onTap: () => Routemaster.of(context).push('/profile'),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(user!.profilePic),
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
                                    : Colors.white,
                              ),
                            ),
                            subtitle: Text(
                              post.content,
                              style: TextStyle(
                                color: post.liked
                                    ? Colors.pink.shade200
                                    : Colors.white,
                              ),
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
          SideMenu(
            menuVisible: _menuVisible,
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            animationController: _menuController,
            isHomeFirst: true,
          ),
          _CurvedPathFab(),
        ],
      ),
    );
  }
}

class _CurvedPathFab extends StatefulWidget {
  @override
  State<_CurvedPathFab> createState() => _CurvedPathFabState();
}

class _CurvedPathFabState extends State<_CurvedPathFab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fabController;
  late final Animation<double> _fabAnim;
  bool _hovering = false;

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();
    _fabAnim = CurvedAnimation(parent: _fabController, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _fabController.dispose();
    super.dispose();
  }

  Offset _fabOffset(double t, Size size) {
    final start = Offset(20, size.height - 80);
    final end = Offset(size.width - 80, size.height - 80);
    final control = Offset(size.width / 2, size.height - 200);
    final x = (1 - t) * (1 - t) * start.dx +
        2 * (1 - t) * t * control.dx +
        t * t * end.dx;
    final y = (1 - t) * (1 - t) * start.dy +
        2 * (1 - t) * t * control.dy +
        t * t * end.dy;
    return Offset(x, y);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AnimatedBuilder(
      animation: _fabAnim,
      builder: (context, child) {
        final pos = _fabOffset(_fabAnim.value, size);
        return Positioned(
          left: pos.dx,
          top: pos.dy,
          child: MouseRegion(
            onEnter: (_) => setState(() => _hovering = true),
            onExit: (_) => setState(() => _hovering = false),
            child: Transform.scale(
              scale: _hovering ? 1.2 : 1.0,
              child: FloatingActionButton(
                onPressed: () => Routemaster.of(context).push('/create-post'),
                child: const Icon(Icons.add),
              ),
            ),
          ),
        );
      },
    );
  }
}
