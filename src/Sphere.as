package {
import alternativa.engine3d.core.Object3D;

import flash.geom.Matrix3D;
import flash.geom.Vector3D;

public class Sphere extends Instance {

    private var translationMatrix:Matrix3D = new Matrix3D();
    private var rotationMatrix:Matrix3D = new Matrix3D();

    function Sphere(obj:Object3D = null, x:Number = 0, y:Number = 0) {
        super(obj, x, y);
        translationMatrix.identity();
        rotationMatrix.identity();
    }

    public override function onStep():void {
        translationMatrix.identity();
        translationMatrix.appendTranslation(x, y, 32);
        if (x != xPrevious || y != yPrevious) {
            rotationMatrix.appendRotation(Math.sqrt(Math.pow(x - xPrevious, 2) + Math.pow(y - yPrevious, 2)),
                    new Vector3D(yPrevious - y, x - xPrevious, 0));
        }
        var matrix:Matrix3D = rotationMatrix.clone();
        matrix.append(translationMatrix);
        obj.matrix = matrix;
        super.onStep();
    }
}
}
