//Created by Action Script Viewer - http://www.buraks.com/asv
package nz.co.resn.molehill.island
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Stage;
    import flash.display3D.Context3DClearMask;
    import flash.display3D.Context3DTextureFormat;
    import flash.display3D.Context3DTriangleFace;
    import flash.display3D.textures.CubeTexture;
    import flash.display3D.textures.Texture;
    import flash.events.Event;
    import flash.filters.BlurFilter;
    import flash.geom.Matrix3D;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.geom.Vector3D;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
    import flash.utils.ByteArray;
    import flash.utils.getTimer;
    
    import nz.co.resn.molehill.base.Base3D;
    import nz.co.resn.molehill.base.Camera3D;
    import nz.co.resn.molehill.island.events.InputEvent;
    
    import org.casalib.util.StageReference;

    public class IslandMain extends Base3D {

        public static const DEG2RAD:Number = 0.0174532925199433;
        public static const DEG2RAD_2:Number = 0.00872664625997165;
		
		[Embed(source="/../images/sky.atf", mimeType="application/octet-stream")]
        protected static var SkyBitmap:Class;
		
		[Embed(source="/../images/cubetexture.atf", mimeType="application/octet-stream")]
        protected static var CubeTextureBitmap:Class;
		
		[Embed(source="/../images/waterbump.png")]
        protected static var WaterBumpBitmap:Class;
		
		[Embed(source="/../images/sandtexture.png")]
        protected static var SandTextureBitmap:Class;
		
		[Embed(source="/../images/sanddistancetexture.png")]
        protected static var SandDistanceTextureBitmap:Class;
		
		[Embed(source="/../images/islandheight.png")]
        protected static var IslandHeightBitmap:Class;
		
		[Embed(source="/../images/caustic.png")]
        protected static var CausticBitmap:Class;

        private const createAmbientCubes:Boolean = false;
        private const createTestCube:Boolean = false;

        private var _camera:Camera3D;
        private var _skyBox:SkyBox;
        private var _terrain:Terrain3D;
        private var _ocean:Ocean;
        private var testCube:Cube;
        private var stage:Stage;
        private var _objects:Array;
        private var arrayRows:uint = 5;
        private var arrayCols:uint = 5;
        private var inputManager:InputManager;
        private var movingForward:Boolean = false;
        private var movingBack:Boolean = false;
        private var movingLeft:Boolean = false;
        private var movingRight:Boolean = false;
        private var movingUp:Boolean = false;
        private var movingDown:Boolean = false;
        private var frames:uint = 0;
        private var ambientObjectArea:Number = 50;
        private var ambientObjectAreaHeight:Number = 5;
        private var ambientObjectAreaVOffset:Number = -0.5;
        private var ambientRotSpeed:Number = 1;
        private var ambientPosSpeed:Number = 0.005;
        private var objectCount:uint = 0;
        private var maxNumObjects:uint = 200;
        private var cubeTexture:CubeTexture;
        private var terrainTexture:Texture;
        private var terrainTextureDist:Texture;
        private var waterTexture:Texture;
        private var causticTexture:Texture;
        private var cameraMinGroundAltitude:Number = 0.3;
        private var cameraMinGroundAltitudeRange:Number = 0.2;
        private var refractionMap:Texture;
        private var reflectionMap:Texture;
        private var oceanSurfaceMaxWaveAmp:Number = 0.05;
        private var antiAlias:Number = 4;

		private var fpsLast:uint = getTimer();
		private var fpsTicks:uint = 0;
		private var fpsTf:TextField;
		
        override protected function init():void{
            var cubeTextureData:ByteArray;
            context3D.enableErrorChecking = true;
            super.init();
            this.stage = StageReference.getStage();
			
			var myFormat:TextFormat = new TextFormat();  
			myFormat.color = 0xFFFFFF;
			myFormat.size = 13
			fpsTf = new TextField();
			fpsTf.x = 0;
			fpsTf.y = 0;
			fpsTf.selectable = false;
			fpsTf.autoSize = TextFieldAutoSize.LEFT;
			fpsTf.defaultTextFormat = myFormat;
			fpsTf.text = "Initializing Stage3d...";
			this.stage.addChild(fpsTf);
			
			
            this.inputManager = new InputManager();
            this.inputManager.addEventListener(InputEvent.MOVE_FORWARD, this.onInputEvent, false, 0, true);
            this.inputManager.addEventListener(InputEvent.MOVE_BACK, this.onInputEvent, false, 0, true);
            this.inputManager.addEventListener(InputEvent.MOVE_LEFT, this.onInputEvent, false, 0, true);
            this.inputManager.addEventListener(InputEvent.MOVE_RIGHT, this.onInputEvent, false, 0, true);
            this.inputManager.addEventListener(InputEvent.MOVE_UP, this.onInputEvent, false, 0, true);
            this.inputManager.addEventListener(InputEvent.MOVE_DOWN, this.onInputEvent, false, 0, true);
            this.inputManager.addEventListener(InputEvent.STOP_FORWARD, this.onInputEvent, false, 0, true);
            this.inputManager.addEventListener(InputEvent.STOP_BACK, this.onInputEvent, false, 0, true);
            this.inputManager.addEventListener(InputEvent.STOP_LEFT, this.onInputEvent, false, 0, true);
            this.inputManager.addEventListener(InputEvent.STOP_RIGHT, this.onInputEvent, false, 0, true);
            this.inputManager.addEventListener(InputEvent.STOP_UP, this.onInputEvent, false, 0, true);
            this.inputManager.addEventListener(InputEvent.STOP_DOWN, this.onInputEvent, false, 0, true);
            this._camera = new Camera3D();
            this._camera.position.y = 0.5;
            this._camera.rotation.x = -10;
            this._camera.rotation.y = 85;
            this._objects = [];
            this._skyBox = new SkyBox(context3D, SkyBitmap);
            this._skyBox.scale = 100;
            if (this.createAmbientCubes){
                cubeTextureData = (new CubeTextureBitmap() as ByteArray);
                this.cubeTexture = context3D.createCubeTexture(0x0100, Context3DTextureFormat.COMPRESSED, false);
                this.cubeTexture.uploadCompressedTextureFromByteArray(cubeTextureData, 0);
            };
            this.terrainTexture = context3D.createTexture(0x0200, 0x0200, Context3DTextureFormat.BGRA, false);
            var terrainBitmap:BitmapData = Bitmap(new SandTextureBitmap()).bitmapData;
            this.terrainTexture.uploadFromBitmapData(terrainBitmap);
            this.terrainTextureDist = context3D.createTexture(0x0200, 0x0200, Context3DTextureFormat.BGRA, false);
            var terrainDistBitmap:BitmapData = Bitmap(new SandDistanceTextureBitmap()).bitmapData;
            this.terrainTextureDist.uploadFromBitmapData(terrainDistBitmap);
            var heightmapBitmap:BitmapData = Bitmap(new IslandHeightBitmap()).bitmapData;
            heightmapBitmap.applyFilter(heightmapBitmap, heightmapBitmap.rect, new Point(), new BlurFilter(3, 3));
            this.waterTexture = context3D.createTexture(0x0100, 0x0100, Context3DTextureFormat.BGRA, false);
            var waterBitmap:BitmapData = Bitmap(new WaterBumpBitmap()).bitmapData;
            this.waterTexture.uploadFromBitmapData(waterBitmap);
            this.causticTexture = context3D.createTexture(0x0100, 0x0100, Context3DTextureFormat.BGRA, false);
            var causticBitmap:BitmapData = Bitmap(new CausticBitmap()).bitmapData;
            this.causticTexture.uploadFromBitmapData(causticBitmap);
            this.refractionMap = context3D.createTexture(0x0400, 0x0400, Context3DTextureFormat.BGRA, true);
            this.reflectionMap = context3D.createTexture(0x0400, 0x0400, Context3DTextureFormat.BGRA, true);
            this._ocean = new Ocean(context3D, this.waterTexture, 25, 25, 50, 50, 50, 50, 500, 500);
            this._ocean.scale = 1;
            this._ocean.rotation.x = -90;
            this._ocean.position.y = 0;
            this._ocean.refractionMap = this.refractionMap;
            this._ocean.reflectionMap = this.reflectionMap;
            this._terrain = new Terrain3D(context3D, this.terrainTexture, 25, 25, 50, 50, 50, 50, 500, 500, heightmapBitmap, 1.3, -0.9);
            this._terrain.scale = 1;
            this._terrain.rotation.x = -90;
            this._terrain.position.y = 0;
            this._terrain.causticMap = this.causticTexture;
            this._terrain.textureDist = this.terrainTextureDist;
            this._terrain.ocean = this._ocean;
            if (this.createTestCube){
                this.testCube = new Cube(context3D, this.cubeTexture);
                this.testCube.scale = 0.01;
                this.testCube.rotation.x = -45;
                this.testCube.rotation.y = -45;
                this.testCube.position.y = 0.1;
                this._objects.push(this.testCube);
            };
            this.stage.addEventListener(Event.ENTER_FRAME, this.onEnterFrame, false, 0, true);
            this.stage.addEventListener(Event.RESIZE, this.onStageResize);
            this.resize();
        }
        private function onEnterFrame(e:Event):void{
			
			// update the FPS display
			fpsTicks++;
			var now:uint = getTimer();
			var delta:uint = now - fpsLast;
			// only update the display once a second
			if (delta >= 1000) 
			{
				var fps:Number = fpsTicks / delta * 1000;
				fpsTf.text = fps.toFixed(1) + " fps";
				fpsTicks = 0;
				fpsLast = now;
			}
			
			
            this.update();
        }
        private function update():void{
            var cubeI:uint;
            this._camera.resetMovement();
            if (this.movingForward){
                this._camera.moveForward();
            };
            if (this.movingBack){
                this._camera.moveBack();
            };
            if (this.movingLeft){
                this._camera.moveLeft();
            };
            if (this.movingRight){
                this._camera.moveRight();
            };
            if (this.movingUp){
                this._camera.moveUp();
            };
            if (this.movingDown){
                this._camera.moveDown();
            };
            this._camera.update();
            var minCamAltitude:Number = ((this._terrain.position.y + this._terrain.getAltitudeAtPoint(this._camera.position.x, this._camera.position.z)) + this.cameraMinGroundAltitude);
            if (this._camera.position.y < minCamAltitude){
                this._camera.position.y = minCamAltitude;
            };
            if (this.createAmbientCubes){
                if ((((this.objectCount < this.maxNumObjects)) && (((this.frames++ % 10) == 0)))){
                    cubeI = 0;
                    while (cubeI < 4) {
                        this.createNewCube();
                        cubeI++;
                    };
                };
            };
            if (this.createTestCube){
                this.testCube.position.x = (this._camera.position.x + (Math.sin((this._camera.rotation.y * DEG2RAD)) * 0.5));
                this.testCube.position.z = (this._camera.position.z + (Math.cos((this._camera.rotation.y * DEG2RAD)) * 0.5));
                this.testCube.position.y = (this._terrain.position.y + this._terrain.getAltitudeAtPoint(this.testCube.position.x, this.testCube.position.z));
            };
            this.renderFrame((getTimer() / 1000));
        }
        private function createNewCube():void{
            var object:Cube;
            object = new Cube(context3D, this.cubeTexture);
            object.scale = 1E-7;
            object.targetScale = (0.005 + ((Math.random() * Math.random()) * 0.08));
            object.rotation = new Vector3D(45, 45, 0);
            object.position = new Vector3D(((Math.random() - 0.5) * this.ambientObjectArea), ((Math.random() * this.ambientObjectAreaHeight) + this.ambientObjectAreaVOffset), ((Math.random() - 0.5) * this.ambientObjectArea));
            object.rotVel = new Vector3D(((Math.random() - 0.5) * this.ambientRotSpeed), ((Math.random() - 0.5) * this.ambientRotSpeed), ((Math.random() - 0.5) * this.ambientRotSpeed));
            object.posVel = new Vector3D(((Math.random() - 0.5) * this.ambientPosSpeed), ((Math.random() - 0.5) * this.ambientPosSpeed), ((Math.random() - 0.5) * this.ambientPosSpeed));
            this._objects.push(object);
            this.objectCount++;
        }
        private function onInputEvent(e:InputEvent):void{
            switch (e.type){
                case InputEvent.MOVE_FORWARD:
                    this.movingForward = true;
                    break;
                case InputEvent.MOVE_BACK:
                    this.movingBack = true;
                    break;
                case InputEvent.MOVE_LEFT:
                    this.movingLeft = true;
                    break;
                case InputEvent.MOVE_RIGHT:
                    this.movingRight = true;
                    break;
                case InputEvent.MOVE_UP:
                    this.movingUp = true;
                    break;
                case InputEvent.MOVE_DOWN:
                    this.movingDown = true;
                    break;
                case InputEvent.STOP_FORWARD:
                    this.movingForward = false;
                    break;
                case InputEvent.STOP_BACK:
                    this.movingBack = false;
                    break;
                case InputEvent.STOP_LEFT:
                    this.movingLeft = false;
                    break;
                case InputEvent.STOP_RIGHT:
                    this.movingRight = false;
                    break;
                case InputEvent.STOP_UP:
                    this.movingUp = false;
                    break;
                case InputEvent.STOP_DOWN:
                    this.movingDown = false;
                    break;
            };
        }
        private function onStageResize(e:Event):void{
            this.resize();
        }
        private function resize():void{
            context3D.configureBackBuffer(this.stage.stageWidth, this.stage.stageHeight, this.antiAlias, true);
            _rect = new Rectangle(0, 0, this.stage.stageWidth, this.stage.stageHeight);
            this._camera.aspect = (this.stage.stageWidth / this.stage.stageHeight);
        }
        override protected function renderFrame(t:Number):void{
            var targetX:Number = ((this.stage.mouseX / this.stage.stageWidth) - 0.5);
            var targetY:Number = ((this.stage.mouseY / this.stage.stageHeight) - 0.5);
            this._camera.rotation.x = (this._camera.rotation.x + (-(targetY) * 5));
            this._camera.rotation.y = (this._camera.rotation.y + (targetX * 5));
            this._camera.rotation.x = Math.max(-90, Math.min(90, this._camera.rotation.x));
//            var objectI:uint;
//            while (objectI < this._objects.length) {
//                this._objects[objectI].update();
//                objectI++;
//            };
            this._ocean.camPosition = this._camera.getWorldPosition();
            this._ocean.update();
            this._terrain.camPosition = this._camera.getWorldPosition();
            context3D.setRenderToTexture(this.refractionMap, true);
            this.renderScene(t, this._camera.viewMatrix, this._camera.projectionMatrix, false, true, (this._camera.position.y < 0));
            context3D.setRenderToBackBuffer();
            context3D.setRenderToTexture(this.reflectionMap, true);
            this.renderScene(t, this._camera.reflectedViewMatrix, this._camera.projectionMatrix, false, true, (this._camera.position.y > 0), (this._camera.position.y > 0));
            context3D.setRenderToBackBuffer();
            this.renderScene(t, this._camera.viewMatrix, this._camera.projectionMatrix);
            context3D.present();
        }
        private function renderScene(t:Number, viewMatrix:Matrix3D, projectionMatrix:Matrix3D, renderOcean:Boolean=true, sliceScene:Boolean=false, sliceAbove:Boolean=true, renderSky:Boolean=true, renderTerrain:Boolean=true):void{
            context3D.clear(0.1, 0.62, 0.6, 1);
            context3D.setCulling(Context3DTriangleFace.NONE);
            if (renderSky){
                this._skyBox.draw(t, viewMatrix, projectionMatrix);
                context3D.clear(0, 0, 0, 0, 1, 0, Context3DClearMask.DEPTH);
            };
            if (renderTerrain){
                context3D.setCulling(Context3DTriangleFace.FRONT);
                this._terrain.aboveSurfaceOnly = !(((sliceScene) && (sliceAbove)));
                this._terrain.draw(t, viewMatrix, projectionMatrix);
            };
            context3D.setCulling(Context3DTriangleFace.NONE);
//            var objectI:uint;
//            while (objectI < this._objects.length) {
//                this._objects[objectI].draw(t, viewMatrix, projectionMatrix);
//                objectI++;
//            };
            if (renderOcean){
                if (this._camera.position.y > -(this.oceanSurfaceMaxWaveAmp)){
                    context3D.setCulling(Context3DTriangleFace.BACK);
                    this._ocean.drawOcean(t, viewMatrix, projectionMatrix, null, false);
                };
                if (this._camera.position.y < this.oceanSurfaceMaxWaveAmp){
                    context3D.setCulling(Context3DTriangleFace.FRONT);
                    this._ocean.drawOcean(t, viewMatrix, projectionMatrix, null, true);
                };
            };
        }
        public function destory():void{
            if (this.inputManager){
                this.inputManager.removeEventListener(InputEvent.MOVE_FORWARD, this.onInputEvent);
                this.inputManager.removeEventListener(InputEvent.MOVE_BACK, this.onInputEvent);
                this.inputManager.removeEventListener(InputEvent.MOVE_LEFT, this.onInputEvent);
                this.inputManager.removeEventListener(InputEvent.MOVE_RIGHT, this.onInputEvent);
                this.inputManager.removeEventListener(InputEvent.MOVE_UP, this.onInputEvent);
                this.inputManager.removeEventListener(InputEvent.MOVE_DOWN, this.onInputEvent);
                this.inputManager.removeEventListener(InputEvent.STOP_FORWARD, this.onInputEvent);
                this.inputManager.removeEventListener(InputEvent.STOP_BACK, this.onInputEvent);
                this.inputManager.removeEventListener(InputEvent.STOP_LEFT, this.onInputEvent);
                this.inputManager.removeEventListener(InputEvent.STOP_RIGHT, this.onInputEvent);
                this.inputManager.removeEventListener(InputEvent.STOP_UP, this.onInputEvent);
                this.inputManager.removeEventListener(InputEvent.STOP_DOWN, this.onInputEvent);
                this.inputManager = null;
            };
            if (this.stage){
                this.stage = null;
            };
            if (context3D){
                context3D = null;
            };
        }

    }
}//package nz.co.resn.molehill.island 
