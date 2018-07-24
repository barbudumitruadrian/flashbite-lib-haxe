package flashbite.skinnableview.view;

import flashbite.helpers.HelpersString;
import flashbite.skinnableview.view.button.SimpleButton;
import flashbite.skinnableview.view.layout.HorizontalLayout;
import flashbite.skinnableview.view.layout.VerticalLayout;

/**
 * Holds all element containers that ISkinnableViewCreator can create in his initial state
 * 
 * @author Adrian Barbu
 */
@:final
class ElementContainerType
{
	private function new() {}
	
	
	public static inline var SIMPLE_BUTTON		:String = "SimpleButton";
	public static inline var VERTICAL_LAYOUT	:String = "VerticalLayout";
	public static inline var HORIZONTAL_LAYOUT	:String = "HorizontalLayout";
	
	
	private static var _all:Array<String> =         [SIMPLE_BUTTON, VERTICAL_LAYOUT, HORIZONTAL_LAYOUT];
	private static var _allClasses:Array<Dynamic> = [SimpleButton,  VerticalLayout,  HorizontalLayout];
	
	public static function getAll():Array<String> { return _all.copy(); }
	public static function isKnown(type:String, caseInsensitive:Bool = true):Bool
	{
		return getIndexOf(type, caseInsensitive) != -1;
	}
	
	public static function getClass(type:String):Dynamic
	{
		if (isKnown(type, true)) {
			return _allClasses[getIndexOf(type, true)];
		}
		return null;
	}
	
	private static function getIndexOf(type:String, caseInsensitive:Bool = true):Int
	{
		if (caseInsensitive) {
			type = HelpersString.toLowerCase(type);
			for (i in 0..._all.length) {
				if (HelpersString.toLowerCase(_all[i]) == type) {
					return i;
				}
			}
			return -1;
		} else {
			return _all.indexOf(type);
		}
	}
}