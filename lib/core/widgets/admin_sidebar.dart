import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdminSidebar extends StatelessWidget {
  // selectedIndex might not be needed if GoRouter handles active route highlighting
  // final int selectedIndex; 
  // final Function(int) onDestinationSelected; // Replaced by direct navigation

  const AdminSidebar({
    super.key,
    // required this.selectedIndex,
    // required this.onDestinationSelected,
  });

  // Helper to determine if a route is active.
  // This is a simple version; more complex scenarios might need more robust logic.
  // bool _isRouteActive(BuildContext context, String routeName) {
  //   final GoRouterState routerState = GoRouterState.of(context);
  //   // Check current route and potential sub-routes.
  //   // This example checks if the current route *starts with* the given routeName,
  //   // which can be useful for nested routes if names are consistent.
  //   // For exact match: routerState.name == routeName
  //   // For matching top-level segments: routerState.topRoute?.name == routeName
  //   return routerState.name?.startsWith(routeName) ?? false;
  // }
  
  int _calculateSelectedIndex(BuildContext context) {
    final GoRouterState routerState = GoRouterState.of(context);
    final String? currentRouteName = routerState.name;
    final String? topRouteName = routerState.topRoute?.name; // Correctly access topRoute


    // More specific matching for nested routes
    if (topRouteName == 'dashboard' || currentRouteName == 'dashboard') return 0;
    if (topRouteName == 'places' || currentRouteName == 'newPlace' || currentRouteName == 'editPlace') return 1;
    if (topRouteName == 'events' || currentRouteName == 'newEvent' || currentRouteName == 'editEvent') return 2;
    if (topRouteName == 'reviews' || currentRouteName == 'moderateReview') return 3;
    if (topRouteName == 'categories' || currentRouteName == 'newCategory' || currentRouteName == 'editCategory') return 4;
    if (topRouteName == 'users' || currentRouteName == 'manageUser') return 5;
    
    // Fallback for situations where routerState.name might be null or not matching topRoute
    // This can happen with nested navigators or initial loading.
    final String location = routerState.uri.toString();
    if (location.startsWith('/dashboard')) return 0;
    if (location.startsWith('/places')) return 1;
    if (location.startsWith('/events')) return 2;
    if (location.startsWith('/reviews')) return 3;
    if (location.startsWith('/categories')) return 4;
    if (location.startsWith('/users')) return 5;
    
    return 0; // Default to dashboard
  }


  @override
  Widget build(BuildContext context) {
    final currentSelectedIndex = _calculateSelectedIndex(context);

    return NavigationRail(
      selectedIndex: currentSelectedIndex,
      onDestinationSelected: (int index) {
        // Navigate based on index
        switch (index) {
          case 0:
            context.goNamed('dashboard');
            break;
          case 1:
            context.goNamed('places');
            break;
          case 2:
            context.goNamed('events');
            break;
          case 3:
            context.goNamed('reviews');
            break;
          case 4:
            context.goNamed('categories');
            break;
          case 5:
            context.goNamed('users');
            break;
          // Add cases for other destinations
        }
      },
      labelType: NavigationRailLabelType.all, 
      // Use extended: true for a wider sidebar that shows labels next to icons,
      // common in desktop admin panels. This requires more horizontal space.
      // extended: MediaQuery.of(context).size.width > 1200, // Example condition
      leading: const Padding( // Example: Add a logo or title
        padding: EdgeInsets.symmetric(vertical: 20.0),
        child: Column(
          children: [
            FlutterLogo(size: 40),
            SizedBox(height: 8),
            Text("Turbo Admin", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
      ),
      destinations: const <NavigationRailDestination>[
        NavigationRailDestination(
          icon: Icon(Icons.dashboard_outlined),
          selectedIcon: Icon(Icons.dashboard),
          label: Text('Dashboard'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.place_outlined),
          selectedIcon: Icon(Icons.place),
          label: Text('Places'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.event_outlined),
          selectedIcon: Icon(Icons.event),
          label: Text('Events'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.reviews_outlined),
          selectedIcon: Icon(Icons.reviews),
          label: Text('Reviews'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.category_outlined),
          selectedIcon: Icon(Icons.category),
          label: Text('Categories'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.people_alt_outlined),
          selectedIcon: Icon(Icons.people_alt),
          label: Text('Users'),
        ),
        // Add more destinations (e.g., Settings)
      ],
    );
  }
}
