import 'package:consultant/constants/const.dart';
import 'package:consultant/cubits/auth/auth_cubit.dart';
import 'package:consultant/cubits/messages/messages_cubit.dart';
import 'package:consultant/views/components/circle_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../cubits/messages/messages_state.dart';

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
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
            delegate: SliverChildListDelegate([
              BlocBuilder<MessageCubit, MessageState>(
                builder: (context, state) {
                  if (state is MessageInitial) {
                    context
                        .read<MessageCubit>()
                        .fetchRooms(AuthCubit.currentUserId!);
                  }
                  if (state is MessageRooms) {
                    if (state.rooms.isEmpty) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * .7,
                        child: Center(
                          child: Text(
                            'Chưa có tin nhắn',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                      );
                    }
                    final tiles = <ListTile>[];
                    for (int i = 0; i < state.rooms.length; i++) {
                      if (state.rooms[i].lastMessage != null) {
                        final partnerId = state.rooms[i].firstPersonId !=
                                AuthCubit.currentUserId
                            ? state.rooms[i].firstPersonId
                            : state.rooms[i].secondPersonId;
                        tiles.add(
                          ListTile(
                            onTap: () => context.push(
                              '/ChatRoom',
                              extra: {
                                'room': state.rooms[i],
                                'partnerId': partnerId,
                              },
                            ),
                            leading: Avatar(
                              imageUrl: state.consultants[i].avtPath ??
                                  defaultAvtPath,
                              radius: 24.0,
                            ),
                            title: Text(state.consultants[i].name),
                            subtitle: Text(state.rooms[i].lastMessage!.content),
                            trailing: Text(DateFormat('hh:mm')
                                .format(state.rooms[i].lastMessage!.time)),
                          ),
                        );
                      }
                    }
                    return Column(
                      children: tiles,
                    );
                  }
                  if (state is MessageLoading) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * .7,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Colors.indigo,
                        ),
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
