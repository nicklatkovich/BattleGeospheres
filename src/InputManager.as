package {
import flash.display.Stage;
import flash.events.KeyboardEvent;
import flash.utils.Dictionary;

public class InputManager {

    private static var _lastInstance:InputManager;
    public static function get lastInstance():InputManager {
        return _lastInstance;
    }

    private var keyboard:Dictionary = new Dictionary();

    public function InputManager(stage:Stage) {
        _lastInstance = this;
        stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
        stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
    }

    public function isButtonPressed(keyCode:uint):Boolean {
        return keyboard[keyCode];
    }

    public static function isButtonPressed(keyCode:uint):Boolean {
        return lastInstance.isButtonPressed(keyCode);
    }

    private function onKeyUp(event:KeyboardEvent):void {
        keyboard[event.keyCode] = false;
    }

    private function onKeyDown(event:KeyboardEvent):void {
        keyboard[event.keyCode] = true;
    }

}
}
