package {
import alternativa.engine3d.core.Object3D;

import flash.geom.Matrix;
import flash.geom.Matrix3D;

public class Instance {

    public var x:Number;
    public var y:Number;
    public var z:Number;
    public var xPrevious:Number;
    public var yPrevious:Number;
    public var zPrevious:Number;
    public var scale:Number = 1;
    public var obj:Object3D;
    public var rotationMatrix:Matrix3D = new Matrix3D();

    public function Instance(obj:Object3D = null, x:Number = 0, y:Number = 0, z:Number = 0) {
        this.obj = obj;
        this.xPrevious = this.x = x;
        this.yPrevious = this.y = y;
        this.zPrevious = this.z = z;
        rotationMatrix.identity();
    }

    public function onStep():void {
        var matrix:Matrix3D = new Matrix3D();
        matrix.identity();
        matrix.appendScale(scale, scale, scale);
        matrix.append(rotationMatrix);
        matrix.appendTranslation(x, y, z);
        obj.matrix = matrix;
        xPrevious = x;
        yPrevious = y;
        zPrevious = z;
    }
}
}
