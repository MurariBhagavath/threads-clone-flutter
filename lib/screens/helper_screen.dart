import 'package:flutter/material.dart';
import 'package:threads_clone/screens/dashboard/account_screen.dart';
import 'package:threads_clone/screens/dashboard/create_post_screen.dart';
import 'package:threads_clone/screens/dashboard/home_screen.dart';
import 'package:threads_clone/screens/dashboard/activity_screen.dart';
import 'package:threads_clone/screens/dashboard/search_screen.dart';

class HelperScreen extends StatefulWidget {
  const HelperScreen({super.key});

  @override
  State<HelperScreen> createState() => _HelperScreenState();
}

class _HelperScreenState extends State<HelperScreen> {
  // final screens = [
  //   HomeScreen(),
  //   SearchScreen(),
  //   Container(),
  //   ActivityScreen(),
  //   AccountScreen(),
  // ];
  List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];
  int _currentIndex = 0;

  showSheet() {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: CreatePostScreen(),
        );
      },
      elevation: 5,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab =
            !await _navigatorKeys[_currentIndex].currentState!.maybePop();

        print(
            'isFirstRouteInCurrentTab: ' + isFirstRouteInCurrentTab.toString());

        // let system handle back button if we're on the first route
        return isFirstRouteInCurrentTab;
      },
      child: Scaffold(
          body: Stack(
            children: [
              _buildOffstageNavigator(0),
              _buildOffstageNavigator(1),
              _buildOffstageNavigator(2),
              _buildOffstageNavigator(3),
              _buildOffstageNavigator(4),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home_filled), label: 'Feed'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.search), label: 'Search'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.add_box_outlined), label: 'Add thread'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.favorite_border), label: 'Activity'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: 'Account'),
            ],
            onTap: (value) {
              if (value == 2) {
                showSheet();
                return;
              }
              setState(() {
                _currentIndex = value;
              });
            },
            currentIndex: _currentIndex,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            iconSize: 32,
            selectedItemColor: Color(0xfff3f4f6),
            unselectedItemColor: Colors.grey[600],
            backgroundColor: Color(0xff101010),
            type: BottomNavigationBarType.fixed,
          )),
    );
  }

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context, int index) {
    return {
      '/': (context) {
        return [
          HomeScreen(),
          SearchScreen(),
          Container(),
          ActivityScreen(),
          AccountScreen(),
        ].elementAt(index);
      },
    };
  }

  Widget _buildOffstageNavigator(int index) {
    var routeBuilders = _routeBuilders(context, index);

    return Offstage(
      offstage: _currentIndex != index,
      child: Navigator(
        key: _navigatorKeys[index],
        onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(
            builder: (context) => routeBuilders[routeSettings.name]!(context),
          );
        },
      ),
    );
  }
}
