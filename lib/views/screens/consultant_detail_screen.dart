import 'package:cached_network_image/cached_network_image.dart';
import 'package:consultant/constants/const.dart';
import 'package:consultant/models/consultant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class ConsultantDetailScreen extends StatelessWidget {
  const ConsultantDetailScreen({super.key, required this.consultant});

  final Consultant consultant;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[
      Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32.0),
            topRight: Radius.circular(32.0),
          ),
        ),
        child: Column(
          // padding: const EdgeInsets.all(16.0)
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8.0),
            Center(
              child: Text(
                textAlign: TextAlign.center,
                'Thông tin',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 8),
            for (var subject in consultant.subjects)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Môn ${subject.name}',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Lớp: ${subject.grade}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Thời gian: ${subject.duration} phút/buổi'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Giờ bắt đầu: ${subject.time}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Các ngày: ${subject.dateToString()}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Giá: ${NumberFormat.simpleCurrency(locale: 'vi').format(subject.price)}/buổi',
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                Text(
                  'Đánh giá',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(
                  width: 8.0,
                ),
                const Icon(
                  Icons.star,
                  color: Colors.yellow,
                ),
                Text('${consultant.rate} (${consultant.raters})'),
                const Spacer(),
                Text(
                  'Xem tất cả',
                  style: TextStyle(color: Colors.lightBlue.shade500),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            SingleChildScrollView(
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
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.yellow,
                                ),
                                Text(consultant.rate.toString()),
                              ],
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
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
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
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
            Text(
              'Vị trí',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.indigo.shade50,
                child: const Icon(
                  Icons.location_on,
                ),
              ),
              title: Text(consultant.address.city),
              subtitle: Text(consultant.address.district),
            ),
            const Divider(
              color: Colors.grey,
              thickness: 1.0,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                height: 44.0,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                    ),
                  ),
                  child: const Text('Đặt lịch hẹn'),
                ),
              ),
            ),
          ],
        ),
      ),
    ];
    return Scaffold(
      backgroundColor: Colors.indigo.shade300,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(FontAwesomeIcons.heart),
                ),
              ],
              collapsedHeight: 130,
              elevation: 0,
              expandedHeight: 240,
              backgroundColor: Colors.indigo.shade300,
              flexibleSpace: ListView(
                children: [
                  const SizedBox(height: 40),
                  CircleAvatar(
                    radius: 38,
                    child: Container(
                      width: 72.0,
                      height: 72.0,
                      clipBehavior: Clip.hardEdge,
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: CachedNetworkImage(
                        imageUrl: consultant.avtPath ?? defaultAvtPath,
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.high,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      textAlign: TextAlign.center,
                      consultant.name,
                      style: Theme.of(context).primaryTextTheme.headline6,
                    ),
                  ),
                  Text(
                    textAlign: TextAlign.center,
                    consultant.subjectsToString(),
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
            SliverList(
              delegate: SliverChildListDelegate(children),
            ),
          ],
        ),
      ),
    );
  }
}
