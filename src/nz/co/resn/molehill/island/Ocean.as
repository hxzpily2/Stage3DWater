//Created by Action Script Viewer - http://www.buraks.com/asv
package nz.co.resn.molehill.island {
    import com.adobe.utils.AGALMiniAssembler;
    
    import flash.display3D.Context3D;
    import flash.display3D.Context3DBlendFactor;
    import flash.display3D.Context3DCompareMode;
    import flash.display3D.Context3DProgramType;
    import flash.display3D.Context3DVertexBufferFormat;
    import flash.display3D.textures.Texture;
    import flash.display3D.textures.TextureBase;
    import flash.geom.Matrix3D;
    import flash.geom.Point;
    import flash.geom.Vector3D;
    import flash.utils.ByteArray;
    
    import __AS3__.vec.Vector;
    
    import nz.co.resn.molehill.base.Plane3D;

    public class Ocean extends Plane3D {

//        private static const oceanVertexProgram:Class = Ocean_oceanVertexProgram;
//        private static const oceanMaterialVertexProgramTextured:Class = Ocean_oceanMaterialVertexProgramTextured;
//        private static const oceanFragmentProgramTextured:Class = Ocean_oceanFragmentProgramTextured;

//        private var vertexRegisterMap:RegisterMap;
//        private var fragmentRegisterMap:RegisterMap;
//        public var parameterBufferHelper:ProgramConstantsHelper;
        private var vertexProgramConstantValues_:Vector.<Number> = null;
        private var fragmentProgramConstantValues_:Vector.<Number> = null;
        public var refractionMap:Texture;
        public var reflectionMap:Texture;
        private var waveScale:Number = 1.2;
        private var waveStretch:Number = 0.5;
        public var camPosition:Vector3D;
        private var waveSpeed:Number = 0.5;
        public var waveScale1:Point;
        public var waveScale2:Point;
        public var waveScale1b:Point;
        public var waveScale2b:Point;
        public var waveScale3:Point;
        public var waveScale4:Point;
        public var waveScale5:Point;
        public var waveScale6:Point;
        public var waveOffset1:Point;
        public var waveOffset2:Point;
        public var waveOffset1b:Point;
        public var waveOffset2b:Point;
        public var waveOffset3:Point;
        public var waveOffset4:Point;
        public var waveOffset5:Point;
        public var waveOffset6:Point;
        public var waveSurfaceFreq1:Number = 2.5;
        public var waveSurfaceAmp1:Number = 0.015;
        public var waveSurfacePhase1:Number = 0;
        public var waveSurfaceVel1:Number = 1.3;
        public var waveSurfaceAngle1:Number = 10;
        public var waveSurfaceFreq2:Number = 1.8;
        public var waveSurfaceAmp2:Number = 0.01;
        public var waveSurfacePhase2:Number = 0.5;
        public var waveSurfaceVel2:Number = 1;
        public var waveSurfaceAngle2:Number = 80;
		
		
		
		private var vertexCode:String = 
			"mov vt0, va0\n" +
			"mov vt1.x, vc4.w\n" +
			"sin vt1.y, vt1.x\n" +
			"mov vt1.x, vt0.x\n" +
			"mul vt1.x, vt1.y, vt1.x\n" +
			"mov vt1.y, vc4.w\n" +
			"cos vt1.z, vt1.y\n" +
			"mov vt1.y, vt0.y\n" +
			"mul vt1.y, vt1.z, vt1.y\n" +
			"add vt1.x, vt1.x, vt1.y\n" +
			"mov vt1.y, vc5.w\n" +
			"sin vt1.z, vt1.y\n" +
			"mov vt1.y, vt0.x\n" +
			"mul vt1.y, vt1.z, vt1.y\n" +
			"mov vt1.z, vc5.w\n" +
			"cos vt1.w, vt1.z\n" +
			"mov vt1.z, vt0.y\n" +
			"mul vt1.z, vt1.w, vt1.z\n" +
			"add vt1.y, vt1.y, vt1.z\n" +
			"mov vt1.z, vc4.y\n" +
			"mul vt1.z, vt1.x, vt1.z\n" +
			"mov vt1.x, vc4.z\n" +
			"add vt1.x, vt1.z, vt1.x\n" +
			"sin vt1.z, vt1.x\n" +
			"mov vt1.x, vc4.x\n" +
			"mul vt1.x, vt1.z, vt1.x\n" +
			"mov vt1.z, vc5.y\n" +
			"mul vt1.y, vt1.y, vt1.z\n" +
			"mov vt1.z, vc5.z\n" +
			"add vt1.y, vt1.y, vt1.z\n" +
			"sin vt1.y, vt1.y\n" +
			"mov vt1.z, vc5.x\n" +
			"mul vt1.y, vt1.y, vt1.z\n" +
			"add vt1.x, vt1.x, vt1.y\n" +
			"mov vt1.y, vt0.y\n" +
			"abs vt1.y, vt1.y\n" +
			"min vt1.y, vc6.x, vt1.y\n" +
			"sub vt1.y, vc6.x, vt1.y\n" +
			"div vt1.y, vt1.y, vc6.x\n" +
			"mov vt1.z, vt0.x\n" +
			"abs vt1.z, vt1.z\n" +
			"min vt1.z, vc6.x, vt1.z\n" +
			"sub vt1.z, vc6.x, vt1.z\n" +
			"mul vt1.y, vt1.y, vt1.z\n" +
			"div vt1.y, vt1.y, vc6.x\n" +
			"mul vt1.x, vt1.x, vt1.y\n" +
			"mov vt1.y, vt0.z\n" +
			"add vt1.x, vt1.y, vt1.x\n" +
//			"mov vt0, vt0\n" +
			"mov vt0.z, vt1.x\n" +
			"m44 vt0, vt0, vc0\n" +
			"mov vt4, vt0\n" +
			"mov vt3, va1\n" +
			"mov vt0, va0\n" +
			"m44 vt2, va0, vc0\n" +
			"m44 vt1, va0, vc0\n" +
			"mov vt3, vt3\n" +
//			"mov vt1, vt1\n" +
//			"mov vt0, vt0\n" +
//			"mov vt2, vt2\n" +
			"mov op, vt4\n" +
			"mov v0, vt3\n" +
			"mov v1, vt1\n" +
			"mov v2, vt0\n" +
			"mov v3, vt2";
		
		private var fragmentCode:String = 
			"mov ft0.y, v0.x\n" +
			"mov ft0.x, v0.y\n" +
			"mov ft2.x, ft0.y\n" +
			"mov ft2.y, ft0.x\n" +
			"mov ft0.y, v1.x\n" +
			"mov ft0.x, v1.w\n" +
			"div ft0.x, ft0.y, ft0.x\n" +
			"div ft0.y, ft0.x, fc1.y\n" +
			"mov ft0.z, v1.y\n" +
			"mov ft0.x, v1.w\n" +
			"div ft0.x, ft0.z, ft0.x\n" +
			"div ft0.x, ft0.x, fc1.y\n" +
			"mov ft1.x, ft0.y\n" +
			"mov ft1.y, ft0.x\n" +
			"mov ft1.z, fc0.z\n" +
			"mov ft1.w, fc0.z\n" +
			"mul ft0.xy, ft2.xy, fc12.zw\n" +
			"add ft0.xy, ft0.xy, fc8.xy\n" +
			"mov ft0, ft0.xy\n" +
			"tex ft0, ft0, fs0 <2d,nearest,repeat,mipnone>\n" +
			"mul ft2.zw, ft2.xyxy, fc12.xyxy\n" +
			"add ft2.zw, ft2.zwzw, fc9.xyxy\n" +
			"mov ft3, ft2.zw\n" +
			"tex ft3, ft3, fs0 <2d,nearest,repeat,mipnone>\n" +
			"mul ft2.zw, ft2.xyxy, fc8.zwzw\n" +
			"add ft2.zw, ft2.zwzw, fc9.zwzw\n" +
			"mov ft4, ft2.zw\n" +
			"tex ft4, ft4, fs0 <2d,nearest,repeat,mipnone>\n" +
			"mul ft2.zw, ft2.xyxy, fc13.xyxy\n" +
			"add ft2.zw, ft2.zwzw, fc10.xyxy\n" +
			"mov ft5, ft2.zw\n" +
			"tex ft5, ft5, fs0 <2d,nearest,repeat,mipnone>\n" +
			"mul ft2.zw, ft2.xyxy, fc10.zwzw\n" +
			"add ft2.zw, ft2.zwzw, fc11.xyxy\n" +
			"mov ft6, ft2.zw\n" +
			"tex ft6, ft6, fs0 <2d,nearest,repeat,mipnone>\n" +
			"mul ft2.xy, ft2.xy, fc13.zw\n" +
			"add ft2.xy, ft2.xy, fc11.zw\n" +
			"mov ft2, ft2.xy\n" +
			"tex ft2, ft2, fs0 <2d,nearest,repeat,mipnone>\n" +
			"add ft0, ft0, ft3\n" +
			"add ft0, ft0, ft4\n" +
			"add ft0, ft0, ft5\n" +
			"add ft0, ft0, ft6\n" +
			"add ft0, ft0, ft2\n" +
			"mul ft0, ft0, fc0.w\n" +
			"sub ft0, ft0, fc0.y\n" +
			"mov ft2.x, v1.w\n" +
			"add ft2.x, fc1.z, ft2.x\n" +
			"div ft2.x, fc1.z, ft2.x\n" +
			"sub ft2.x, fc1.z, ft2.x\n" +
			"mul ft2.x, ft2.x, ft2.x\n" +
			"mul ft2.x, ft2.x, fc0.x\n" +
			"add ft2.x, fc1.z, ft2.x\n" +
			"div ft0, ft0, ft2.x\n" +
			"mov ft2.x, ft1.x\n" +
			"add ft2.x, ft2.x, fc0.y\n" +
			"mov ft2.y, ft1.y\n" +
			"add ft2.y, ft2.y, fc0.y\n" +
			"add ft2.z, ft2.y, fc7.w\n" +
			"mov ft2.x, ft2.x\n" +
			"mov ft2.y, ft2.z\n" +
			"mov ft2.z, v3.z\n" +
			"sub ft2.z, ft2.z, fc1.x\n" +
			"mov ft2.w, fc4.z\n" +
			"abs ft2.w, ft2.w\n" +
			"div ft2.w, ft2.w, fc1.w\n" +
			"max ft2.w, fc1.w, ft2.w\n" +
			"mul ft2.z, ft2.z, ft2.w\n" +
			"mul ft2.z, ft2.z, fc4.w\n" +
			"min ft2.z, fc1.z, ft2.z\n" +
			"sub ft2.w, fc1.z, ft2.z\n" +
			"mul ft2.z, ft2.w, ft2.w\n" +
			"mul ft3.x, ft2.w, ft2.z\n" +
			"mov ft2.z, ft0.x\n" +
			"mov ft2.w, ft0.y\n" +
			"mul ft3.y, ft3.x, fc5.y\n" +
			"add ft2.w, ft2.w, ft3.y\n" +
			"mov ft3.y, ft2.z\n" +
			"mov ft3.z, ft2.w\n" +
			"sub ft2.zw, ft3.yzyz, fc2.zwzw\n" +
			"mul ft2.zw, ft2.zwzw, fc7.y\n" +
			"add ft2.xy, ft2.xy, ft2.zw\n" +
			"mov ft2, ft2.xy\n" +
			"tex ft2, ft2, fs1 <2d,nearest,clamp,mipnone>\n" +
			"mov ft3.y, ft1.x\n" +
			"add ft3.y, ft3.y, fc0.y\n" +
			"mov ft1.x, ft1.y\n" +
			"sub ft1.x, fc0.z, ft1.x\n" +
			"add ft1.z, ft1.x, fc0.y\n" +
			"mov ft1.x, ft3.y\n" +
			"mov ft1.y, ft1.z\n" +
			"mov ft1.z, ft0.x\n" +
			"mov ft3.y, ft0.y\n" +
			"mov ft1.z, ft1.z\n" +
			"mov ft1.w, ft3.y\n" +
			"mul ft3.w, ft3.x, fc5.y\n" +
			"mov ft3.y, fc0.z\n" +
			"mov ft3.z, ft3.w\n" +
			"add ft3.yz, ft1.zzw, ft3.yyz\n" +
			"mov ft1.z, fc7.z\n" +
			"mov ft1.w, fc7.z\n" +
			"mul ft1.zw, ft3.yzyz, ft1.zwzw\n" +
			"add ft1.zw, ft1.xyxy, ft1.zwzw\n" +
			"mov ft4.x, fc7.z\n" +
			"mov ft4.y, fc7.z\n" +
			"add ft4.xy, ft4.xy, fc2.xy\n" +
			"mul ft3.yz, ft3.yyz, ft4.xxy\n" +
			"add ft1.xy, ft1.xy, ft3.yz\n" +
			"mov ft4, ft1.xy\n" +
			"tex ft4, ft4, fs2 <2d,nearest,clamp,mipnone>\n" +
			"mov ft3.y, ft4.x\n" +
			"mov ft4, ft1.zw\n" +
			"tex ft4, ft4, fs2 <2d,nearest,clamp,mipnone>\n" +
			"mov ft3.z, ft4.y\n" +
			"mov ft1, ft1.xy\n" +
			"tex ft1, ft1, fs2 <2d,nearest,clamp,mipnone>\n" +
			"mov ft3.w, ft1.z\n" +
			"mov ft1.x, ft3.y\n" +
			"mov ft1.y, ft3.z\n" +
			"mov ft1.z, ft3.w\n" +
			"mov ft1.w, fc1.z\n" +
			"mov ft3.y, ft0.x\n" +
			"mov ft4.x, ft0.y\n" +
			"mov ft3.y, ft3.y\n" +
			"mov ft3.z, ft4.x\n" +
			"mov ft3.w, fc0.z\n" +
			"mul ft3.yzw, ft3.yyzw, fc5.z\n" +
			"add ft3.yzw, fc6.xxyz, ft3.yyzw\n" +
			"mov ft4.x, v2.x\n" +
			"mov ft4.w, v2.y\n" +
			"mov ft5.x, v2.z\n" +
			"mov ft4.x, ft4.x\n" +
			"mov ft4.y, ft4.w\n" +
			"mov ft4.z, ft5.x\n" +
			"sub ft4.xyz, fc4.xyz, ft4.xyz\n" +
			"dp3 ft4.w, ft4.xyz, ft4.xyz\n" +
			"rsq ft4.w, ft4.w\n" +
			"mul ft4.xyz, ft4.xyz, ft4.w\n" +
			"dp3 ft3.y, ft4.xyz, ft3.yzw\n" +
			"sub ft3.y, fc1.z, ft3.y\n" +
			"pow ft3.y, ft3.y, fc5.x\n" +
			"min ft3.y, fc1.z, ft3.y\n" +
			"sub ft3.y, fc1.z, ft3.y\n" +
			"sub ft4, ft0, fc3.x\n" +
			"mul ft4, ft4, fc3.y\n" +
			"add ft1, ft1, ft4\n" +
			"mul ft1, ft1, ft3.y\n" +
			"sub ft3.y, fc1.z, ft3.y\n" +
			"mul ft2, ft2, ft3.y\n" +
			"add ft1, ft1, ft2\n" +
			"mov ft0.x, ft0.x\n" +
			"sub ft0.x, ft0.x, fc3.z\n" +
			"max ft0.x, fc0.z, ft0.x\n" +
			"mul ft0.x, ft0.x, fc3.w\n" +
			"mov ft0.y, fc1.z\n" +
			"sub ft0.y, ft0.y, fc7.x\n" +
			"mul ft0.x, ft0.x, ft0.y\n" +
			"add ft0, ft1, ft0.x\n" +
			"sub ft1.x, fc1.z, ft3.x\n" +
//			"mov ft0, ft0\n" +
			"mov ft0.w, ft1.x\n" +
//			"mov ft0, ft0\n" +
			"mov oc, ft0";

        public function Ocean(context3D:Context3D, texture:TextureBase, width:Number=2, length:Number=2, segmentsX:uint=5, segmentsY:uint=5, tileRepeatX:uint=1, tileRepeatY:uint=1, marginX:Number=0, marginY:Number=0){
            this.camPosition = new Vector3D();
            this.waveScale1 = new Point(1.822, 0.8);
            this.waveScale2 = new Point(1.2342, 0.8);
            this.waveScale1b = new Point(1.522, 0.8);
            this.waveScale2b = new Point(1.0342, 0.8);
            this.waveScale3 = new Point(0.3252, 0.5);
            this.waveScale4 = new Point(0.2735, 0.5);
            this.waveScale5 = new Point(0.0552, 0.4);
            this.waveScale6 = new Point(0.04735, 0.4);
            this.waveOffset1 = new Point();
            this.waveOffset2 = new Point();
            this.waveOffset1b = new Point();
            this.waveOffset2b = new Point();
            this.waveOffset3 = new Point();
            this.waveOffset4 = new Point();
            this.waveOffset5 = new Point();
            this.waveOffset6 = new Point();
            super(context3D, texture, width, length, segmentsX, segmentsY, tileRepeatX, tileRepeatY, marginX, marginY);
            this.waveScale1.x = (this.waveScale1.x / this.waveScale);
            this.waveScale2.x = (this.waveScale2.x / this.waveScale);
            this.waveScale3.x = (this.waveScale3.x / this.waveScale);
            this.waveScale4.x = (this.waveScale4.x / this.waveScale);
            this.waveScale5.x = (this.waveScale5.x / this.waveScale);
            this.waveScale6.x = (this.waveScale6.x / this.waveScale);
            this.waveScale1.y = (this.waveScale1.x * this.waveScale1.y);
            this.waveScale2.y = (this.waveScale2.x * this.waveScale2.y);
            this.waveScale3.y = (this.waveScale3.x * this.waveScale3.y);
            this.waveScale4.y = (this.waveScale4.x * this.waveScale4.y);
            this.waveScale5.y = (this.waveScale5.x * this.waveScale5.y);
            this.waveScale6.y = (this.waveScale6.x * this.waveScale6.y);
        }
        override protected function initPrograms():void{
//            var inputVertexProgram:PBASMProgram = new PBASMProgram(this.readFile(oceanVertexProgram));
//            var inputMaterialVertexProgram:PBASMProgram = new PBASMProgram(this.readFile(oceanMaterialVertexProgramTextured));
//            var inputFragmentProgram:PBASMProgram = new PBASMProgram(this.readFile(oceanFragmentProgramTextured));
//            var programs:AGALProgramPair = PBASMCompiler.compile(inputVertexProgram, inputMaterialVertexProgram, inputFragmentProgram);
//            var agalVertexBinary:ByteArray = programs.vertexProgram.byteCode;
//            var agalFragmentBinary:ByteArray = programs.fragmentProgram.byteCode;
//            this.vertexRegisterMap = programs.vertexProgram.registers;
//            this.fragmentRegisterMap = programs.fragmentProgram.registers;
//            this.vertexProgramConstantValues_ = new Vector.<Number>((this.nRegisters(this.vertexRegisterMap) * 4));
//            this.fragmentProgramConstantValues_ = new Vector.<Number>((this.nRegisters(this.fragmentRegisterMap) * 4));
//            this.initializeNumericalConstants(this.vertexRegisterMap.numericalConstants, this.vertexProgramConstantValues_);
//            this.initializeNumericalConstants(this.fragmentRegisterMap.numericalConstants, this.fragmentProgramConstantValues_);
//            this.parameterBufferHelper = new ProgramConstantsHelper(context3D, this.vertexRegisterMap, this.fragmentRegisterMap);
 
			var assembler:* = new AGALMiniAssembler(false);
			assembler.assemble("vertex", vertexCode);
			var agalVertexBinary:* = assembler.agalcode;
			
			assembler.assemble("fragment", fragmentCode);
			var agalFragmentBinary:* = assembler.agalcode;
			
			_shaderProgram = context3D.createProgram();
			
            _shaderProgram.upload(agalVertexBinary, agalFragmentBinary);
        }
//        private function initializeNumericalConstants(numericalConstants:NumericalConstantInfo, constantValues:Vector.<Number>):void{
//            var offset:int = (numericalConstants.startRegister * 4);
//            var i:int;
//            while (i < numericalConstants.values.length) {
//                constantValues[(i + offset)] = numericalConstants.values[i];
//                i++;
//            };
//        }
//        public function nRegisters(registerMap:RegisterMap):int{
//            var pr:ParameterRegisterInfo;
//            var n:int;
//            n = Math.max(n, (registerMap.numericalConstants.values.length / 4));
//            for each (pr in registerMap.parameterRegisters) {
//                n = Math.max(n, (pr.elementGroup.elements[(pr.elementGroup.elements.length - 1)].registerIndex + 1));
//            };
//            return (n);
//        }
        private function readFile(f:Class):String{
            var bytes:ByteArray;
            bytes = new (f)();
            return (bytes.readUTFBytes(bytes.bytesAvailable));
        }
        override public function update():void{
            this.waveOffset1.x = (this.waveOffset1.x + (-0.00544 * this.waveSpeed));
            this.waveOffset1.y = (this.waveOffset1.y + (-0.00435 * this.waveSpeed));
            this.waveOffset2.x = (this.waveOffset2.x + (-0.0052 * this.waveSpeed));
            this.waveOffset2.y = (this.waveOffset2.y + (0.00475 * this.waveSpeed));
            this.waveOffset1b.x = (this.waveOffset1b.x + (-0.00514 * this.waveSpeed));
            this.waveOffset1b.y = (this.waveOffset1b.y + (-0.00405 * this.waveSpeed));
            this.waveOffset2b.x = (this.waveOffset2b.x + (-0.00484 * this.waveSpeed));
            this.waveOffset2b.y = (this.waveOffset2b.y + (0.00435 * this.waveSpeed));
            this.waveOffset3.x = (this.waveOffset3.x + (-0.00313 * this.waveSpeed));
            this.waveOffset3.y = (this.waveOffset3.y + (-0.00272 * this.waveSpeed));
            this.waveOffset4.x = (this.waveOffset4.x + (-0.002732 * this.waveSpeed));
            this.waveOffset4.y = (this.waveOffset4.y + (0.002223 * this.waveSpeed));
            this.waveOffset5.x = (this.waveOffset5.x + (-0.0014533 * this.waveSpeed));
            this.waveOffset5.y = (this.waveOffset5.y + (-0.001262 * this.waveSpeed));
            this.waveOffset6.x = (this.waveOffset6.x + (-0.00097532 * this.waveSpeed));
            this.waveOffset6.y = (this.waveOffset6.y + (0.0008323 * this.waveSpeed));
        }
        public function drawOcean(t:Number=0, viewMatrix:Matrix3D=null, projectionMatrix:Matrix3D=null, transformMatrix:Matrix3D=null, underwater:Boolean=false):void{
            var oceanNormal:Vector.<Number>;
            if (transformMatrix == null){
                transformMatrix = new Matrix3D();
                transformMatrix.identity();
            };
            context3D.setProgram(_shaderProgram);
            context3D.setTextureAt(0, texture);
            context3D.setTextureAt(1, this.reflectionMap);
            context3D.setTextureAt(2, this.refractionMap);
            context3D.setVertexBufferAt(0, _vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
            context3D.setVertexBufferAt(1, _vertexBuffer, 3, Context3DVertexBufferFormat.FLOAT_2);
			
//			vc0 : objectToClipSpaceTransform : float4x4
//			vc4 : waveSurfaceAmpFreqPhaseAngle : float4
//			vc5 : waveSurfaceAmpFreqPhaseAngle2 : float4
//			vc6 : waveSurfaceWidthO2 : float1
//            this.parameterBufferHelper.setNumberParameterByName(Context3DProgramType.VERTEX, "waveSurfaceWidthO2", Vector.<Number>([(width / 2)]));
//            this.parameterBufferHelper.setNumberParameterByName(Context3DProgramType.VERTEX, "waveSurfaceAmpFreqPhaseAngle", Vector.<Number>([this.waveSurfaceAmp1, this.waveSurfaceFreq1, ((t * this.waveSurfaceVel1) + this.waveSurfacePhase1), this.waveSurfaceAngle1]));
//            this.parameterBufferHelper.setNumberParameterByName(Context3DProgramType.VERTEX, "waveSurfaceAmpFreqPhaseAngle2", Vector.<Number>([this.waveSurfaceAmp2, this.waveSurfaceFreq2, ((t * this.waveSurfaceVel2) + this.waveSurfacePhase2), this.waveSurfaceAngle2]));
			context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 4, Vector.<Number>([this.waveSurfaceAmp1, this.waveSurfaceFreq1, ((t * this.waveSurfaceVel1) + this.waveSurfacePhase1), this.waveSurfaceAngle1]));
			context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 5, Vector.<Number>([this.waveSurfaceAmp2, this.waveSurfaceFreq2, ((t * this.waveSurfaceVel2) + this.waveSurfacePhase2), this.waveSurfaceAngle2]));
			context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 6, Vector.<Number>([(width / 2, 0, 0, 0)]));
			

//			fc4 : camPosition : float3
//			fc4 : edgeRefractDistMultiplier : float1
//			this.parameterBufferHelper.setNumberParameterByName(Context3DProgramType.FRAGMENT, "camPosition", Vector.<Number>([this.camPosition.x, this.camPosition.y, this.camPosition.z]));
//          this.parameterBufferHelper.setNumberParameterByName(Context3DProgramType.FRAGMENT, "edgeRefractDistMultiplier", Vector.<Number>([150]));
			context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 4, Vector.<Number>([this.camPosition.x, this.camPosition.y, this.camPosition.z, 150]));

			var fresnelPow:Number = 0;
            var reflectionPerturbationAmount:Number = 0;
            var refractionPerturbationAmount:Number = 0;
            var underwaterAmount:Number = 0;
            if (underwater){
                oceanNormal = Vector.<Number>([0, 0, -1]);
                fresnelPow = 0.5;
                reflectionPerturbationAmount = 0.2;
                refractionPerturbationAmount = 1.5;
            } else {
                oceanNormal = Vector.<Number>([0, 0, 1]);
                fresnelPow = 8;
                reflectionPerturbationAmount = 1;
                refractionPerturbationAmount = 0.1;
            };
            if (this.camPosition.z < -0.01){
                underwaterAmount = 1;
            } else {
                if (this.camPosition.z < 0.01){
                    underwaterAmount = (1 - ((this.camPosition.z + 0.01) / 0.02));
                };
            };
			
			context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, Vector.<Number>([4, 0.5, 0, 0.1666]));
			context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, Vector.<Number>([0.005, 2, 1, 0.1]));
			context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 2, Vector.<Number>([0.0125, 0.0125, 0, 0]));
			context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 3, Vector.<Number>([0.45, 0.15, 0.03, 15]));
			

//			fc5 : fresnelPow : float1
//			fc5 : edgeRefractMultiplier : float1
//			fc5 : normalPerturbation : float1
//          this.parameterBufferHelper.setNumberParameterByName(Context3DProgramType.FRAGMENT, "fresnelPow", Vector.<Number>([fresnelPow]));
//			this.parameterBufferHelper.setNumberParameterByName(Context3DProgramType.FRAGMENT, "edgeRefractMultiplier", Vector.<Number>([-2.5]));
//          this.parameterBufferHelper.setNumberParameterByName(Context3DProgramType.FRAGMENT, "normalPerturbation", Vector.<Number>([(underwater) ? 1 : 0.2]));
			
			context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 5, Vector.<Number>([fresnelPow, -2.5, (underwater) ? 1 : 0.2, 0]));
			
			
			//fc6 : normalVector : float3
//			this.parameterBufferHelper.setNumberParameterByName(Context3DProgramType.FRAGMENT, "normalVector", oceanNormal);
			context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 6, oceanNormal);
			
//			fc7 : underwater : float1
//			fc7 : reflectionPerturbationAmount : float1
//			fc7 : refractionPerturbationAmount : float1
//			fc7 : reflectionYOffset : float1
//            this.parameterBufferHelper.setNumberParameterByName(Context3DProgramType.FRAGMENT, "underwater", Vector.<Number>([underwaterAmount]));
//            this.parameterBufferHelper.setNumberParameterByName(Context3DProgramType.FRAGMENT, "reflectionPerturbationAmount", Vector.<Number>([reflectionPerturbationAmount]));
//            this.parameterBufferHelper.setNumberParameterByName(Context3DProgramType.FRAGMENT, "refractionPerturbationAmount", Vector.<Number>([refractionPerturbationAmount]));
//			this.parameterBufferHelper.setNumberParameterByName(Context3DProgramType.FRAGMENT, "reflectionYOffset", Vector.<Number>([(0.005 * ((underwater) ? 1 : -1))]));
			context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 7, Vector.<Number>([underwaterAmount, reflectionPerturbationAmount, refractionPerturbationAmount, (0.005 * ((underwater) ? 1 : -1))]));
			
//			fc8 : waveOffset1 : float2
//			fc8 : waveScale3 : float2
//			this.parameterBufferHelper.setNumberParameterByName(Context3DProgramType.FRAGMENT, "waveOffset1", Vector.<Number>([this.waveOffset1.y, this.waveOffset1.x]));
//			this.parameterBufferHelper.setNumberParameterByName(Context3DProgramType.FRAGMENT, "waveScale3", Vector.<Number>([this.waveScale3.y, this.waveScale3.x]));
			context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 8, Vector.<Number>([this.waveOffset1.y, this.waveOffset1.x, this.waveScale3.y, this.waveScale3.x]));
			
//			fc9 : waveOffset2 : float2
//			fc9 : waveOffset3 : float2
//			this.parameterBufferHelper.setNumberParameterByName(Context3DProgramType.FRAGMENT, "waveOffset2", Vector.<Number>([this.waveOffset2.y, this.waveOffset2.x]));
//			this.parameterBufferHelper.setNumberParameterByName(Context3DProgramType.FRAGMENT, "waveOffset3", Vector.<Number>([this.waveOffset3.y, this.waveOffset3.x]));
			context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 9, Vector.<Number>([this.waveOffset2.y, this.waveOffset2.x, this.waveOffset3.y, this.waveOffset3.x]));
			
//			fc10 : waveOffset4 : float2
//			fc10 : waveScale5 : float2
//			this.parameterBufferHelper.setNumberParameterByName(Context3DProgramType.FRAGMENT, "waveOffset4", Vector.<Number>([this.waveOffset4.y, this.waveOffset4.x]));
//			this.parameterBufferHelper.setNumberParameterByName(Context3DProgramType.FRAGMENT, "waveScale5", Vector.<Number>([this.waveScale5.y, this.waveScale5.x]));
			context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 10, Vector.<Number>([this.waveOffset4.y, this.waveOffset4.x, this.waveScale5.y, this.waveScale5.x]));
			
//			fc11 : waveOffset5 : float2
//			fc11 : waveOffset6 : float2
//			this.parameterBufferHelper.setNumberParameterByName(Context3DProgramType.FRAGMENT, "waveOffset5", Vector.<Number>([this.waveOffset5.y, this.waveOffset5.x]));
//			this.parameterBufferHelper.setNumberParameterByName(Context3DProgramType.FRAGMENT, "waveOffset6", Vector.<Number>([this.waveOffset6.y, this.waveOffset6.x]));
			context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 11, Vector.<Number>([this.waveOffset5.y, this.waveOffset5.x, this.waveOffset6.y, this.waveOffset6.x]));

//			fc12 : waveScale2 : float2
//			fc12 : waveScale1 : float2
//			this.parameterBufferHelper.setNumberParameterByName(Context3DProgramType.FRAGMENT, "waveScale2", Vector.<Number>([this.waveScale2.y, this.waveScale2.x]));
//			this.parameterBufferHelper.setNumberParameterByName(Context3DProgramType.FRAGMENT, "waveScale1", Vector.<Number>([this.waveScale1.y, this.waveScale1.x]));
			context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 12, Vector.<Number>([this.waveScale2.y, this.waveScale2.x, this.waveScale1.y, this.waveScale1.x]));

			
//			fc13 : waveScale4 : float2
//			fc13 : waveScale6 : float2
//            this.parameterBufferHelper.setNumberParameterByName(Context3DProgramType.FRAGMENT, "waveScale4", Vector.<Number>([this.waveScale4.y, this.waveScale4.x]));
//            this.parameterBufferHelper.setNumberParameterByName(Context3DProgramType.FRAGMENT, "waveScale6", Vector.<Number>([this.waveScale6.y, this.waveScale6.x]));
			context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 13, Vector.<Number>([this.waveScale4.y, this.waveScale4.x, this.waveScale6.y, this.waveScale6.x]));

			
			
			var newViewMatrix:Matrix3D = new Matrix3D();
            newViewMatrix.append(viewMatrix);
            var newTransformMatrix:Matrix3D = new Matrix3D();
            newTransformMatrix.append(this.worldMatrix);
            newTransformMatrix.append(transformMatrix);
            renderMatrix = new Matrix3D();
            renderMatrix.append(newTransformMatrix);
            renderMatrix.append(newViewMatrix);
            renderMatrix.append(projectionMatrix);
			
			
			context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, renderMatrix, true);
//            this.parameterBufferHelper.setMatrixParameterByName(Context3DProgramType.VERTEX, "objectToClipSpaceTransform", renderMatrix, true);
			
			
//            this.parameterBufferHelper.setNumberParameterByName(Context3DProgramType.VERTEX, "one", Vector.<Number>([1]));
//            this.parameterBufferHelper.setNumberParameterByName(Context3DProgramType.VERTEX, "zero", Vector.<Number>([0]));
//            this.parameterBufferHelper.update();
            context3D.setDepthTest(true, Context3DCompareMode.LESS);
            context3D.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
            context3D.drawTriangles(_indexBuffer, 0, numTriangles);
            context3D.setTextureAt(0, null);
            context3D.setTextureAt(1, null);
            context3D.setTextureAt(2, null);
            context3D.setVertexBufferAt(0, null);
            context3D.setVertexBufferAt(1, null);
        }

    }
}//package nz.co.resn.molehill.island 
