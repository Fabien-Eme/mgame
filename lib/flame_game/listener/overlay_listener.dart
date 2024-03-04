import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:mgame/flame_game/level_world.dart';
import 'package:mgame/flame_game/riverpod_controllers/overlay_controller.dart';
import 'package:mgame/flame_game/ui/overlay/overlay_dialog.dart';

import '../game.dart';

class OverlayListener extends Component with HasGameRef<MGame>, HasWorldReference<LevelWorld>, RiverpodComponentMixin {
  @override
  void onMount() {
    addToGameWidgetBuild(() => ref.listen(overlayControllerProvider, (previous, overlayState) {
          _handleNewState(overlayState);
        }));
    super.onMount();
  }

  void _handleNewState(OverlayState overlayState) {
    if (overlayState.isVisible) {
      if (game.overlayDialog == null) {
        game.overlayDialog = OverlayDialog(overlayDialogType: overlayState.overlayDialogType!);
        game.camera.viewport.add(game.overlayDialog!);
      }
    } else {
      if (game.overlayDialog != null) {
        game.camera.viewport.remove(game.overlayDialog!);
        game.overlayDialog = null;
        game.myMouseCursor.resetMouseCursor();
      }
    }
  }
}
