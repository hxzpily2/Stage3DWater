//Created by Action Script Viewer - http://www.buraks.com/asv
package nz.co.resn.base.core {
    import flash.events.*;

    public class ResnEventDispatcher extends EventDispatcher implements IDestroyable {

        protected var _isDestroyed:Boolean;

        public function ResnEventDispatcher(){
            super();
        }
        public function get destroyed():Boolean{
            return (this._isDestroyed);
        }
        public function destroy():void{
            this._isDestroyed = true;
        }

    }
}//package nz.co.resn.base.core 
