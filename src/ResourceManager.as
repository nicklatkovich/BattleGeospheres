package {
import alternativa.engine3d.materials.TextureMaterial;
import alternativa.engine3d.resources.BitmapTextureResource;

public class ResourceManager {

    [Embed(source="res/GroundMap.png")]
    private static const STONE_TEXTURE:Class;
    private static var stoneTexture:BitmapTextureResource = new BitmapTextureResource(new STONE_TEXTURE().bitmapData);
    private static var _stoneMaterial:TextureMaterial = new TextureMaterial(stoneTexture);
    public static function get stoneMaterial():TextureMaterial {
        return _stoneMaterial;
    }

    [Embed(source="res/MetalMap.png")]
    private static const METAL_TEXTURE:Class;
    private static var metalTexture:BitmapTextureResource = new BitmapTextureResource(new METAL_TEXTURE().bitmapData);
    private static var _metalMaterial:TextureMaterial = new TextureMaterial(metalTexture);
    public static function get metalMaterial():TextureMaterial {
        return _metalMaterial;
    }

    [Embed(source="res/GunMap.png")]
    private static const GUN_TEXTURE:Class;
    private static var gunTexture:BitmapTextureResource = new BitmapTextureResource(new GUN_TEXTURE().bitmapData);
    private static var _gunMaterial:TextureMaterial = new TextureMaterial(gunTexture);
    public static function get gunMaterial():TextureMaterial {
        return _gunMaterial;
    }

    [Embed(source="res/ForgeFieldMap.png")]
    private static const FORGE_FIELD_TEXTURE:Class;
    private static var forgeFieldTexture:BitmapTextureResource =
            new BitmapTextureResource(new FORGE_FIELD_TEXTURE().bitmapData);

    [Embed(source="res/ForgeFieldOpacityMap.jpg")]
    private static const FORGE_FIELD_OPACITY_TEXTURE:Class;
    private static var forgeFieldOpacityTexture:BitmapTextureResource =
            new BitmapTextureResource(new FORGE_FIELD_OPACITY_TEXTURE().bitmapData);
    private static var _forgeFieldMaterial:TextureMaterial =
            new TextureMaterial(forgeFieldTexture, forgeFieldOpacityTexture);
    public static function get forgeFieldMaterial():TextureMaterial {
        return _forgeFieldMaterial;
    }

    {
        _forgeFieldMaterial.alphaThreshold = 1.0;
        _forgeFieldMaterial.transparentPass = true;
        _forgeFieldMaterial.opaquePass = true;
    }

    [Embed(source="res/skybox/sky_neg_x.png")]
    private static const left_t_c:Class;
    private static var left_t:BitmapTextureResource = new BitmapTextureResource(new left_t_c().bitmapData);
    public static var left_mat:TextureMaterial = new TextureMaterial(left_t);
    [Embed(source="res/skybox/sky_pos_x.png")]
    private static const right_t_c:Class;
    private static var right_t:BitmapTextureResource = new BitmapTextureResource(new right_t_c().bitmapData);
    public static var right_mat:TextureMaterial = new TextureMaterial(right_t);
    [Embed(source="res/skybox/sky_pos_y.png")]
    private static const top_t_c:Class;
    private static var top_t:BitmapTextureResource = new BitmapTextureResource(new top_t_c().bitmapData);
    public static var top_mat:TextureMaterial = new TextureMaterial(top_t);
    [Embed(source="res/skybox/sky_neg_y.png")]
    static private const bottom_t_c:Class;
    private static var bottom_t:BitmapTextureResource = new BitmapTextureResource(new bottom_t_c().bitmapData);
    public static var bottom_mat:TextureMaterial = new TextureMaterial(bottom_t);
    [Embed(source="res/skybox/sky_pos_z.png")]
    static private const front_t_c:Class;
    private static var front_t:BitmapTextureResource = new BitmapTextureResource(new front_t_c().bitmapData);
    public static var front_mat:TextureMaterial = new TextureMaterial(front_t);
    [Embed(source="res/skybox/sky_neg_z.png")]
    static private const back_t_c:Class;
    private static var back_t:BitmapTextureResource = new BitmapTextureResource(new back_t_c().bitmapData);
    public static var back_mat:TextureMaterial = new TextureMaterial(back_t);

    public function ResourceManager() {

    }
}
}
