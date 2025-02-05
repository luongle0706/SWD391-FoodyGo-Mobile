import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:foodygo/utils/constants.dart';
import 'package:foodygo/utils/injection.dart';
import 'package:foodygo/view/pages/home.dart';
import 'package:foodygo/view/pages/login.dart';
import 'package:foodygo/view/pages/profile.dart';
import 'package:foodygo/view/pages/register.dart';
import 'package:foodygo/view/pages/splash_screen.dart';
import 'package:foodygo/view/pages/welcome_screen.dart';
import 'package:go_router/go_router.dart';

void main() {
  setupInjection();
  runApp(Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  Future<bool> isAuthenticated() async {
    String? savedUser = await locator<FlutterSecureStorage>().read(key: 'user');
    return savedUser != null;
  }

  GoRouter get _router => GoRouter(
        initialLocation: '/splash',
        routes: [
          GoRoute(
              name: 'home',
              path: '/',
              pageBuilder: (context, state) {
                return MaterialPage(child: HomePage());
              }),
          GoRoute(
              name: 'splash_screen',
              path: '/splash',
              pageBuilder: (context, state) {
                return MaterialPage(child: SplashScreen());
              }),
          GoRoute(
              name: 'welcome_screen',
              path: '/welcome',
              pageBuilder: (context, state) {
                return MaterialPage(child: WelcomeScreen());
              }),
          GoRoute(
              name: 'login',
              path: '/login',
              pageBuilder: (context, state) {
                return MaterialPage(child: LoginPage());
              }),
          GoRoute(
              name: 'register',
              path: '/register',
              pageBuilder: (context, state) {
                return MaterialPage(child: RegisterPage());
              }),
          GoRoute(
              name: 'profile',
              path: '/profile',
              pageBuilder: (context, state) {
                return MaterialPage(child: ProfilePage());
              })
        ],
        redirect: (context, state) async {
          final isAuthenticated = await this.isAuthenticated();
          final isProtectedRoute =
              globalProtectedRoutes.contains(state.matchedLocation);
          if (isProtectedRoute && !isAuthenticated) {
            return '/login';
          } else {
            return null;
          }
        },
      );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }
}
