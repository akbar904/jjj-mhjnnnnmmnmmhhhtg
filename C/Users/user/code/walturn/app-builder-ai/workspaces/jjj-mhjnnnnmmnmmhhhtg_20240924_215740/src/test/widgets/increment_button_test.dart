
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:counter_app/widgets/increment_button.dart';
import 'package:counter_app/cubits/counter_cubit.dart';

class MockCounterCubit extends Mock implements CounterCubit {}

void main() {
	group('IncrementButton Widget Tests', () {
		late CounterCubit counterCubit;

		setUp(() {
			counterCubit = MockCounterCubit();
		});

		testWidgets('renders IncrementButton with correct text', (WidgetTester tester) async {
			await tester.pumpWidget(
				MaterialApp(
					home: Scaffold(
						body: IncrementButton(),
					),
				),
			);

			expect(find.text('Increment'), findsOneWidget);
		});

		testWidgets('calls increment method on tap', (WidgetTester tester) async {
			when(() => counterCubit.increment()).thenReturn(null);

			await tester.pumpWidget(
				BlocProvider.value(
					value: counterCubit,
					child: MaterialApp(
						home: Scaffold(
							body: IncrementButton(),
						),
					),
				),
			);

			await tester.tap(find.byType(ElevatedButton));
			verify(() => counterCubit.increment()).called(1);
		});
	});
}
