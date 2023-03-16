
import '../../models/consultant_model.dart';

abstract class FilterState {}

class FilterInitial extends FilterState {}

class FilterLoading extends FilterState {}

class FilteredConsultants extends FilterState {
  final List<Consultant> consultants;
  FilteredConsultants(this.consultants);
}
