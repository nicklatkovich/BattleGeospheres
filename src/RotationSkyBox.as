package {
import alternativa.engine3d.materials.Material;
import alternativa.engine3d.objects.SkyBox;

import avm2.intrinsics.memory.mfence;

import flash.geom.Matrix3D;
import flash.geom.Vector3D;

public class RotationSkyBox extends SkyBox {

    public var direction:Number = Number.random() * 360;
    public var pitch:Number = Number.random() * 360;

    public const MAX_DIRECTION_SPEED:Number = 3;
    public const MAX_PITCH_SPEED:Number = 3;

    public const DIRECTION_ACC:Number = 0.01;
    public const PITCH_ACC:Number = 0.01;

//    (m + a) * r = m
//    r = m / (m + a)
    public const DIRECTION_RESISTANCE:Number = MAX_DIRECTION_SPEED / (MAX_DIRECTION_SPEED + DIRECTION_ACC);
    public const PITCH_RESISTANCE:Number = MAX_PITCH_SPEED / (MAX_PITCH_SPEED + PITCH_ACC);

    public var directionSpeed:Number = Number.random() * 2 * MAX_DIRECTION_SPEED - MAX_DIRECTION_SPEED;
    public var pitchSpeed:Number = Number.random() * 2 * MAX_PITCH_SPEED - MAX_PITCH_SPEED;

    public function RotationSkyBox(size:Number,
                                   left:Material = null, right:Material = null, back:Material = null,
                                   front:Material = null, bottom:Material = null, top:Material = null,
                                   uvPadding:Number = 0) {
        super(size, left, right, back, front, bottom, top, uvPadding);
    }

    public function OnStep():void {
        var newMatrix:Matrix3D = new Matrix3D();
        newMatrix.identity();
        directionSpeed += Number.random() * 2 * DIRECTION_ACC - DIRECTION_ACC;
        directionSpeed *= DIRECTION_RESISTANCE;
        direction += directionSpeed;
        pitchSpeed += Number.random() * 2 * PITCH_ACC - PITCH_ACC;
        pitchSpeed *= PITCH_RESISTANCE;
        pitch += pitchSpeed;
        newMatrix.appendRotation(pitch, Vector3D.X_AXIS);
        newMatrix.appendRotation(direction, Vector3D.Z_AXIS);
        var player:Player = Main.lastInstance.player;
        newMatrix.appendTranslation(player.x, player.y, player.z);
        matrix = newMatrix;
    }
}
}
