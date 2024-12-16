import 'dart:math' as math;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vector_math/vector_math.dart';

part 'package:island_gen_flutter/generated/features/camera/camera_state_provider.freezed.dart';
part 'package:island_gen_flutter/generated/features/camera/camera_state_provider.g.dart';

@freezed
class CameraState with _$CameraState {
  const CameraState._();

  factory CameraState({
    Vector3? target,
    double? distance,
    double? theta,
    double? phi,
    double? fov,
  }) = _CameraState;

  factory CameraState.initial() => CameraState(
        target: Vector3.zero(),
        distance: 10.0,
        theta: 0.0,
        phi: math.pi / 4,
        fov: 45.0,
      );

  Matrix4 getViewMatrix() {
    // Convert spherical to Cartesian coordinates
    double x = distance! * math.sin(phi!) * math.cos(theta!);
    double y = distance! * math.cos(phi!);
    double z = distance! * math.sin(phi!) * math.sin(theta!);

    Vector3 eye = target! + Vector3(x, y, z);
    return makeViewMatrix(eye, target!, Vector3(0, 1, 0));
  }

  Matrix4 getProjectionMatrix(double aspect) {
    return makePerspectiveMatrix(
      fov! * (math.pi / 180.0), // Convert FOV to radians
      aspect,
      0.1,
      100.0,
    );
  }

  Vector3 getCameraPosition() {
    double x = distance! * math.sin(phi!) * math.cos(theta!);
    double y = distance! * math.cos(phi!);
    double z = distance! * math.sin(phi!) * math.sin(theta!);
    return target! + Vector3(x, y, z);
  }
}

@Riverpod(keepAlive: true)
class CameraController extends _$CameraController {
  // Camera constraints
  static const double minDistance = 2.0;
  static const double maxDistance = 50.0;
  static const double minPhi = 0.1;
  static const double maxPhi = math.pi / 2 - 0.1;

  @override
  CameraState build() => CameraState.initial();

  void orbit(double deltaX, double deltaY) {
    state = state.copyWith(
      theta: state.theta! + deltaX,
      phi: (state.phi! + deltaY).clamp(minPhi, maxPhi),
    );
  }

  void zoom(double factor) {
    state = state.copyWith(
      distance: (state.distance! * factor).clamp(minDistance, maxDistance),
    );
  }

  void setTarget(Vector3 target) {
    state = state.copyWith(target: target);
  }

  void setFov(double fov) {
    state = state.copyWith(fov: fov.clamp(30.0, 90.0));
  }
}
