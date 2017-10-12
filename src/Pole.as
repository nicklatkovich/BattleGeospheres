package {
import alternativa.engine3d.core.Object3D;
import alternativa.engine3d.primitives.GeoSphere;

public class Pole extends Instance {

    private var radius:Number;

    public function Pole(x:Number = 0, y:Number = 0, radius:Number = 64) {
        this.radius = radius;
        var object:GeoSphere = new GeoSphere(radius, 2, false, ResourceManager.stoneMaterial);
        super(object, x, y, 32);
        Main.lastInstance.poles.push(this);
    }
}
}
