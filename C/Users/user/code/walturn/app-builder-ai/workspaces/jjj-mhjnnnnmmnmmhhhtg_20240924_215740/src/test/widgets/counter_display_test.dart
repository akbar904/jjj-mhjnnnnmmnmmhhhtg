
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:com.example.counter_app/widgets/counter_display.dart';
import 'package:com.example.counter_app/cubits/counter_cubit.dart';
import 'package:com.example.counter_app/models/counter_state.dart';

// Mock CounterCubit to simulate its behavior during widget testing
class MockCounterCubit extends MockCubit<CounterState> implements CounterCubit {}

void main() {
	group('CounterDisplay Widget', () {
		// Initialize the MockCounterCubit before each test
		late CounterCubit counterCubit;

		setUp(() {
			counterCubit = MockCounterCubit();
		});

		testWidgets('displays the initial counter value', (WidgetTester tester) async {
			// Arrange
			when(() => counterCubit.state).thenReturn(CounterState(1));

			// Act
			await tester.pumpWidget(
				MaterialApp(
					home: BlocProvider<CounterCubit>.value(
						value: counterCubit,
						child: CounterDisplay(),
					),
				),
			);

			// Assert
			expect(find.text('1'), findsOneWidget);
		});

		testWidgets('updates the displayed counter value when state changes', (WidgetTester tester) async {
			// Arrange
			whenListen(
				counterCubit,
				Stream.fromIterable([CounterState(1), CounterState(10)]),
				initialState: CounterState(1),
			);

			// Act
			await tester.pumpWidget(
				MaterialApp(
					home: BlocProvider<CounterCubit>.value(
						value: counterCubit,
						child: CounterDisplay(),
					),
				),
			);

			// Pump the widget tree to simulate state change
			await tester.pump();

			// Assert
			expect(find.text('10'), findsOneWidget);
		});
	});
}
