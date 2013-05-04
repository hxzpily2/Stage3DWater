//Created by Action Script Viewer - http://www.buraks.com/asv
package nz.co.resn.molehill.base {
    import com.adobe.utils.*;
    import flash.display.*;
    import flash.display3D.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.utils.*;
    import flash.text.*;

    public class Base3D {

        protected var _shaderProgram:Program3D;
        protected var _indexBuffer:IndexBuffer3D;
        protected var _vertexBuffer:VertexBuffer3D;
        protected var _ntris:uint;
        protected var _width:uint;
        protected var _height:uint;
        protected var _sprite:Sprite;
        protected var _label:TextField;
        protected var _fragmentShaderAssembler:AGALMiniAssembler;
        protected var _vertexShaderAssembler:AGALMiniAssembler;
        protected var _mvpMatrix:Matrix3D;
        protected var _rect:Rectangle;
        protected var _slot:int;
        protected var _rendermode:String;
        protected var _stage:Stage;
        public var context3D:Context3D;

        public function Base3D(){
            super();
        }
        public function SetStage3DParams(stage:Stage, renderMode:String, slot:int, rectangle:Rectangle):void{
            this._stage = stage;
            this._rendermode = renderMode;
            this._rect = rectangle;
            this._slot = slot;
            this._width = rectangle.width;
            this._height = rectangle.height;
            this._stage.stage3Ds[this._slot].addEventListener(Event.CONTEXT3D_CREATE, this.stageNotificationHandler);
            this._stage.stage3Ds[this._slot].requestContext3D(renderMode);
        }
        protected function stageNotificationHandler(event:Event):void{
            var t:Stage3D = (event.target as Stage3D);
            this.context3D = t.context3D;
            if (this.context3D == null){
                trace("Base3D.stageNotificationHandler context3D = null");
            } else {
                this.init();
                this.renderFrame((getTimer() / 1000));
            };
        }
        protected function init():void{
            try {
                this.context3D.configureBackBuffer(this._width, this._height, 0, true);
            } catch(e) {
                trace(e.toString());
            };
        }
        protected function renderFrame(t:Number):void{
        }

    }
}//package nz.co.resn.molehill.base 
