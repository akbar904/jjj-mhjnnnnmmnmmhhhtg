
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:counter_app/screens/home_screen.dart';
import 'package:counter_app/cubits/counter_cubit.dart';
import 'package:counter_app/models/counter_state.dart';

class MockCounterCubit extends MockCubit<CounterState> implements CounterCubit {}

void main() {
	group('HomeScreen Widget Tests', () {
		late CounterCubit mockCounterCubit;

		setUp(() {
			mockCounterCubit = MockCounterCubit();
		});

		testWidgets('displays the initial counter value', (WidgetTester tester) async {
			when(() => mockCounterCubit.state).thenReturn(CounterState(0));

			await tester.pumpWidget(
				BlocProvider<CounterCubit>.value(
					value: mockCounterCubit,
					child: MaterialApp(
						home: HomeScreen(),
					),
				),
			);

			expect(find.text('0'), findsOneWidget);
		});

		testWidgets('displays the multiplied counter value after increment button is pressed', (WidgetTester tester) async {
			when(() => mockCounterCubit.state).thenReturn(CounterState(0));
			whenListen(mockCounterCubit, Stream.fromIterable([CounterState(0), CounterState(10)]));

			await tester.pumpWidget(
				BlocProvider<CounterCubit>.value(
					value: mockCounterCubit,
					child: MaterialApp(
						home: HomeScreen(),
					),
				),
			);

			await tester.tap(find.byType(InkWell)); // Assuming the increment button is wrapped in InkWell
			await tester.pumpAndSettle();

			expect(find.text('10'), findsOneWidget);
		});
	});
}
