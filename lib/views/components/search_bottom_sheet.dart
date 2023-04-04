import 'package:consultant/constants/const.dart';
import 'package:consultant/cubits/searching/searching_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class SearchBottomSheet extends StatefulWidget {
  const SearchBottomSheet({super.key});

  @override
  State<SearchBottomSheet> createState() => _SearchBottomSheetState();
}

class _SearchBottomSheetState extends State<SearchBottomSheet> {
  final style = const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold);
  double priceSliderValue = 50;

  List<Map<String, dynamic>> subjectsMap = kSubjects.map((subject) {
    return <String, dynamic>{
      'name': subject,
      'value': false,
    };
  }).toList();

  List<Map> gendersMap = kGenders.map((e) {
    Gender value = Gender.all;
    if (e == 'Nữ') {
      value = Gender.female;
    } else if (e == 'Nam') {
      value = Gender.male;
    }
    return {
      'title': e,
      'value': value,
    };
  }).toList();

  Gender radioGroupValue = Gender.all;

  RangeValues rateRangeValues = const RangeValues(1, 5);

  RangeValues classRangeValues = const RangeValues(1, 12);

  RangeValues priceRangeValues = const RangeValues(40000, 200000);

  String locaion = 'Tất cả';

  @override
  Widget build(BuildContext context) {
    final listTileWidth = MediaQuery.of(context).size.width / 2;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Lọc'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => GoRouter.of(context).pop(),
            icon: const Icon(Icons.keyboard_arrow_down),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Môn học', style: style),
            ),
            Wrap(
              children: subjectsMap.map((map) {
                return SizedBox(
                  width: listTileWidth,
                  child: CheckboxListTile(
                    title: Text(map['name']),
                    value: map['value'],
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (value) {
                      setState(() {
                        map['value'] = value ?? map['value'];
                      });
                    },
                  ),
                );
              }).toList(),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Text(
                    'Giá (buổi)',
                    style: style,
                  ),
                  const Spacer(),
                  Text(
                    '${NumberFormat.simpleCurrency(locale: "vi").format(priceRangeValues.start.toInt())} - ${NumberFormat.simpleCurrency(locale: "vi").format(priceRangeValues.end.toInt())}',
                    style: style,
                  ),
                ],
              ),
            ),
            RangeSlider(
              divisions: 32,
              values: priceRangeValues,
              min: 40000.0,
              max: 200000.0,
              onChanged: (value) {
                setState(() {
                  priceRangeValues = RangeValues(
                    value.start.ceilToDouble(),
                    value.end.ceilToDouble(),
                  );
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Giới tính', style: style),
            ),
            Column(
              children: gendersMap.map((element) {
                return RadioListTile<Gender>(
                  title: Text(element['title']),
                  value: element['value'],
                  groupValue: radioGroupValue,
                  onChanged: (value) {
                    setState(() {
                      radioGroupValue = value ?? radioGroupValue;
                    });
                  },
                );
              }).toList(),
            ),
            ListTile(
              leading: Text('Đánh giá', style: style),
              trailing: Text(
                '${rateRangeValues.start} - ${rateRangeValues.end}',
                style: style,
              ),
            ),
            RangeSlider(
              values: rateRangeValues,
              min: 1.0,
              max: 5.0,
              onChanged: (value) {
                setState(() {
                  rateRangeValues = RangeValues(
                    double.parse(value.start.toStringAsFixed(1)),
                    double.parse(value.end.toStringAsFixed(1)),
                  );
                });
              },
            ),
            ListTile(
              leading: Text('Lớp', style: style),
              trailing: Text(
                '${classRangeValues.start.round()} - ${classRangeValues.end.round()}',
                style: style,
              ),
            ),
            RangeSlider(
              values: classRangeValues,
              min: 1.0,
              max: 12.0,
              onChanged: (value) {
                setState(() {
                  classRangeValues = RangeValues(
                    value.start.ceilToDouble(),
                    value.end.ceilToDouble(),
                  );
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Vị trí', style: style),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 32.0,
              ),
              child: DropdownButtonFormField<String>(
                value: locaion,
                items: const [
                  DropdownMenuItem(
                    value: 'Tất cả',
                    child: Text('Tất cả'),
                  ),
                  DropdownMenuItem(
                    value: 'Hồ Chí Minh',
                    child: Text('Hồ Chí Minh'),
                  ),
                  DropdownMenuItem(
                    value: 'Hà Nội',
                    child: Text('Hà Nội'),
                  ),
                ],
                onChanged: (value) {
                  locaion = value ?? locaion;
                },
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    context.read<SearchingCubit>().search(
                          classRange: classRangeValues,
                          gender: radioGroupValue,
                          priceRange: priceRangeValues,
                          location: locaion,
                          rateRange: rateRangeValues,
                          subjects: subjectsMap
                              .where((sub) => sub['value'] as bool)
                              .toList()
                              .map((sub) => sub['name'] as String)
                              .toList(),
                        );
                    context.pop();
                  },
                  style: ButtonStyle(
                    alignment: Alignment.center,
                    minimumSize: MaterialStateProperty.all(
                      const Size(double.infinity, 44.0),
                    ),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0),
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
}

enum Gender {
  male,
  female,
  all,
}
