part of 'show_item_bloc.dart';

@freezed
class ShowItemEvent with _$ShowItemEvent {
  const factory ShowItemEvent.option(bool isGrid) = _Option;
}