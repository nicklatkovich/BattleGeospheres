package {
import alternativa.engine3d.core.Object3D;

import flash.events.Event;
import flash.geom.Vector3D;

public class Bullet extends Instance {

    public var hSpeed:Number;
    public var vSpeed:Number;
//    public var health:uint;

    public function Bullet(mesh:Object3D, x:Number, y:Number, z:Number, direction:Number, speed:Number,
                           gunLength:Number = 32) {
        var hSpeedIdentity:Number = Math.sin(direction);
        var vSpeedIdentity:Number = Math.cos(direction);
        super(mesh, x + hSpeedIdentity * gunLength, y + vSpeedIdentity * gunLength, z);
        hSpeed = hSpeedIdentity * speed;
        vSpeed = vSpeedIdentity * speed;
//        health = liveSteps;
        scale = 0.3;
    }

    public function get moveDirection():Vector3D {
        return new Vector3D(hSpeed, vSpeed);
    }


    public override function onStep():void {
        x += hSpeed;
        y += vSpeed;
//        if (health > 0) {
//            health--;
//        }
        super.onStep();
    }
}
}
