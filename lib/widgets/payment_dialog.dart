import 'package:flutter/material.dart';
import 'package:project/models/calculation_model.dart';

void showPaymentDetailsDialog(
    CalculationModel calculationModel, BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      var showingInterestRate = calculationModel.interestRate * 100;
      var interestRate = showingInterestRate == showingInterestRate.toInt()
          ? showingInterestRate.toStringAsFixed(0)
          : showingInterestRate.toStringAsFixed(1);
      return AlertDialog(
        title: const Text('Payment Details'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Loan Amount: ${calculationModel.loanAmount}'),
            Text('Interest Rate: $interestRate'),
            Text('Loan Term (months): ${calculationModel.loanTerm}'),
            Text(
                'Payment Type: ${calculationModel.isAnnuityPaymentType ? 'Annuity' : 'Differential'}'),
            Text('Total Payments: ${calculationModel.totalPayments}'),
            Text(
                'Interest Overpayment: ${calculationModel.interestOverpayment}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Close'),
          ),
        ],
      );
    },
  );
}
