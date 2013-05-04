//Created by Action Script Viewer - http://www.buraks.com/asv
package nz.co.resn.molehill.base {
    import flash.geom.*;

    public class Camera3D extends Object3D {

        public static const DEG2RAD:Number = 0.0174532925199433;
        public static const DEG2RAD_2:Number = 0.00872664625997165;

        protected var _viewMatrix:Matrix3D;
        protected var _aspect:Number = 1.33333333333333;
        protected var _zNear:Number = 0.1;
        protected var _zFar:Number = 10000;
        protected var _fovDegrees:Number = 60;
        private var _moveSpeed:Number = 0.05;
        private var offset:Vector3D;
        private var offsetVel:Vector3D;
        private var targetOffset:Vector3D;
        public var velAccel:Number = 0.005;
        public var velDecel:Number = 0.9;

        public function Camera3D(){
            super();
            this.offset = new Vector3D();
            this.offsetVel = new Vector3D();
            this.targetOffset = new Vector3D();
            this.viewMatrix = new Matrix3D();
            this.viewMatrix.identity();
        }
        public function set viewMatrix(value:Matrix3D):void{
            this._viewMatrix = value;
        }
        public function get viewMatrix():Matrix3D{
            var newMatrix:Matrix3D = this.positionMatrix;
            newMatrix.append(rotationMatrix);
            this._viewMatrix = newMatrix;
            return (this._viewMatrix);
        }
        override protected function get positionMatrix():Matrix3D{
            var newMatrix:Matrix3D = new Matrix3D();
            newMatrix.appendTranslation(-(position.x), position.y, position.z);
            return (newMatrix);
        }
        public function get projectionMatrix():Matrix3D{
            return (this.makeProjectionMatrix());
        }
        public function get screenViewMatrix():Matrix3D{
            var newMatrix:Matrix3D = this.screenPositionMatrix;
            newMatrix.append(this.screenRotationMatrix);
            return (newMatrix);
        }
        protected function get screenPositionMatrix():Matrix3D{
            var newMatrix:Matrix3D = new Matrix3D();
            newMatrix.appendTranslation(-(position.x), position.y, position.z);
            return (newMatrix);
        }
        public function get screenRotationMatrix():Matrix3D{
            var newMatrix:Matrix3D = new Matrix3D();
            newMatrix.appendRotation(rotation.z, Vector3D.Z_AXIS);
            newMatrix.appendRotation(rotation.y, Vector3D.Y_AXIS);
            newMatrix.appendRotation(rotation.x, Vector3D.X_AXIS);
            return (newMatrix);
        }
        public function get screenProjectionMatrix():Matrix3D{
            return (this.makeScreenProjectionMatrix());
        }
        public function get reflectedViewMatrix():Matrix3D{
            var newMatrix:Matrix3D = this.reflectedPositionMatrix;
            newMatrix.append(this.reflectedRotationMatrix);
            return (newMatrix);
        }
        protected function get reflectedPositionMatrix():Matrix3D{
            var newMatrix:Matrix3D = new Matrix3D();
            newMatrix.appendTranslation(-(position.x), -(position.y), position.z);
            return (newMatrix);
        }
        public function get reflectedRotationMatrix():Matrix3D{
            var newMatrix:Matrix3D = new Matrix3D();
            newMatrix.appendRotation(rotation.z, Vector3D.Z_AXIS);
            newMatrix.appendRotation(rotation.y, Vector3D.Y_AXIS);
            newMatrix.appendRotation(-(rotation.x), Vector3D.X_AXIS);
            return (newMatrix);
        }
        public function makeProjectionMatrix():Matrix3D{
            var yval:Number = (this.zNear * Math.tan((this.fovDegrees * DEG2RAD_2)));
            var xval:Number = (yval * this.aspect);
            return (this.makeFrustumMatrix(-(xval), xval, -(yval), yval, this.zNear, this.zFar));
        }
        public function makeScreenProjectionMatrix():Matrix3D{
            var yval:Number = (this.zNear * Math.tan((this.fovDegrees * DEG2RAD_2)));
            var xval:Number = (yval * this.aspect);
            var frustrumMatrix:Matrix3D = this.makeFrustumMatrix(-(xval), xval, -(yval), yval, this.zNear, this.zFar);
            return (frustrumMatrix);
        }
        public function get aspect():Number{
            return (this._aspect);
        }
        public function set aspect(value:Number):void{
            this._aspect = value;
        }
        public function get zNear():Number{
            return (this._zNear);
        }
        public function set zNear(value:Number):void{
            this._zNear = value;
        }
        public function get zFar():Number{
            return (this._zFar);
        }
        public function set zFar(value:Number):void{
            this._zFar = value;
        }
        public function get fovDegrees():Number{
            return (this._fovDegrees);
        }
        public function set fovDegrees(value:Number):void{
            this._fovDegrees = value;
        }
        public function get moveSpeed():Number{
            return (this._moveSpeed);
        }
        public function set moveSpeed(value:Number):void{
            this._moveSpeed = value;
        }
        public function makeFrustumMatrix(left:Number, right:Number, top:Number, bottom:Number, zNear:Number, zFar:Number):Matrix3D{
            return (new Matrix3D(Vector.<Number>([((2 * zNear) / (right - left)), 0, ((right + left) / (right - left)), 0, 0, ((2 * zNear) / (top - bottom)), ((top + bottom) / (top - bottom)), 0, 0, 0, (zFar / (zNear - zFar)), -1, 0, 0, ((zNear * zFar) / (zNear - zFar)), 0])));
        }
        public function resetMovement():void{
            this.targetOffset.x = 0;
            this.targetOffset.y = 0;
            this.targetOffset.z = 0;
        }
        public function moveForward():void{
            this.targetOffset.z = (this.targetOffset.z + this.moveSpeed);
        }
        public function moveBack():void{
            this.targetOffset.z = (this.targetOffset.z + -(this.moveSpeed));
        }
        public function moveLeft():void{
            this.targetOffset.x = (this.targetOffset.x + -(this.moveSpeed));
        }
        public function moveRight():void{
            this.targetOffset.x = (this.targetOffset.x + this.moveSpeed);
        }
        public function moveUp():void{
            this.targetOffset.y = (this.targetOffset.y + this.moveSpeed);
        }
        public function moveDown():void{
            this.targetOffset.y = (this.targetOffset.y + -(this.moveSpeed));
        }
        private function offsetCamera(offsetX:Number, offsetY:Number, offsetZ:Number):void{
            this.targetOffset.x = offsetX;
            this.targetOffset.y = offsetY;
            this.targetOffset.z = offsetZ;
        }
        override public function update():void{
            this.offsetVel.x = (this.offsetVel.x + ((this.targetOffset.x - this.offset.x) * this.velAccel));
            this.offsetVel.y = (this.offsetVel.y + ((this.targetOffset.y - this.offset.y) * this.velAccel));
            this.offsetVel.z = (this.offsetVel.z + ((this.targetOffset.z - this.offset.z) * this.velAccel));
            this.offsetVel.x = (this.offsetVel.x * this.velDecel);
            this.offsetVel.y = (this.offsetVel.y * this.velDecel);
            this.offsetVel.z = (this.offsetVel.z * this.velDecel);
            this.offset.x = (this.offset.x + this.offsetVel.x);
            this.offset.y = (this.offset.y + this.offsetVel.y);
            this.offset.z = (this.offset.z + this.offsetVel.z);
            var positionOffset:Vector3D = new Vector3D(this.offset.x, this.offset.y, this.offset.z);
            positionOffset = Vector3DUtil.rotateX(positionOffset, -(rotation.x));
            positionOffset = Vector3DUtil.rotateY(positionOffset, rotation.y);
            position.x = (position.x + positionOffset.x);
            position.y = (position.y + positionOffset.y);
            position.z = (position.z + positionOffset.z);
        }
        public function getWorldPosition():Vector3D{
            return (new Vector3D(position.x, position.z, position.y));
        }

    }
}//package nz.co.resn.molehill.base 
