//Created by Action Script Viewer - http://www.buraks.com/asv
package nz.co.resn.molehill.island.events {
    import flash.events.*;

    public class InputEvent extends Event {

        public static const MOVE_FORWARD:String = "InputEvent.MOVE_FORWARD";
        public static const MOVE_BACK:String = "InputEvent.MOVE_BACK";
        public static const MOVE_LEFT:String = "InputEvent.MOVE_LEFT";
        public static const MOVE_RIGHT:String = "InputEvent.MOVE_RIGHT";
        public static const STOP_FORWARD:String = "InputEvent.STOP_FORWARD";
        public static const STOP_BACK:String = "InputEvent.STOP_BACK";
        public static const STOP_LEFT:String = "InputEvent.STOP_LEFT";
        public static const STOP_RIGHT:String = "InputEvent.STOP_RIGHT";
        public static const MOVE_UP:String = "InputEvent.MOVE_UP";
        public static const MOVE_DOWN:String = "InputEvent.MOVE_DOWN";
        public static const STOP_UP:String = "InputEvent.STOP_UP";
        public static const STOP_DOWN:String = "InputEvent.STOP_DOWN";

        public function InputEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false){
            super(type, bubbles, cancelable);
        }
        override public function clone():Event{
            return (new InputEvent(type, bubbles, cancelable));
        }
        override public function toString():String{
            return (formatToString("InputEvent", "type", "bubbles", "cancelable", "eventPhase"));
        }

    }
}//package nz.co.resn.molehill.island.events 
