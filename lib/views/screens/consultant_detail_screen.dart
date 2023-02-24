import 'package:consultant/models/consultant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ConsultantDetailScreen extends StatelessWidget {
  const ConsultantDetailScreen({super.key, required this.consultant});

  final Consultant consultant;

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
                        consultant.name,
                        style: Theme.of(context).primaryTextTheme.headline6,
                      ),
                    ),
                    Text(
                      consultant.subjects.toString(),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text(
                        'About consultant',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      subtitle: const Text('lorem and asura kapa endi'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Reviews',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const SizedBox(
                            width: 8.0,
                          ),
                          const Icon(
                            Icons.star,
                            color: Colors.yellow,
                          ),
                          const Text('4.9 (124)'),
                          const Spacer(),
                          Text(
                            'See all',
                            style: TextStyle(color: Colors.lightBlue.shade500),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Container(
                            height: 120,
                            width: 280,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  leading: const CircleAvatar(
                                    child: FlutterLogo(),
                                  ),
                                  title: const Text('Mr. Hanh'),
                                  subtitle: const Text('1 day ago'),
                                  trailing: SizedBox(
                                    width: 60.0,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: const [
                                        Icon(
                                          Icons.star,
                                          color: Colors.yellow,
                                        ),
                                        Text('4.9'),
                                      ],
                                    ),
                                  ),
                                ),
                                const Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 16.0),
                                  child: Text('lorem and asura kapa endi'),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          Container(
                            height: 120,
                            width: 280,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  leading: const CircleAvatar(
                                    child: FlutterLogo(),
                                  ),
                                  title: const Text('Mr. Hanh'),
                                  subtitle: const Text('1 day ago'),
                                  trailing: SizedBox(
                                    width: 60.0,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: const [
                                        Icon(
                                          Icons.star,
                                          color: Colors.yellow,
                                        ),
                                        Text('4.9'),
                                      ],
                                    ),
                                  ),
                                ),
                                const Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 16.0),
                                  child: Text('lorem and asura kapa endi'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Location',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.indigo.shade50,
                          child: const Icon(
                            Icons.location_on,
                          ),
                        ),
                        title: Text(consultant.address),
                        subtitle: const Text('concrete address'),
                      ),
                    ),
                    const Spacer(),
                    const Divider(
                      color: Colors.grey,
                      thickness: 3.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: const [
                          Text('Consumption prices'),
                          Spacer(),
                          Text('100\$'),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 44.0,
                        child: ElevatedButton(
                          onPressed: () {},
                          child: const Text('Book Appointment'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
