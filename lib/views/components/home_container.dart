import 'package:consultant/cubits/home/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomeContainer extends StatelessWidget {
  const HomeContainer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is HomeConsultants) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 8.0),
                  child: Row(
                    children: [
                      Text(
                        'Hello Hanh',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () => context.go('/Detail'),
                        child: CircleAvatar(
                          backgroundColor: Colors.grey.shade300,
                          radius: 24.0,
                          child: const FlutterLogo(
                            size: 40.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // const SizedBox(width: 8.0),
                      Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width:
                                  MediaQuery.of(context).size.width / 2 - 24.0,
                              height: 120,
                              decoration: BoxDecoration(
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 8.0,
                                    blurStyle: BlurStyle.outer,
                                  ),
                                ],
                                color: Colors.indigo.shade300,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                          const Positioned(
                            top: 16.0,
                            left: 16.0,
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Icon(Icons.add),
                            ),
                          ),
                          const Positioned(
                            top: 60,
                            left: 0,
                            child: SizedBox(
                              width: 130.0,
                              child: ListTile(
                                textColor: Colors.white,
                                title: Text('Minh Hanh'),
                                subtitle: Text('subtitle'),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // const SizedBox(width: 8.0),
                      Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width:
                                  MediaQuery.of(context).size.width / 2 - 24.0,
                              height: 120,
                              decoration: BoxDecoration(
                                boxShadow: const [
                                  BoxShadow(
                                    blurRadius: 8.0,
                                    color: Colors.grey,
                                    blurStyle: BlurStyle.outer,
                                  ),
                                ],
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 16.0,
                            left: 16.0,
                            child: CircleAvatar(
                              backgroundColor: Colors.indigo.shade100,
                              child: Icon(
                                Icons.home,
                                color: Colors.indigo.shade300,
                              ),
                            ),
                          ),
                          const Positioned(
                            top: 60,
                            left: 0,
                            child: SizedBox(
                              width: 130.0,
                              child: ListTile(
                                textColor: Colors.black,
                                title: Text('Minh Hanh'),
                                subtitle: Text('subtitle'),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 8.0),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Subject',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                SizedBox(
                  height: 48,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    scrollDirection: Axis.horizontal,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8.0),
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Center(
                          child: Text(
                            'Physical',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8.0),
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Center(
                          child: Text(
                            'Math',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8.0),
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Center(
                          child: Text(
                            'Geography',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8.0),
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Center(
                          child: Text(
                            'Chemistry',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      Text(
                        'Popular consultant',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {},
                        child: Text(
                          'see all',
                          style: TextStyle(
                              color: Colors.blue[700], fontSize: 16.0),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                    ),
                    itemCount: state.consultants.length,
                    itemBuilder: (context, index) => InkWell(
                      onTap: () => context.push(
                        '/Detail',
                        extra: state.consultants[index],
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 4.0,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 12.0,
                            ),
                            CircleAvatar(
                              backgroundColor: Colors.grey.shade300,
                              radius: 36.0,
                              child: const FlutterLogo(
                                size: 36.0,
                              ),
                            ),
                            ListTile(
                              title: Text(
                                state.consultants[index].name,
                                textAlign: TextAlign.center,
                              ),
                              subtitle: Text(
                                state.consultants[index].subjects.toString(),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
