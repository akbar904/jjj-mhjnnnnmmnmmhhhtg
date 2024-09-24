
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:counter_app/cubits/counter_cubit.dart';
import 'package:counter_app/models/counter_state.dart';

class MockCounterCubit extends MockCubit<CounterState> implements CounterCubit {}

void main() {
	group('CounterCubit', () {
		late CounterCubit counterCubit;

		setUp(() {
			counterCubit = CounterCubit();
		});

		tearDown(() {
			counterCubit.close();
		});

		test('initial state is CounterState with value 1', () {
			expect(counterCubit.state, CounterState(1));
		});

		blocTest<CounterCubit, CounterState>(
			'emits [CounterState(10)] when increment is called once',
			build: () => counterCubit,
			act: (cubit) => cubit.increment(),
			expect: () => [CounterState(10)],
		);

		blocTest<CounterCubit, CounterState>(
			'emits [CounterState(10), CounterState(100)] when increment is called twice',
			build: () => counterCubit,
			act: (cubit) {
				cubit.increment();
				cubit.increment();
			},
			expect: () => [CounterState(10), CounterState(100)],
		);
	});
}
