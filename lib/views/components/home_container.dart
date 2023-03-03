import 'package:consultant/cubits/home/home_cubit.dart';
import 'package:consultant/views/components/consultant_card_info.dart';
import 'package:consultant/views/components/subject.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class HomeContainer extends StatelessWidget {
  const HomeContainer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (state is HomeConsultants) {
          return Scaffold(
            body: CustomScrollView(
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
                      child: Image.asset(
                        'assets/dog.jpeg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  title: const Text(
                    'Chào Hạnh',
                    style: TextStyle(
                      fontSize: 24.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  actions: [
                    IconButton(
                      onPressed: () {},
                      icon: const FaIcon(
                        FontAwesomeIcons.heart,
                        color: Colors.indigo,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        FontAwesomeIcons.locationDot,
                        color: Colors.indigo,
                      ),
                    ),
                  ],
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
                              style: Theme.of(context).textTheme.headline6,
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
                          children: const [
                            SubjectColumn(
                              icon: FaIcon(FontAwesomeIcons.infinity),
                              label: 'Toán Học',
                            ),
                            SubjectColumn(
                              icon: FaIcon(FontAwesomeIcons.book),
                              label: 'Văn Học',
                            ),
                            SubjectColumn(
                              icon: FaIcon(FontAwesomeIcons.scaleBalanced),
                              label: 'Vật Lý',
                            ),
                            SubjectColumn(
                              icon: FaIcon(FontAwesomeIcons.flaskVial),
                              label: 'Hóa Học',
                            ),
                            SubjectColumn(
                              icon: FaIcon(FontAwesomeIcons.language),
                              label: 'Tiếng Anh',
                            ),
                            SubjectColumn(
                              icon: FaIcon(FontAwesomeIcons.earthAsia),
                              label: 'Địa Lý',
                            ),
                            SubjectColumn(
                              icon: FaIcon(FontAwesomeIcons.clockRotateLeft),
                              label: 'Lịch Sử',
                            ),
                            SubjectColumn(
                              icon: FaIcon(FontAwesomeIcons.dna),
                              label: 'Sinh Học',
                            ),
                            SubjectColumn(
                              icon: FaIcon(FontAwesomeIcons.laptopCode),
                              label: 'Tin Học',
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
                    child: Row(
                      children: [
                        Text(
                          'Phổ biến',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () => context.push('/Consultants'),
                          child: Text(
                            'Thêm >',
                            style: TextStyle(
                                color: Colors.blue[700], fontSize: 16.0),
                          ),
                        ),
                      ],
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
                        consultant: state.consultants[index],
                        index: index,
                      );
                    },
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                    childAspectRatio: 1,
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 16)),
              ],
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
