import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() => runApp(const ConsultantApp());

final _router = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (context, state) => HomeScreen(state.extra.toString()),
    ),
    GoRoute(
      path: '/detail',
      builder: (context, state) => const DetailScreen(),
    )
  ],
);

class ConsultantApp extends StatelessWidget {
  const ConsultantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
      title: 'Material App',
    );
  }
}

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InkWell(
        onTap: () => context.go('/', extra: '1'),
        child: Container(
          child: const Text('Detail Screen'),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen(this.para, {super.key});

  final String para;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: InkWell(
          onTap: () {
            context.go('/detail');
          },
          child: Text('Home Screen para: ${para}'),
        ),
      ),
    );
  }
}
