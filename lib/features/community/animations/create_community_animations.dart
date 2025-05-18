import 'package:flutter/material.dart';

class CreateCommunityAnimations {
  final TickerProvider vsync;

  // Icon animation
  late final AnimationController iconController;
  late final Animation<double> iconAnimation;
  int beatCount = 0;

  // Menu animation
  late final AnimationController morphController;

  CreateCommunityAnimations(this.vsync) {
    _initializeIconAnimation();
    _initializeMenuAnimation();
  }

  void _initializeIconAnimation() {
    iconController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 400),
    );
    iconAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: iconController, curve: Curves.easeInOut),
    );
    iconController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        beatCount++;
        if (beatCount < 4) {
          iconController.reverse();
        }
      } else if (status == AnimationStatus.dismissed) {
        if (beatCount < 4) {
          iconController.forward();
        }
      }
    });
  }

  void _initializeMenuAnimation() {
    morphController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 300),
    )..reset();
  }

  void startIconAnimation() {
    iconController.forward();
  }

  void toggleMenu(bool menuVisible) {
    menuVisible ? morphController.forward() : morphController.reverse();
  }

  void dispose() {
    iconController.dispose();
    morphController.dispose();
  }
}
