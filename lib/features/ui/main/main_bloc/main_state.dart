// ignore_for_file: must_be_immutable

part of 'main_bloc.dart';

class MainState extends Equatable {

  MainState({
    required this.tabIndex,
  });
  int tabIndex;

  @override
  List<Object> get props => [tabIndex];

  MainState copyWith({int? tabIndex}) {
    return MainState(
      tabIndex: tabIndex ?? this.tabIndex,
    );
  }
}
