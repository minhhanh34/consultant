part of 'home_cubit.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeConsultants extends HomeState {
  final List<Consultant> consultants;
  HomeConsultants(this.consultants);
}
