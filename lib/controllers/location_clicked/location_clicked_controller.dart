import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'location_clicked_controller.g.dart';

@riverpod
class LocationClicked extends _$LocationClicked {
  @override
  List<double> build() {
    return [];
  }

  void setLocationClicked({required List<double> newValue}) {
    state = newValue;
    print("NEW STATE IS $state");
  }
}
