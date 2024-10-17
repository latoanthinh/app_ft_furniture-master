import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../constants/size.dart';
import '../index_screen.dart';
import 'home/home_tab.dart';
import 'home/research_tab.dart';

class IChingIndexScreen extends StatefulWidget {
  final int initSelectedIndex;

  const IChingIndexScreen({super.key, this.initSelectedIndex = 0});

  @override
  State<IChingIndexScreen> createState() => _IChingIndexScreenState();
}

class _IChingIndexScreenState extends State<IChingIndexScreen> {
  int? _selectedIndex;
  final List<Destination> destinations = const [
    Destination(
      icon: Icon(Icons.person_search_outlined),
      selectedIcon: Icon(Icons.person_search),
      label: 'i_ching.tabs.home',
      view: IChingHomeTab(),
    ),
    Destination(
      icon: Icon(Icons.menu_book_outlined),
      selectedIcon: Icon(Icons.menu_book),
      label: 'i_ching.tabs.research',
      view: IChingResearchTab(),
    ),
  ];

  void _onDestinationSelected(int tabIndexNew) {
    setState(() {
      _selectedIndex = tabIndexNew;
    });
  }

  @override
  Widget build(BuildContext context) {
    final sizeQuery = MediaQuery.sizeOf(context);
    final isCompactMode = sizeQuery.width < AppSize.compact;
    final isMediumMode = !isCompactMode && sizeQuery.width < AppSize.medium;

    return Scaffold(
      bottomNavigationBar: Visibility(
        visible: isCompactMode,
        child: NavigationBar(
          onDestinationSelected: _onDestinationSelected,
          selectedIndex: _selectedIndex ?? widget.initSelectedIndex,
          destinations: destinations.map(
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
              destinations: destinations.map(
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
            child: destinations[_selectedIndex ?? widget.initSelectedIndex].view,
          ),
        ],
      ),
    );
  }
}
