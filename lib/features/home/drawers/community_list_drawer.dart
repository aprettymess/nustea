import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nustea/core/common/error_text.dart';
import 'package:nustea/core/common/loader.dart';
import 'package:nustea/core/common/sign_in_button.dart';
import 'package:nustea/features/auth/controller/auth_controller.dart';
import 'package:nustea/features/community/controller/community_controller.dart';
import 'package:nustea/models/community_model.dart';
import 'package:routemaster/routemaster.dart';

class CommunityListDrawer extends ConsumerStatefulWidget {
  const CommunityListDrawer({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CommunityListDrawerState();
}

class _CommunityListDrawerState extends ConsumerState<CommunityListDrawer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.3, 1.0, curve: Curves.easeIn),
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void navigateToCreateCommunity(BuildContext context) {
    Routemaster.of(context).push('/create-community');
  }

  void navigateToCommunity(BuildContext context, Community community) {
    Routemaster.of(context).push('/n/${community.name}');
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;

    return Drawer(
      child: SafeArea(
        child: SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                isGuest
                    ? const SignInButton()
                    : ListTile(
                        title: const Text('Create a community'),
                        leading: const Icon(Icons.add),
                        onTap: () => navigateToCreateCommunity(context),
                      ),
                if (!isGuest)
                  ref.watch(userCommunitiesProvider).when(
                        data: (communities) => Expanded(
                          child: ListView.builder(
                            itemCount: communities.length,
                            itemBuilder: (BuildContext context, int index) {
                              final community = communities[index];
                              return AnimatedBuilder(
                                animation: _controller,
                                builder: (context, child) {
                                  return FadeTransition(
                                    opacity: Tween<double>(
                                      begin: 0.0,
                                      end: 1.0,
                                    ).animate(CurvedAnimation(
                                      parent: _controller,
                                      curve: Interval(
                                        0.3 + (index * 0.1),
                                        0.6 + (index * 0.1),
                                        curve: Curves.easeIn,
                                      ),
                                    )),
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage:
                                            NetworkImage(community.avatar),
                                        onBackgroundImageError: (_, __) {
                                          // Handle image loading error
                                        },
                                      ),
                                      title: Text('n/${community.name}'),
                                      onTap: () {
                                        navigateToCommunity(context, community);
                                      },
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        error: (error, stackTrace) => ErrorText(
                          error: error.toString(),
                        ),
                        loading: () => const Loader(),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
