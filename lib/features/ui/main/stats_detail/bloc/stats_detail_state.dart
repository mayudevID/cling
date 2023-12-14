part of 'stats_detail_bloc.dart';

sealed class StatsDetailState extends Equatable {
  const StatsDetailState();
  
  @override
  List<Object> get props => [];
}

final class StatsDetailInitial extends StatsDetailState {}
