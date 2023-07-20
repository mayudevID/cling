part of 'main_bloc.dart';

abstract class MainState extends Equatable {
  final int tabIndex;
  const MainState({required this.tabIndex});

  @override
  List<Object> get props => [tabIndex];
}

class MainInitial extends MainState {
  const MainInitial({required super.tabIndex});
}
