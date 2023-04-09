import 'package:consultant/models/consultant_model.dart';

abstract class SearchingState {}

class SearchingInitial extends SearchingState {}

class SearchingConsultants extends SearchingState {
  final List<Consultant> consultants;
  final bool isFiltering;
  SearchingConsultants({required this.consultants, this.isFiltering = false});
}

class SearchingLoading extends SearchingState {}
