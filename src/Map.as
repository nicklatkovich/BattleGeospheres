package {
import flash.geom.Matrix;

public class Map {

    private var _width:uint;
    public function get width():uint {
        return _width;
    }

    private var _height:uint;
    public function get height():uint {
        return _height;
    }

    private var _grid:Vector.<Vector.<uint>>;

    public function Map(width:uint, height:uint) {
        _width = width;
        _height = height;
        var i:uint;
        var j:uint;
        _grid = new Vector.<Vector.<uint>>(width);
        for (i = 0; i < width; i++) {
            _grid[i] = new Vector.<uint>(height);
            for (j = 0; j < height; j++) {
                _grid[i][j] = 0;
            }
        }
        var preWidth:uint = width - 1;
        var preHeight:uint = height - 1;
        for (i = 0; i < width; i++) {
            _grid[i][0] = _grid[i][height - 1] = 1;
        }
        for (j = 1; j < preHeight; j++) {
            _grid[0][j] = _grid[preWidth][j] = 1;
        }
    }
}
}
