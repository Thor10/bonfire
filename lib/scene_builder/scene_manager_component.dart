import 'package:bonfire/bonfire.dart';

///
/// Created by
///
/// ─▄▀─▄▀
/// ──▀──▀
/// █▀▀▀▀▀█▄
/// █░░░░░█─█
/// ▀▄▄▄▄▄▀▀
///
/// Rafaelbarbosatec
/// on 04/03/22

class SceneBuilderStatus {
  final bool isRunning;
  final SceneAction? currentAction;

  SceneBuilderStatus({this.isRunning = false, this.currentAction});

  SceneBuilderStatus copyWith({
    bool? isRunning,
    SceneAction? currentAction,
  }) {
    if (isRunning == this.isRunning && currentAction == this.currentAction) {
      return this;
    }
    return SceneBuilderStatus(
      isRunning: isRunning ?? this.isRunning,
      currentAction: currentAction ?? this.currentAction,
    );
  }
}

class SceneBuilderComponent extends Component with BonfireHasGameRef {
  final List<SceneAction> actions;
  int _indexCurrent = 0;

  SceneBuilderComponent(this.actions);

  @override
  void update(double dt) {
    final currentAction = actions[_indexCurrent];

    if (currentAction.runAction(dt, gameRef)) {
      if (_indexCurrent < actions.length - 1) {
        _indexCurrent++;
        _modifyStatus(currentAction: actions[_indexCurrent]);
      } else {
        removeFromParent();
      }
    }
    super.update(dt);
  }

  @override
  void onMount() {
    _modifyStatus(isRunning: true, currentAction: actions[_indexCurrent]);
    super.onMount();
  }

  void _modifyStatus({
    bool? isRunning,
    SceneAction? currentAction,
  }) {
    gameRef.sceneBuilderStatus = gameRef.sceneBuilderStatus.copyWith(
      isRunning: isRunning,
      currentAction: currentAction,
    );
  }

  @override
  void onRemove() {
    gameRef.sceneBuilderStatus = SceneBuilderStatus();
    super.onRemove();
  }
}
