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

import com.adobe.air.gaming.RequestManager;

import flash.display.Sprite;
import flash.display.Stage3D;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import flash.ui.Keyboard;
import flash.utils.Dictionary;

[SWF(width=1280, height=704, backgroundColor=0x000000)]
public class Main extends Sprite {

    public static const MAP_WIDTH:Number = 8;
    public static const MAP_HEIGHT:Number = 8;
    public static const CELL_WIDTH:Number = 256;
    public static const CELL_HEIGHT:Number = 256;

    public static function get MAP_REAL_WIDTH():Number {
        return MAP_WIDTH * CELL_WIDTH;
    }

    public static function get MAP_REAL_HEIGHT():Number {
        return MAP_HEIGHT * CELL_HEIGHT;
    }

    public static function get HALF_MAP_REAL_WIDTH():Number {
        return MAP_REAL_WIDTH / 2.0;
    }

    public static function get HALF_MAP_REAL_HEIGHT():Number {
        return MAP_REAL_HEIGHT / 2.0;
    }

    public static var instance:Main;

    public static var keyboard:Dictionary = new Dictionary();

    public var cameraDistance:Number = 256;
    public var cameraDirection:Number = 0;

    private var cameraPitch:Number = Math.PI / 6;
    private var stage3D:Stage3D;
    private var rootContainer:Object3D = new Object3D();
    private var camera:Camera3D;
    private var player:Player;

    public function Main() {
        instance = this;

        stage.frameRate = 60;
        stage.align = StageAlign.TOP_LEFT;
        stage.scaleMode = StageScaleMode.NO_SCALE;

        camera = new Camera3D(1, 10000);
        camera.view = new View(stage.stageWidth, stage.stageHeight);
        addChild(camera.view);
        addChild(camera.diagram);
        rootContainer.addChild(camera);

        var plane:Plane = new Plane(MAP_REAL_WIDTH, MAP_REAL_HEIGHT, MAP_WIDTH, MAP_HEIGHT, false, false, null,
                ResourceManager.stoneMaterial);
        rootContainer.addChild(plane);
//        for (var x:int = 0; x <= MAP_WIDTH; x++) {
//            for (var y:int = 0; y <= MAP_HEIGHT; y++) {
//                var plane:Plane = new Plane(CELL_WIDTH, CELL_HEIGHT);
//                plane.setMaterialToAllSurfaces(new TextureMaterial(stoneTextureResource));
//                plane.x = x * CELL_WIDTH - HALF_MAP_REAL_WIDTH;
//                plane.y = y * CELL_HEIGHT - HALF_MAP_REAL_HEIGHT;
//                plane.z = 0;
//                rootContainer.addChild(plane);
//            }
//        }
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
        var
                playerWheelMesh:Mesh,
                playerBaseMesh:Mesh,
                playerForgeFieldMesh:Mesh;
        for (var i:int = 0; i < parser.objects.length; i++) {
            var mesh:Mesh = parser.objects[i] as Mesh;
            switch (mesh.name) {
                case "Wheel":
                    playerWheelMesh = mesh;
                    playerWheelMesh.setMaterialToAllSurfaces(ResourceManager.metalMaterial);
                    break;
                case "Base":
                    playerBaseMesh = mesh;
                    playerBaseMesh.setMaterialToAllSurfaces(ResourceManager.gunMaterial);
                    break;
                case "ForceField":
                    playerForgeFieldMesh = mesh;
                    playerForgeFieldMesh.setMaterialToAllSurfaces(ResourceManager.gunMaterial);
                    break;
            }
        }
        player = new Player(playerWheelMesh, playerBaseMesh, playerForgeFieldMesh);
        rootContainer.addChild(playerWheelMesh);
        rootContainer.addChild(playerBaseMesh);
//        rootContainer.addChild(playerForgeFieldMesh);

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
        player.onStep();
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

    public static function angleDifference(currentAngle:Number, angleTo:Number):Number {
        return Math.atan2(Math.sin(angleTo - currentAngle), Math.cos(angleTo - currentAngle));
    }

    public static function sign(x:Number):int {
        if (x < 0) {
            return -1;
        }
        if (x > 0) {
            return 1;
        }
        return 0;
    }
}
}
