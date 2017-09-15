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
import flash.events.KeyboardEvent;
import flash.geom.Matrix3D;
import flash.geom.Point;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import flash.ui.Keyboard;
import flash.utils.Dictionary;

[SWF(width=640, height=480, backgroundColor=0x000000)]
public class Main extends Sprite {

    [Embed(source="res/stone.png")]
    static private const STONE_TEXTURE:Class;
    private var stoneTexture:BitmapTextureResource = new BitmapTextureResource(new STONE_TEXTURE().bitmapData);

    [Embed(source="res/MetalMap.png")]
    static private const METAL_TEXTURE:Class;
    private var metalTexture:BitmapTextureResource = new BitmapTextureResource(new METAL_TEXTURE().bitmapData);

    private var cameraDistance:Number = 256;
    private var cameraDirection:Number = 0;
    private var cameraPitch:Number = Math.PI / 6;

    private var stage3D:Stage3D;
    private var rootContainer:Object3D = new Object3D();
    private var camera:Camera3D;
    private var player:Sphere;
    private var keyboard:Dictionary = new Dictionary();

    public function Main() {
        stage.frameRate = 60;
        stage.align = StageAlign.TOP_LEFT;
        stage.scaleMode = StageScaleMode.NO_SCALE;

        camera = new Camera3D(1, 10000);
        camera.view = new View(640, 480);
        addChild(camera.view);
        addChild(camera.diagram);
        rootContainer.addChild(camera);

        for (var x:int = -1000; x <= 1000; x += 256) {
            for (var y:int = -1000; y <= 1000; y += 256) {
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
        stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
        stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
    }

    private function onSphereLoaded(event:Event):void {
        var parser:Parser3DS = new Parser3DS();
        parser.parse((event.target as URLLoader).data);
        var playerMesh:Mesh;
        for (var i:int = 0; i < parser.objects.length; i++) {
            var mesh:Mesh = parser.objects[i] as Mesh;
            if (mesh.name == "Base") {
                playerMesh = mesh;
                playerMesh.setMaterialToAllSurfaces(new TextureMaterial(metalTexture));
            }
        }
        player = new Sphere(playerMesh, 0, 128);
        rootContainer.addChild(playerMesh);

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

    private function onKeyUp(event:KeyboardEvent):void {
        keyboard[event.keyCode] = false;
        if (event.keyCode == Keyboard.SPACE) {
            trace(player.obj.matrix.rawData);
        }
    }

    private function onEnterFrame(event:Event):void {
        var dx:Number = 0;
        var dy:Number = 0;
        if (keyboard[Keyboard.W]) {
            dy -= 2;
        }
        if (keyboard[Keyboard.S]) {
            dy += 2;
        }
        if (keyboard[Keyboard.A]) {
            dx -= 2;
        }
        if (keyboard[Keyboard.D]) {
            dx += 2;
        }
        player.x += Math.cos(cameraDirection) * dx - Math.sin(cameraDirection) * dy;
        player.y -= Math.sin(cameraDirection) * dx + Math.cos(cameraDirection) * dy;
        player.onStep();
        if (keyboard[Keyboard.LEFT]) {
            cameraDirection -= Math.PI / 128;
        }
        if (keyboard[Keyboard.RIGHT]) {
            cameraDirection += Math.PI / 128;
        }
        if (keyboard[Keyboard.UP]) {
            cameraPitch -= Math.PI / 256;
        }
        if (keyboard[Keyboard.DOWN]) {
            cameraPitch += Math.PI / 256;
        }
        cameraPitch = Math.max(Math.min(cameraPitch, Math.PI / 2), 0);
        camera.x = player.x - cameraDistance * Math.sin(cameraDirection) * Math.cos(cameraPitch);
        camera.y = player.y - cameraDistance * Math.cos(cameraDirection) * Math.cos(cameraPitch);
        camera.z = 32 + cameraDistance * Math.sin(cameraPitch);
        camera.rotationX = -cameraPitch - Math.PI / 2;
        camera.rotationZ = -cameraDirection;
        camera.render(stage3D);
    }

    private function onKeyDown(event:KeyboardEvent):void {
        keyboard[event.keyCode] = true;
    }
}
}
