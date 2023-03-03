import 'package:badges/badges.dart';
import 'package:flutter/material.dart';

class MessagesContainer extends StatelessWidget {
  const MessagesContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            elevation: 0,
            pinned: true,
            backgroundColor: Colors.white,
            title: Text(
              'Tin nhắn',
              style: Theme.of(context)
                  .textTheme
                  .headline5
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16.0),
                      hintText: 'Tìm kiếm',
                      suffixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Đang trực tuyến',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (int i = 0; i < 10; i++)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Badge(
                            position: BadgePosition.custom(
                              top: 2,
                              end: 4,
                            ),
                            badgeStyle: BadgeStyle(
                              badgeColor: Colors.green.shade400,
                              borderSide: const BorderSide(
                                width: 1,
                                color: Colors.white,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 26.0,
                              child: Container(
                                width: 48.0,
                                height: 48.0,
                                clipBehavior: Clip.hardEdge,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: Image.asset(
                                  'assets/dog.jpeg',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    top: 16.0,
                    bottom: 8.0,
                  ),
                  child: Text(
                    'Gần đây',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate.fixed([
              for (int i = 0; i < 10; i++)
                ListTile(
                  leading: Container(
                    width: 48.0,
                    height: 48.0,
                    clipBehavior: Clip.hardEdge,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      'assets/dog.jpeg',
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: const Text('Tên gia sư'),
                  subtitle: const Text('nội dung tin nhắn'),
                  trailing: const Text('6:00'),
                ),
            ]),
          ),
        ],
      ),
    );
  }
}
