import 'package:3hgj_banana/client.dart';

@MirrorsUsed(targets: const [RenderingSystem, BuildingRenderingSystem
                            ])
import 'dart:mirrors';

void main() {
  new Game().start();
}

class Game extends GameBase {

  Game() : super.noAssets('3hgj_banana', 'canvas', 800, 600);

  void createEntities() {
    var p1 = 1 + random.nextInt(3);
    var p2 = 5 + random.nextInt(3);
    for (int i = 0; i < 10; i++) {
      var height = 50 + random.nextInt(300);
      var hue = random.nextInt(255);
      addEntity([new Transform(40 + i * 80, 0), new Building(height, hue)]);
      if (i == p1) {
        addEntity([new Transform(40 + i * 80, 600 - height - 20), new Player(1)]);
      } else if (i == p2) {
        addEntity([new Transform(40 + i * 80, 600 - height - 20), new Player(2)]);
      }
    }
  }

  List<EntitySystem> getSystems() {
    return [
            new CanvasCleaningSystem(canvas, fillStyle: '#00B0EC'),
            new BuildingRenderingSystem(ctx),
            new RenderingSystem(ctx),
            new FpsRenderingSystem(ctx)
    ];
  }

  Future onInit() {
  }

  Future onInitDone() {
  }
}

