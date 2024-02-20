import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mgame/flame_game/ui/overlay/overlay_dialog.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'overlay_controller.g.dart';
part 'overlay_controller.freezed.dart';

@Riverpod(keepAlive: true)
class OverlayController extends _$OverlayController {
  @override
  OverlayState build() {
    return OverlayState(isVisible: false);
  }

  void overlayOpen({required OverlayDialogType overlayDialogType}) {
    if (!state.isVisible) {
      state = OverlayState(isVisible: true, overlayDialogType: overlayDialogType);
    }
  }

  void overlayClose() {
    if (state.isVisible) {
      state = OverlayState(isVisible: false);
    }
  }
}

@freezed
class OverlayState with _$OverlayState {
  factory OverlayState({
    required bool isVisible,
    OverlayDialogType? overlayDialogType,
  }) = _OverlayState;
}
