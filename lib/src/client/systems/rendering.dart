part of client;


class RenderingSystem extends EntityProcessingSystem {
  ComponentMapper<Transform> tm;
  ComponentMapper<Renderable> rm;
  CanvasRenderingContext2D ctx;
  SpriteSheet sheet;
  RenderingSystem(this.ctx, this.sheet) : super(Aspect.getAspectForAllOf([Transform, Renderable]));

  @override
  void processEntity(Entity entity) {
    var t = tm.get(entity);
    var r = rm.get(entity);

    var sprite = sheet.sprites[r.sprite];
    ctx.drawImageToRect(sheet.image, new Rectangle(sprite.dst.left + t.pos.x, sprite.dst.top + t.pos.y, sprite.dst.width, sprite.dst.height), sourceRect: sprite.src);
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

class InputRenderingSystem extends EntityProcessingSystem {
  ComponentMapper<AngleInput> am;
  ComponentMapper<VelocityInput> vm;
  ComponentMapper<Player> pm;
  CanvasRenderingContext2D ctx;
  InputRenderingSystem(this.ctx) : super(Aspect.getAspectForAllOf([Player, AngleInput, VelocityInput]));


  @override
  void processEntity(Entity entity) {
    var p = pm.get(entity);
    var v = vm.get(entity);
    var a = am.get(entity);

    var value = a.angle == null ? '' : a.angle;
    ctx.fillStyle = 'black';
    ctx.fillText('Angle', p.id == 0 ? 10 : 710, 20);
    ctx.fillText(': $value', p.id == 0 ? 60 : 760, 20);
    if (a.done) {
      value = v.velocity == null ? '' : v.velocity;
      ctx.fillText('Velocity', p.id == 0 ? 10 : 710, 35);
      ctx.fillText(': $value', p.id == 0 ? 60 : 760, 35);
    }
  }
}