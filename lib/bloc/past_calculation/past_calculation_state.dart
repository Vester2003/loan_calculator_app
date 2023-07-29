part of 'past_calculation_cubit.dart';

abstract class PastCalculationState {}

class PastCalculationInitial extends PastCalculationState {}

class PastCalculationLoading extends PastCalculationState {}

class PastCalculationLoaded extends PastCalculationState {
  final List<CalculationModel> pastCalculations;

  PastCalculationLoaded({required this.pastCalculations});
}

class PastCalculationError extends PastCalculationState {
  final String e;

  PastCalculationError({required this.e});
}
