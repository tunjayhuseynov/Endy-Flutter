import 'package:endy/streams/products.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailPageState {
  int? current;

  DetailPageState({this.current = 0});

  DetailPageState copyWith({int? current}) {
    return DetailPageState(current: current ?? this.current);
  }
}

class DetailPageBloc extends Cubit<DetailPageState> {
  DetailPageBloc() : super(DetailPageState());

  void increaseSeenTime(String id) {
    ProductsCrud.increaseSeenTimes(id);
  }

  void changeCurrent(int current) {
    emit(state.copyWith(current: current));
  }
}
