package flashbite.helpers;

import flashbite.logger.Logger;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.geom.Point;

/**
 * Global helpers uncategorized
 * 
 * @author Adrian Barbu
 */
@:final
class HelpersGlobal 
{
	private function new() {}
	
	/**
	 * Get a string representation of the class name
	 * 
	 * @param	object = object to query for information
	 * @param	fullClass = tells if the full qualified class name should be returned
	 * @return : a string, for example : openfl.display.Sprite if fullClass=true, Sprite if fullClass=false
	 */
	public static function getClassName(object:Dynamic, fullClass:Bool = false):String
	{
		var className:String = Type.getClassName(Type.getClass(object));
		if (fullClass == false) {
			className = className.split(".").pop();
		}
		
		return className;
	}
	
	public static function getCaseInsensitivePropValuePercent(obj:Dynamic, propName:String, log:Bool = false):Float
	{
		var realPropName:String = HelpersString.getCaseInsensitivePropName(obj, propName, log);
		if (realPropName != null) {
			var realValue:Dynamic = Reflect.getProperty(obj, realPropName);
			if (Std.is(realValue, String)) {
				var valueAsString:String = cast realValue;
				var percent:Float = 100;
				if (valueAsString.indexOf("%") != -1) {
					valueAsString = valueAsString.split("%").join("");
					percent = Std.parseFloat(valueAsString);
				}
				
				if (Math.isNaN(percent) == false && percent > 0) {
					return percent / 100;
				} else {
					return 0;
				}
			}
		}
		
		return 0;
	}
	
	/** Get a caseInsensitive property value from an object */
	public static function getCaseInsensitivePropValue(obj:Dynamic, propName:String, defaultValue:Dynamic = null, restrictValuesList:Dynamic = null, log:Bool = false):Dynamic
	{
		var realPropName:String = HelpersString.getCaseInsensitivePropName(obj, propName, log);
		if (realPropName != null) {
			var realValue:Dynamic = Reflect.getProperty(obj, realPropName);
			//this is a little tricky, we must have a specific type of Array
			if (restrictValuesList != null && realValue != null && Std.is(realValue, String) && Std.is(restrictValuesList, Array)) {
				var length:Int = Std.parseInt(Reflect.getProperty(restrictValuesList, "length"));
				for (i in 0...length) {
					var value:String = Std.string(Reflect.getProperty(restrictValuesList, Std.string(i)));
					if (HelpersString.toLowerCase(value) == HelpersString.toLowerCase(Std.string(realValue))) {
						return value;
						break;
					}
				}
				if (log) {
					Logger.warning("HelpersGlobal", "getCaseInsensitivePropValue-- value " + realValue + " not in list " + restrictValuesList);
				}
			} else {
				return realValue;
			}
		}

		return defaultValue;
	}
	
	/** Checks if obj has the property specified */
	public static function hasProperty(obj:Dynamic, propertyName:String):Bool
	{
		var propertyNameFromObj = HelpersString.getCaseInsensitivePropName(obj, propertyName);
		if (propertyNameFromObj == null || propertyNameFromObj == "") {
			return false;
		} else {
			return true;
		}
	}
	
	/** Checks if obj has one of the properties specified */
	public static function hasOneOfProperty(obj:Dynamic, propertiesList:Array<String>):Bool
	{
		var hasOne:Bool = false;
		
		if (propertiesList.length != 0) {
			for (propertyName in propertiesList) {
				if (HelpersGlobal.hasProperty(obj, propertyName)) {
					hasOne = true;
					break;
				}
			}
		} else {
			hasOne = true;
		}
		
		return hasOne;
	}
	
	/** Checks if obj has all the properties specified */
	public static function hasAllProperties(obj:Dynamic, propertiesList:Array<String>):Bool
	{
		var hasAll:Bool = true;
		
		if (propertiesList.length != 0) {
			for (propertyName in propertiesList) {
				if (HelpersGlobal.hasProperty(obj, propertyName) == false) {
					hasAll = false;
					break;
				}
			}
		} else {
			hasAll = true;
		}
		
		return hasAll;
	}
	
	private static var TRUE_VALUES:Array<String> = ["true", "active", "yes", "1"];
	private static var FALSE_VALUES:Array<String> = ["false", "inactive", "no", "0"];
	
	/** Translate a value of any type into Bool */
	public static function translateToBoolean(value:Dynamic):Bool
	{
		//treat 'null' standard values as false
		if (value == null) {
			return false;
		}
		
		//toString
		var valueAsString:String = HelpersString.toLowerCase(Std.string(value));
		
		if (TRUE_VALUES.indexOf(valueAsString) != -1) {
			return true;
		} else if (FALSE_VALUES.indexOf(valueAsString) != -1) {
			return false;
		} else {
			return (value != "");
		}
	}
	
	private static inline var PATH_DELIMITER:String = ".";
	
	/** get a child as in Flash display list : itemViewContainer.itemView.txt */
	public static function getChildByName(container:DisplayObjectContainer, name:String, log:Bool = false):DisplayObject
	{
		var target:DisplayObject = null;

		//fast lookup
		if (name.indexOf(PATH_DELIMITER) == -1) {
			target = container.getChildByName(name);

			if (target != null) {
				return target;
			}
			else {
				if (log) {
					Logger.error("HelpersGlobal", "getChildByName(name = '" + name + "') not found!!!");
				}
				return null;
			}
		}
		else { //normal, with "." in path
			var targetSplitPath = name.split(PATH_DELIMITER);
			var len:Int = targetSplitPath.length;

			target = container;
			var currentIndex:Int = 0;
			for (i in 0...len) {
				currentIndex = i;
				if (Std.is(target, DisplayObjectContainer) == false || target == null) { //force stopped ;)
					break;
				}
				target = (cast (target, DisplayObjectContainer)).getChildByName(targetSplitPath[i]);
			}

			if (currentIndex == len - 1 && target != null) {
				return target;
			}
			else {
				if (log) {
					Logger.error("HelpersGlobal", "getChildByName(name = '" + name + "') not found!!!");
				}
				return null;
			}
		}
		
		return null;
	}
	
	/** add zeroes in front of a number to match the final length specified */
	public static function addLeadingZeroes(nmb:Int, numFinalLength:Int):String
	{
		var str:String = Std.string(nmb);
		var difZeroes:Int = numFinalLength - str.length;

		for (i in 0...difZeroes) {
			str = "0" + str;
		}

		return str;
	}
	
	/**
	 * transform a string like "100,200" into a point with x=100 and y=200
	 * it will always return a valid point even if the value is null, empty or in an incorrect format
	 */
	public static function parseToPoint(value:String):Point
	{
		var valueX:Float = 0;
		var valueY:Float = 0;
		
		try {
			var valueStringSplit = value.split(",");
			valueX = Std.parseFloat(valueStringSplit[0]);
			valueY = Std.parseFloat(valueStringSplit[1]);
		} catch (e:Dynamic) {}
		
		if (Math.isFinite(valueX) == false || Math.isFinite(valueY) == false) {
			valueX = valueY = 0;
		}
		
		return new Point(valueX, valueY);
	}
}