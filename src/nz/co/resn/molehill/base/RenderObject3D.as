//Created by Action Script Viewer - http://www.buraks.com/asv
package nz.co.resn.molehill.base {
    import flash.geom.*;
    import flash.display3D.*;
    import com.adobe.utils.*;
    import __AS3__.vec.*;
    import flash.display3D.textures.*;

    public class RenderObject3D extends Object3D {

        protected var _texture:TextureBase;
        protected var _context3D:Context3D;
        protected var _vertices:Vector.<Number>;
        protected var _indencies:Vector.<uint>;
        protected var _indexBuffer:IndexBuffer3D;
        protected var _vertexBuffer:VertexBuffer3D;
        protected var _fragmentShaderAssembler:AGALMiniAssembler;
        protected var _vertexShaderAssembler:AGALMiniAssembler;
        protected var _shaderProgram:Program3D;
        protected var renderMatrix:Matrix3D;

        public function RenderObject3D(context3D:Context3D){
            this._vertices = new Vector.<Number>();
            this._indencies = new Vector.<uint>();
            super();
            this.context3D = context3D;
        }
        protected function initPrograms():void{
        }
        public function get context3D():Context3D{
            return (this._context3D);
        }
        public function set context3D(value:Context3D):void{
            this._context3D = value;
        }
        public function get texture():TextureBase{
            return (this._texture);
        }
        public function set texture(value:TextureBase):void{
            this._texture = value;
        }

    }
}//package nz.co.resn.molehill.base 
