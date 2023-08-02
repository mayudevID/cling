part of 'main_bloc.dart';

abstract class MainEvent extends Equatable {
  const MainEvent();

  @override
  List<Object> get props => [];
}

class TabChange extends MainEvent {
  final int tabIndex;

  const TabChange({required this.tabIndex});
}

class HomePageStateChange extends MainEvent {
  final HomePageState homePageState;

  const HomePageStateChange({
    required this.homePageState,
  });
}
