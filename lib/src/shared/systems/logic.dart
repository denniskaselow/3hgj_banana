part of shared;


class PlayerActionSystem extends EntityProcessingSystem {
  Mapper<AngleInput> am;
  Mapper<VelocityInput> vm;
  Mapper<Player> pm;
  Mapper<Transform> tm;

  PlayerActionSystem() : super(Aspect.getAspectForAllOf([Player, AngleInput, VelocityInput, Transform]));


  @override
  void processEntity(Entity entity) {
    var a = am[entity];
    var v = vm[entity];
    if (a.done && v.done) {
      var p = pm[entity];
      var t = tm[entity];
      world.createAndAddEntity([new Transform(p.id == 0 ? t.pos.x - 15 : t.pos.x + 15, t.pos.y - 5),
                                new Player(p.id),
                                new Velocity(a.angle, v.velocity),
                                new Renderable('banana.png')]);
      a.done = false;
      a.angle = null;
      v.done = false;
      v.velocity = null;
    }
  }
}

class MovementSystem extends EntityProcessingSystem {
  Mapper<Transform> tm;
  Mapper<Velocity> vm;
  MovementSystem() : super(Aspect.getAspectForAllOf([Transform, Velocity]));

  @override
  void processEntity(Entity entity) {
    var v = vm[entity];
    var t = tm[entity];
    t.pos += v.velocity;
  }
}

class GravitySystem extends EntityProcessingSystem {
  Mapper<Velocity> vm;
  GravitySystem() : super(Aspect.getAspectForAllOf([Velocity]));

  @override
  void processEntity(Entity entity) {
    vm[entity].velocity.y += 0.1;
  }
}

class CollisionSystem extends EntitySystem {
  Mapper<Transform> tm;
  Mapper<Player> pm;

  CollisionSystem() : super(Aspect.getAspectForAllOf([Transform, Player]));

  @override
  void processEntities(Iterable<Entity> entitiesInBag) {
    var entities = new List<Entity>();
    entitiesInBag.forEach((entity) => entities.add(entity));

    for (int i = 0; i < entities.length - 1; i++) {
      var entity1 = entities[i];
      var t1 = tm[entity1];
      for (int j = i + 1; j < entities.length; j++) {
        var entity2 = entities[j];
        var t2 = tm[entity2];
        if (t2.pos.distanceToSquared(t1.pos) < 100) {
          entity1.deleteFromWorld();
          entity2.deleteFromWorld();
        }
      }
    }
  }

  @override
  bool checkProcessing() => true;
}