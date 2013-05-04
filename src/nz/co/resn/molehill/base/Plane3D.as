//Created by Action Script Viewer - http://www.buraks.com/asv
package nz.co.resn.molehill.base {
    import flash.display3D.*;
    import flash.display3D.textures.*;
    import com.adobe.utils.*;
    import __AS3__.vec.*;
    import flash.geom.*;

    public class Plane3D extends RenderObject3D {

        protected var width:Number;
        protected var length:Number;
        protected var segmentsX:uint;
        protected var segmentsY:uint;
        protected var tileRepeatX:uint;
        protected var tileRepeatY:uint;
        protected var marginX:uint;
        protected var marginY:uint;
        protected var numTriangles:uint;
        protected var dataPerVertex:uint = 5;

        public function Plane3D(context3D:Context3D, texture:TextureBase, width:Number=2, length:Number=2, segmentsX:uint=5, segmentsY:uint=5, tileRepeatX:uint=1, tileRepeatY:uint=1, marginX:Number=0, marginY:Number=0){
            super(context3D);
            this.width = width;
            this.length = length;
            this.segmentsX = segmentsX;
            this.segmentsY = segmentsY;
            this.tileRepeatX = tileRepeatX;
            this.tileRepeatY = tileRepeatY;
            this.marginX = marginX;
            this.marginY = marginY;
            this.texture = texture;
            this.initModel();
        }
        private function initModel():void{
            this.makePlaneMesh(this.segmentsX, this.segmentsY);
            this.initPrograms();
        }
        override protected function initPrograms():void{
            _vertexShaderAssembler = new AGALMiniAssembler();
            _vertexShaderAssembler.assemble(Context3DProgramType.VERTEX, (((("dp4 op.x, va0, vc0\t\t\n" + "dp4 op.y, va0, vc1\t\t\n") + "dp4 op.z, va0, vc2\t\t\n") + "dp4 op.w, va0, vc3\t\t\n") + "mov v0, va1.xyzw\t\t\n"));
            _fragmentShaderAssembler = new AGALMiniAssembler();
            _fragmentShaderAssembler.assemble(Context3DProgramType.FRAGMENT, (("mov ft0, v0\n" + "tex ft1, ft0, fs0 <2d,wrap,linear>\n") + "mov oc, ft1\n"));
            _shaderProgram = context3D.createProgram();
            _shaderProgram.upload(_vertexShaderAssembler.agalcode, _fragmentShaderAssembler.agalcode);
        }
        protected function makePlaneMesh(nu:uint, nv:uint):void{
            var i:uint;
            var j:uint;
            var u:uint;
            var v:uint;
            var vertexX:Number;
            var vertexY:Number;
            var vertexZ:Number;
            var vertexU:Number;
            var vertexV:Number;
            var vf:Number;
            var uf:Number;
            this.numTriangles = (((nu - 1) * (nv - 1)) * 2);
            _indencies = new Vector.<uint>((this.numTriangles * 3));
            v = 0;
            i = 0;
            j = 0;
            while (v < (nv - 1)) {
                u = 0;
                while (u < (nu - 1)) {
                    _indencies[(j + 0)] = i;
                    _indencies[(j + 1)] = (i + nu);
                    _indencies[(j + 2)] = ((i + nu) + 1);
                    _indencies[(j + 3)] = i;
                    _indencies[(j + 4)] = ((i + nu) + 1);
                    _indencies[(j + 5)] = (i + 1);
                    j = (j + 6);
                    i++;
                    u++;
                };
                i++;
                v++;
            };
            _vertices = new Vector.<Number>(((nv * nu) * this.dataPerVertex));
            i = 0;
            v = 0;
            while (v < nv) {
                vf = (v / (nv - 1));
                u = 0;
                while (u < nu) {
                    uf = (u / (nu - 1));
                    vertexX = ((uf - 0.5) * this.width);
                    vertexY = ((vf - 0.5) * this.length);
                    vertexZ = 0;
                    vertexU = (uf * this.tileRepeatX);
                    vertexV = (vf * this.tileRepeatY);
                    if (u == 0){
                        vertexX = (vertexX - this.marginX);
                        vertexU = (vertexU - ((this.marginX / this.width) * this.tileRepeatX));
                    };
                    if (u == (nu - 1)){
                        vertexX = (vertexX + this.marginX);
                        vertexU = (vertexU + ((this.marginX / this.width) * this.tileRepeatX));
                    };
                    if (v == 0){
                        vertexY = (vertexY - this.marginY);
                        vertexV = (vertexV - ((this.marginX / this.width) * this.tileRepeatX));
                    };
                    if (v == (nv - 1)){
                        vertexY = (vertexY + this.marginY);
                        vertexV = (vertexV + ((this.marginX / this.width) * this.tileRepeatX));
                    };
                    _vertices[(i + 0)] = vertexX;
                    _vertices[(i + 1)] = vertexY;
                    _vertices[(i + 2)] = vertexZ;
                    _vertices[(i + 3)] = vertexU;
                    _vertices[(i + 4)] = vertexV;
                    i = (i + this.dataPerVertex);
                    u++;
                };
                v++;
            };
            _indexBuffer = context3D.createIndexBuffer((this.numTriangles * 3));
            _indexBuffer.uploadFromVector(_indencies, 0, (this.numTriangles * 3));
            _vertexBuffer = context3D.createVertexBuffer((nv * nu), this.dataPerVertex);
            _vertexBuffer.uploadFromVector(_vertices, 0, (nu * nv));
        }
        override public function draw(t:Number=0, viewMatrix:Matrix3D=null, projectionMatrix:Matrix3D=null, transformMatrix:Matrix3D=null):void{
            var newTransformMatrix:Matrix3D;
            if (transformMatrix == null){
                transformMatrix = new Matrix3D();
                transformMatrix.identity();
            };
            context3D.setProgram(_shaderProgram);
            context3D.setTextureAt(0, texture);
            context3D.setVertexBufferAt(0, _vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
            context3D.setVertexBufferAt(1, _vertexBuffer, 3, Context3DVertexBufferFormat.FLOAT_2);
            var newViewMatrix:Matrix3D = new Matrix3D();
            newViewMatrix.appendRotation(180, Vector3D.X_AXIS);
            newViewMatrix.append(viewMatrix);
            newTransformMatrix = new Matrix3D();
            newTransformMatrix.append(this.worldMatrix);
            newTransformMatrix.append(transformMatrix);
            renderMatrix = new Matrix3D();
            renderMatrix.append(newTransformMatrix);
            renderMatrix.append(newViewMatrix);
            renderMatrix.append(projectionMatrix);
            context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, renderMatrix, true);
            context3D.drawTriangles(_indexBuffer, 0, this.numTriangles);
            context3D.setVertexBufferAt(0, null);
            context3D.setVertexBufferAt(1, null);
            context3D.setVertexBufferAt(3, null);
        }

    }
}//package nz.co.resn.molehill.base 
