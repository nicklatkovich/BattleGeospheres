package {
import alternativa.engine3d.core.Object3D;

public class Instance {

    public var x:Number;
    public var y:Number;
    public var xPrevious:Number;
    public var yPrevious:Number;
    public var obj:Object3D;

    public function Instance(obj:Object3D = null, x:Number = 0, y:Number = 0) {
        this.obj = obj;
        this.xPrevious = this.x = x;
        this.yPrevious = this.y = y;
    }

    public function onStep():void {
        xPrevious = x;
        yPrevious = y;
    }
}
}
