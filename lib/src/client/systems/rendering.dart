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

  BuildingRenderingSystem(this.ctx) : super(Aspect.getAspectForAllOf([Transform, Building]));

  @override
  void processEntity(Entity entity) {
    var t = tm.get(entity);
    var b = bm.get(entity);

    ctx..setFillColorHsl(b.hue, 25, 45)
       ..fillRect(t.pos.x - 40, 600 - b.height, 80, b.height);
  }
}