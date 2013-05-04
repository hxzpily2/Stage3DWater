package com.bigspaceship.events
{
    import flash.events.*;

    public class OutEvent extends Event
    {
        public var output:String;
        public static const ALL:String = "all";
        public static const INFO:String = "info";
        public static const STATUS:String = "status";
        public static const DEBUG:String = "debug";
        public static const WARNING:String = "warning";
        public static const ERROR:String = "error";
        public static const FATAL:String = "fatal";

        public function OutEvent($type:String, $out:String)
        {
            super($type);
            this.output = $out;
            return;
        }// end function

        override public function clone() : Event
        {
            return new OutEvent(type, this.output);
        }// end function

    }
}
