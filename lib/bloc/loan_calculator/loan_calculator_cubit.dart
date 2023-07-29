import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/models/calculation_model.dart';
import 'package:project/services.dart';

part 'loan_calculator_state.dart';

class LoanCalculatorCubit extends Cubit<LoanCalculatorState> {
  LoanCalculatorCubit() : super(LoanCalculatorMain(isAnnuityPaymentType: true));

  changedPaymentType(bool newValue) {
    emit(LoanCalculatorMain(isAnnuityPaymentType: newValue));
  }

  void calculateLoan(
      {required int? loanAmount,
      required double? interestRate,
      required int? loanTerm,
      required bool isAnnuityPaymentType}) {
    if (loanAmount == null || interestRate == null || loanTerm == null) return;

    interestRate = interestRate / 100;
    final double monthlyInterestRate = interestRate / 12;
    final List<double> differentiatedPayments = [];

    if (isAnnuityPaymentType) {
      final double monthlyPayment = (loanAmount * monthlyInterestRate) /
          (1 - pow(1 + monthlyInterestRate, -loanTerm));
      final double totalPayments = monthlyPayment * loanTerm;
      final double interestOverpayment = totalPayments - loanAmount;

      emit(
        LoanCalculatorCalculate(
            interestOverpayment: interestOverpayment.toInt(),
            monthlyPayment: monthlyPayment.toInt(),
            totalPayments: totalPayments.toInt(),
            differentiatedPayments: null),
      );
      saveToStorage(CalculationModel(
          loanAmount: loanAmount,
          interestRate: interestRate,
          loanTerm: loanTerm,
          isAnnuityPaymentType: isAnnuityPaymentType,
          monthlyPayment: monthlyPayment.toInt(),
          totalPayments: totalPayments.toInt(),
          interestOverpayment: interestOverpayment.toInt()));
    } else {
      final double monthlyPrincipal = loanAmount / loanTerm;
      double remainingAmount = loanAmount.toDouble();
      double totalPayments = 0.0;

      for (int i = 0; i < loanTerm; i++) {
        final double interestPayment = remainingAmount * monthlyInterestRate;
        final double totalMonthlyPayment = monthlyPrincipal + interestPayment;
        remainingAmount -= monthlyPrincipal;

        totalPayments += totalMonthlyPayment;
        differentiatedPayments.add(totalMonthlyPayment);
      }

      final double interestOverpayment = totalPayments - loanAmount;

      emit(LoanCalculatorCalculate(
        differentiatedPayments: differentiatedPayments,
        interestOverpayment: interestOverpayment.toInt(),
        monthlyPayment: totalPayments ~/ loanTerm,
        totalPayments: totalPayments.toInt(),
      ));

      saveToStorage(CalculationModel(
          loanAmount: loanAmount,
          interestRate: interestRate,
          loanTerm: loanTerm,
          isAnnuityPaymentType: isAnnuityPaymentType,
          monthlyPayment: monthlyPrincipal.toInt(),
          totalPayments: totalPayments.toInt(),
          interestOverpayment: interestOverpayment.toInt()));
    }
  }
}
