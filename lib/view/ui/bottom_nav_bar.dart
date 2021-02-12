import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_viewer_db/bloc/navigation_bloc/navigation_bloc.dart';
import 'package:movie_viewer_db/bloc/navigation_bloc/navigation_state.dart';

class AppBottomNavigationBar extends StatefulWidget {
  final ValueChanged<int> onItemTapped;

  AppBottomNavigationBar(this.onItemTapped);

  @override
  _AppBottomNavigationBarState createState() => _AppBottomNavigationBarState();
}

class _AppBottomNavigationBarState extends State<AppBottomNavigationBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    widget.onItemTapped(index);

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NavigationBloc, NavigationState>(
        listener: (context, state) {
          if (state.pageIndex != _selectedIndex) {
            setState(() {
              _selectedIndex = state.pageIndex;
            });
          }
        },
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_movies),
              label: 'Movies',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
          ],
          onTap: _onItemTapped,
        ));
  }
}
