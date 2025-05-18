import 'package:flutter/material.dart';
import 'package:nustea/features/auth/screens/login_screen.dart';
import 'package:nustea/features/community/screens/create_community_screen.dart';
import 'package:nustea/features/home/screens/home_screen.dart';
import 'package:nustea/features/profile/screens/profile_screen.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage<void>(child: LoginScreen()),
});

final loggedInRoute = RouteMap(routes: {
  '/': (_) => MaterialPage<void>(child: HomeScreen()),
  '/create-community': (_) =>
      MaterialPage<void>(child: CreateCommunityScreen()),
  '/profile': (_) => MaterialPage<void>(child: ProfileScreen()),
});
