import 'package:flutter/material.dart';
import 'package:cinemapedia_app/presentation/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  static const String name = 'home_screen';

  final Widget childView;

  const HomeScreen({super.key, required this.childView});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: childView,
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}
