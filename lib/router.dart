import 'package:flutter/material.dart';
import 'package:nustea/features/auth/screens/login_screen.dart';
import 'package:nustea/features/home/screens/home_screen.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(routes: {
  '/': (_) => MaterialPage<void>(child: LoginScreen()),
});

final loggedInRoute = RouteMap(routes: {
  '/': (_) => MaterialPage<void>(child: HomeScreen()),
});
