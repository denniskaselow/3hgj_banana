part of client;


class RenderingSystem extends EntityProcessingSystem {
  ComponentMapper<Transform> tm;
  CanvasRenderingContext2D ctx;

  RenderingSystem(this.ctx) : super(Aspect.getAspectForAllOf([Transform, Player]));

  @override
  void processEntity(Entity entity) {
    var t = tm.get(entity);
    ctx..fillStyle = 'black'
       ..fillRect(t.pos.x - 10, t.pos.y - 20, 20, 40);
  }
}

class BuildingRenderingSystem extends EntityProcessingSystem {
  ComponentMapper<Transform> tm;
  ComponentMapper<Building> bm;
  CanvasRenderingContext2D ctx;
  CanvasElement buffer;
  var inBuffer = false;

  BuildingRenderingSystem(this.ctx) : super(Aspect.getAspectForAllOf([Transform, Building])) {
    buffer = new CanvasElement(width: 800, height: 600);
  }

  @override
  void processEntity(Entity entity) {
    var t = tm.get(entity);
    var b = bm.get(entity);

    if (!inBuffer) {
      var bufferCtx = buffer.context2D;
      bufferCtx..setFillColorHsl(b.hue, 25, 45)
               ..strokeStyle = 'black'
               ..strokeRect(t.pos.x - 40, 600 - b.height, 80, b.height)
               ..fillRect(t.pos.x - 40, 600 - b.height, 80, b.height);

      for (int y = 0; y < b.height ~/ 20 + 1; y++) {
        for (int x = 0; x < 5; x++) {
          var fillStyle = random.nextInt(10) < 8 ? '#AAA' : 'yellow';
          bufferCtx..fillStyle = fillStyle
                   ..fillRect(t.pos.x - 30 + x * 13, 600 - b.height + 10 + y * 20, 8, 15);
        }
      }
    }
    ctx.drawImage(buffer, 0, 0);
  }

  @override
  void end() {
    inBuffer = true;
  }
}