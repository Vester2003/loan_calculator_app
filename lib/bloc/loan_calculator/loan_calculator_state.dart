part of 'loan_calculator_cubit.dart';

abstract class LoanCalculatorState {}

class LoanCalculatorMain extends LoanCalculatorState {
  final bool isAnnuityPaymentType;

  LoanCalculatorMain({required this.isAnnuityPaymentType});
}

class LoanCalculatorCalculate extends LoanCalculatorState {
  final int monthlyPayment;
  final int totalPayments;
  final int interestOverpayment;
  List<double>? differentiatedPayments;

  LoanCalculatorCalculate(
      {required this.monthlyPayment,
      required this.totalPayments,
      required this.interestOverpayment,
      required this.differentiatedPayments});
}
