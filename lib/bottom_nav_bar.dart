import 'package:flutter/material.dart';
import 'package:money_management/home_screen.dart';
import 'package:money_management/profile.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  final List<NavItem> _navItems = [
    NavItem(
      icon: Icons.dashboard_rounded,
      label: 'Dashboard',
      screen: HomeScreen(), // Replace with your dashboard screen
    ),
    NavItem(
      icon: Icons.people_rounded,
      label: 'Analytics',
      screen: HomeScreen(), // Replace with your borrowers screen
    ),
    NavItem(
      icon: Icons.add_circle_rounded,
      label: 'New Loan',
      screen: HomeScreen(), // Replace with your new loan screen
    ),
    NavItem(
      icon: Icons.history_rounded,
      label: 'History',
      screen: HomeScreen(), // Replace with your loan history screen
    ),
    NavItem(
      icon: Icons.account_circle_rounded,
      label: 'Profile',
      screen: Profile(), // Replace with your profile screen
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _controllers = List.generate(
      _navItems.length,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 200),
        vsync: this,
      ),
    );

    _animations = _controllers.map((controller) {
      return Tween<double>(begin: 1.0, end: 1.2).animate(
        CurvedAnimation(
          parent: controller,
          curve: Curves.easeInOut,
        ),
      );
    }).toList();

    // Start with the dashboard icon selected
    _controllers[0].forward();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;

    setState(() {
      // Reset previous selection
      _controllers[_selectedIndex].reverse();
      _selectedIndex = index;
      // Animate new selection
      _controllers[_selectedIndex].forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _navItems[_selectedIndex].screen,
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        boxShadow: [
          BoxShadow(
            color: Colors.green.shade700.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_navItems.length, (index) {
              return _buildNavItem(
                item: _navItems[index],
                index: index,
                animation: _animations[index],
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required NavItem item,
    required int index,
    required Animation<double> animation,
  }) {
    bool isSelected = _selectedIndex == index;

    // Special styling for the New Loan button
    if (index == 2) {
      return GestureDetector(
        onTap: () => _onItemTapped(index),
        child: ScaleTransition(
          scale: animation,
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.green.shade600,
                  Colors.green.shade800,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.shade600.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              item.icon,
              color: Colors.white,
              size: 28,
            ),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color:
              isSelected ? Colors.green.withOpacity(0.15) : Colors.transparent,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ScaleTransition(
              scale: animation,
              child: Icon(
                item.icon,
                color:
                    isSelected ? Colors.green.shade400 : Colors.grey.shade400,
                size: 24,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              item.label,
              style: TextStyle(
                color:
                    isSelected ? Colors.green.shade400 : Colors.grey.shade400,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NavItem {
  final IconData icon;
  final String label;
  final Widget screen;

  NavItem({
    required this.icon,
    required this.label,
    required this.screen,
  });
}
