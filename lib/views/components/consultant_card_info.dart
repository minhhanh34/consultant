import 'package:cached_network_image/cached_network_image.dart';
import 'package:consultant/models/consultant.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../constants/const.dart';

class ConsultantCardInfor extends StatelessWidget {
  const ConsultantCardInfor({
    Key? key,
    required this.consultant,
    required this.index,
  }) : super(key: key);

  final Consultant consultant;
  final int index;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        // context.read<HomeCubit>().fetchComments(consultant);
        context.push(
          '/Detail',
          extra: consultant,
        );
      },
      child: Container(
        margin: EdgeInsets.only(
          left: index % 2 == 0 ? 16.0 : 0.0,
          right: index % 2 == 1 ? 16.0 : 0.0,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.indigo,
              blurRadius: 4.0,
              blurStyle: BlurStyle.outer,
              offset: Offset(2, 2),
              spreadRadius: 1.0,
            ),
          ],
          // border: Border.all(),
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 42.0,
              child: Container(
                width: 80.0,
                height: 80.0,
                clipBehavior: Clip.hardEdge,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high,
                  imageUrl: consultant.avtPath ?? defaultAvtPath,
                  placeholder: (context, url) => Container(
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(Icons.image),
                    ),
                  ),
                ),
              ),
            ),
            ListTile(
              title: Text(
                textAlign: TextAlign.center,
                consultant.name,
              ),
              subtitle: Text(
                textAlign: TextAlign.center,
                consultant.subjectsToString(),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.star,
                  color: Colors.yellow,
                ),
                Text(
                  consultant.rate == null ? '--' : consultant.rate.toString(),
                ),
                const SizedBox(width: 8.0),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
