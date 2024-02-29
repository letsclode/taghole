import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'page_controller.g.dart';

@riverpod
class PageIndex extends _$PageIndex {
  @override
  int build() {
    return 0;
  }

  void setPage({required int newValue}) {
    state = newValue;
  }
}
