import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';

import '../../game.dart';
import '../../level.dart';

import '../../riverpod_controllers/user_controller.dart';
import '../dialog_button.dart';
import '../../utils/my_text_style.dart';

class UpgradeTrucksContent extends Component with HasGameReference<MGame>, RiverpodComponentMixin {
  final Vector2 boxSize;
  UpgradeTrucksContent({required this.boxSize});

  late final DialogButton upgradeNaturalGasTruck;
  late final DialogButton upgradeElectricTruck;

  bool isFetchingData = false;

  @override
  FutureOr<void> onLoad() {
    super.onLoad();
    add(TextComponent(
      text: "UPGRADE TRUCKS",
      textRenderer: MyTextStyle.title,
      anchor: Anchor.topCenter,
      position: Vector2(0, -boxSize.y / 2 + 20),
    ));

    add(TextComponent(
      text: 'Natural Gas truck   2 EcoCredits\nAbility to purchase Natural Gas truck ',
      textRenderer: MyTextStyle.text,
      anchor: Anchor.centerLeft,
      position: Vector2(-boxSize.x / 2 + 50, -boxSize.y / 2 + 180),
    ));

    add(upgradeNaturalGasTruck = DialogButton(
      text: 'Buy upgrade',
      onPressed: () async {
        if (!isFetchingData) {
          isFetchingData = true;
          String upgradeText = "";
          final doc = await FirebaseFirestore.instance.collection('users').doc(ref.read(userControllerProvider)!.email!).get();
          if (doc.data() != null && (doc.data()!['EcoCredits'] as int) >= 2) {
            upgradeText = 'Upgrade Bought';
            await FirebaseFirestore.instance.collection('users').doc(ref.read(userControllerProvider)!.email!).update({
              "EcoCredits": FieldValue.increment(-2),
            });
            (game.findByKeyName('level') as Level).isPurpleTruckAvailable = true;
          } else {
            upgradeText = 'Insufficient EcoCredits';
          }
          if (upgradeNaturalGasTruck.isMounted) {
            remove(upgradeNaturalGasTruck);
          }
          add(TextComponent(
            text: upgradeText,
            textRenderer: MyTextStyle.text,
            anchor: Anchor.center,
            position: Vector2(boxSize.x / 2 - 150, -boxSize.y / 2 + 180),
          ));
          isFetchingData = false;
        }
      },
      buttonSize: Vector2(200, 50),
      position: Vector2(boxSize.x / 2 - 150, -boxSize.y / 2 + 180),
    ));

    add(TextComponent(
      text: 'Electric truck   5 EcoCredits\nAbility to purchase Electric truck ',
      textRenderer: MyTextStyle.text,
      anchor: Anchor.centerLeft,
      position: Vector2(-boxSize.x / 2 + 50, -boxSize.y / 2 + 280),
    ));

    add(upgradeElectricTruck = DialogButton(
      text: 'Buy upgrade',
      onPressed: () async {
        if (!isFetchingData) {
          isFetchingData = true;
          String upgradeText = "";
          final doc = await FirebaseFirestore.instance.collection('users').doc(ref.read(userControllerProvider)!.email!).get();
          if (doc.data() != null && (doc.data()!['EcoCredits'] as int) >= 2) {
            upgradeText = 'Upgrade Bought';
            await FirebaseFirestore.instance.collection('users').doc(ref.read(userControllerProvider)!.email!).update({
              "EcoCredits": FieldValue.increment(-5),
            });
            (game.findByKeyName('level') as Level).isBlueTruckAvailable = true;
          } else {
            upgradeText = 'Insufficient EcoCredits';
          }
          if (upgradeElectricTruck.isMounted) {
            remove(upgradeElectricTruck);
          }
          add(TextComponent(
            text: upgradeText,
            textRenderer: MyTextStyle.text,
            anchor: Anchor.center,
            position: Vector2(boxSize.x / 2 - 150, -boxSize.y / 2 + 280),
          ));
          isFetchingData = false;
        }
      },
      buttonSize: Vector2(200, 50),
      position: Vector2(boxSize.x / 2 - 150, -boxSize.y / 2 + 280),
    ));
  }
}
