
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:com.example.counter_app/main.dart';

class MockCounterCubit extends MockCubit<int> implements CounterCubit {}

void main() {
	group('MyApp Initialization', () {
		testWidgets('should render MyApp with HomeScreen', (tester) async {
			await tester.pumpWidget(MyApp());
			
			expect(find.byType(HomeScreen), findsOneWidget);
		});
	});
	
	group('CounterCubit', () {
		late CounterCubit counterCubit;
		
		setUp(() {
			counterCubit = MockCounterCubit();
		});
		
		blocTest<CounterCubit, int>(
			'emits [0] when initialized',
			build: () => counterCubit,
			expect: () => [0],
		);
		
		blocTest<CounterCubit, int>(
			'emits [0, 10] when increment is called',
			build: () => counterCubit,
			act: (cubit) => cubit.increment(),
			expect: () => [0, 10],
		);
	});
	
	group('HomeScreen Widgets', () {
		testWidgets('should find CounterDisplay and IncrementButton', (tester) async {
			await tester.pumpWidget(MyApp());
			
			expect(find.byType(CounterDisplay), findsOneWidget);
			expect(find.byType(IncrementButton), findsOneWidget);
		});
	});
	
	group('CounterDisplay', () {
		testWidgets('should display initial counter value', (tester) async {
			final counterCubit = MockCounterCubit();
			when(() => counterCubit.state).thenReturn(0);
			
			await tester.pumpWidget(
				BlocProvider<CounterCubit>(
					create: (_) => counterCubit,
					child: MaterialApp(home: CounterDisplay()),
				),
			);
			
			expect(find.text('0'), findsOneWidget);
		});
		
		testWidgets('should update counter value when state changes', (tester) async {
			final counterCubit = MockCounterCubit();
			whenListen(counterCubit, Stream.fromIterable([0, 10]));
			
			await tester.pumpWidget(
				BlocProvider<CounterCubit>(
					create: (_) => counterCubit,
					child: MaterialApp(home: CounterDisplay()),
				),
			);
			
			await tester.pumpAndSettle();
			
			expect(find.text('10'), findsOneWidget);
		});
	});
	
	group('IncrementButton', () {
		testWidgets('should call increment on CounterCubit when pressed', (tester) async {
			final counterCubit = MockCounterCubit();
			
			await tester.pumpWidget(
				BlocProvider<CounterCubit>(
					create: (_) => counterCubit,
					child: MaterialApp(home: IncrementButton()),
				),
			);
			
			await tester.tap(find.byType(IncrementButton));
			verify(() => counterCubit.increment()).called(1);
		});
	});
}
