package flashbite.skinnableview.model.skinstyle;

import flashbite.helpers.HelpersGlobal;
import flashbite.helpers.HelpersString;
import flashbite.skinnableview.model.skinstyle.IRawObject;

/**
 * RawObject class;
 * 
 * used to hold all data from one XML node; 
 * properties can be accessed with caseInsensitive names with getPropertyValue() function
 * 
 * @author Adrian Barbu
 */
@:final
class RawObject implements IRawObject implements Dynamic<String>
{
	// =====================================================================================================================================
	// CONSTRUCTOR, DESTRUCTOR
	// =====================================================================================================================================
	
	public dynamic function new() {}
	
	// ====================================================================================================================================
	// IRawObject
	// ====================================================================================================================================
	
	public function hasProperty(propertyName:String, caseInsensitive:Bool = true):Bool 
	{
		var propertyValue:Dynamic = null;

		if (caseInsensitive == false) {
			propertyValue = Reflect.field(this, propertyName);
		}
		else {
			var insensitivePropertyName:String = HelpersString.getCaseInsensitivePropName(this, propertyName);
			if (insensitivePropertyName != null) {
				propertyValue = Reflect.field(this, insensitivePropertyName);
			}
		}

		return (propertyValue != null);
	}
	
	public function getPropertyValue(propertyName:String, caseInsensitive:Bool = true, defaultValue:String = null):String 
	{
		if (caseInsensitive) {
			return HelpersGlobal.getCaseInsensitivePropValue(this, propertyName, defaultValue);
		}
		else {
			if (Reflect.hasField(this, propertyName)) {
				return Reflect.field(this, propertyName);
			}
			else {
				return defaultValue;
			}
		}
	}
	
	public function copyFrom(from:IRawObject):Void 
	{
		for (key in Reflect.fields(from)) {
			Reflect.setField(this, key, Reflect.field(from, key));
		}
	}
}