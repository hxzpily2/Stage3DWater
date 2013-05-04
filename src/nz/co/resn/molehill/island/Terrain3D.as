//Created by Action Script Viewer - http://www.buraks.com/asv
package nz.co.resn.molehill.island {
    import com.adobe.utils.AGALMiniAssembler;
    
    import flash.display.BitmapData;
    import flash.display3D.Context3D;
    import flash.display3D.Context3DProgramType;
    import flash.display3D.Context3DVertexBufferFormat;
    import flash.display3D.textures.Texture;
    import flash.display3D.textures.TextureBase;
    import flash.geom.Matrix;
    import flash.geom.Matrix3D;
    import flash.geom.Vector3D;
    import flash.utils.ByteArray;
    
    import nz.co.resn.molehill.base.Plane3D;

    public class Terrain3D extends Plane3D {

//		
//        private static const terrainVertexProgram:Class = Terrain3D_terrainVertexProgram;
//        private static const terrainMaterialVertexProgramTextured:Class = Terrain3D_terrainMaterialVertexProgramTextured;
//        private static const terrainFragmentProgramTextured:Class = Terrain3D_terrainFragmentProgramTextured;

//        private var vertexRegisterMap:RegisterMap;
//        private var fragmentRegisterMap:RegisterMap;
//        public var parameterBufferHelper:ProgramConstantsHelper;
        public var causticMap:Texture;
        public var refractionMap:Texture;
        public var textureDist:Texture;
        protected var heightmapBitmap:BitmapData;
        protected var heightmapDataBitmap:BitmapData;
        protected var height:Number;
        protected var depth:Number;
        public var camPosition:Vector3D;
        public var aboveSurfaceOnly:Boolean = true;
        private var _ocean:Ocean;

		private var vertexCode:String =
			"mov vt0, va0\n" +
			"m44 vt0, vt0, vc0\n" +
			"mov vt1, vt0\n" +
			"mov vt3, va1\n" +
			"mov vt2, va2\n" +
			"m44 vt0, vt2, vc0\n" +
//			"mov vt2, vt2\n" +
//			"mov vt3, vt3\n" +
//			"mov vt0, vt0\n" +
			"mov op, vt1\n" +
			"mov v0, vt2\n" +
			"mov v1, vt3\n" +
			"mov v2, vt0";
			
			
			
		private var fragmentCode:String =
			"mov ft0.y, v1.x\n" +
			"mov ft0.x, v1.y\n" +
			"mov ft2.y, ft0.y\n" +
			"mov ft2.z, ft0.x\n" +
			"mov ft0, ft2.yz\n" +
			"tex ft1, ft0, fs1 <2d,nearest,repeat,mipnone>\n" +
			"mul ft0.xy, ft2.yz, fc0.xy\n" +
			"mov ft0, ft0.xy\n" +
			"tex ft0, ft0, fs2 <2d,nearest,repeat,mipnone>\n" +
			"mul ft1, ft1, fc1\n" +
			"mov ft2.x, v0.z\n" +
			"sub ft2.x, fc2.y, ft2.x\n" +
			"max ft2.x, fc2.y, ft2.x\n" +
			"mul ft2.x, ft2.x, fc2.x\n" +
			"min ft2.x, fc8.y, ft2.x\n" +
			"mov ft2.w, v0.z\n" +
			"sub ft2.w, fc2.y, ft2.w\n" +
			"max ft2.w, fc2.y, ft2.w\n" +
			"mul ft2.w, ft2.w, fc8.y\n" +
			"min ft2.w, fc8.y, ft2.w\n" +
			"sub ft2.w, fc8.y, ft2.w\n" +
			"mul ft2.x, ft2.x, ft2.w\n" +
			"mul ft3.xy, ft2.yz, fc18.xy\n" +
			"add ft3.xy, ft3.xy, fc14.xy\n" +
			"mov ft3, ft3.xy\n" +
			"tex ft3, ft3, fs0 <2d,nearest,repeat,mipnone>\n" +
			"sub ft3, ft3, fc3\n" +
			"mul ft4.xy, ft2.yz, fc19.zw\n" +
			"add ft4.xy, ft4.xy, fc15.xy\n" +
			"mov ft4, ft4.xy\n" +
			"tex ft4, ft4, fs0 <2d,nearest,repeat,mipnone>\n" +
			"sub ft4, ft4, fc3\n" +
			"add ft3, ft3, ft4\n" +
			"mul ft4.xy, ft2.yz, fc18.zw\n" +
			"add ft4.xy, ft4.xy, fc14.zw\n" +
			"mov ft4, ft4.xy\n" +
			"tex ft4, ft4, fs0 <2d,nearest,repeat,mipnone>\n" +
			"sub ft4, ft4, fc4\n" +
			"add ft3, ft3, ft4\n" +
			"mul ft4.xy, ft2.yz, fc19.xy\n" +
			"add ft4.xy, ft4.xy, fc15.zw\n" +
			"mov ft4, ft4.xy\n" +
			"tex ft4, ft4, fs0 <2d,nearest,repeat,mipnone>\n" +
			"sub ft4, ft4, fc4\n" +
			"add ft3, ft3, ft4\n" +
			"mul ft4.xy, ft2.yz, fc20.xy\n" +
			"add ft4.xy, ft4.xy, fc16.xy\n" +
			"mov ft4, ft4.xy\n" +
			"tex ft4, ft4, fs0 <2d,nearest,repeat,mipnone>\n" +
			"sub ft4, ft4, fc5\n" +
			"mul ft4, ft4, fc6\n" +
			"add ft3, ft3, ft4\n" +
			"mul ft4.xy, ft2.yz, fc20.zw\n" +
			"add ft4.xy, ft4.xy, fc16.zw\n" +
			"mov ft4, ft4.xy\n" +
			"tex ft4, ft4, fs0 <2d,nearest,repeat,mipnone>\n" +
			"sub ft4, ft4, fc5\n" +
			"mul ft4, ft4, fc6\n" +
			"add ft3, ft3, ft4\n" +
			"mul ft4.xy, ft2.yz, fc21.xy\n" +
			"add ft4.xy, ft4.xy, fc17.xy\n" +
			"mov ft4, ft4.xy\n" +
			"tex ft4, ft4, fs0 <2d,nearest,repeat,mipnone>\n" +
			"sub ft4, ft4, fc6\n" +
			"mul ft4, ft4, fc6\n" +
			"add ft3, ft3, ft4\n" +
			"mul ft2.yz, ft2.yyz, fc21.zzw\n" +
			"add ft2.yz, ft2.yyz, fc17.zzw\n" +
			"mov ft4, ft2.yz\n" +
			"tex ft4, ft4, fs0 <2d,nearest,repeat,mipnone>\n" +
			"sub ft4, ft4, fc6\n" +
			"mul ft4, ft4, fc6\n" +
			"add ft3, ft3, ft4\n" +
			"mul ft3, ft3, fc7\n" +
			"mov ft2.y, v2.z\n" +
			"mov ft2.z, fc13.z\n" +
			"sub ft2.z, ft2.z, fc2.z\n" +
			"sub ft2.z, fc2.y, ft2.z\n" +
			"max ft2.z, fc2.y, ft2.z\n" +
			"sub ft2.z, fc2.y, ft2.z\n" +
			"mul ft2.z, ft2.z, fc0.w\n" +
			"mov ft2.w, v2.z\n" +
			"mul ft2.w, ft2.w, fc8.x\n" +
			"sub ft2.z, ft2.z, ft2.w\n" +
			"mov ft2.w, fc13.z\n" +
			"add ft2.w, ft2.w, fc0.z\n" +
			"sub ft2.w, fc2.y, ft2.w\n" +
			"sge ft2.w, ft2.w, fc2.y\n" +
			"sub ft2.w, ft2.z, ft2.w\n" +
			"mov ft2.z, fc13.z\n" +
			"add ft2.z, ft2.z, ft2.w\n" +
			"max ft2.z, fc8.z, ft2.z\n" +
			"mov ft4.x, v0.z\n" +
			"add ft2.w, ft4.x, ft2.w\n" +
			"min ft2.w, fc2.y, ft2.w\n" +
			"sub ft2.w, ft2.z, ft2.w\n" +
			"div ft2.z, ft2.z, ft2.w\n" +
			"min ft2.z, fc8.y, ft2.z\n" +
			"mul ft2.z, ft2.y, ft2.z\n" +
			"sub ft2.y, ft2.y, ft2.z\n" +
			"max ft2.y, fc2.y, ft2.y\n" +
			"abs ft2.y, ft2.y\n" +
			"mul ft2.y, ft2.y, fc8.w\n" +
			"add ft2.y, ft2.y, fc8.y\n" +
			"max ft2.y, fc2.y, ft2.y\n" +
			"div ft2.y, fc8.y, ft2.y\n" +
			"sub ft2.y, fc8.y, ft2.y\n" +
			"mul ft2.y, ft2.y, fc13.w\n" +
			"sub ft2.z, fc8.y, ft2.y\n" +
			"mov ft4, fc9\n" +
			"mov ft2.w, v2.z\n" +
			"abs ft2.w, ft2.w\n" +
			"mul ft2.w, ft2.w, fc8.w\n" +
			"add ft2.w, ft2.w, fc8.y\n" +
			"max ft2.w, fc2.y, ft2.w\n" +
			"div ft2.w, fc8.y, ft2.w\n" +
			"sub ft2.w, fc8.y, ft2.w\n" +
			"sub ft5.x, fc8.y, ft2.w\n" +
			"mul ft1, ft1, ft5.x\n" +
			"mul ft0, ft0, ft2.w\n" +
			"add ft0, ft1, ft0\n" +
			"mul ft1, ft3, ft2.x\n" +
			"add ft0, ft0, ft1\n" +
			"mov ft1.x, v0.z\n" +
			"mul ft1, fc10, ft1.x\n" +
			"add ft0, ft0, ft1\n" +
			"mov ft1.x, v0.y\n" +
			"mul ft1, fc11, ft1.x\n" +
			"add ft0, ft0, ft1\n" +
			"mul ft0, ft0, ft2.z\n" +
			"mul ft1, ft4, ft2.y\n" +
			"add ft0, ft0, ft1\n" +
			"mov ft1.x, v0.z\n" +
			"sub ft1.x, fc2.y, ft1.x\n" +
			"add ft1.x, ft1.x, fc12.x\n" +
			"sub ft1.x, ft1.x, fc2.y\n" +
			"sge ft1.x, ft1.x, fc2.y\n" +
			"mov ft1.y, fc8.y\n" +
			"sub ft1.y, ft1.y, fc13.w\n" +
			"mul ft1.x, ft1.x, ft1.y\n" +
			"sub ft1.x, fc8.y, ft1.x\n" +
//			"mov ft0, ft0\n" +
			"mov ft0.w, ft1.x\n" +
//			"mov ft0, ft0\n" +
			"mov oc, ft0";

		
        public function Terrain3D(context3D:Context3D, texture:TextureBase, width:Number=2, length:Number=2, segmentsX:uint=5, segmentsY:uint=5, tileRepeatX:uint=1, tileRepeatY:uint=1, marginX:Number=0, marginY:Number=0, heightmapBitmap:BitmapData=null, height:Number=0.1, depth:Number=0.1){
            this.camPosition = new Vector3D();
            this.heightmapBitmap = heightmapBitmap;
            this.height = height;
            this.depth = depth;
            super(context3D, texture, width, length, segmentsX, segmentsY, tileRepeatX, tileRepeatY, marginX, marginY);
            this.heightmapDataBitmap = new BitmapData(segmentsX, segmentsY);
            var heightmapDataMatrix:Matrix = new Matrix();
            heightmapDataMatrix.scale((segmentsX / heightmapBitmap.width), (segmentsY / heightmapBitmap.height));
            this.heightmapDataBitmap.draw(heightmapBitmap, heightmapDataMatrix);
            this.updateMesh();
        }
        override protected function initPrograms():void{
//            var inputVertexProgram:PBASMProgram = new PBASMProgram(this.readFile(terrainVertexProgram));
//            var inputMaterialVertexProgram:PBASMProgram = new PBASMProgram(this.readFile(terrainMaterialVertexProgramTextured));
//            var inputFragmentProgram:PBASMProgram = new PBASMProgram(this.readFile(terrainFragmentProgramTextured));
//            var programs:AGALProgramPair = PBASMCompiler.compile(inputVertexProgram, inputMaterialVertexProgram, inputFragmentProgram);
//            var agalVertexBinary:ByteArray = programs.vertexProgram.byteCode;
//            var agalFragmentBinary:ByteArray = programs.fragmentProgram.byteCode;
//            this.vertexRegisterMap = programs.vertexProgram.registers;
//            this.fragmentRegisterMap = programs.fragmentProgram.registers;
//            this.parameterBufferHelper = new ProgramConstantsHelper(context3D, this.vertexRegisterMap, this.fragmentRegisterMap);
			var assembler:* = new AGALMiniAssembler(false);
			assembler.assemble("vertex", vertexCode);
			var agalVertexBinary:* = assembler.agalcode;
			
			assembler.assemble("fragment", fragmentCode);
			var agalFragmentBinary:* = assembler.agalcode;
			
            _shaderProgram = context3D.createProgram();
            _shaderProgram.upload(agalVertexBinary, agalFragmentBinary);
        }
        private function readFile(f:Class):String{
            var bytes:ByteArray;
            bytes = new (f)();
            return (bytes.readUTFBytes(bytes.bytesAvailable));
        }
        private function updateMesh():void{
            var vertexOffset:uint;
            var vertexZ:Number;
            var heightmapPointColour:Number;
            var heightmapPointValue:Number;
            var vertextCol:uint;
            var vertextRow:uint;
            while (vertextRow < segmentsX) {
                vertextCol = 0;
                while (vertextCol < segmentsY) {
                    vertexOffset = (((vertextRow * segmentsX) * dataPerVertex) + (vertextCol * dataPerVertex));
                    vertexZ = _vertices[(vertexOffset + 2)];
                    if ((((((((vertextCol > 1)) && ((vertextCol < (segmentsY - 2))))) && ((vertextRow > 1)))) && ((vertextRow < (segmentsX - 2))))){
                        if (this.heightmapBitmap){
                            heightmapPointValue = this.getAltitudeAtPoint((((vertextCol / segmentsY) - 0.5) * width), (((1 - (vertextRow / segmentsX)) - 0.5) * length));
                            vertexZ = (vertexZ + heightmapPointValue);
                        };
                    } else {
                        if (((((((!((vertextCol == 0))) && (!((vertextCol == (segmentsY - 1)))))) && (!((vertextRow == 0))))) && (!((vertextRow == (segmentsX - 1)))))){
                            vertexZ = (vertexZ + this.depth);
                        };
                    };
                    if ((((vertextCol == (segmentsY - 1))) && ((vertextRow == 1)))){
                        _vertices[(vertexOffset + 1)] = _vertices[(((((vertextRow - 1) * segmentsX) * dataPerVertex) + (vertextCol * dataPerVertex)) + 1)];
                        _vertices[(vertexOffset + 4)] = _vertices[(((((vertextRow - 1) * segmentsX) * dataPerVertex) + (vertextCol * dataPerVertex)) + 4)];
                    };
                    if ((((vertextCol == 0)) && ((vertextRow == (segmentsX - 2))))){
                        _vertices[(vertexOffset + 1)] = _vertices[(((((vertextRow + 1) * segmentsX) * dataPerVertex) + (vertextCol * dataPerVertex)) + 1)];
                        _vertices[(vertexOffset + 4)] = _vertices[(((((vertextRow + 1) * segmentsX) * dataPerVertex) + (vertextCol * dataPerVertex)) + 4)];
                    };
                    if (vertextRow == 1){
                        _vertices[(vertexOffset + 1)] = _vertices[(((((vertextRow - 1) * segmentsX) * dataPerVertex) + (vertextCol * dataPerVertex)) + 1)];
                        _vertices[(vertexOffset + 4)] = _vertices[(((((vertextRow - 1) * segmentsX) * dataPerVertex) + (vertextCol * dataPerVertex)) + 4)];
                    };
                    if (vertextRow == (segmentsX - 2)){
                        _vertices[(vertexOffset + 1)] = _vertices[(((((vertextRow + 1) * segmentsX) * dataPerVertex) + (vertextCol * dataPerVertex)) + 1)];
                        _vertices[(vertexOffset + 4)] = _vertices[(((((vertextRow + 1) * segmentsX) * dataPerVertex) + (vertextCol * dataPerVertex)) + 4)];
                    };
                    if (vertextCol == 1){
                        _vertices[(vertexOffset + 0)] = _vertices[((((vertextRow * segmentsX) * dataPerVertex) + ((vertextCol - 1) * dataPerVertex)) + 0)];
                        _vertices[(vertexOffset + 3)] = _vertices[((((vertextRow * segmentsX) * dataPerVertex) + ((vertextCol - 1) * dataPerVertex)) + 3)];
                    };
                    if (vertextCol == (segmentsY - 2)){
                        _vertices[(vertexOffset + 0)] = _vertices[((((vertextRow * segmentsX) * dataPerVertex) + ((vertextCol + 1) * dataPerVertex)) + 0)];
                        _vertices[(vertexOffset + 3)] = _vertices[((((vertextRow * segmentsX) * dataPerVertex) + ((vertextCol + 1) * dataPerVertex)) + 3)];
                    };
                    _vertices[(vertexOffset + 2)] = vertexZ;
                    vertextCol++;
                };
                vertextRow++;
            };
            _indexBuffer = context3D.createIndexBuffer((numTriangles * 3));
            _indexBuffer.uploadFromVector(_indencies, 0, (numTriangles * 3));
            _vertexBuffer = context3D.createVertexBuffer((segmentsY * segmentsX), dataPerVertex);
            _vertexBuffer.uploadFromVector(_vertices, 0, (segmentsY * segmentsX));
        }
        public function getAltitudeAtPoint(x:Number, y:Number):Number{
            var leftAbs:Number;
            var topAbs:Number;
            var left:int;
            var top:int;
            var xNormalized:Number;
            var zNormalized:Number;
            var topHeight:Number;
            var bottomHeight:Number;
            var heightmapPointValue:Number;
            var testBitmapX:Number = (1 - ((y / width) + 0.5));
            var testBitmapY:Number = ((x / length) + 0.5);
            var altitude:Number = this.depth;
            if ((((((((testBitmapX > 0)) && ((testBitmapX < 1)))) && ((testBitmapY > 0)))) && ((testBitmapY < 1)))){
                leftAbs = (testBitmapX * this.heightmapDataBitmap.width);
                topAbs = (testBitmapY * this.heightmapDataBitmap.height);
                left = Math.floor(leftAbs);
                top = Math.floor(topAbs);
                xNormalized = (leftAbs - left);
                zNormalized = (topAbs - top);
                topHeight = this.lerp((this.heightmapDataBitmap.getPixel(left, top) >> 16), (this.heightmapDataBitmap.getPixel((left + 1), top) >> 16), xNormalized);
                bottomHeight = this.lerp((this.heightmapDataBitmap.getPixel(left, (top + 1)) >> 16), (this.heightmapDataBitmap.getPixel((left + 1), (top + 1)) >> 16), xNormalized);
                heightmapPointValue = (this.lerp(topHeight, bottomHeight, zNormalized) / 0xFF);
                altitude = (altitude + (heightmapPointValue * this.height));
            };
            return (altitude);
        }
        protected function lerp(value1:Number, value2:Number, amount:Number):Number{
            return ((value1 + ((value2 - value1) * amount)));
        }
        override public function draw(t:Number=0, viewMatrix:Matrix3D=null, projectionMatrix:Matrix3D=null, transformMatrix:Matrix3D=null):void{
            var newViewMatrix:Matrix3D;
            if (transformMatrix == null){
                transformMatrix = new Matrix3D();
                transformMatrix.identity();
            };
            context3D.setProgram(_shaderProgram);
            context3D.setTextureAt(0, this.causticMap);
            context3D.setTextureAt(1, texture);
            context3D.setTextureAt(2, this.textureDist);
            context3D.setVertexBufferAt(0, _vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
            context3D.setVertexBufferAt(1, _vertexBuffer, 3, Context3DVertexBufferFormat.FLOAT_2);
            context3D.setVertexBufferAt(2, _vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
            var underwaterMarginOffset:Number = 0;
			
//			fc0 : ( 0.1, 0.1, 0.02, 0.8 )
//			fc1 : ( 1.15, 1.15, 1.15, 1.15 )
//			fc2 : ( 12, 0, 0.03, 0 )
//			fc3 : ( 0.3, 0.3, 0.3, 0.3 )
//			fc4 : ( 0.45, 0.45, 0.45, 0.45 )
//			fc5 : ( 0.55, 0.55, 0.55, 0.55 )
//			fc6 : ( 0.5, 0.5, 0.5, 0.5 )
//			fc7 : ( 0.12, 0.12, 0.12, 1 )
//			fc8 : ( 0.001, 1, 0.002, 0.5 )
//			fc9 : ( 0.1, 0.62, 0.6, 1 )
//			fc10 : ( 0.00001, 0.00001, 0.00001, 0.00001 )
//			fc11 : ( 0, 0, 0, 0 )
			
			context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, Vector.<Number>([0.1, 0.1, 0.02, 0.8]));
			context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, Vector.<Number>([1.15, 1.15, 1.15, 1.15]));
			context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 2, Vector.<Number>([12, 0, 0.03, 0]));
			context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 3, Vector.<Number>([0.3, 0.3, 0.3, 0.3]));
			context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 4, Vector.<Number>([0.45, 0.45, 0.45, 0.45]));
			context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 5, Vector.<Number>([0.55, 0.55, 0.55, 0.55]));
			context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 6, Vector.<Number>([0.5, 0.5, 0.5, 0.5]));
			context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 7, Vector.<Number>([ 0.12, 0.12, 0.12, 1]));
			context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 8, Vector.<Number>([0.001, 1, 0.002, 0.5]));
			context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 9, Vector.<Number>([0.1, 0.62, 0.6, 1]));
			context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 10, Vector.<Number>([0.00001, 0.00001, 0.00001, 0.00001]));
			context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 11, Vector.<Number>([0, 0, 0, 0]));
			
//			fc12 : aboveSurfaceOffset : float1
//			this.parameterBufferHelper.setNumberParameterByName(Context3DProgramType.FRAGMENT, "aboveSurfaceOffset", Vector.<Number>([-0.02]));
			context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 12, Vector.<Number>([-0.02, 0, 0, 0]));
			
//			fc13 : camPosition : float3
//			fc13 : aboveSurfaceOnly : float1
//			this.parameterBufferHelper.setNumberParameterByName(Context3DProgramType.FRAGMENT, "camPosition", Vector.<Number>([this.camPosition.x, this.camPosition.y, this.camPosition.z]));
//			this.parameterBufferHelper.setNumberParameterByName(Context3DProgramType.FRAGMENT, "aboveSurfaceOnly", Vector.<Number>([(this.aboveSurfaceOnly) ? 1 : 0]));
			context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 13, Vector.<Number>([this.camPosition.x, this.camPosition.y, this.camPosition.z, (this.aboveSurfaceOnly) ? 1 : 0]));

//			fc14 : waveOffset1 : float2
//			fc14 : waveOffset1b : float2
//			this.parameterBufferHelper.setNumberParameterByName(Context3DProgramType.FRAGMENT, "waveOffset1", Vector.<Number>([(-(this._ocean.waveOffset1.y) * 0.5), (-(this._ocean.waveOffset1.x) * 0.4)]));
//			this.parameterBufferHelper.setNumberParameterByName(Context3DProgramType.FRAGMENT, "waveOffset1b", Vector.<Number>([(-(this._ocean.waveOffset1b.y) * 0.7), (-(this._ocean.waveOffset1b.x) * 0.5)]));
			context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 14, Vector.<Number>([(-(this._ocean.waveOffset1.y) * 0.5), (-(this._ocean.waveOffset1.x) * 0.4), (-(this._ocean.waveOffset1b.y) * 0.7), (-(this._ocean.waveOffset1b.x) * 0.5)]));

//			fc15 : waveOffset2 : float2
//			fc15 : waveOffset2b : float2
//			this.parameterBufferHelper.setNumberParameterByName(Context3DProgramType.FRAGMENT, "waveOffset2", Vector.<Number>([(-(this._ocean.waveOffset2.y) * 0.5), (-(this._ocean.waveOffset2.x) * 0.4)]));
//			this.parameterBufferHelper.setNumberParameterByName(Context3DProgramType.FRAGMENT, "waveOffset2b", Vector.<Number>([(-(this._ocean.waveOffset2b.y) * 0.7), (-(this._ocean.waveOffset2b.x) * 0.5)]));
			context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 15, Vector.<Number>([(-(this._ocean.waveOffset2.y) * 0.5), (-(this._ocean.waveOffset2.x) * 0.4), (-(this._ocean.waveOffset2b.y) * 0.7), (-(this._ocean.waveOffset2b.x) * 0.5)]));

//			fc16 : waveOffset3 : float2
//			fc16 : waveOffset4 : float2
//			this.parameterBufferHelper.setNumberParameterByName(Context3DProgramType.FRAGMENT, "waveOffset3", Vector.<Number>([-(this._ocean.waveOffset3.y), -(this._ocean.waveOffset3.x)]));
//			this.parameterBufferHelper.setNumberParameterByName(Context3DProgramType.FRAGMENT, "waveOffset4", Vector.<Number>([-(this._ocean.waveOffset4.y), -(this._ocean.waveOffset4.x)]));
			context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 16, Vector.<Number>([-(this._ocean.waveOffset3.y), -(this._ocean.waveOffset3.x), -(this._ocean.waveOffset4.y), -(this._ocean.waveOffset4.x)]));

			
//			fc17 : waveOffset5 : float2
//			fc17 : waveOffset6 : float2
//			this.parameterBufferHelper.setNumberParameterByName(Context3DProgramType.FRAGMENT, "waveOffset5", Vector.<Number>([-(this._ocean.waveOffset5.y), -(this._ocean.waveOffset5.x)]));
//			this.parameterBufferHelper.setNumberParameterByName(Context3DProgramType.FRAGMENT, "waveOffset6", Vector.<Number>([-(this._ocean.waveOffset6.y), -(this._ocean.waveOffset6.x)]));
			context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 17, Vector.<Number>([-(this._ocean.waveOffset5.y), -(this._ocean.waveOffset5.x), -(this._ocean.waveOffset6.y), -(this._ocean.waveOffset6.x)]));

//			fc18 : waveScale1 : float2
//			fc18 : waveScale1b : float2
//			this.parameterBufferHelper.setNumberParameterByName(Context3DProgramType.FRAGMENT, "waveScale1", Vector.<Number>([(this._ocean.waveScale1.y * 0.75), (this._ocean.waveScale1.x * 0.75)]));
//			this.parameterBufferHelper.setNumberParameterByName(Context3DProgramType.FRAGMENT, "waveScale1b", Vector.<Number>([(this._ocean.waveScale1b.y * 0.75), (this._ocean.waveScale1b.x * 0.75)]));
			context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 18, Vector.<Number>([(this._ocean.waveScale1.y * 0.75), (this._ocean.waveScale1.x * 0.75), (this._ocean.waveScale1b.y * 0.75), (this._ocean.waveScale1b.x * 0.75)]));

//			fc19 : waveScale2b : float2
//			fc19 : waveScale2 : float2
//			this.parameterBufferHelper.setNumberParameterByName(Context3DProgramType.FRAGMENT, "waveScale2b", Vector.<Number>([(this._ocean.waveScale2b.y * 0.75), (this._ocean.waveScale2b.x * 0.75)]));
//			this.parameterBufferHelper.setNumberParameterByName(Context3DProgramType.FRAGMENT, "waveScale2", Vector.<Number>([(this._ocean.waveScale2.y * 0.75), (this._ocean.waveScale2.x * 0.75)]));
			context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 19, Vector.<Number>([(this._ocean.waveScale2b.y * 0.75), (this._ocean.waveScale2b.x * 0.75), (this._ocean.waveScale2.y * 0.75), (this._ocean.waveScale2.x * 0.75)]));

//			fc20 : waveScale3 : float2
//			fc20 : waveScale4 : float2
//			this.parameterBufferHelper.setNumberParameterByName(Context3DProgramType.FRAGMENT, "waveScale3", Vector.<Number>([this._ocean.waveScale3.y, this._ocean.waveScale3.x]));
//			this.parameterBufferHelper.setNumberParameterByName(Context3DProgramType.FRAGMENT, "waveScale4", Vector.<Number>([this._ocean.waveScale4.y, this._ocean.waveScale4.x]));
			context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 20, Vector.<Number>([this._ocean.waveScale3.y, this._ocean.waveScale3.x, this._ocean.waveScale4.y, this._ocean.waveScale4.x]));

//			fc21 : waveScale5 : float2
//			fc21 : waveScale6 : float2
//			this.parameterBufferHelper.setNumberParameterByName(Context3DProgramType.FRAGMENT, "waveScale5", Vector.<Number>([this._ocean.waveScale5.y, this._ocean.waveScale5.x]));
//			this.parameterBufferHelper.setNumberParameterByName(Context3DProgramType.FRAGMENT, "waveScale6", Vector.<Number>([this._ocean.waveScale6.y, this._ocean.waveScale6.x]));
			context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 21, Vector.<Number>([this._ocean.waveScale5.y, this._ocean.waveScale5.x, this._ocean.waveScale6.y, this._ocean.waveScale6.x]));

            newViewMatrix = new Matrix3D();
            newViewMatrix.appendRotation(180, Vector3D.X_AXIS);
            newViewMatrix.append(viewMatrix);
            var newTransformMatrix:Matrix3D = new Matrix3D();
            newTransformMatrix.append(this.worldMatrix);
            newTransformMatrix.append(transformMatrix);
            renderMatrix = new Matrix3D();
            renderMatrix.append(newTransformMatrix);
            renderMatrix.append(newViewMatrix);
            renderMatrix.append(projectionMatrix);
//            this.parameterBufferHelper.update();
            context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, renderMatrix, true);
            context3D.drawTriangles(_indexBuffer, 0, numTriangles);
            context3D.setTextureAt(0, null);
            context3D.setTextureAt(1, null);
            context3D.setTextureAt(2, null);
            context3D.setVertexBufferAt(0, null);
            context3D.setVertexBufferAt(1, null);
            context3D.setVertexBufferAt(2, null);
        }
        public function get ocean():Ocean{
            return (this._ocean);
        }
        public function set ocean(value:Ocean):void{
            this._ocean = value;
        }

    }
}//package nz.co.resn.molehill.island 
