import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'show_item_bloc.freezed.dart';
part 'show_item_event.dart';
part 'show_item_state.dart';

class ShowItemBloc extends Bloc<ShowItemEvent, ShowItemState> {
  ShowItemBloc() : super(const ShowItemState.show(isGrid: true)) {
    on<_Option>((event, emit) {
      emit(ShowItemState.show(isGrid: state.isGrid ? false : true));
    });
  }
}
