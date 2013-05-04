//Created by Action Script Viewer - http://www.buraks.com/asv
package nz.co.resn.molehill.island {
    import org.casalib.util.*;
    import flash.events.*;
    import org.casalib.ui.*;
    import flash.ui.*;
    import nz.co.resn.molehill.island.events.*;
    import flash.display.*;
    import nz.co.resn.base.core.*;

    public class InputManager extends ResnEventDispatcher {

        protected var stage:Stage;

        public function InputManager(){
            super();
            this.stage = StageReference.getStage();
            this.stage.addEventListener(KeyboardEvent.KEY_DOWN, this.onKeyEvent, false, 0, true);
            this.stage.addEventListener(KeyboardEvent.KEY_UP, this.onKeyEvent, false, 0, true);
            this.stage.addEventListener(MouseEvent.MOUSE_DOWN, this.onMouseEvent, false, 0, true);
            this.stage.addEventListener(MouseEvent.MOUSE_UP, this.onMouseEvent, false, 0, true);
        }
        private function onMouseEvent(e:MouseEvent):void{
            switch (e.type){
                case MouseEvent.MOUSE_DOWN:
                    if (Key.getInstance().isDown(Keyboard.CONTROL)){
                        dispatchEvent(new InputEvent(InputEvent.MOVE_BACK));
                    } else {
                        dispatchEvent(new InputEvent(InputEvent.MOVE_FORWARD));
                    };
                    break;
                case MouseEvent.MOUSE_UP:
                    dispatchEvent(new InputEvent(InputEvent.STOP_FORWARD));
                    dispatchEvent(new InputEvent(InputEvent.STOP_BACK));
                    break;
            };
        }
        private function onKeyEvent(e:KeyboardEvent):void{
            switch (e.type){
                case KeyboardEvent.KEY_DOWN:
                    switch (e.keyCode){
                        case Keyboard.UP:
                        case 87:
                            dispatchEvent(new InputEvent(InputEvent.MOVE_FORWARD));
                            break;
                        case Keyboard.DOWN:
                        case 83:
                            dispatchEvent(new InputEvent(InputEvent.MOVE_BACK));
                            break;
                        case Keyboard.LEFT:
                        case 65:
                            dispatchEvent(new InputEvent(InputEvent.MOVE_LEFT));
                            break;
                        case Keyboard.RIGHT:
                        case 68:
                            dispatchEvent(new InputEvent(InputEvent.MOVE_RIGHT));
                            break;
                        case 81:
                            dispatchEvent(new InputEvent(InputEvent.MOVE_UP));
                            break;
                        case 90:
                            dispatchEvent(new InputEvent(InputEvent.MOVE_DOWN));
                            break;
                    };
                    break;
                case KeyboardEvent.KEY_UP:
                    switch (e.keyCode){
                        case Keyboard.UP:
                        case 87:
                            dispatchEvent(new InputEvent(InputEvent.STOP_FORWARD));
                            break;
                        case Keyboard.DOWN:
                        case 83:
                            dispatchEvent(new InputEvent(InputEvent.STOP_BACK));
                            break;
                        case Keyboard.LEFT:
                        case 65:
                            dispatchEvent(new InputEvent(InputEvent.STOP_LEFT));
                            break;
                        case Keyboard.RIGHT:
                        case 68:
                            dispatchEvent(new InputEvent(InputEvent.STOP_RIGHT));
                            break;
                        case 81:
                            dispatchEvent(new InputEvent(InputEvent.STOP_UP));
                            break;
                        case 90:
                            dispatchEvent(new InputEvent(InputEvent.STOP_DOWN));
                            break;
                    };
                    break;
            };
        }
        override public function destroy():void{
            super.destroy();
            this.stage.removeEventListener(KeyboardEvent.KEY_DOWN, this.onKeyEvent);
            this.stage.removeEventListener(KeyboardEvent.KEY_UP, this.onKeyEvent);
        }

    }
}//package nz.co.resn.molehill.island 
