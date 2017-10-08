package {
import alternativa.engine3d.core.Object3D;

import flash.geom.Matrix3D;
import flash.geom.Vector3D;

import flash.ui.Keyboard;

public class Player extends Sphere {

    public var forceFieldDirection:Number = Number.random() * 360;
    public var forceFieldPitch:Number = Number.random() * 360;

    public const FORCE_FIELD_MAX_DIRECTION_SPEED:Number = 9;
    public const FORCE_FIELD_MAX_PITCH_SPEED:Number = 9;

    public const FORCE_FIELD_DIRECTION_ACC:Number = 0.03;
    public const FORCE_FIELD_PITCH_ACC:Number = 0.03;

    public const FORCE_FIELD_DIRECTION_RESISTANCE:Number =
            FORCE_FIELD_MAX_DIRECTION_SPEED / (FORCE_FIELD_MAX_DIRECTION_SPEED + FORCE_FIELD_DIRECTION_ACC);
    public const FORCE_FIELD_PITCH_RESISTANCE:Number =
            FORCE_FIELD_MAX_PITCH_SPEED / (FORCE_FIELD_MAX_PITCH_SPEED + FORCE_FIELD_PITCH_ACC);

    public var forceFieldDirectionSpeed:Number =
            Number.random() * 2 * FORCE_FIELD_MAX_DIRECTION_SPEED - FORCE_FIELD_MAX_DIRECTION_SPEED;
    public var forceFieldPitchSpeed:Number =
            Number.random() * 2 * FORCE_FIELD_MAX_PITCH_SPEED - FORCE_FIELD_MAX_PITCH_SPEED;

    public var forceFieldAlpha:Number = 0.0;

    public var base:Object3D;
    public var forgeField:Object3D;
    public const GUN_SPEED:Number = Math.PI / 192;
    public const SHOOT_STEP_INTERVAL:uint = 30;

    public var gunDirection:Number = 0;
    public var hSpeed:Number = 0;
    public var vSpeed:Number = 0;
    public var acc:Number = 0.2;
    public var maxSpeed:Number = 4;
    public var shootState:uint = 0;
    public var bullets:Vector.<Bullet> = new Vector.<Bullet>();
    /*
     (maxSpeed + acc) * fric = maxSpeed
     */
    public var fric:Number = maxSpeed / (maxSpeed + acc);

    public function Player(meshWheel:Object3D, meshBase:Object3D, meshForgeField:Object3D) {
        super(meshWheel, 0, 0, 32);
        base = meshBase;
        forgeField = meshForgeField;
//        forgeField
    }

    public function shoot():void {
        var bulletMesh:Object3D = obj.clone();
        Main.lastInstance.addInRootContainer(bulletMesh);
        bullets.push(new Bullet(bulletMesh, x, y, z, gunDirection, maxSpeed * 2));
    }

    public override function onStep():void {
        var dx:Number = 0;
        var dy:Number = 0;
        if (InputManager.isButtonPressed(Keyboard.W)) {
            dy -= 2;
        }
        if (InputManager.isButtonPressed(Keyboard.S)) {
            dy += 2;
        }
        if (InputManager.isButtonPressed(Keyboard.A)) {
            dx -= 2;
        }
        if (InputManager.isButtonPressed(Keyboard.D)) {
            dx += 2;
        }
        if (shootState > 0) {
            shootState--;
        }
        if (InputManager.isButtonPressed(Keyboard.SPACE)) {
            if (shootState == 0) {
                shootState = SHOOT_STEP_INTERVAL;
                shoot();
            }
        }
        for (var i:uint = 0; i < bullets.length; i++) {
            bullets[i].onStep();
//            if (bullets[i].health == 0) {
            if (bullets[i].x + 32 * (1 - bullets[i].scale) < -Main.HALF_MAP_REAL_WIDTH ||
                    bullets[i].x - 32 * (1 - bullets[i].scale) > Main.HALF_MAP_REAL_WIDTH ||
                    bullets[i].y + 32 * (1 - bullets[i].scale) < -Main.HALF_MAP_REAL_HEIGHT ||
                    bullets[i].y - 32 * (1 - bullets[i].scale) > Main.HALF_MAP_REAL_HEIGHT) {
                Main.lastInstance.removeFromRootContainer(bullets[i].obj);
                bullets.removeAt(i);
                i--;
            }
        }

        var ddx:Number = Math.cos(Main.lastInstance.cameraDirection) * dx - Math.sin(Main.lastInstance.cameraDirection) * dy;
        var ddy:Number = Math.sin(Main.lastInstance.cameraDirection) * dx + Math.cos(Main.lastInstance.cameraDirection) * dy;
        var direction:Number = Math.atan2(ddy, ddx);
        var m:Number = Math.min(1, Math.abs(Math.pow(ddy, 2) + Math.pow(ddx, 2)));
        hSpeed += m * acc * Math.cos(direction);
        vSpeed -= m * acc * Math.sin(direction);
        hSpeed *= fric;
        vSpeed *= fric;
        x += hSpeed;
        y += vSpeed;
        if (forceFieldAlpha > 0.0) {
            forceFieldAlpha -= 0.01;
        }
        if (x > Main.HALF_MAP_REAL_WIDTH || x < -Main.HALF_MAP_REAL_WIDTH) {
            x = xPrevious;
            hSpeed *= -1;
            forceFieldAlpha = 1;
        }
        if (y > Main.HALF_MAP_REAL_HEIGHT || y < -Main.HALF_MAP_REAL_HEIGHT) {
            y = yPrevious;
            vSpeed *= -1;
            forceFieldAlpha = 1;
        }
        var gunDiff:Number = Main.angleDifference(Main.lastInstance.cameraDirection, gunDirection);
        if (Math.abs(gunDiff) <= GUN_SPEED) {
            gunDirection = Main.lastInstance.cameraDirection;
        } else {
            gunDirection -= GUN_SPEED * Main.sign(gunDiff);
        }
        var matrix:Matrix3D = new Matrix3D();
        matrix.identity();
        matrix.appendRotation(-gunDirection / Math.PI * 180, Vector3D.Z_AXIS);
        matrix.appendTranslation(x, y, 32);
        base.matrix = matrix;
        var forceFieldMatrix:Matrix3D = new Matrix3D();
        forceFieldMatrix.identity();
        forceFieldDirectionSpeed += Number.random() * 2 * FORCE_FIELD_DIRECTION_ACC - FORCE_FIELD_DIRECTION_ACC;
        forceFieldDirectionSpeed *= FORCE_FIELD_DIRECTION_RESISTANCE;
        forceFieldDirection += forceFieldDirectionSpeed;
        forceFieldPitchSpeed += Number.random() * 2 * FORCE_FIELD_PITCH_ACC - FORCE_FIELD_PITCH_ACC;
        forceFieldPitchSpeed *= FORCE_FIELD_PITCH_RESISTANCE;
        forceFieldPitch += forceFieldPitchSpeed;
        forceFieldMatrix.appendRotation(forceFieldPitch, Vector3D.X_AXIS);
        forceFieldMatrix.appendRotation(forceFieldDirection, Vector3D.Z_AXIS);
        forceFieldMatrix.appendTranslation(x, y, z);
        forgeField.matrix = forceFieldMatrix;
        ResourceManager.forgeFieldMaterial.alpha = forceFieldAlpha;
        super.onStep();
    }
}
}
