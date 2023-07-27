part of 'main_bloc.dart';

class MainState extends Equatable {
  final int tabIndex;
  final HomePageState homePageState;
  const MainState({
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
