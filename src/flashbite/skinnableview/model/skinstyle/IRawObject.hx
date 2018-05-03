package flashbite.skinnableview.model.skinstyle;

/**
 * IRawObject interface;
 * 
 * used to hold all data from one skinnable XML node;
 * properties values can be accessed with caseInsensitive names with getPropertyValue() function
 * the check if a property exists can be made with hasProperty() function
 * 
 * @author Adrian Barbu
 */
interface IRawObject 
{
	/** check if a given property name is found in IRawObject */
	public function hasProperty(propertyName:String, caseInsensitive:Bool = true):Bool;

	/** get a property value by a name from IRawObject */
	public function getPropertyValue(propertyName:String, caseInsensitive:Bool = true, defaultValue:String = null):String;

	/** copy from another IRawObject */
	public function copyFrom(from:IRawObject):Void;
}