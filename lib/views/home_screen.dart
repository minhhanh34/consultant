import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  Text(
                    'Hello Hanh',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () => context.go('/Detail'),
                    child: CircleAvatar(
                      backgroundColor: Colors.grey.shade300,
                      radius: 24.0,
                      child: const FlutterLogo(
                        size: 40.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 160,
                        height: 120,
                        decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 8.0,
                              blurStyle: BlurStyle.outer,
                            ),
                          ],
                          color: Colors.indigo.shade300,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    const Positioned(
                      top: 16.0,
                      left: 16.0,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(Icons.add),
                      ),
                    ),
                    const Positioned(
                      top: 60,
                      left: 0,
                      child: SizedBox(
                        width: 130.0,
                        child: ListTile(
                          textColor: Colors.white,
                          title: Text('Minh Hanh'),
                          subtitle: Text('subtitle'),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 8.0),
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 160,
                        height: 120,
                        decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 8.0,
                              color: Colors.grey,
                              blurStyle: BlurStyle.outer,
                            ),
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 16.0,
                      left: 16.0,
                      child: CircleAvatar(
                        backgroundColor: Colors.indigo.shade100,
                        child: Icon(
                          Icons.home,
                          color: Colors.indigo.shade300,
                        ),
                      ),
                    ),
                    const Positioned(
                      top: 60,
                      left: 0,
                      child: SizedBox(
                        width: 130.0,
                        child: ListTile(
                          textColor: Colors.black,
                          title: Text('Minh Hanh'),
                          subtitle: Text('subtitle'),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Ban dang muon gi?',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
            SizedBox(
              height: 60,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Center(
                      child: Text(
                        'Primary',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Center(
                      child: Text(
                        'Primary',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Center(
                      child: Text(
                        'Primary',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Center(
                      child: Text(
                        'Primary',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Popular consultant',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: GridView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                ),
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 4.0,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 12.0,
                        ),
                        CircleAvatar(
                          backgroundColor: Colors.grey.shade300,
                          radius: 36.0,
                          child: const FlutterLogo(
                            size: 36.0,
                          ),
                        ),
                        const ListTile(
                          title: Text(
                            'Minh Hanh',
                            textAlign: TextAlign.center,
                          ),
                          subtitle: Text(
                            'subtitle',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 4.0,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 12.0,
                        ),
                        CircleAvatar(
                          backgroundColor: Colors.grey.shade300,
                          radius: 36.0,
                          child: const FlutterLogo(
                            size: 36.0,
                          ),
                        ),
                        const ListTile(
                          title: Text(
                            'Minh Hanh',
                            textAlign: TextAlign.center,
                          ),
                          subtitle: Text(
                            'subtitle',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 4.0,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 12.0,
                        ),
                        CircleAvatar(
                          backgroundColor: Colors.grey.shade300,
                          radius: 36.0,
                          child: const FlutterLogo(
                            size: 36.0,
                          ),
                        ),
                        const ListTile(
                          title: Text(
                            'Minh Hanh',
                            textAlign: TextAlign.center,
                          ),
                          subtitle: Text(
                            'subtitle',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 4.0,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 12.0,
                        ),
                        CircleAvatar(
                          backgroundColor: Colors.grey.shade300,
                          radius: 36.0,
                          child: const FlutterLogo(
                            size: 36.0,
                          ),
                        ),
                        const ListTile(
                          title: Text(
                            'Minh Hanh',
                            textAlign: TextAlign.center,
                          ),
                          subtitle: Text(
                            'subtitle',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}