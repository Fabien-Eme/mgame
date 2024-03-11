import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:mgame/flame_game/menu/add_to_google_wallet.dart';
import 'package:mgame/flame_game/menu/forward_backward_button.dart';
import 'package:mgame/flame_game/menu/menu_without_tabs.dart';
import 'package:mgame/flame_game/riverpod_controllers/user_controller.dart';

import '../../gen/assets.gen.dart';
import '../utils/my_text_style.dart';

class MenuAchievement extends MenuWithoutTabs with RiverpodComponentMixin {
  MenuAchievement() : super(boxSize: Vector2(800, 600));

  late final AddToGoogleWallet addToGoogleWallet;
  late final SpriteComponent achievementSpriteComponent;

  late final TextComponent loading;

  late final TextComponent achievementTitle;
  late final TextComponent achievementReward;
  late final TextComponent achievementInfo;
  List<String> listAchievements = [];
  int currentAchievementIndex = 0;

  @override
  void onLoad() {
    super.onLoad();

    final title = TextComponent(
      text: "ACHIEVEMENTS",
      textRenderer: MyTextStyle.title,
      anchor: Anchor.topCenter,
      position: Vector2(0, -boxSize.y / 2 + 20),
    );
    world.add(title);

    loading = TextComponent(
      text: "Loading",
      textRenderer: MyTextStyle.bigText,
      anchor: Anchor.centerLeft,
      position: Vector2(-80, 20),
    );
    world.add(loading);
  }

  @override
  void onMount() {
    getAchievement();

    super.onMount();
  }

  void getAchievement() async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(ref.read(userControllerProvider)!.email!).get();

    for (final achievement in doc.data()!['achievements'] as Iterable) {
      listAchievements.add(achievement as String);
    }
    displayAchievements();

    world.remove(loading);
  }

  void displayAchievements() {
    if (listAchievements.isEmpty) {
      world.add(TextComponent(
        text: "You have no achievements yet.",
        textRenderer: MyTextStyle.bigText,
        anchor: Anchor.center,
        position: Vector2(0, 20),
      ));
    } else {
      String currentAchievement = listAchievements[currentAchievementIndex];
      world.add(achievementTitle = TextComponent(
        text: mapAchievements[currentAchievement]!['title']!,
        textRenderer: MyTextStyle.bigText,
        anchor: Anchor.center,
        position: Vector2(0, -100),
      ));
      world.add(achievementReward = TextComponent(
        text: 'This achievement awarded you 5 EcoCredits.',
        textRenderer: MyTextStyle.dialogText,
        anchor: Anchor.center,
        position: Vector2(0, 100),
      ));
      world.add(achievementInfo = TextComponent(
        text:
            'Adding this to your Google Wallet will let you show your friends your achievement.\nYou will also be able to see how many citizen have earned this achievement and\nyou will see global air pollution updated daily !',
        textRenderer: MyTextStyle.smallText,
        anchor: Anchor.center,
        position: Vector2(0, 245),
      ));
      world.add(
        achievementSpriteComponent = SpriteComponent(
          sprite: Sprite(game.images.fromCache(
            mapAchievements[currentAchievement]!['assetPath']!,
          )),
          anchor: Anchor.center,
        ),
      );

      world.add(ForwardBackwardButton(
        isForward: true,
        onPressed: () => updateAchievementIndex(currentAchievementIndex + 1),
        position: Vector2(200, 0),
      ));

      world.add(ForwardBackwardButton(
        isForward: false,
        onPressed: () => updateAchievementIndex(currentAchievementIndex - 1),
        position: Vector2(-200, 0),
      ));

      addToGoogleWallet = AddToGoogleWallet(
        achievementName: currentAchievement,
        userMail: ref.read(userControllerProvider)!.email!,
        position: Vector2(0, 175),
      );
      world.add(addToGoogleWallet);
    }
  }

  void updateAchievementIndex(int index) {
    currentAchievementIndex = index;

    if (currentAchievementIndex == listAchievements.length) currentAchievementIndex = 0;
    if (currentAchievementIndex < 0) currentAchievementIndex = listAchievements.length - 1;

    String currentAchievement = listAchievements[currentAchievementIndex];
    achievementTitle.text = mapAchievements[currentAchievement]!['title']!;
    achievementSpriteComponent.sprite = Sprite(game.images.fromCache(
      mapAchievements[currentAchievement]!['assetPath']!,
    ));
    addToGoogleWallet.achievementName = currentAchievement;
  }

  double timeElapsed = 0.0;

  @override
  void update(double dt) {
    if (loading.isMounted) {
      timeElapsed += dt;
      if (timeElapsed >= 0.3) {
        timeElapsed = 0.0;
        if (loading.text == "Loading") {
          loading.text = "Loading.";
        } else if (loading.text == "Loading.") {
          loading.text = "Loading..";
        } else if (loading.text == "Loading..") {
          loading.text = "Loading...";
        } else if (loading.text == "Loading...") {
          loading.text = "Loading";
        }
      }
    }
    super.update(dt);
  }
}

Map<String, Map<String, String>> mapAchievements = {
  'cityCleaner': {
    'title': 'City Cleaner',
    'assetPath': Assets.images.achievements.cityCleaner.path,
  },
  'garbageCollector': {
    'title': 'Garbage Collector',
    'assetPath': Assets.images.achievements.garbageCollector.path,
  },
};
