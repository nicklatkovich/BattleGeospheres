package {

import alternativa.engine3d.core.Camera3D;
import alternativa.engine3d.core.Object3D;
import alternativa.engine3d.core.Resource;
import alternativa.engine3d.core.View;
import alternativa.engine3d.loaders.Parser3DS;
import alternativa.engine3d.materials.TextureMaterial;
import alternativa.engine3d.objects.Mesh;
import alternativa.engine3d.primitives.Plane;
import alternativa.engine3d.resources.BitmapTextureResource;

import flash.display.Sprite;
import flash.display.Stage3D;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;

[SWF (width=640, height=480, backgroundColor=0x000000)]
public class Main extends Sprite {

    [Embed(source = "res/stone.png")] static private const STONE_TEXTURE:Class;
    private var stoneTexture:BitmapTextureResource = new BitmapTextureResource(new STONE_TEXTURE().bitmapData);

    [Embed(source = "res/MetalMap.png")] static private const METAL_TEXTURE:Class;
    private var metalTexture:BitmapTextureResource = new BitmapTextureResource(new METAL_TEXTURE().bitmapData);

    private var stage3D:Stage3D;
    private var rootContainer:Object3D = new Object3D();
    private var camera:Camera3D;
    private var player:Mesh;

    public function Main() {
        stage.frameRate = 60;
        stage.align = StageAlign.TOP_LEFT;
        stage.scaleMode = StageScaleMode.NO_SCALE;

        camera = new Camera3D(1, 10000);
        camera.view = new View(640, 480);
        camera.rotationX = -Math.PI / 2.0;
        camera.z = 64;
        addChild(camera.view);
        addChild(camera.diagram);
        rootContainer.addChild(camera);

        for (var x:int = -1000; x <= 1000; x+=256) {
            for (var y:int = -1000; y <= 1000; y+=256) {
                var plane:Plane = new Plane(256, 256);
                plane.setMaterialToAllSurfaces(new TextureMaterial(stoneTexture));
                plane.x = x;
                plane.y = y;
                plane.z = 0;
                rootContainer.addChild(plane);
            }
        }
        var loader3ds:URLLoader = new URLLoader();
        loader3ds.dataFormat = URLLoaderDataFormat.BINARY;
        loader3ds.load(new URLRequest("res/Sphere.3DS"));
        loader3ds.addEventListener(Event.COMPLETE, onSphereLoaded);
    }

    private function onSphereLoaded(event:Event):void {
        var parser:Parser3DS = new Parser3DS();
        parser.parse((event.target as URLLoader).data);
        for (var i:int = 0; i < parser.objects.length; i++)
        {
            var mesh:Mesh = parser.objects[i] as Mesh;
            if (mesh.name == "Base") {
                player = mesh;
                player.setMaterialToAllSurfaces(new TextureMaterial(metalTexture));
            }
        }
        player.y = 128;
        rootContainer.addChild(player);

        stage3D = stage.stage3Ds[0];
        stage3D.addEventListener(Event.CONTEXT3D_CREATE, onInit);
        stage3D.requestContext3D();
    }

    private function onInit(event:Event):void {
        trace("Context3D is created");
        for each (var resource:Resource in rootContainer.getResources(true)) {
            resource.upload(stage3D.context3D);
        }
        addEventListener(Event.ENTER_FRAME, onEnterFrame);
    }

    private function onEnterFrame(event:Event):void {
        camera.render(stage3D);
    }
}
}
