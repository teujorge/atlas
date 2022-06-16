import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:george/characters/george.dart';
import 'package:george/dialog/dialog_box.dart';
import '../main.dart';

class FriendsComponent extends PositionComponent
    with CollisionCallbacks, HasGameRef<GeorgeGame> {
  FriendsComponent() {
    // debugMode = true;
    add(RectangleHitbox());
  }
  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    if (other is GeorgeComponent) {
      // gameRef.showDialog  = "";
      if (gameRef.bakedGoodsInventory > 0) {
        gameRef.dialogMessage = "Wow. Thanks so much. Please come over"
            " this weekend for dinner. I have to run now."
            " See you on Saturday at 7pm";

        gameRef.friendNumber++;
        gameRef.bakedGoodsInventory--;
        gameRef.applause.start();
      } else {
        gameRef.dialogMessage =
            "Great to meet you. I have to run to a meeting.";
      }
      // gameRef.dialogBox = DialogBox(text: message, game: gameRef);
      // gameRef.add(gameRef.dialogBox);
      gameRef.showDialog = true;
      gameRef.remove(this); // remove bounding box
    }
  }
}
