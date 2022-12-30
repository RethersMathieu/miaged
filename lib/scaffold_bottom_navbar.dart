import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ScaffoldWithNavBarTabItem extends BottomNavigationBarItem {
  const ScaffoldWithNavBarTabItem({required this.initialLocation, required Widget icon, String? label}): super(icon: icon, label: label);
  final String initialLocation;
}

class ScaffoldWithBottomNavBar extends StatefulWidget {
  const ScaffoldWithBottomNavBar({super.key, required this.child, required this.items});
  final Widget child;
  final List<ScaffoldWithNavBarTabItem> items;

  @override
  State<ScaffoldWithBottomNavBar> createState() => _ScaffoldWithBottomNavBarState();
}

class _ScaffoldWithBottomNavBarState extends State<ScaffoldWithBottomNavBar> {
  _ScaffoldWithBottomNavBarState();

  int get _currentIndex => _locationToTabIndex(GoRouter.of(context).location);

  int _locationToTabIndex(String location) {
    final index = widget.items.indexWhere((t) => location.startsWith(t.initialLocation));
    // if index not found (-1), return 0
    return index < 0 ? 0 : index;
  }

  // callback used to navigate to the desired tab
  void _onItemTapped(BuildContext context, int tabIndex) {
    if (tabIndex != _currentIndex) {
      // go to the initial location of the selected tab (by index)
      context.go(widget.items[tabIndex].initialLocation);
    }
  }

  @override
  Widget build(BuildContext context) {
    var iconTheme = const IconThemeData(color: Colors.blue);
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: widget.items,
        onTap: (index) => _onItemTapped(context, index),
        showUnselectedLabels: false,
        selectedIconTheme: iconTheme,
        selectedLabelStyle: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w500),
        unselectedIconTheme: iconTheme,
        fixedColor: Colors.blue,
      ),
    );
  }
}