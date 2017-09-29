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

    [Embed(source="res/alpha.jpg")]
    private static const FORGE_FIELD_OPACITY_TEXTURE:Class;
    private static var forgeFieldOpacityTexture:BitmapTextureResource =
            new BitmapTextureResource(new FORGE_FIELD_OPACITY_TEXTURE().bitmapData);
    private static var _forgeFieldMaterial:TextureMaterial = new TextureMaterial(forgeFieldTexture, forgeFieldTexture);
    public static function get forgeFieldMaterial():TextureMaterial {
        return _forgeFieldMaterial;
    }

    {
        _forgeFieldMaterial.alphaThreshold = 0.5;
        _forgeFieldMaterial.transparentPass = true;
        _forgeFieldMaterial.opaquePass = true;
    }

    public function ResourceManager() {

    }
}
}
