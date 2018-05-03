package flashbite.skinnableview.view;

/**
 * Holds all element containers that ISkinnableViewCreator can create in his initial state
 * 
 * @author Adrian Barbu
 */
@:final
class ElementContainerType
{
	private function new() {}
	
	
	private static var _all:Array<String> = [];
	private static var _allClasses:Array<Dynamic> = [];
	
	public static function getAll():Array<String> { return _all.copy(); }
	public static function isKnown(value:String):Bool { return _all.indexOf(value) != -1; }
	
	public static function getClass(type:String):Dynamic
	{
		if (isKnown(type)) {
			return _allClasses[_all.indexOf(type)];
		}
		return null;
	}
}