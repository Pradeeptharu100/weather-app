import 'package:go_router/go_router.dart';
import 'package:weather_app/features/home_screen/presentation/pages/home_screen.dart';
import 'package:weather_app/features/splash_screen/presentation/pages/splash_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
  ],
);
