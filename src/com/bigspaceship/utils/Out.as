package com.bigspaceship.utils
{
    import com.bigspaceship.events.OutEvent;
    import com.bigspaceship.utils.out.adapters.IOutAdapter;
    
    import flash.events.EventDispatcher;
    import flash.utils.getQualifiedClassName;

    public class Out extends EventDispatcher
    {
        public static const INFO:Number = 0;
        public static const STATUS:Number = 1;
        public static const DEBUG:Number = 2;
        public static const WARNING:Number = 3;
        public static const ERROR:Number = 4;
        public static const FATAL:Number = 5;
        private static var __levels:Array = [];
        private static var __silenced:Object = {};
        private static var __instance:Out;
        private static var __debuggers:Array = [];

        public function Out()
        {
            return;
        }// end function

        public static function enableLevel($level:Number) : void
        {
            __levels[$level] = __output;
            return;
        }// end function

        public static function disableLevel($level:Number) : void
        {
            __levels[$level] = null;
            return;
        }// end function

        public static function enableAllLevels() : void
        {
            enableLevel(INFO);
            enableLevel(STATUS);
            enableLevel(DEBUG);
            enableLevel(WARNING);
            enableLevel(ERROR);
            enableLevel(FATAL);
            return;
        }// end function

        public static function disableAllLevels() : void
        {
            disableLevel(INFO);
            disableLevel(STATUS);
            disableLevel(DEBUG);
            disableLevel(WARNING);
            disableLevel(ERROR);
            disableLevel(FATAL);
            return;
        }// end function

        public static function registerDebugger($debugger:IOutAdapter) : void
        {
            __debuggers[__debuggers.length] = $debugger;
            return;
        }// end function

        public static function isSilenced($o) : Boolean
        {
            var _loc_2:* = __getClassName($o);
            return __silenced[_loc_2];
        }// end function

        public static function silence($o) : void
        {
            var _loc_2:* = __getClassName($o);
            __silenced[_loc_2] = true;
            return;
        }// end function

        public static function unsilence($o) : void
        {
            var _loc_2:* = __getClassName($o);
            __silenced[_loc_2] = false;
            return;
        }// end function

        public static function info($origin, ... args) : void
        {
            if (isSilenced($origin))
            {
                return;
            }
            if (__levels.hasOwnProperty(INFO))
            {
                __levels.hasOwnProperty(INFO);
            }
            if (__levels[INFO] != null)
            {
                __levels[INFO].apply(null, ["INFO", $origin, OutEvent.INFO].concat(args));
            }
            return;
        }// end function

        public static function status($origin, ... args) : void
        {
            if (isSilenced($origin))
            {
                return;
            }
            if (__levels.hasOwnProperty(STATUS))
            {
                __levels.hasOwnProperty(STATUS);
            }
            if (__levels[STATUS] != null)
            {
                __levels[STATUS].apply(null, ["STATUS", $origin, OutEvent.STATUS].concat(args));
            }
            return;
        }// end function

        public static function debug($origin, ... args) : void
        {
            if (isSilenced($origin))
            {
                return;
            }
            if (__levels.hasOwnProperty(DEBUG))
            {
                __levels.hasOwnProperty(DEBUG);
            }
            if (__levels[DEBUG] != null)
            {
                __levels[DEBUG].apply(null, ["DEBUG", $origin, OutEvent.DEBUG].concat(args));
            }
            return;
        }// end function

        public static function warning($origin, ... args) : void
        {
            if (isSilenced($origin))
            {
                return;
            }
            if (__levels.hasOwnProperty(WARNING))
            {
                __levels.hasOwnProperty(WARNING);
            }
            if (__levels[WARNING] != null)
            {
                __levels[WARNING].apply(null, ["WARNING", $origin, OutEvent.WARNING].concat(args));
            }
            return;
        }// end function

        public static function error($origin, ... args) : void
        {
            if (isSilenced($origin))
            {
                return;
            }
            if (__levels.hasOwnProperty(ERROR))
            {
                __levels.hasOwnProperty(ERROR);
            }
            if (__levels[ERROR] != null)
            {
                __levels[ERROR].apply(null, ["ERROR", $origin, OutEvent.ERROR].concat(args));
            }
            return;
        }// end function

        public static function fatal($origin, $str:String, ... args) : void
        {
            if (isSilenced($origin))
            {
                return;
            }
            if (__levels.hasOwnProperty(FATAL))
            {
                __levels.hasOwnProperty(FATAL);
            }
            if (__levels[FATAL] != null)
            {
                __levels[FATAL].apply(null, ["FATAL", $origin, OutEvent.FATAL].concat(args));
            }
            return;
        }// end function

        public static function clear() : void
        {
            var _loc_1:IOutAdapter = null;
            if (__debuggers.length)
            {
                for each (_loc_1 in __debuggers)
                {
                    
                    _loc_1.clear();
                }
            }
            return;
        }// end function

        public static function traceObject($origin, $str:String, $obj) : void
        {
            var _loc_4:* = undefined;
            if (isSilenced($origin))
            {
                return;
            }
            __output("OBJECT", $origin, $str, OutEvent.ALL);
            for (_loc_4 in $obj)
            {
                
                __output("", null, _loc_4 + " : " + $obj[_loc_4], OutEvent.ALL);
            }
            return;
        }// end function

        public static function addEventListener($type:String, $func:Function) : void
        {
            __getInstance().addEventListener($type, $func);
            return;
        }// end function

        public static function removeEventListener($type:String, $func:Function) : void
        {
            __getInstance().removeEventListener($type, $func);
            return;
        }// end function

        private static function __getInstance() : Out
        {
			if(__instance) return __instance;
			else{
				var inst:* = new Out;
				__instance = inst;
				return inst;
			}
        }// end function

        public static function createInstance() : void
        {
            var _loc_1:* = undefined;
            var _loc_2:* = undefined;
            var _loc_3:Object = {};
            var _loc_4:Array = [];
            for (_loc_1 in __silenced)
            {
                
                _loc_3[_loc_1] = __silenced;
            }
            for (_loc_1 in __levels)
            {
                
                if (__levels[_loc_1])
                {
                }
                if (__levels[_loc_1] != null)
                {
                    _loc_4.push(_loc_1);
                }
            }
            enableAllLevels();
            for (_loc_2 in _loc_3)
            {
                
                silence(_loc_2);
            }
            _loc_2 = 0;
            while (_loc_2 < _loc_4.length)
            {
                
                disableLevel(_loc_4[_loc_2]);
                _loc_2 = _loc_2 + 1;
            }
            return;
        }// end function

        private static function __output($level:String, $origin, $type:String, ... args) : void
        {
//            var _loc_10:String = null;
//            var _loc_11:IOutAdapter = null;
//            args = $level;
//            var _loc_6:* = $origin ? (__getClassName($origin)) : ("");
//            var _loc_7:* = __getInstance();
//            while (args.length < 8)
//            {
//                
//                args = args + " ";
//            }
//            var _loc_8:* = args + ":::\t" + _loc_6 + "\t:: ";
//            var _loc_9:* = _loc_8;
//            for (_loc_10 in args)
//            {
//                
//                _loc_9 = _loc_9 + (" " + args[_loc_10]);
//            }
//            if (__debuggers.length)
//            {
//                for each (_loc_11 in __debuggers)
//                {
//                    
//                    _loc_11.output.apply(null, [_loc_8, $level].concat(args));
//                }
//            }
//            trace(_loc_9);
//            _loc_7.dispatchEvent(new OutEvent(OutEvent.ALL, _loc_9));
//            _loc_7.dispatchEvent(new OutEvent($type, _loc_9));
            return;
        }// end function

        private static function __getClassName($o) : String
        {
            var _loc_2:* = getQualifiedClassName($o);
			
			return _loc_2;
//            if (!_loc_2.split("::")[1])
//            {
//            }
//            var _loc_3:* = _loc_2 == "String" ? ($o) : (if (_loc_2.split("::")[1]) goto 73, _loc_2);
//            return _loc_3;
        }// end function

    }
}
