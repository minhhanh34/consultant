import 'package:consultant/cubits/auth/auth_cubit.dart';
import 'package:consultant/cubits/home/home_cubit.dart';
import 'package:consultant/cubits/posts/post_cubit.dart';
import 'package:consultant/models/post_model.dart';
import 'package:consultant/widgets/circle_avatar.dart';
import 'package:consultant/widgets/consultant_card_info.dart';
import 'package:consultant/widgets/subject_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../constants/consts.dart';
import '../cubits/home/home_state.dart';

class HomeContainer extends StatefulWidget {
  const HomeContainer({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeContainer> createState() => _HomeContainerState();
}

class _HomeContainerState extends State<HomeContainer>
    with SingleTickerProviderStateMixin {
  late TextEditingController _controller;
  late PersistentBottomSheetController _bottomSheetController;
  bool loading = false;

  late AnimationController _animationController;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        // if(state is HomeInitial) {
        //   context.read<HomeCubit>().onInitialize(AuthCubit.currentUserId);
        // }
        if (state is HomeLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (state is HomeConsultants) {
          if (AuthCubit.infoUpdated == false) {
            context.go('/ParentUpdate', extra: {
              'parent': state.parent,
              'isFirstUpdate': true,
            });
            // return const SizedBox();
          }
          _animationController.forward();
          return Scaffold(
            body: RefreshIndicator(
              onRefresh: context.read<HomeCubit>().refresh,
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    toolbarHeight: 60.0,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    leadingWidth: 68.0,
                    leading: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 80.0,
                        height: 80.0,
                        clipBehavior: Clip.hardEdge,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.black),
                        child: Avatar(
                          imageUrl: state.parent.avtPath,
                          radius: 24,
                        ),
                      ),
                    ),
                    title: Text(
                      '${state.parent.name.isEmpty ? "" : "Chào "}${state.parent.name.split(" ").last}',
                      style: const TextStyle(
                        fontSize: 24.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    actions: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          FontAwesomeIcons.locationDot,
                          color: Colors.indigo,
                        ),
                      ),
                    ],
                  ),
                  SliverAppBar(
                    elevation: 0,
                    pinned: true,
                    backgroundColor: Colors.grey.shade100,
                    title: ListTile(
                      onTap: () async {
                        _bottomSheetController = showBottomSheet(
                          context: context,
                          builder: (context) {
                            if (loading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return Container(
                              height: MediaQuery.of(context).size.height * .6,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 8),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Tìm gia sư',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  // const SizedBox(height: 16.0),
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: TextField(
                                      controller: _controller,
                                      maxLines: 8,
                                      decoration: InputDecoration(
                                        hintText: 'Soạn bài viết...',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(16.0),
                                          borderSide:
                                              const BorderSide(width: 0),
                                        ),
                                        fillColor: Theme.of(context).hoverColor,
                                        filled: true,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          if (_controller.text.isEmpty) {
                                            SnackBar snackBar = const SnackBar(
                                              content: Text(
                                                'Bài đăng chưa có nội dung!',
                                              ),
                                            );
                                            ScaffoldMessenger.of(context)
                                              ..hideCurrentSnackBar()
                                              ..showSnackBar(snackBar);
                                            return;
                                          }
                                          _bottomSheetController.setState!(() {
                                            loading = true;
                                          });

                                          await context
                                              .read<PostCubit>()
                                              .createPost(
                                                Post(
                                                  content: _controller.text,
                                                  time: DateTime.now(),
                                                  posterId: state.parent.id!,
                                                  posterAvtPath:
                                                      state.parent.avtPath,
                                                  posterName: state.parent.name,
                                                ),
                                              );
                                          if (!mounted) return;
                                          _controller.clear();
                                          _bottomSheetController.close();
                                          loading = false;
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                        },
                                        child: const Text('Đăng'),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      leading: Icon(Icons.add_circle_outline,
                          color: Theme.of(context).primaryColor),
                      title: Text(
                        'Đăng bài tìm gia sư',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        const SizedBox(height: 8.0),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(
                                'Môn học',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const Spacer(),
                              const Icon(Icons.arrow_forward_ios_rounded),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        SizedBox(
                          height: 200,
                          child: GridView(
                            scrollDirection: Axis.horizontal,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                            ),
                            children: [
                              SubjectColumn(
                                ontap: () => context.push(
                                  '/ConsultantsFiltered',
                                  extra: [math],
                                ),
                                icon: const FaIcon(FontAwesomeIcons.infinity),
                                label: math,
                              ),
                              SubjectColumn(
                                ontap: () => context.push(
                                  '/ConsultantsFiltered',
                                  extra: [literature],
                                ),
                                icon: const FaIcon(FontAwesomeIcons.book),
                                label: literature,
                              ),
                              SubjectColumn(
                                ontap: () => context.push(
                                  '/ConsultantsFiltered',
                                  extra: [physical],
                                ),
                                icon: const FaIcon(
                                    FontAwesomeIcons.scaleBalanced),
                                label: physical,
                              ),
                              SubjectColumn(
                                ontap: () => context.push(
                                  '/ConsultantsFiltered',
                                  extra: [chemistry],
                                ),
                                icon: const FaIcon(FontAwesomeIcons.flaskVial),
                                label: chemistry,
                              ),
                              SubjectColumn(
                                ontap: () => context.push(
                                  '/ConsultantsFiltered',
                                  extra: [english],
                                ),
                                icon: const FaIcon(FontAwesomeIcons.language),
                                label: english,
                              ),
                              SubjectColumn(
                                ontap: () => context.push(
                                  '/ConsultantsFiltered',
                                  extra: [geography],
                                ),
                                icon: const FaIcon(FontAwesomeIcons.earthAsia),
                                label: geography,
                              ),
                              SubjectColumn(
                                ontap: () => context.push(
                                  '/ConsultantsFiltered',
                                  extra: [history],
                                ),
                                icon: const FaIcon(
                                    FontAwesomeIcons.clockRotateLeft),
                                label: history,
                              ),
                              SubjectColumn(
                                ontap: () => context.push(
                                  '/ConsultantsFiltered',
                                  extra: [biology],
                                ),
                                icon: const FaIcon(FontAwesomeIcons.dna),
                                label: biology,
                              ),
                              SubjectColumn(
                                ontap: () => context.push(
                                  '/ConsultantsFiltered',
                                  extra: [it],
                                ),
                                icon: const FaIcon(FontAwesomeIcons.laptopCode),
                                label: it,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 8.0),
                      child: Text(
                        'Phổ biến',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 16.0),
                  ),
                  SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      childCount: state.consultants.length,
                      (context, index) {
                        return ConsultantCardInfor(
                          controller: _animationController,
                          consultant: state.consultants[index],
                          index: index,
                        );
                      },
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1,
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 16)),
                ],
              ),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
