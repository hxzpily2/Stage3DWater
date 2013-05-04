//Created by Action Script Viewer - http://www.buraks.com/asv
package nz.co.resn.molehill.base {
    import flash.display.*;
    import flash.display3D.*;
    import flash.events.*;
    import flash.geom.*;
    import org.casalib.util.*;

	[SWF(frameRate="60", backgroundColor="#FFFFFF")]
    public class Base3DHarness extends Sprite {

        protected static const WIDTH:uint = 800;
        protected static const HEIGHT:uint = 600;
        protected static const MARGIN:uint = 0;
        protected static const MODE_LIST:Vector.<String> = new Vector.<String>();
;

        protected var difimage:Bitmap;
        protected var alltests:Array;
        private var controlClass:Class;

        public function Base3DHarness(controlClass:Class){
            this.alltests = new Array();
            super();
            this.controlClass = controlClass;
            this.addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
        }
        private function onAddedToStage(e:Event):void{
            var base3dClass:Object;
            var rect:Rectangle;
            var base3d:Base3D;
            StageReference.setStage(stage);
            removeEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;
            var i:int;
            while (i < MODE_LIST.length) {
                rect = new Rectangle();
                rect.width = WIDTH;
                rect.height = HEIGHT;
                rect.x = (MARGIN + ((WIDTH + MARGIN) * (i & 1)));
                rect.y = (MARGIN + ((HEIGHT + MARGIN) * ((i & 2) >> 1)));
                base3dClass = new this.controlClass();
                base3d = (base3dClass as Base3D);
                base3d.SetStage3DParams(stage, MODE_LIST[i], i, rect);
                this.alltests.push(base3d);
                i++;
            };
        }

        MODE_LIST.push(Context3DRenderMode.AUTO);
    }
}//package nz.co.resn.molehill.base 
