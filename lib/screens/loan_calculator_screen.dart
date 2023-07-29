import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/bloc/loan_calculator/loan_calculator_cubit.dart';
import 'package:project/screens/past_calculation_screen.dart';
import 'package:project/widgets/payment_chart.dart';

class LoanCalculatorScreen extends StatefulWidget {
  const LoanCalculatorScreen({super.key});

  @override
  LoanCalculatorScreenState createState() => LoanCalculatorScreenState();
}

class LoanCalculatorScreenState extends State<LoanCalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController loanAmountController = TextEditingController();
  final TextEditingController interestRateController = TextEditingController();
  final TextEditingController loanTermController = TextEditingController();
  bool isAnnuityPaymentType = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoanCalculatorCubit(),
      child: BlocBuilder<LoanCalculatorCubit, LoanCalculatorState>(
        builder: (context, state) {
          var cubit = context.read<LoanCalculatorCubit>();
          return Scaffold(
            appBar: AppBar(
              title: const Text('Loan Calculator'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.history),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PastCalculationsScreen()),
                    );
                  },
                ),
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: loanAmountController,
                      keyboardType: TextInputType.number,
                      decoration:
                          const InputDecoration(labelText: 'Loan Amount'),
                      validator: (value) {
                        if (value!.isEmpty || double.tryParse(value) == null) {
                          return 'Please enter a valid loan amount.';
                        }
                        return null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                    TextFormField(
                      controller: interestRateController,
                      keyboardType: TextInputType.number,
                      decoration:
                          const InputDecoration(labelText: 'Interest Rate (%)'),
                      validator: (value) {
                        if (value!.isEmpty || double.tryParse(value) == null) {
                          return 'Please enter a valid interest rate.';
                        }
                        return null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                    TextFormField(
                      controller: loanTermController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          labelText: 'Loan Term (months)'),
                      validator: (value) {
                        if (value!.isEmpty || int.tryParse(value) == null) {
                          return 'Please enter a valid loan term.';
                        }
                        return null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                    Row(
                      children: [
                        const Text('Payment Type:'),
                        const SizedBox(width: 10),
                        DropdownButton<bool>(
                          value: isAnnuityPaymentType,
                          onChanged: (newValue) {
                            cubit.changedPaymentType(newValue!);
                            isAnnuityPaymentType = newValue;
                          },
                          items: const [
                            DropdownMenuItem<bool>(
                              value: true,
                              child: Text('Annuity'),
                            ),
                            DropdownMenuItem<bool>(
                              value: false,
                              child: Text('Differential'),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => cubit.calculateLoan(
                        loanAmount: int.tryParse(loanAmountController.text),
                        interestRate:
                            double.tryParse(interestRateController.text),
                        loanTerm: int.tryParse(loanTermController.text),
                        isAnnuityPaymentType: isAnnuityPaymentType,
                      ),
                      child: const Text('Calculate'),
                    ),
                    const SizedBox(height: 20),
                    if (state is LoanCalculatorCalculate)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          isAnnuityPaymentType
                              ? Text('Monthly Payment: ${state.monthlyPayment}')
                              : const SizedBox(),
                          Text('Total Payments: ${state.totalPayments}'),
                          Text(
                              'Interest Overpayment: ${state.interestOverpayment}'),
                          if (state.differentiatedPayments != null)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 20),
                                const Text('Monthly Payments:'),
                                ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount:
                                      state.differentiatedPayments!.length,
                                  itemBuilder: (context, index) {
                                    final payment =
                                        state.differentiatedPayments![index];
                                    return Text(
                                        'Month ${index + 1}: ${payment.toInt()}');
                                  },
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: SizedBox(
                                    height: 500,
                                    width: 800,
                                    child: LineChart(
                                      buildDifferentialPaymentChart(
                                          differentiatedPayments:
                                              state.differentiatedPayments!),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
