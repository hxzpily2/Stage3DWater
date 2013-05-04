//Created by Action Script Viewer - http://www.buraks.com/asv
package
{
    import com.bigspaceship.utils.Out;
    
    import flash.events.Event;
    
    import nz.co.resn.molehill.base.Base3DHarness;
    import nz.co.resn.molehill.island.IslandMain;

	
    public class Island extends Base3DHarness {

		public function Island(){
            super(IslandMain);
            Out.enableAllLevels();
            this.addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
        }
        private function onAddedToStage(e:Event):void{
            removeEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
            stage.addEventListener(Event.RESIZE, this.onResize);
            this.onResize();
        }
        private function onResize(e:Event=null):void{
        }

    }
}//package nz.co.resn.molehill.island 
