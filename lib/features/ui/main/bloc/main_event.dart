part of 'main_bloc.dart';

abstract class MainEvent extends Equatable {
  const MainEvent();

  @override
  List<Object> get props => [];
}

class TabChange extends MainEvent {
  final int tabIndex;
  final BuildContext context;

  const TabChange({
    required this.tabIndex,
    required this.context,
  });
}

class HomePageStateChange extends MainEvent {
  final HomePageState homePageState;
  final BuildContext context;

  const HomePageStateChange({
    required this.homePageState,
    required this.context,
  });
}
