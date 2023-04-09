import 'package:consultant/cubits/searching/searching_cubit.dart';
import 'package:consultant/cubits/searching/searching_state.dart';
import 'package:consultant/views/components/consultant_card_info.dart';
import 'package:consultant/views/components/search_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchingContainer extends StatefulWidget {
  const SearchingContainer({super.key});

  @override
  State<SearchingContainer> createState() => _SearchingContainerState();
}

class _SearchingContainerState extends State<SearchingContainer>
    with SingleTickerProviderStateMixin {
  late TextEditingController _controller;
  bool isSearching = false;
  late AnimationController _animationController;
  bool isFiltering = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(() {
      context.read<SearchingCubit>().filterByName(_controller.text);
      if (_controller.text.isNotEmpty) {
        isSearching = true;
      } else {
        isSearching = false;
      }
    });
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
    return Scaffold(
      body: BlocBuilder<SearchingCubit, SearchingState>(
        builder: (context, state) {
          if (state is SearchingInitial) {
            context.read<SearchingCubit>().featchAllConsultants();
          }
          if (state is SearchingConsultants) {
            _animationController.forward();
            return CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  title: Text(
                    'Tìm kiếm',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: Colors.white,
                  elevation: 0,
                ),
                SliverAppBar(
                  elevation: 0,
                  backgroundColor: Colors.white,
                  pinned: true,
                  flexibleSpace: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _controller,
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16.0),
                        hintText: 'TÌm gia sư theo tên',
                        suffixIcon: isSearching
                            ? InkWell(
                                onTap: () => context
                                    .read<SearchingCubit>()
                                    .filterByName(_controller.text = ''),
                                child: const Icon(Icons.close),
                              )
                            : const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Text(
                          'Lọc',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const Spacer(),
                        Visibility(
                          visible: state.isFiltering,
                          child: TextButton(
                            onPressed: () {
                              isFiltering = false;
                              context
                                  .read<SearchingCubit>()
                                  .featchAllConsultants();
                            },
                            child: const Text('Bỏ lọc'),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            isFiltering = true;
                            FocusManager.instance.primaryFocus?.unfocus();
                            showBottomSheet(
                              context: context,
                              builder: (context) => const SearchBottomSheet(),
                            );
                          },
                          child: Icon(
                            Icons.filter_list,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Visibility(
                    visible: state.consultants.isEmpty,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * .55,
                      child: Center(
                        child: Text(
                          'Không tìm thấy gia sư nào',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    ),
                  ),
                ),
                SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    childCount: state.consultants.length,
                    (context, index) {
                      return ConsultantCardInfor(
                        controller: _animationController,
                        curve: Curves.elasticInOut,
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
              ],
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
