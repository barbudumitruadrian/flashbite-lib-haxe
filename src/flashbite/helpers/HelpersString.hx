package flashbite.helpers;

import flashbite.logger.Logger;

/**
 * String helpers
 * 
 * @author Adrian Barbu
 */
@:final
class HelpersString 
{	
	private function new() {}
	
	/** Get a caseInsensitive property name from an object */
	public static function getCaseInsensitivePropName(obj:Dynamic, propName:String, log:Bool = false):String
	{
		//check first by propertyName given
		if (Reflect.hasField(obj, propName)) {
			if (log && Reflect.getProperty(obj, propName) == null) {
				Logger.warning("HelpersGlobal", "getCaseInsensitivePropName-- propName " + propName + " value is null!!!");
			}
			return propName;
		}

		var propNameToLowerCase:String = HelpersString.toLowerCase(propName);
		
		//check now by lowercase
		if (Reflect.hasField(obj, propNameToLowerCase)) {
			if (log && Reflect.getProperty(obj, propNameToLowerCase) == null) {
				Logger.warning("HelpersGlobal", "getCaseInsensitivePropName-- propName " + propNameToLowerCase + " value is null!!!");
			}
			return propNameToLowerCase;
		}

		//now deep search
		for (key in Reflect.fields(obj)) {
			if (HelpersString.toLowerCase(key) == propNameToLowerCase) {
				if (log && Reflect.getProperty(obj, key) == null) {
					Logger.warning("HelpersGlobal", "getCaseInsensitivePropName-- key " + key + " value is null!!!");
				}
				return key;
				break;
			}
		}

		if (log) {
			Logger.warning("HelpersGlobal", "getCaseInsensitivePropName-- Unable to find " + propName + " !!!");
		}

		return null;
	}
	
	private static var STRING_CACHE_LOWERCASE:Map<String, String> = new Map<String, String>();
	private static var STRING_CACHE_UPPERCASE:Map<String, String> = new Map<String, String>();
	
	/** Converts a string to his lowerCase value, by using a string cache in order to avoid GC */
	public static function toLowerCase(string:String):String
	{
		var result:String = STRING_CACHE_LOWERCASE.get(string);
		if (result == null) {
			result = string.toLowerCase();
			STRING_CACHE_LOWERCASE.set(string, result);
		}
		return result;
	}

	/** Converts a string to his upperCase value, by using a string cache in order to avoid GC */
	public static function toUpperCase(string:String):String
	{
		var result:String = STRING_CACHE_UPPERCASE.get(string);
		if (result == null) {
			result = string.toUpperCase();
			STRING_CACHE_UPPERCASE.set(string, result);
		}
		return result;
	}
}