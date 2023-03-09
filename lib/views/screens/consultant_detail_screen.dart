import 'package:cached_network_image/cached_network_image.dart';
import 'package:consultant/constants/const.dart';
import 'package:consultant/cubits/home/home_cubit.dart';
import 'package:consultant/models/chat_room.dart';
import 'package:consultant/models/consultant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class ConsultantDetailScreen extends StatefulWidget {
  const ConsultantDetailScreen({super.key, required this.consultant});

  final Consultant consultant;

  @override
  State<ConsultantDetailScreen> createState() => _ConsultantDetailScreenState();
}

class _ConsultantDetailScreenState extends State<ConsultantDetailScreen> {
  bool commentsFetched = false;
  String calTime(index) {
    final long = DateTime.now()
        .subtract(Duration(days: widget.consultant.comments[index].time.day));
    if (long.day > 0) return '${long.day} ngày trước';
    return 'Hôm nay';
  }

  void call() async {
    final phoneLaunchUri = Uri(
      scheme: 'tel',
      path: widget.consultant.phone,
    );
    await launchUrl(phoneLaunchUri);
  }

  void openChatRoom(BuildContext context) {
    
    context.push(
      '/ChatRoom',
      extra: {
        'partner': widget.consultant,
        'room': ChatRoom(
          id: 'vLE5iPPgCcL4FRnHj6mN',
          firstPersonId: '123',
          secondPersonId: widget.consultant.id!,
        ),
      },
    );
  }

  Future<Consultant>? _fetchComments() async {
    if (commentsFetched) {
      return widget.consultant;
    }
    final consultant =
        await context.read<HomeCubit>().fetchComments(widget.consultant);
    commentsFetched = true;
    return consultant;
  }

  @override
  Widget build(BuildContext context) {
    buildChildren(AsyncSnapshot snapshot) => <Widget>[
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
                for (var subject in snapshot.data.subjects)
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
                    Text('${snapshot.data.rate} (${snapshot.data.raters})'),
                    const Spacer(),
                    TextButton(
                      onPressed: () => context.push(
                        '/Comments',
                        extra: widget.consultant.comments,
                      ),
                      child: Text(
                        'Xem tất cả',
                        style: TextStyle(color: Colors.lightBlue.shade500),
                      ),
                    ),
                  ],
                ),
                // const SizedBox(height: 16.0),
                Visibility(
                  visible: snapshot.data.comments.isNotEmpty,
                  child: SizedBox(
                    height: 120.0,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data.comments.length < 2
                          ? snapshot.data.comments.length
                          : 2,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.fromLTRB(0, 0, 16.0, 0),
                          height: 120,
                          width: 300,
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
                                title: Text(
                                  snapshot.data.comments[0].commentatorName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                  calTime(0),
                                  maxLines: 2,
                                ),
                                trailing: SizedBox(
                                  width: 48.0,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        color: Colors.yellow,
                                      ),
                                      Text(snapshot.data.comments[0].rate
                                          .toString()),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Text(
                                  snapshot.data.comments[0].content,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
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
                  onTap: () => context.push('/Map',
                      extra: snapshot.data.address.geoPoint),
                  leading: CircleAvatar(
                    backgroundColor: Colors.indigo.shade50,
                    child: const Icon(
                      Icons.location_on,
                    ),
                  ),
                  title: Text(snapshot.data.address.city),
                  subtitle: Text(snapshot.data.address.district),
                  trailing: const Icon(Icons.map_outlined),
                ),
                const Divider(
                  color: Colors.grey,
                  thickness: 1.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: double.infinity,
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
    
    return FutureBuilder<Consultant>(
      future: _fetchComments(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
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
                            decoration:
                                const BoxDecoration(shape: BoxShape.circle),
                            child: CachedNetworkImage(
                              imageUrl:
                                  widget.consultant.avtPath ?? defaultAvtPath,
                              fit: BoxFit.cover,
                              filterQuality: FilterQuality.high,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            textAlign: TextAlign.center,
                            widget.consultant.name,
                            style: Theme.of(context).primaryTextTheme.headline6,
                          ),
                        ),
                        Text(
                          textAlign: TextAlign.center,
                          widget.consultant.subjectsToString(),
                          style: Theme.of(context).primaryTextTheme.subtitle1,
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: call,
                              child: CircleAvatar(
                                backgroundColor: Colors.indigo.shade200,
                                child: Icon(
                                  Icons.phone,
                                  color:
                                      Theme.of(context).primaryIconTheme.color,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 16.0,
                            ),
                            InkWell(
                              onTap: () => openChatRoom(context),
                              child: CircleAvatar(
                                backgroundColor: Colors.indigo.shade200,
                                child: Icon(
                                  CupertinoIcons.chat_bubble_text_fill,
                                  color:
                                      Theme.of(context).primaryIconTheme.color,
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(buildChildren(snapshot)),
                  ),
                ],
              ),
            ),
          );
        }
        return const Scaffold(
          body: SafeArea(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      },
    );
  }
}
