
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:counter_app/cubits/counter_cubit.dart';

class IncrementButton extends StatelessWidget {
	const IncrementButton({Key? key}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return ElevatedButton(
			onPressed: () {
				context.read<CounterCubit>().increment();
			},
			child: Text('Increment'),
		);
	}
}
