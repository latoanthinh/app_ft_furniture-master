import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants/router.dart';
import '../constants/size.dart';
import 'home/home_tab.dart';
import 'home/profile_tab.dart';

class Destination {
  final Widget icon;
  final Widget? selectedIcon;
  final String label;
  final Widget view;

  const Destination({
    required this.icon,
    this.selectedIcon,
    required this.label,
    required this.view,
  });
}

class IndexScreen extends StatefulWidget {
  final int initSelectedIndex;

  const IndexScreen({super.key, this.initSelectedIndex = 0});

  @override
  State<IndexScreen> createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  int? _selectedIndex;
  final List<Destination> _destinations = const [
    Destination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home),
      label: 'index.tabs.home',
      view: HomeTab(),
    ),
    Destination(
      icon: Icon(Icons.person_outline),
      selectedIcon: Icon(Icons.person),
      label: 'index.tabs.account',
      view: ProfileTab(),
    ),
  ];

  void _onDestinationSelected(int tabIndexNew) {
    setState(() {
      _selectedIndex = tabIndexNew;
    });
  }

  void _onPressedFloatingButton() {
    context.goNamed(AppRouter.scanQr);
  }

  @override
  Widget build(BuildContext context) {
    final sizeQuery = MediaQuery.sizeOf(context);
    final isCompactMode = sizeQuery.width < AppSize.compact;
    final isMediumMode = !isCompactMode && sizeQuery.width < AppSize.medium;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _onPressedFloatingButton,
        child: const Icon(Icons.qr_code_scanner),
      ),
      floatingActionButtonLocation: isCompactMode ? FloatingActionButtonLocation.centerDocked : FloatingActionButtonLocation.miniStartFloat,
      bottomNavigationBar: Visibility(
        visible: isCompactMode,
        child: NavigationBar(
          onDestinationSelected: _onDestinationSelected,
          selectedIndex: _selectedIndex ?? widget.initSelectedIndex,
          destinations: _destinations.map(
            (e) {
              return NavigationDestination(
                icon: e.icon,
                selectedIcon: e.selectedIcon,
                label: e.label.tr(),
              );
            },
          ).toList(),
        ),
      ),
      body: Row(
        children: [
          Visibility(
            visible: !isCompactMode,
            child: NavigationRail(
              onDestinationSelected: _onDestinationSelected,
              selectedIndex: _selectedIndex ?? widget.initSelectedIndex,
              labelType: isMediumMode ? NavigationRailLabelType.all : NavigationRailLabelType.none,
              extended: !isMediumMode,
              destinations: _destinations.map(
                (e) {
                  return NavigationRailDestination(
                    icon: e.icon,
                    selectedIcon: e.selectedIcon,
                    label: Text(e.label.tr()),
                  );
                },
              ).toList(),
            ),
          ),
          Visibility(
            visible: !isCompactMode,
            child: const VerticalDivider(width: 1),
          ),
          Expanded(
            child: _destinations[_selectedIndex ?? widget.initSelectedIndex].view,
          ),
        ],
      ),
    );
  }
}
