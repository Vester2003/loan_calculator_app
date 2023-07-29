import 'package:equatable/equatable.dart';

class CalculationModel extends Equatable {
  final int loanAmount;
  final double interestRate;
  final int loanTerm;
  final bool isAnnuityPaymentType;
  final int monthlyPayment;
  final int totalPayments;
  final int interestOverpayment;

  const CalculationModel(
      {required this.loanAmount,
      required this.interestRate,
      required this.loanTerm,
      required this.isAnnuityPaymentType,
      required this.monthlyPayment,
      required this.totalPayments,
      required this.interestOverpayment});

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'loanAmount': loanAmount,
      'interestRate': interestRate,
      'loanTerm': loanTerm,
      'isAnnuityPaymentType': isAnnuityPaymentType,
      'monthlyPayment': monthlyPayment,
      'totalPayments': totalPayments,
      'interestOverpayment': interestOverpayment,
    };
  }

  factory CalculationModel.fromJson(Map<String, dynamic> json) {
    return CalculationModel(
      interestOverpayment: json['interestOverpayment'],
      interestRate: json['interestRate'],
      isAnnuityPaymentType: json['isAnnuityPaymentType'],
      loanAmount: json['loanAmount'],
      loanTerm: json['loanTerm'],
      monthlyPayment: json['monthlyPayment'],
      totalPayments: json['totalPayments'],
    );
  }

  @override
  List<Object?> get props => [
        loanAmount,
        interestRate,
        loanTerm,
        isAnnuityPaymentType,
        monthlyPayment,
        totalPayments,
        interestOverpayment,
      ];
}
