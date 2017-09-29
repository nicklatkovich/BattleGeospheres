package {
import alternativa.engine3d.core.Object3D;

import flash.geom.Matrix3D;
import flash.geom.Vector3D;

public class Sphere extends Instance {

    function Sphere(obj:Object3D = null, x:Number = 0, y:Number = 0, z:Number = 0) {
        super(obj, x, y, z);
    }

    public override function onStep():void {
        if (x != xPrevious || y != yPrevious) {
            rotationMatrix.appendRotation(Math.sqrt(Math.pow(x - xPrevious, 2) + Math.pow(y - yPrevious, 2)),
                    new Vector3D(yPrevious - y, x - xPrevious, 0));
        }
        super.onStep();
    }
}
}
