
import 'package:bloc/bloc.dart';
import 'package:counter_app/models/counter_state.dart';

class CounterCubit extends Cubit<CounterState> {
	CounterCubit() : super(CounterState(1));

	void increment() {
		emit(CounterState(state.value * 10));
	}
}
