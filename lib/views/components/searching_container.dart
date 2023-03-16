import 'package:consultant/cubits/searching/searching_cubit.dart';
import 'package:consultant/cubits/searching/searching_state.dart';
import 'package:consultant/views/components/consultant_card_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SearchingContainer extends StatefulWidget {
  const SearchingContainer({super.key});

  @override
  State<SearchingContainer> createState() => _SearchingContainerState();
}

class _SearchingContainerState extends State<SearchingContainer>
    with SingleTickerProviderStateMixin {
  final style = const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold);
  late TextEditingController _controller;
  bool isSearching = false;
  late AnimationController _animationController;

  late PersistentBottomSheetController _bottomSheetController;

  double priceSliderValue = 50;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(() {
      context.read<SearchingCubit>().filter(_controller.text);
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
    final listTileWidth = MediaQuery.of(context).size.width / 2;
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
                        .headline5
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
                                    .filter(_controller.text = ''),
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
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            builder(context) {
                              return Scaffold(
                                appBar: AppBar(
                                  automaticallyImplyLeading: false,
                                  title: const Text('Lọc'),
                                  centerTitle: true,
                                  actions: [
                                    IconButton(
                                      onPressed: () =>
                                          GoRouter.of(context).pop(),
                                      icon:
                                          const Icon(Icons.keyboard_arrow_down),
                                    )
                                  ],
                                ),
                                body: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Text('Môn học', style: style),
                                      ),
                                      Wrap(
                                        children: [
                                          SizedBox(
                                            width: listTileWidth,
                                            child: CheckboxListTile(
                                              title: const Text('Toán'),
                                              value: false,
                                              controlAffinity:
                                                  ListTileControlAffinity
                                                      .leading,
                                              onChanged: (value) {},
                                            ),
                                          ),
                                          SizedBox(
                                            width: listTileWidth,
                                            child: CheckboxListTile(
                                              title: const Text('Văn'),
                                              value: true,
                                              controlAffinity:
                                                  ListTileControlAffinity
                                                      .leading,
                                              onChanged: (value) {},
                                            ),
                                          ),
                                          SizedBox(
                                            width: listTileWidth,
                                            child: CheckboxListTile(
                                              title: const Text('Vật Lý'),
                                              value: true,
                                              controlAffinity:
                                                  ListTileControlAffinity
                                                      .leading,
                                              onChanged: (value) {},
                                            ),
                                          ),
                                          SizedBox(
                                            width: listTileWidth,
                                            child: CheckboxListTile(
                                              title: const Text('Hóa'),
                                              value: true,
                                              controlAffinity:
                                                  ListTileControlAffinity
                                                      .leading,
                                              onChanged: (value) {},
                                            ),
                                          ),
                                          SizedBox(
                                            width: listTileWidth,
                                            child: CheckboxListTile(
                                              title: const Text('Anh'),
                                              value: true,
                                              controlAffinity:
                                                  ListTileControlAffinity
                                                      .leading,
                                              onChanged: (value) {},
                                            ),
                                          ),
                                          SizedBox(
                                            width: listTileWidth,
                                            child: CheckboxListTile(
                                              title: const Text('Sử'),
                                              value: true,
                                              controlAffinity:
                                                  ListTileControlAffinity
                                                      .leading,
                                              onChanged: (value) {},
                                            ),
                                          ),
                                          SizedBox(
                                            width: listTileWidth,
                                            child: CheckboxListTile(
                                              title: const Text('Địa'),
                                              value: true,
                                              controlAffinity:
                                                  ListTileControlAffinity
                                                      .leading,
                                              onChanged: (value) {},
                                            ),
                                          ),
                                          SizedBox(
                                            width: listTileWidth,
                                            child: CheckboxListTile(
                                              title: const Text('Sinh'),
                                              value: true,
                                              controlAffinity:
                                                  ListTileControlAffinity
                                                      .leading,
                                              onChanged: (value) {},
                                            ),
                                          ),
                                          SizedBox(
                                            width: listTileWidth,
                                            child: CheckboxListTile(
                                              title: const Text('Tin'),
                                              value: true,
                                              controlAffinity:
                                                  ListTileControlAffinity
                                                      .leading,
                                              onChanged: (value) {},
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Row(
                                          children: [
                                            Text(
                                              'Giá (cho 1 buổi)',
                                              style: style,
                                            ),
                                            const Spacer(),
                                            Text(
                                              '${priceSliderValue.round().toString()}k',
                                              style: style,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Slider(
                                        divisions: 32,
                                        label:
                                            priceSliderValue.round().toString(),
                                        min: 40.0,
                                        max: 200.0,
                                        value: priceSliderValue,
                                        onChanged: (value) {
                                          _bottomSheetController.setState!(() {
                                            priceSliderValue = value;
                                          });
                                        },
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Text('Giới tính', style: style),
                                      ),
                                      RadioListTile(
                                        title: const Text('Nam'),
                                        value: false,
                                        groupValue: const [],
                                        onChanged: (value) {},
                                      ),
                                      RadioListTile(
                                        title: const Text('Nữ'),
                                        value: false,
                                        groupValue: const [],
                                        onChanged: (value) {},
                                      ),
                                      RadioListTile(
                                        title: const Text('Tất cả'),
                                        value: false,
                                        groupValue: const [],
                                        onChanged: (value) {},
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Text('Đánh giá', style: style),
                                      ),
                                      RangeSlider(
                                        values: const RangeValues(2, 4),
                                        min: 1.0,
                                        max: 5.0,
                                        onChanged: (value) {},
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Text('Lớp', style: style),
                                      ),
                                      RangeSlider(
                                        values: const RangeValues(6, 10),
                                        min: 1.0,
                                        max: 12.0,
                                        onChanged: (value) {},
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Text('Vị trí', style: style),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 32.0,
                                        ),
                                        child: DropdownButtonFormField(
                                          value: 1,
                                          items: const [
                                            DropdownMenuItem(
                                              value: 1,
                                              child: Text('Hồ Chí Minh'),
                                            ),
                                            DropdownMenuItem(
                                              value: 2,
                                              child: Text('Hà Nội'),
                                            ),
                                          ],
                                          onChanged: (value) {},
                                        ),
                                      ),
                                      Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: ElevatedButton(
                                            onPressed: () =>
                                                GoRouter.of(context).pop(),
                                            style: ButtonStyle(
                                              alignment: Alignment.center,
                                              minimumSize:
                                                  MaterialStateProperty.all(
                                                const Size(120.0, 40.0),
                                              ),
                                              shape: MaterialStateProperty.all(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          40.0),
                                                ),
                                              ),
                                            ),
                                            child: const Text('Áp dụng'),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }

                            _bottomSheetController = showBottomSheet(
                              context: context,
                              builder: builder,
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
