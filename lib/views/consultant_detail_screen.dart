import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ConsultantDetailScreen extends StatelessWidget {
  const ConsultantDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              color: Colors.indigo.shade300,
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () => context.go('/'),
                  icon: Icon(
                    CupertinoIcons.back,
                    color: Theme.of(context).primaryIconTheme.color,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.more_vert,
                    color: Theme.of(context).primaryIconTheme.color,
                  ),
                ),
              ],
            ),
            Positioned(
              top: 32.0,
              left: MediaQuery.of(context).size.width / 2 - 100,
              child: SizedBox(
                width: 200,
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 36.0,
                      child: FlutterLogo(),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Consultant name',
                        style: Theme.of(context).primaryTextTheme.headline6,
                      ),
                    ),
                    Text(
                      'Math',
                      style: Theme.of(context).primaryTextTheme.subtitle1,
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.indigo.shade200,
                          child: Icon(
                            Icons.phone,
                            color: Theme.of(context).primaryIconTheme.color,
                          ),
                        ),
                        const SizedBox(
                          width: 16.0,
                        ),
                        CircleAvatar(
                          backgroundColor: Colors.indigo.shade200,
                          child: Icon(
                            CupertinoIcons.chat_bubble_text_fill,
                            color: Theme.of(context).primaryIconTheme.color,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    topRight: Radius.circular(16.0),
                  ),
                ),
                height: MediaQuery.of(context).size.height * 0.65,
                width: MediaQuery.of(context).size.width,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
