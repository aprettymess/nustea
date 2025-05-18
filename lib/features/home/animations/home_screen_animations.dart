import 'package:flutter/material.dart';

class HomeScreenAnimations {
  final TickerProvider vsync;

  // Icon animation
  late final AnimationController iconController;
  late final Animation<double> iconAnimation;
  int beatCount = 0;

  // Menu animation
  late final AnimationController menuController;

  // Post animations
  late final List<AnimationController> postControllers;
  late final List<Animation<Offset>> postAnimations;

  // FAB animation
  late final AnimationController fabController;
  late final Animation<double> fabAnimation;

  HomeScreenAnimations(this.vsync) {
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
    menuController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 300),
    )..reset();
  }

  void initializePostAnimations(int postCount) {
    postControllers = List.generate(
      postCount,
      (i) => AnimationController(
        vsync: vsync,
        duration: const Duration(milliseconds: 400),
      ),
    );

    postAnimations = postControllers
        .map((ctrl) => Tween<Offset>(
              begin: const Offset(0, 0.25),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: ctrl, curve: Curves.easeOut)))
        .toList();

    for (var i = 0; i < postControllers.length; i++) {
      Future.delayed(Duration(milliseconds: 100 * i), () {
        postControllers[i].forward();
      });
    }
  }

  void initializeFabAnimation() {
    fabController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 1200),
    )..forward();
    fabAnimation =
        CurvedAnimation(parent: fabController, curve: Curves.easeInOut);
  }

  Offset calculateFabOffset(double t, Size size) {
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

  void dispose() {
    iconController.dispose();
    menuController.dispose();
    for (final controller in postControllers) {
      controller.dispose();
    }
    fabController.dispose();
  }
}
