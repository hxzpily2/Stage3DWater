//Created by Action Script Viewer - http://www.buraks.com/asv
package nz.co.resn.molehill.base {
    import flash.geom.*;

    public class Vector3DUtil {

        public static const DEG2RAD:Number = 0.0174532925199433;

        public static function rotateX(sourcePoint:Vector3D, angle:Number):Vector3D{
            angle = (angle * DEG2RAD);
            var cosRY:Number = Math.cos(angle);
            var sinRY:Number = Math.sin(angle);
            var newPoint:Vector3D = new Vector3D();
            newPoint.copyFrom(sourcePoint);
            newPoint.y = ((sourcePoint.y * cosRY) - (sourcePoint.z * sinRY));
            newPoint.z = ((sourcePoint.y * sinRY) + (sourcePoint.z * cosRY));
            return (newPoint);
        }
        public static function rotateY(sourcePoint:Vector3D, angle:Number):Vector3D{
            angle = (angle * DEG2RAD);
            var cosRY:Number = Math.cos(angle);
            var sinRY:Number = Math.sin(angle);
            var newPoint:Vector3D = new Vector3D();
            newPoint.copyFrom(sourcePoint);
            newPoint.x = ((sourcePoint.x * cosRY) + (sourcePoint.z * sinRY));
            newPoint.z = ((sourcePoint.x * -(sinRY)) + (sourcePoint.z * cosRY));
            return (newPoint);
        }
        public static function rotateZ(sourcePoint:Vector3D, angle:Number):Vector3D{
            angle = (angle * DEG2RAD);
            var cosRY:Number = Math.cos(angle);
            var sinRY:Number = Math.sin(angle);
            var newPoint:Vector3D = new Vector3D();
            newPoint.copyFrom(sourcePoint);
            newPoint.x = ((sourcePoint.x * cosRY) - (sourcePoint.y * sinRY));
            newPoint.y = ((sourcePoint.x * sinRY) + (sourcePoint.y * cosRY));
            return (newPoint);
        }

    }
}//package nz.co.resn.molehill.base 
