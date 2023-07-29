import 'package:get_storage/get_storage.dart';
import 'package:project/models/calculation_model.dart';

final box = GetStorage();

saveToStorage(CalculationModel calculationModel) {
  final data = box.read("pastCalculations");
  if (data != null) {
    data.add(calculationModel.toJson());
    box.write("pastCalculations", data);
    return;
  }
  box.write("pastCalculations", [
    calculationModel.toJson(),
  ]);
}

List<CalculationModel> getFromStorage() {
  var data = box.read("pastCalculations");
  if (data == null) return [];
  return data
      .map((e) => CalculationModel.fromJson(e))
      .cast<CalculationModel>()
      .toList();
}

void deleteCalculation(CalculationModel model) {
  final List<CalculationModel> list = getFromStorage();
  list.removeWhere((element) => model == element);
  box.remove("pastCalculations");
  for (int i = 0; i < list.length; i++) {
    saveToStorage(list[i]);
  }
}
