part of client;


class RenderingSystem extends EntityProcessingSystem {
  Mapper<Transform> tm;
  Mapper<Renderable> rm;
  CanvasRenderingContext2D ctx;
  SpriteSheet sheet;
  RenderingSystem(this.ctx, this.sheet) : super(Aspect.getAspectForAllOf([Transform, Renderable]));

  @override
  void processEntity(Entity entity) {
    var t = tm[entity];
    var r = rm[entity];

    var sprite = sheet.sprites[r.sprite];
    ctx.drawImageToRect(sheet.image, new Rectangle(sprite.dst.left + t.pos.x, sprite.dst.top + t.pos.y, sprite.dst.width, sprite.dst.height), sourceRect: sprite.src);
  }
}

class BuildingRenderingSystem extends EntityProcessingSystem {
  Mapper<Transform> tm;
  Mapper<Building> bm;
  CanvasRenderingContext2D ctx;
  CanvasElement buffer;
  var inBuffer = false;

  BuildingRenderingSystem(this.ctx) : super(Aspect.getAspectForAllOf([Transform, Building])) {
    buffer = new CanvasElement(width: 800, height: 600);
  }

  @override
  void processEntity(Entity entity) {
    var t = tm[entity];
    var b = bm[entity];

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
  Mapper<AngleInput> am;
  Mapper<VelocityInput> vm;
  Mapper<Player> pm;
  CanvasRenderingContext2D ctx;
  InputRenderingSystem(this.ctx) : super(Aspect.getAspectForAllOf([Player, AngleInput, VelocityInput]));


  @override
  void processEntity(Entity entity) {
    var p = pm[entity];
    var v = vm[entity];
    var a = am[entity];

    var value = a.angle == null ? '' : a.angle;
    ctx.fillStyle = 'black';
    ctx.fillText('Angle', p.id == 0 ? 10 : 710, 20);
    ctx.fillText(': $value', p.id == 0 ? 60 : 760, 20);
    value = v.velocity == null ? '' : v.velocity;
    ctx.fillText('Velocity', p.id == 0 ? 10 : 710, 35);
    ctx.fillText(': $value', p.id == 0 ? 60 : 760, 35);
  }
}