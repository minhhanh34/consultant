import 'package:consultant/models/consultant.dart';

abstract class SearchingState {}

class SearchingInitial extends SearchingState {}

class SearchingConsultants extends SearchingState {
  final List<Consultant> consultants;
  SearchingConsultants(this.consultants);
}

class SearchingLoading extends SearchingState {}
