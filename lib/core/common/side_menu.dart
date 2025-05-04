// side_menu.dart

import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

class SideMenu extends StatelessWidget {
  final bool menuVisible;
  final double screenWidth;
  final double screenHeight;
  final AnimationController animationController;
  final bool isHomeFirst;

  const SideMenu({
    super.key,
    required this.menuVisible,
    required this.screenWidth,
    required this.screenHeight,
    required this.animationController,
    required this.isHomeFirst,
  });

  void _navigateHome(BuildContext context) {
    Routemaster.of(context).push('/');
  }

  void _navigateCreateCommunities(BuildContext context) {
    Routemaster.of(context).push('/create-community');
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      top: kToolbarHeight,
      left: menuVisible ? 0 : -screenWidth * 0.6,
      child: Container(
        width: screenWidth * 0.6,
        height: screenHeight - kToolbarHeight,
        color: Colors.grey.shade900,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: isHomeFirst
                ? [
                    ListTile(
                      leading: const Icon(Icons.group, color: Colors.white),
                      title: const Text('Communities',
                          style: TextStyle(color: Colors.white)),
                      onTap: () => _navigateCreateCommunities(context),
                    ),
                    ListTile(
                      leading: const Icon(Icons.home, color: Colors.white),
                      title: const Text('Home',
                          style: TextStyle(color: Colors.white)),
                      onTap: () => _navigateHome(context),
                    ),
                  ]
                : [
                    ListTile(
                      leading: const Icon(Icons.home, color: Colors.white),
                      title: const Text('Home',
                          style: TextStyle(color: Colors.white)),
                      onTap: () => _navigateHome(context),
                    ),
                    ListTile(
                      leading: const Icon(Icons.group, color: Colors.white),
                      title: const Text('Communities',
                          style: TextStyle(color: Colors.white)),
                      onTap: () => _navigateCreateCommunities(context),
                    ),
                  ],
          ),
        ),
      ),
    );
  }
}
