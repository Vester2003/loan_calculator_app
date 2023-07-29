import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/bloc/past_calculation/past_calculation_cubit.dart';
import 'package:project/widgets/payment_dialog.dart';

class PastCalculationsScreen extends StatefulWidget {
  const PastCalculationsScreen({super.key});

  @override
  PastCalculationsScreenState createState() => PastCalculationsScreenState();
}

class PastCalculationsScreenState extends State<PastCalculationsScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PastCalculationCubit()..loadPastCalculations(),
      child: BlocConsumer<PastCalculationCubit, PastCalculationState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is PastCalculationError) {
            return Center(
              child: Text(state.e),
            );
          }
          if (state is PastCalculationLoaded) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Past Calculations'),
              ),
              body: ListView.builder(
                itemCount: state.pastCalculations.length,
                itemBuilder: (context, index) {
                  final model = state.pastCalculations[index];
                  return ListTile(
                    title: Text('Calculation ${index + 1}'),
                    subtitle: Text('Loan Amount: ${model.loanAmount}'),
                    onTap: () {
                      showPaymentDetailsDialog(model, context);
                    },
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        context
                            .read<PastCalculationCubit>()
                            .deletePastCalculation(model);
                      },
                    ),
                  );
                },
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
