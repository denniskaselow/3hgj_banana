import 'package:threehgj_banana/client.dart';

@MirrorsUsed(targets: const [RenderingSystem, BuildingRenderingSystem,
                             InputListeningSystem, InputRenderingSystem,
                             PlayerActionSystem, MovementSystem, GravitySystem,
                             CollisionSystem
                            ])
import 'dart:mirrors';

void main() {
  new Game().start();
}

class Game extends GameBase {

  Game() : super('threehgj_banana', 'canvas', 800, 600, bodyDefsName: null);

  void createEntities() {
    var p1 = 1 + random.nextInt(3);
    var p2 = 5 + random.nextInt(3);
    for (int i = 0; i < 10; i++) {
      var height = 50 + random.nextInt(300);
      var hue = random.nextInt(255);
      addEntity([new Transform(40 + i * 80, 0), new Building(height, hue)]);
      if (i == p1) {
        addEntity([new Transform(40 + i * 80, 600 - height - 20), new Player(0), new AngleInput(), new VelocityInput(), new Renderable('player.png')]);
      } else if (i == p2) {
        addEntity([new Transform(40 + i * 80, 600 - height - 20), new Player(1), new Renderable('player.png')]);
      }
    }
  }

  Map<int, List<EntitySystem>> getSystems() {
    return {GameBase.rendering: [
            new MovementSystem(),
            new GravitySystem(),
            new CollisionSystem(),
            new InputListeningSystem(canvas),
            new CanvasCleaningSystem(canvas, fillStyle: '#00B0EC'),
            new BuildingRenderingSystem(ctx),
            new RenderingSystem(ctx, spriteSheet),
            new InputRenderingSystem(ctx),
            new PlayerActionSystem(),
    ]};
  }

  onInit() {
  }

  onInitDone() {
  }
}

