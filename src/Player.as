package {
import alternativa.engine3d.core.Object3D;

import flash.geom.Matrix3D;
import flash.geom.Vector3D;

import flash.ui.Keyboard;

public class Player extends Sphere {

    public var base:Object3D;
    public var forgeField:Object3D;
    public const GUN_SPEED:Number = Math.PI / 192;

    public var gunDirection:Number = 0;
    public var hSpeed:Number = 0;
    public var vSpeed:Number = 0;
    public var acc:Number = 0.2;
    public var maxSpeed:Number = 4;
    /*
    (maxSpeed + acc) * fric = maxSpeed
     */
    public var fric:Number = maxSpeed / (maxSpeed + acc);

    public function Player(meshWheel:Object3D, meshBase:Object3D, meshForgeField:Object3D) {
        super(meshWheel, 0, 0);
        base = meshBase;
        forgeField = meshForgeField;
//        forgeField
    }

    public override function onStep():void {
        var dx:Number = 0;
        var dy:Number = 0;
        if (Main.keyboard[Keyboard.W]) {
            dy -= 2;
        }
        if (Main.keyboard[Keyboard.S]) {
            dy += 2;
        }
        if (Main.keyboard[Keyboard.A]) {
            dx -= 2;
        }
        if (Main.keyboard[Keyboard.D]) {
            dx += 2;
        }
        var ddx:Number = Math.cos(Main.instance.cameraDirection) * dx - Math.sin(Main.instance.cameraDirection) * dy;
        var ddy:Number = Math.sin(Main.instance.cameraDirection) * dx + Math.cos(Main.instance.cameraDirection) * dy;
        var direction:Number = Math.atan2(ddy, ddx);
        var m:Number = Math.min(1, Math.abs(Math.pow(ddy, 2) + Math.pow(ddx, 2)));
        hSpeed += m * acc * Math.cos(direction);
        vSpeed -= m * acc * Math.sin(direction);
        hSpeed *= fric;
        vSpeed *= fric;
        x += hSpeed;
        y += vSpeed;
        if (x > Main.HALF_MAP_REAL_WIDTH || x < -Main.HALF_MAP_REAL_WIDTH) {
            x = xPrevious;
            hSpeed *= -1;
        }
        if (y > Main.HALF_MAP_REAL_HEIGHT || y < -Main.HALF_MAP_REAL_HEIGHT) {
            y = yPrevious;
            vSpeed *= -1;
        }
        var gunDiff:Number = Main.angleDifference(Main.instance.cameraDirection, gunDirection);
        if (Math.abs(gunDiff) <= GUN_SPEED) {
            gunDirection = Main.instance.cameraDirection;
        } else {
            gunDirection -= GUN_SPEED * Main.sign(gunDiff);
        }
        var matrix:Matrix3D = new Matrix3D();
        matrix.identity();
        matrix.appendRotation(-gunDirection / Math.PI * 180, Vector3D.Z_AXIS);
        matrix.appendTranslation(x, y, 32);
        base.matrix = matrix;
        forgeField.matrix = matrix;
        super.onStep();
    }
}
}
