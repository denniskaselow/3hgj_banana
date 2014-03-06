part of client;

class InputListeningSystem extends EntityProcessingSystem {
  ComponentMapper<AngleInput> am;
  ComponentMapper<VelocityInput> vm;

  int keyCode;
  InputListeningSystem() : super(Aspect.getAspectForAllOf([AngleInput, VelocityInput]));

  @override
  void initialize() {
    window.onKeyDown.listen(handleKeyDown);
  }

  void handleKeyDown(KeyboardEvent event) {
    keyCode = event.keyCode;
  }

  @override
  void processEntity(Entity entity) {
    var a = am.get(entity);
    var v = vm.get(entity);
    if (keyCode == KeyCode.ENTER) {
      if (a.angle != null && !a.done) {
        a.done = true;
      } else if (a.done && v.velocity != null && !v.done) {
        v.done = true;
      }
    } else if (keyCode == KeyCode.BACKSPACE) {
      if (!a.done) {
        a.angle = a.angle == null ? null : a.angle < 10 ? null : a.angle ~/ 10;
      } else {
        v.velocity = v.velocity == null ? null : v.velocity < 10 ? null : v.velocity ~/ 10;
      }
    } else {
      int value;
      if (keyCode >= KeyCode.ZERO && keyCode <= KeyCode.NINE) {
        value = keyCode - KeyCode.ZERO;
      } else if (keyCode >= KeyCode.NUM_ZERO && keyCode <= KeyCode.NUM_NINE) {
        value = keyCode - KeyCode.NUM_ZERO;
      }
      if (!a.done) {
        a.angle = a.angle == null ? value : a.angle * 10 + value;
        a.angle = min(359, a.angle);
      } else if (a.done && !v.done) {
        v.velocity = v.velocity == null ? value : v.velocity * 10 + value;
        v.velocity = min(999, v.velocity);
      }
    }
  }

  @override
  void end() {
    keyCode = null;
  }

  bool checkProcessing() => keyCode != null;
}

