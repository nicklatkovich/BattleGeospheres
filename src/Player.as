package {
import alternativa.engine3d.core.Object3D;

import flash.ui.Keyboard;

public class Player extends Sphere {

    public var hSpeed:Number = 0;
    public var vSpeed:Number = 0;
    public var acc:Number = 0.2;
    public var maxSpeed:Number = 4;
    /*
    (maxSpeed + acc) * fric = maxSpeed
     */
    public var fric:Number = maxSpeed / (maxSpeed + acc);

    public function Player(mesh:Object3D) {
        super(mesh, 0, 0);
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
        var ddx:Number = Math.cos(Main.cameraDirection) * dx - Math.sin(Main.cameraDirection) * dy;
        var ddy:Number = Math.sin(Main.cameraDirection) * dx + Math.cos(Main.cameraDirection) * dy;
        var direction:Number = Math.atan2(ddy, ddx);
        var m:Number = Math.min(1, Math.abs(Math.pow(ddy, 2) + Math.pow(ddx, 2)));
        hSpeed += m * acc * Math.cos(direction);
        vSpeed -= m * acc * Math.sin(direction);
        hSpeed *= fric;
        vSpeed *= fric;
        x += hSpeed;
        y += vSpeed;
        super.onStep();
    }
}
}
