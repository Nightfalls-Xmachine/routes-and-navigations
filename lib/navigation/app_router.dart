import 'package:flutter/material.dart';
import 'package:routes_navigations/screens/screens.dart';
import 'package:routes_navigations/models/models.dart';

class AppRouter extends RouterDelegate with ChangeNotifier, PopNavigatorRouterDelegateMixin{

  @override
  final GlobalKey<NavigatorState> navigatorKey;

  final AppStateManager appStateManager;

  final GroceryManager groceryManager;

  final ProfileManager profileManager;

  AppRouter({
    required this.appStateManager,
    required this.groceryManager,
    required this.profileManager,
}) : navigatorKey = GlobalKey<NavigatorState>(){
    //Todo: Add Listeners
    appStateManager.addListener(notifyListeners);
    groceryManager.addListener(notifyListeners);
    profileManager.addListener(notifyListeners);
  }
    //TODO: Dispose listeners
    @override
    void dispose(){
      appStateManager.removeListener(notifyListeners);
      groceryManager.removeListener(notifyListeners);
      profileManager.removeListener(notifyListeners);
      super.dispose();
    }

    @override
  Widget build(BuildContext context){
    return Navigator(
      key: navigatorKey,
      //TODO: Add onPopPage
      onPopPage: _handlePopPage,

      pages: [
        //TODO: Add SplashScreen
        if(!appStateManager.isInitialized) SplashScreen.page(),
        //TODO: Add LoginScreen
        if(appStateManager.isInitialized && !appStateManager.isLoggedIn) LoginScreen.page(),
        //TODO: Add OnboardingScreen
        if(appStateManager.isLoggedIn && !appStateManager.isOnboardingComplete) OnboardingScreen.page(),
        //TODO: Add Home
        if(appStateManager.isOnboardingComplete) Home.page(appStateManager.getSelectedTap),
        //TODO: Create new item
        if(groceryManager.isCreatingNewItem)
          GroceryItemScreen.page(
              onCreate: (item){
                groceryManager.addItem(item);
              },
              onUpdate: (item, index){},
          ),
        //TODO: Select GroceryItemScreen
        if(groceryManager.selectedIndex != -1)
          GroceryItemScreen.page(
            item: groceryManager.selectedGroceryItem,
              index: groceryManager.selectedIndex,
              onCreate: (_){
              //No creater45
              },
              onUpdate: (item, index){
              groceryManager.updateItem(item, index);
              },
          ),
        //TODO: Add Profile Screen
        if (profileManager.didSelectUser)
          ProfileScreen.page(profileManager.getUser),
        //TODO: Add WebView Screen
        if (profileManager.didTapOnRaywenderlich) WebViewScreen.page()
      ],
    );
    }
    //TODO: Add _handlePopPage
  bool _handlePopPage(
      Route<dynamic> route, result){
    if(!route.didPop(result)){
      return false;
    }

    //TODO: Handle Onboarding and splash
    if(route.settings.name == FooderlichPages.onboardingPath){
      appStateManager.logout();
    }
    //TODO: Handle state when user closes grocery item screen
    if(route.settings.name == FooderlichPages.groceryItemDetails){
      groceryManager.groceryItemTapped(-1);
    }
    //TODO: Handle state when user closes profile screen
    if (route.settings.name == FooderlichPages.profilePath) {
      profileManager.tapOnProfile(false);
    }
    //TODO: Handle when user closes WebView screen
    if (route.settings.name == FooderlichPages.raywenderlich) {
      profileManager.tapOnRaywenderlich(false);
    }
    return true;
  }

    @override
  Future<void> setNewRoutePath(configuration) async => null;
}