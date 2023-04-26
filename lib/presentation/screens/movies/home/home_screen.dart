import 'package:cinemapedia_app/presentation/views/views.dart';
import 'package:flutter/material.dart';
import 'package:cinemapedia_app/presentation/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  static const String name = 'home_screen';
  final int pageIndex;

  const HomeScreen({super.key, required this.pageIndex});

  final viewRoutes = const <Widget>[
    HomeView(),
    SizedBox(), // TODO: Categories View
    FavoritesView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: pageIndex,
        children: viewRoutes,
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: pageIndex,
      ),
    );
  }
}
