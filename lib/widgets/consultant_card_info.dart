import 'package:cached_network_image/cached_network_image.dart';
import 'package:consultant/models/consultant_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/consts.dart';

class ConsultantCardInfor extends StatefulWidget {
  const ConsultantCardInfor({
    Key? key,
    required this.consultant,
    required this.index,
    this.controller,
    this.curve,
  }) : super(key: key);

  final Consultant consultant;
  final int index;
  final AnimationController? controller;
  final Curve? curve;

  @override
  State<ConsultantCardInfor> createState() => _ConsultantCardInforState();
}

class _ConsultantCardInforState extends State<ConsultantCardInfor> {
  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final duMili = widget.controller?.duration?.inMilliseconds;
    final duration = Duration(
      milliseconds: duMili != null ? duMili * (widget.index + 1) : 0,
    );
    return InkWell(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        context.push(
          '/Detail',
          extra: widget.consultant,
        );
      },
      child: AnimatedOpacity(
        curve: widget.curve ?? Curves.linear,
        duration: duration,
        opacity: widget.controller?.value ?? 1,
        child: Container(
          margin: EdgeInsets.only(
            left: widget.index % 2 == 0 ? 16.0 : 0.0,
            right: widget.index % 2 == 1 ? 16.0 : 0.0,
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
                    imageUrl: widget.consultant.avtPath ?? defaultAvtPath,
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
                  widget.consultant.name,
                ),
                subtitle: Text(
                  textAlign: TextAlign.center,
                  widget.consultant.subjectsToString(),
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
                    widget.consultant.rate == null
                        ? '--'
                        : widget.consultant.rate!.toStringAsFixed(1),
                  ),
                  const SizedBox(width: 8.0),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
