//Created by Action Script Viewer - http://www.buraks.com/asv
package nz.co.resn.molehill.base {
    import flash.geom.*;
    import nz.co.resn.base.core.*;

    public class Object3D extends ResnEventDispatcher {

        protected var _scale:Number = 1;
        protected var _position:Vector3D;
        protected var _rotation:Vector3D;

        public function Object3D(){
            super();
            this.position = new Vector3D();
            this.rotation = new Vector3D();
        }
        public function get worldMatrix():Matrix3D{
            var newMatrix:Matrix3D = this.scaleMatrix;
            newMatrix.append(this.rotationMatrix);
            newMatrix.append(this.positionMatrix);
            return (newMatrix);
        }
        protected function get positionMatrix():Matrix3D{
            var newMatrix:Matrix3D = new Matrix3D();
            newMatrix.appendTranslation(this.position.x, this.position.y, this.position.z);
            return (newMatrix);
        }
        public function get rotationMatrix():Matrix3D{
            var newMatrix:Matrix3D = new Matrix3D();
            newMatrix.appendRotation(this.rotation.z, Vector3D.Z_AXIS);
            newMatrix.appendRotation(this.rotation.y, Vector3D.Y_AXIS);
            newMatrix.appendRotation(this.rotation.x, Vector3D.X_AXIS);
            return (newMatrix);
        }
        protected function get scaleMatrix():Matrix3D{
            var newMatrix:Matrix3D = new Matrix3D();
            newMatrix.appendScale(this.scale, this.scale, this.scale);
            return (newMatrix);
        }
        public function get scale():Number{
            return (this._scale);
        }
        public function set scale(value:Number):void{
            this._scale = value;
        }
        public function get position():Vector3D{
            return (this._position);
        }
        public function set position(value:Vector3D):void{
            this._position = value;
        }
        public function get rotation():Vector3D{
            return (this._rotation);
        }
        public function set rotation(value:Vector3D):void{
            this._rotation = value;
        }
        public function draw(t:Number=0, viewMatrix:Matrix3D=null, projectionMatrix:Matrix3D=null, transformMatrix:Matrix3D=null):void{
        }
        public function update():void{
        }

    }
}//package nz.co.resn.molehill.base 
