package {
import flash.geom.Vector3D;

public class SimpleUtils {

    public static function pointDistance(point1:Vector3D, point2:Vector3D):Number {
        return Math.sqrt(
                Math.pow(point1.x - point2.x, 2) +
                Math.pow(point1.y - point2.y, 2) +
                Math.pow(point1.z - point2.z, 2));
    }

}
}
