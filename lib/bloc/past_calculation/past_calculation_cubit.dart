import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/models/calculation_model.dart';
import 'package:project/services.dart';

part 'past_calculation_state.dart';

class PastCalculationCubit extends Cubit<PastCalculationState> {
  PastCalculationCubit() : super(PastCalculationInitial());

  void loadPastCalculations() {
    emit(PastCalculationLoading());
    try {
      var data = getFromStorage();
      emit(PastCalculationLoaded(pastCalculations: data));
    } catch (e) {
      emit(PastCalculationError(e: e.toString()));
    }
  }

  void deletePastCalculation(CalculationModel model) {
    deleteCalculation(model);
    loadPastCalculations();
  }
}
