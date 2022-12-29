import 'package:flutter_bloc/flutter_bloc.dart';

enum FilterPageState {
  none,
  lastDay,
  moreThan20,
  lastAdded,
}

class FilterPageBloc extends Cubit<FilterPageState> {
  FilterPageBloc() : super(FilterPageState.none);

  void changeFilter(FilterPageState event) => emit(event);
}
