// ignore_for_file: must_be_immutable

part of 'main_bloc.dart';

class MainState extends Equatable {
  int tabIndex;
  HomePageState homePageState;
  MainState({
    required this.tabIndex,
    required this.homePageState,
  });

  @override
  List<Object> get props => [tabIndex, homePageState];

  MainState copyWith({
    int? tabIndex,
    HomePageState? homePageState,
  }) {
    return MainState(
      tabIndex: tabIndex ?? this.tabIndex,
      homePageState: homePageState ?? this.homePageState,
    );
  }
}
