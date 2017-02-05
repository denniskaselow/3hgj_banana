part of client;

class InputListeningSystem extends EntityProcessingSystem {
  Mapper<AngleInput> am;
  Mapper<VelocityInput> vm;
  CanvasElement canvas;

  Point startPoint;
  Point endPoint;
  Point intermediatePoint;

  InputListeningSystem(this.canvas) : super(Aspect.getAspectForAllOf([AngleInput, VelocityInput]));

  @override
  void initialize() {
    canvas.onMouseDown.listen((event) {
      startPoint = event.offset;
      intermediatePoint = startPoint;
    });
    canvas.onMouseUp.listen((event) => endPoint = event.offset);
    canvas.onMouseMove.listen((event) {
      if (null == endPoint && null != startPoint) {
        intermediatePoint = event.offset;
      }
    });
  }

  @override
  void processEntity(Entity entity) {
    var a = am[entity];
    var v = vm[entity];
    Point diff;
    if (null != endPoint) {
      diff = endPoint - startPoint;
    } else {
      diff = intermediatePoint - startPoint;
    }

    v.velocity = diff.magnitude.toInt();
    a.angle = (180/PI * atan2(-diff.y, diff.x)).toInt();
    if (null != endPoint) {
      a.done = true;
      v.done = true;
    }
  }

  @override
  void end() {
    if (null != endPoint) {
      startPoint = null;
      endPoint = null;
      intermediatePoint = null;
    }
  }

  @override
  bool checkProcessing() => null != startPoint;
}

