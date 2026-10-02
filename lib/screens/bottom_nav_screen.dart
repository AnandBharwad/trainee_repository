import 'package:flutter/material.dart';
import 'package:t_assignment/screens/home_screen.dart';
import 'package:t_assignment/screens/operation_screen.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int currentTabIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentTabIndex,
        children: const [HomeScreen(), OperationScreen()],
      ),
      bottomNavigationBar: NavigationBar(
        height: 62,
        selectedIndex: currentTabIndex,
        onDestinationSelected: (index) => setState(() {
          currentTabIndex = index;
        }),
        destinations: [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: "Home"),
          NavigationDestination(
            icon: Icon(Icons.settings_applications),
            label: "Operation",
          ),
        ],
      ),
    );
  }
}
