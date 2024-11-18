part of 'show_item_bloc.dart';

@freezed
class ShowItemState with _$ShowItemState {
  const factory ShowItemState.show({@Default(true) bool isGrid}) = _Show;
}
