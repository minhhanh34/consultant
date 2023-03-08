import 'package:cached_network_image/cached_network_image.dart';
import 'package:consultant/constants/const.dart';
import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  const Avatar({super.key, this.imageUrl = defaultAvtPath, this.radius = 38.0});
  final String imageUrl;
  final double radius;
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.indigo,
      radius: radius,
      child: Container(
        width: 2 * radius - 2.0,
        height: 2 * radius - 2.0,
        clipBehavior: Clip.hardEdge,
        decoration: const BoxDecoration(shape: BoxShape.circle),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          filterQuality: FilterQuality.high,
        ),
      ),
    );
  }
}
